/*
 * WebVM プロセススケジューラ実装
 */

#include "../include/kernel.h"
#include "../include/process.h"
#include "../include/wasi_syscalls.h"

/* スケジューラの状態 */
static struct {
  struct process *ready_head; /* レディキューの先頭 */
  struct process *ready_tail; /* レディキューの末尾 */
  uint64_t tick_count;        /* ティックカウント */
  uint32_t time_slice;        /* タイムスライス (ミリ秒) */
  bool initialized;           /* 初期化フラグ */
} scheduler_state = {.ready_head = NULL,
                     .ready_tail = NULL,
                     .tick_count = 0,
                     .time_slice = 10, /* 10ms */
                     .initialized = false};

/* 外部関数宣言 */
int kprintf(const char *format, ...);
extern struct process *process_get_current(void);
extern struct process *process_find(pid_t pid);

/* 外部変数宣言 */
extern struct process_table g_process_table;

/**
 * スケジューラの初期化
 */
void scheduler_init(void) {
  kprintf("[SCHEDULER] Initializing scheduler...\n");

  scheduler_state.ready_head = NULL;
  scheduler_state.ready_tail = NULL;
  scheduler_state.tick_count = 0;
  scheduler_state.initialized = true;

  kprintf("[SCHEDULER] Scheduler initialized\n");
}

/**
 * レディキューにプロセスを追加
 */
void scheduler_add_ready(struct process *proc) {
  if (proc == NULL || proc->state != PROCESS_STATE_READY) {
    return;
  }

  /* リンクをクリア */
  proc->next = NULL;
  proc->prev = NULL;

  /* キューが空の場合 */
  if (scheduler_state.ready_head == NULL) {
    scheduler_state.ready_head = proc;
    scheduler_state.ready_tail = proc;
  } else {
    /* キューの末尾に追加 */
    scheduler_state.ready_tail->next = proc;
    proc->prev = scheduler_state.ready_tail;
    scheduler_state.ready_tail = proc;
  }

  kprintf("[SCHEDULER] Added process %d to ready queue\n", proc->pid);
}

/**
 * レディキューからプロセスを削除
 */
void scheduler_remove_ready(struct process *proc) {
  if (proc == NULL) {
    return;
  }

  /* 前のプロセスがある場合 */
  if (proc->prev) {
    proc->prev->next = proc->next;
  } else {
    /* 先頭の場合 */
    scheduler_state.ready_head = proc->next;
  }

  /* 次のプロセスがある場合 */
  if (proc->next) {
    proc->next->prev = proc->prev;
  } else {
    /* 末尾の場合 */
    scheduler_state.ready_tail = proc->prev;
  }

  proc->next = NULL;
  proc->prev = NULL;

  kprintf("[SCHEDULER] Removed process %d from ready queue\n", proc->pid);
}

/**
 * 次に実行するプロセスを選択
 */
static struct process *scheduler_select_next(void) {
  struct process *next = scheduler_state.ready_head;

  if (next == NULL) {
    /* レディキューが空の場合はカーネルプロセス */
    return process_find(0);
  }

  /* レディキューから取り出す */
  scheduler_remove_ready(next);

  return next;
}

/**
 * コンテキストスイッチ (簡易実装)
 *
 * 注意: WebAssemblyの制約により、真のコンテキストスイッチは不可能
 * ここでは協調的マルチタスキングを実装
 */
static void context_switch(struct process *from, struct process *to) {
  if (from == to) {
    return;
  }

  kprintf("[SCHEDULER] Context switch: %d -> %d\n", from ? from->pid : -1,
          to ? to->pid : -1);

  /* 現在のプロセスの状態を保存 */
  if (from && from->state == PROCESS_STATE_RUNNING) {
    from->state = PROCESS_STATE_READY;
    scheduler_add_ready(from);
  }

  /* 新しいプロセスを実行状態にする */
  to->state = PROCESS_STATE_RUNNING;

  /* カレントプロセスを更新 */
  extern struct process_table g_process_table;
  g_process_table.current = to;

  /*
   * WebAssemblyではレジスタの直接操作ができないため、
   * 協調的マルチタスキングとして実装
   * プロセスは自発的にyieldを呼ぶ必要がある
   */
}

/**
 * スケジューラティック
 * 定期的に呼ばれることを想定
 */
void scheduler_tick(void) {
  struct process *current;
  struct process *next;

  if (!scheduler_state.initialized) {
    return;
  }

  scheduler_state.tick_count++;

  /* 現在のプロセスを取得 */
  current = process_get_current();
  if (current == NULL) {
    return;
  }

  /* CPU時間を更新 */
  current->cpu_time++;

  /* タイムスライスをチェック */
  if (scheduler_state.tick_count % scheduler_state.time_slice == 0) {
    /* 次のプロセスを選択 */
    next = scheduler_select_next();
    if (next && next != current) {
      context_switch(current, next);
    }
  }
}

/**
 * CPUを自発的に譲る
 */
void scheduler_yield(void) {
  struct process *current;
  struct process *next;

  if (!scheduler_state.initialized) {
    return;
  }

  /* 現在のプロセスを取得 */
  current = process_get_current();
  if (current == NULL) {
    return;
  }

  kprintf("[SCHEDULER] Process %d yielding CPU\n", current->pid);

  /* 次のプロセスを選択 */
  next = scheduler_select_next();
  if (next == NULL) {
    /* 実行可能なプロセスがない */
    kprintf("[SCHEDULER] No runnable processes\n");
    return;
  }

  /* コンテキストスイッチ */
  context_switch(current, next);

  /*
   * 注意: WebAssemblyの制約により、ここで実際の制御移譲は行われない
   * 呼び出し元が協調的に処理を終了する必要がある
   */
}

/**
 * アイドルループ
 * レディキューが空の時に実行される
 */
void scheduler_idle(void) {
  kprintf("[SCHEDULER] Entering idle loop\n");

  while (1) {
    /* レディキューをチェック */
    if (scheduler_state.ready_head != NULL) {
      scheduler_yield();
      break;
    }

    /* 少し待機 (WebAssemblyでは実際のスリープは不可能) */
    /* TODO: Web Workersを使った実装を検討 */
  }
}