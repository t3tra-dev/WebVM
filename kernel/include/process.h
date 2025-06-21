/*
 * WebVM プロセス管理ヘッダ
 */

#ifndef __WEBVM_PROCESS_H__
#define __WEBVM_PROCESS_H__

#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

/* プロセス定数 */
#define MAX_PROCESSES 64
#define MAX_PROCESS_NAME 32
#define PROCESS_STACK_SIZE (64 * 1024) /* 64KB スタック */

/* プロセス状態 */
typedef enum {
  PROCESS_STATE_UNUSED = 0,
  PROCESS_STATE_INIT,
  PROCESS_STATE_READY,
  PROCESS_STATE_RUNNING,
  PROCESS_STATE_WAITING,
  PROCESS_STATE_ZOMBIE,
  PROCESS_STATE_TERMINATED
} process_state_t;

/* プロセスID型 */
typedef int32_t pid_t;

/* プロセスコンテキスト (WebAssembly制約下での簡易版) */
struct process_context {
  void *stack_ptr; /* スタックポインタ */
  void *pc;        /* プログラムカウンタ (関数ポインタ) */
  uint32_t flags;  /* フラグ */
};

/* プロセス制御ブロック (PCB) */
struct process {
  pid_t pid;                   /* プロセスID */
  pid_t ppid;                  /* 親プロセスID */
  char name[MAX_PROCESS_NAME]; /* プロセス名 */
  process_state_t state;       /* プロセス状態 */

  /* メモリ管理 */
  void *stack_base;  /* スタックベースアドレス */
  size_t stack_size; /* スタックサイズ */
  void *heap_base;   /* ヒープベースアドレス */
  size_t heap_size;  /* ヒープサイズ */

  /* コンテキスト */
  struct process_context context; /* プロセスコンテキスト */

  /* エントリポイント */
  int (*entry)(int argc, char **argv); /* プロセスエントリポイント */
  int argc;                            /* 引数カウント */
  char **argv;                         /* 引数配列 */

  /* 終了情報 */
  int exit_code; /* 終了コード */

  /* 統計情報 */
  uint64_t start_time; /* 開始時刻 */
  uint64_t cpu_time;   /* CPU使用時間 */

  /* リンクリスト */
  struct process *next; /* 次のプロセス */
  struct process *prev; /* 前のプロセス */
};

/* プロセステーブル */
struct process_table {
  struct process processes[MAX_PROCESSES];
  struct process *current;    /* 現在実行中のプロセス */
  struct process *ready_list; /* 実行可能プロセスリスト */
  pid_t next_pid;             /* 次のPID */
  uint32_t process_count;     /* プロセス数 */
};

/* プロセス管理関数 */
int process_init(void);
pid_t process_create(const char *name, int (*entry)(int, char **), int argc,
                     char **argv);
int process_exit(int exit_code);
int process_wait(pid_t pid);
int process_kill(pid_t pid, int signal);
struct process *process_get_current(void);
struct process *process_find(pid_t pid);

/* スケジューラ関数 */
void scheduler_init(void);
void scheduler_tick(void);
void scheduler_yield(void);
void scheduler_add_ready(struct process *proc);
void scheduler_remove_ready(struct process *proc);

/* POSIX spawn API */
typedef struct {
  int flags;
  /* 将来的な拡張用 */
} posix_spawnattr_t;

typedef struct {
  char **argv;
  char **envp;
} posix_spawn_file_actions_t;

int posix_spawn(pid_t *pid, const char *path,
                const posix_spawn_file_actions_t *file_actions,
                const posix_spawnattr_t *attrp, char *const argv[],
                char *const envp[]);

/* デバッグ関数 */
void process_dump_table(void);

#endif /* __WEBVM_PROCESS_H__ */