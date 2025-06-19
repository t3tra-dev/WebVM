/*
 * WebVM プロセス管理実装
 */

#include "../include/process.h"
#include "../include/kernel.h"
#include "../include/mm.h"
#include "../include/wasi_syscalls.h"

/* グローバルプロセステーブル */
struct process_table g_process_table;

/* カーネルプロセス (PID 0) */
static struct process kernel_process = {
    .pid = 0,
    .ppid = -1,
    .name = "kernel",
    .state = PROCESS_STATE_RUNNING,
    .exit_code = 0
};

/* シェルプロセス (PID 1) */
static struct process shell_process = {
    .pid = 1,
    .ppid = 0,
    .name = "shell",
    .state = PROCESS_STATE_RUNNING,
    .exit_code = 0
};

/* 外部関数宣言 */
int kprintf(const char *format, ...);

/* 文字列関数 */
static void *memset(void *s, int c, size_t n) {
    unsigned char *p = s;
    while (n--) {
        *p++ = (unsigned char)c;
    }
    return s;
}

static char *strncpy(char *dest, const char *src, size_t n) {
    size_t i;
    for (i = 0; i < n && src[i] != '\0'; i++) {
        dest[i] = src[i];
    }
    for (; i < n; i++) {
        dest[i] = '\0';
    }
    return dest;
}

/**
 * プロセス管理の初期化
 */
int process_init(void) {
    kprintf("[PROCESS] Initializing process management...\n");
    
    /* プロセステーブルの初期化 */
    memset(&g_process_table, 0, sizeof(g_process_table));
    
    /* 全プロセススロットを未使用に設定 */
    for (int i = 0; i < MAX_PROCESSES; i++) {
        g_process_table.processes[i].state = PROCESS_STATE_UNUSED;
        g_process_table.processes[i].pid = -1;
    }
    
    /* カーネルプロセスを登録 */
    g_process_table.processes[0] = kernel_process;
    
    /* シェルプロセスを登録 */
    g_process_table.processes[1] = shell_process;
    
    /* 現在実行中はシェル */
    g_process_table.current = &g_process_table.processes[1];
    g_process_table.process_count = 2;
    g_process_table.next_pid = 2;
    
    kprintf("[PROCESS] Process management initialized\n");
    return 0;
}

/**
 * 空きプロセススロットを探す
 */
static struct process *find_free_slot(void) {
    /* スロット0はカーネルプロセス用なので、1から開始 */
    for (int i = 1; i < MAX_PROCESSES; i++) {
        if (g_process_table.processes[i].state == PROCESS_STATE_UNUSED) {
            return &g_process_table.processes[i];
        }
    }
    return NULL;
}

/**
 * プロセスを作成
 */
pid_t process_create(const char *name, int (*entry)(int, char**), int argc, char **argv) {
    struct process *proc;
    
    /* 空きスロットを探す */
    proc = find_free_slot();
    if (proc == NULL) {
        kprintf("[PROCESS] No free process slots available\n");
        return -1;
    }
    
    /* プロセス情報を設定 */
    proc->pid = g_process_table.next_pid++;
    proc->ppid = g_process_table.current ? g_process_table.current->pid : 0;
    strncpy(proc->name, name, MAX_PROCESS_NAME - 1);
    proc->name[MAX_PROCESS_NAME - 1] = '\0';
    proc->state = PROCESS_STATE_INIT;
    
    /* スタックを割り当て */
    proc->stack_size = PROCESS_STACK_SIZE;
    proc->stack_base = kmalloc(proc->stack_size);
    if (proc->stack_base == NULL) {
        kprintf("[PROCESS] Failed to allocate stack for process %d\n", proc->pid);
        proc->state = PROCESS_STATE_UNUSED;
        return -1;
    }
    
    /* スタックポインタを設定 (スタックは下向きに成長) */
    proc->context.stack_ptr = (char *)proc->stack_base + proc->stack_size;
    
    /* エントリポイントと引数を設定 */
    proc->entry = entry;
    proc->argc = argc;
    proc->argv = argv;
    proc->context.pc = entry;
    
    /* 時刻情報を初期化 */
    proc->start_time = wasi_get_time_ns();
    proc->cpu_time = 0;
    
    /* プロセスを準備完了状態にする */
    proc->state = PROCESS_STATE_READY;
    
    /* レディキューに追加 */
    scheduler_add_ready(proc);
    
    g_process_table.process_count++;
    
    kprintf("[PROCESS] Created process %d: %s\n", proc->pid, proc->name);
    return proc->pid;
}

/**
 * プロセスを終了
 */
