/*
 * WebVM プロセス間通信 (IPC) ヘッダ
 */

#ifndef __WEBVM_IPC_H__
#define __WEBVM_IPC_H__

#include "process.h"
#include <stddef.h>
#include <stdint.h>

/* IPC定数 */
#define MAX_MESSAGE_SIZE 1024
#define MAX_MESSAGES_PER_PROCESS 16

/* メッセージタイプ */
typedef enum {
  MSG_TYPE_DATA = 0,  /* データメッセージ */
  MSG_TYPE_SIGNAL,    /* シグナル */
  MSG_TYPE_PIPE,      /* パイプデータ */
  MSG_TYPE_SHARED_MEM /* 共有メモリ通知 */
} message_type_t;

/* メッセージ構造体 */
struct ipc_message {
  pid_t sender_pid;         /* 送信者PID */
  pid_t receiver_pid;       /* 受信者PID */
  message_type_t type;      /* メッセージタイプ */
  size_t size;              /* データサイズ */
  void *data;               /* データポインタ */
  uint64_t timestamp;       /* タイムスタンプ */
  struct ipc_message *next; /* 次のメッセージ */
};

/* メッセージキュー */
struct message_queue {
  struct ipc_message *head;
  struct ipc_message *tail;
  uint32_t count;
  uint32_t max_messages;
};

/* パイプ構造体 */
struct pipe {
  char *buffer;      /* バッファ */
  size_t size;       /* バッファサイズ */
  size_t read_pos;   /* 読み込み位置 */
  size_t write_pos;  /* 書き込み位置 */
  pid_t reader_pid;  /* 読み込みプロセス */
  pid_t writer_pid;  /* 書き込みプロセス */
  bool closed_read;  /* 読み込み側クローズ */
  bool closed_write; /* 書き込み側クローズ */
};

/* 共有メモリセグメント */
struct shared_memory {
  void *address;      /* メモリアドレス */
  size_t size;        /* サイズ */
  uint32_t ref_count; /* 参照カウント */
  pid_t owner_pid;    /* 所有者PID */
  uint32_t flags;     /* フラグ */
};

/* IPC初期化 */
int ipc_init(void);

/* メッセージ送受信 */
int ipc_send_message(pid_t to_pid, const void *data, size_t size,
                     message_type_t type);
int ipc_receive_message(struct ipc_message **msg, bool blocking);
void ipc_free_message(struct ipc_message *msg);

/* パイプ操作 */
int ipc_create_pipe(int *read_fd, int *write_fd);
int ipc_pipe_read(int fd, void *buf, size_t count);
int ipc_pipe_write(int fd, const void *buf, size_t count);
int ipc_pipe_close(int fd);

/* 共有メモリ */
void *ipc_create_shared_memory(size_t size);
void *ipc_attach_shared_memory(int shmid);
int ipc_detach_shared_memory(void *addr);
int ipc_destroy_shared_memory(int shmid);

/* デバッグ */
void ipc_dump_queues(void);

#endif /* __WEBVM_IPC_H__ */