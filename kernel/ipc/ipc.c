/*
 * WebVM プロセス間通信 (IPC) 実装
 */

#include "../include/ipc.h"
#include "../include/kernel.h"
#include "../include/mm.h"
#include "../include/wasi_syscalls.h"

/* 外部関数宣言 */
int kprintf(const char *format, ...);

/* 文字列関数 */
static void *memcpy(void *dest, const void *src, size_t n) {
  unsigned char *d = dest;
  const unsigned char *s = src;
  while (n--) {
    *d++ = *s++;
  }
  return dest;
}

/* グローバルメッセージキューテーブル */
static struct {
  struct message_queue queues[MAX_PROCESSES];
  bool initialized;
} ipc_state = {.initialized = false};

/**
 * IPC初期化
 */
int ipc_init(void) {
  kprintf("[IPC] Initializing IPC subsystem...\n");

  /* 全プロセスのメッセージキューを初期化 */
  for (int i = 0; i < MAX_PROCESSES; i++) {
    ipc_state.queues[i].head = NULL;
    ipc_state.queues[i].tail = NULL;
    ipc_state.queues[i].count = 0;
    ipc_state.queues[i].max_messages = MAX_MESSAGES_PER_PROCESS;
  }

  ipc_state.initialized = true;
  kprintf("[IPC] IPC subsystem initialized\n");

  return 0;
}

/**
 * メッセージをキューに追加
 */
static int enqueue_message(pid_t pid, struct ipc_message *msg) {
  struct message_queue *queue;

  if (pid < 0 || pid >= MAX_PROCESSES) {
    return -1;
  }

  queue = &ipc_state.queues[pid];

  /* キューが満杯かチェック */
  if (queue->count >= queue->max_messages) {
    kprintf("[IPC] Message queue full for process %d\n", pid);
    return -1;
  }

  /* キューに追加 */
  msg->next = NULL;
  if (queue->tail) {
    queue->tail->next = msg;
  } else {
    queue->head = msg;
  }
  queue->tail = msg;
  queue->count++;

  return 0;
}

/**
 * メッセージをキューから取り出し
 */
static struct ipc_message *dequeue_message(pid_t pid) {
  struct message_queue *queue;
  struct ipc_message *msg;

  if (pid < 0 || pid >= MAX_PROCESSES) {
    return NULL;
  }

  queue = &ipc_state.queues[pid];

  /* キューが空かチェック */
  if (queue->head == NULL) {
    return NULL;
  }

  /* 先頭から取り出し */
  msg = queue->head;
  queue->head = msg->next;
  if (queue->head == NULL) {
    queue->tail = NULL;
  }
  queue->count--;

  msg->next = NULL;
  return msg;
}

/**
 * メッセージ送信
 */
int ipc_send_message(pid_t to_pid, const void *data, size_t size,
                     message_type_t type) {
  struct ipc_message *msg;
  struct process *sender;
  struct process *receiver;

  if (!ipc_state.initialized) {
    kprintf("[IPC] IPC not initialized\n");
    return -1;
  }

  /* 送信者と受信者を確認 */
  sender = process_get_current();
  if (sender == NULL) {
    return -1;
  }

  receiver = process_find(to_pid);
  if (receiver == NULL) {
    kprintf("[IPC] Process %d not found\n", to_pid);
    return -1;
  }

  /* メッセージを割り当て */
  msg = (struct ipc_message *)kmalloc(sizeof(struct ipc_message));
  if (msg == NULL) {
    kprintf("[IPC] Failed to allocate message\n");
    return -1;
  }

  /* データをコピー */
  if (size > 0 && data != NULL) {
    msg->data = kmalloc(size);
    if (msg->data == NULL) {
      kfree(msg);
      return -1;
    }
    memcpy(msg->data, data, size);
  } else {
    msg->data = NULL;
  }

  /* メッセージ情報を設定 */
  msg->sender_pid = sender->pid;
  msg->receiver_pid = to_pid;
  msg->type = type;
  msg->size = size;
  msg->timestamp = wasi_get_time_ns();
  msg->next = NULL;

  /* キューに追加 */
  if (enqueue_message(to_pid, msg) < 0) {
    if (msg->data) {
      kfree(msg->data);
    }
    kfree(msg);
    return -1;
  }

  kprintf("[IPC] Message sent from %d to %d (type=%d, size=%zu)\n", sender->pid,
          to_pid, type, size);

  /* 受信プロセスを起床 (TODO: 実装) */
  if (receiver->state == PROCESS_STATE_WAITING) {
    receiver->state = PROCESS_STATE_READY;
    scheduler_add_ready(receiver);
  }

  return 0;
}

/**
 * メッセージ受信
 */
int ipc_receive_message(struct ipc_message **msg, bool blocking) {
  struct process *current;
  struct ipc_message *received;

  if (!ipc_state.initialized || msg == NULL) {
    return -1;
  }

  current = process_get_current();
  if (current == NULL) {
    return -1;
  }

  while (1) {
    /* メッセージを取り出し */
    received = dequeue_message(current->pid);
    if (received != NULL) {
      *msg = received;
      kprintf("[IPC] Process %d received message from %d\n", current->pid,
              received->sender_pid);
      return 0;
    }

    /* ノンブロッキングモードの場合は即座に返る */
    if (!blocking) {
      *msg = NULL;
      return 0;
    }

    /* ブロッキングモードの場合は待機 */
    kprintf("[IPC] Process %d waiting for message\n", current->pid);
    current->state = PROCESS_STATE_WAITING;
    scheduler_yield();
  }
}

/**
 * メッセージを解放
 */
void ipc_free_message(struct ipc_message *msg) {
  if (msg == NULL) {
    return;
  }

  if (msg->data) {
    kfree(msg->data);
  }
  kfree(msg);
}

/**
 * メッセージキューをダンプ (デバッグ用)
 */
void ipc_dump_queues(void) {
  kprintf("[IPC] Message queue dump:\n");
  kprintf("PID  COUNT  MESSAGES\n");
  kprintf("---  -----  --------\n");

  for (int i = 0; i < MAX_PROCESSES; i++) {
    struct message_queue *queue = &ipc_state.queues[i];
    if (queue->count > 0) {
      kprintf("%-3d  %-5d  ", i, queue->count);

      struct ipc_message *msg = queue->head;
      while (msg) {
        kprintf("(from:%d,type:%d,size:%zu) ", msg->sender_pid, msg->type,
                msg->size);
        msg = msg->next;
      }
      kprintf("\n");
    }
  }
}