int process_exit(int exit_code) {
    struct process *current = process_get_current();
    
    if (current == NULL || current->pid == 0) {
        kprintf("[PROCESS] Kernel process cannot exit\n");
        return -1;
    }
    
    kprintf("[PROCESS] Process %d exiting with code %d\n", current->pid, exit_code);
    
    /* 終了コードを設定 */
    current->exit_code = exit_code;
    
    /* スタックを解放 */
    if (current->stack_base) {
        kfree(current->stack_base);
        current->stack_base = NULL;
    }
    
    /* ヒープを解放 (将来的な実装) */
    if (current->heap_base) {
        kfree(current->heap_base);
        current->heap_base = NULL;
    }
    
    /* プロセス状態をゾンビに設定 */
    current->state = PROCESS_STATE_ZOMBIE;
    
    /* 親プロセスがwaitしていない場合は、すぐに終了状態にする */
    /* TODO: 親プロセスへの通知実装 */
    current->state = PROCESS_STATE_UNUSED;
    current->pid = -1;
    
    g_process_table.process_count--;
    
    /* スケジューラに制御を渡す */
    scheduler_yield();
    
    return 0;
}

/**
 * プロセスを待機
 */
int process_wait(pid_t pid) {
    struct process *proc;
    
    /* プロセスを検索 */
    proc = process_find(pid);
    if (proc == NULL) {
        kprintf("[PROCESS] Process %d not found\n", pid);
        return -1;
    }
    
    /* プロセスがまだ実行中の場合は待機 */
    while (proc->state != PROCESS_STATE_ZOMBIE && 
           proc->state != PROCESS_STATE_TERMINATED) {
        /* TODO: 実際の待機実装 (現在はビジーウェイト) */
        scheduler_yield();
    }
    
    /* 終了コードを取得 */
    int exit_code = proc->exit_code;
    
    /* プロセススロットを解放 */
    proc->state = PROCESS_STATE_UNUSED;
    proc->pid = -1;
    
    return exit_code;
}

/**
 * プロセスを強制終了
 */
int process_kill(pid_t pid, int signal) {
    struct process *proc;
    
    /* プロセスを検索 */
    proc = process_find(pid);
    if (proc == NULL) {
        kprintf("[PROCESS] Process %d not found\n", pid);
        return -1;
    }
    
    /* カーネルプロセスは終了できない */
    if (pid == 0) {
        kprintf("[PROCESS] Cannot kill kernel process\n");
        return -1;
    }
    
    kprintf("[PROCESS] Killing process %d with signal %d\n", pid, signal);
    
    /* TODO: シグナル処理の実装 */
    /* 現在は強制終了のみ */
    
    /* 既に終了している場合 */
    if (proc->state == PROCESS_STATE_TERMINATED || 
        proc->state == PROCESS_STATE_UNUSED) {
        kprintf("[PROCESS] Process %d already terminated\n", pid);
        return -1;
    }
    
    /* レディキューから削除 (状態変更前に実行) */
    if (proc->state == PROCESS_STATE_READY) {
        scheduler_remove_ready(proc);
    }
    
    /* プロセスを強制終了 */
    proc->exit_code = -signal;
    proc->state = PROCESS_STATE_TERMINATED;
    
    /* リソースを解放 */
    if (proc->stack_base) {
        kfree(proc->stack_base);
        proc->stack_base = NULL;
    }
    
    if (proc->heap_base) {
        kfree(proc->heap_base);
        proc->heap_base = NULL;
    }
    
    /* プロセススロットを解放 */
    proc->state = PROCESS_STATE_UNUSED;
    proc->pid = -1;
    
    g_process_table.process_count--;
    
    return 0;
}

/**
 * 現在実行中のプロセスを取得
 */
struct process *process_get_current(void) {
    return g_process_table.current;
}

/**
 * PIDからプロセスを検索
 */
struct process *process_find(pid_t pid) {
    if (pid < 0 || pid >= MAX_PROCESSES) {
        return NULL;
    }
    
    struct process *proc = &g_process_table.processes[pid];
    if (proc->state == PROCESS_STATE_UNUSED) {
        return NULL;
    }
    
    return proc;
}

/**
 * プロセステーブルをダンプ (デバッグ用)
 */
void process_dump_table(void) {
    kprintf("[PROCESS] Process table dump:\n");
    kprintf("PID  PPID  STATE      NAME\n");
    kprintf("---  ----  ---------  ----------------\n");
    
    for (int i = 0; i < MAX_PROCESSES; i++) {
        struct process *proc = &g_process_table.processes[i];
        if (proc->state != PROCESS_STATE_UNUSED) {
            const char *state_str;
            switch (proc->state) {
                case PROCESS_STATE_INIT:    state_str = "INIT    "; break;
                case PROCESS_STATE_READY:   state_str = "READY   "; break;
                case PROCESS_STATE_RUNNING: state_str = "RUNNING "; break;
                case PROCESS_STATE_WAITING: state_str = "WAITING "; break;
                case PROCESS_STATE_ZOMBIE:  state_str = "ZOMBIE  "; break;
                case PROCESS_STATE_TERMINATED: state_str = "TERM    "; break;
                default:                    state_str = "UNKNOWN "; break;
            }
            kprintf("%-3d  %-4d  %s  %s\n", 
                   proc->pid, proc->ppid, state_str, proc->name);
        }
    }
    kprintf("Total processes: %d\n", g_process_table.process_count);
}