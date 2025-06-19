/*
 * WebVM POSIX spawn実装
 * 
 * fork()がWebAssemblyで実装できないため、posix_spawnを使用
 */

#include "../include/process.h"
#include "../include/kernel.h"
#include "../include/fs.h"
#include "../include/mm.h"

/* 外部関数宣言 */
int kprintf(const char *format, ...);

/* 文字列関数 */
static int strcmp(const char *s1, const char *s2) {
    while (*s1 && (*s1 == *s2)) {
        s1++;
        s2++;
    }
    return *(unsigned char *)s1 - *(unsigned char *)s2;
}

static size_t strlen(const char *s) {
    size_t len = 0;
    while (s[len])
        len++;
    return len;
}

static char *strcpy(char *dest, const char *src) {
    char *d = dest;
    while ((*d++ = *src++))
        ;
    return dest;
}

static char *strrchr(const char *s, int c) {
    const char *last = NULL;
    while (*s) {
        if (*s == c) {
            last = s;
        }
        s++;
    }
    return (char *)last;
}

/**
 * 実行可能ファイルのエントリポイントを解決
 * 
 * 注意: 現在はシェルビルトインコマンドのみサポート
 * 将来的にELFローダーを実装予定
 */
static int (*resolve_entry_point(const char *path))(int, char**) {
    /* TODO: ファイルシステムから実行可能ファイルを読み込む */
    /* TODO: ELFパーサーを実装 */
    /* TODO: WebAssemblyモジュールのロードを実装 */
    
    /* 現在はビルトインコマンドのマッピングのみ */
    struct builtin_cmd {
        const char *name;
        int (*func)(int, char**);
    };
    
    /* ビルトインコマンドのリスト (将来的に拡張) */
    static struct builtin_cmd builtins[] = {
        /* シェルコマンドをここに追加 */
        {NULL, NULL}
    };
    
    /* パスからコマンド名を抽出 */
    const char *cmd_name = strrchr(path, '/');
    if (cmd_name) {
        cmd_name++;
    } else {
        cmd_name = path;
    }
    
    /* ビルトインコマンドを検索 */
    for (int i = 0; builtins[i].name != NULL; i++) {
        if (strcmp(cmd_name, builtins[i].name) == 0) {
            return builtins[i].func;
        }
    }
    
    return NULL;
}

/**
 * 引数配列をコピー
 */
static char **copy_argv(char *const argv[]) {
    int argc = 0;
    char **new_argv;
    
    /* 引数カウント */
    if (argv) {
        while (argv[argc] != NULL) {
            argc++;
        }
    }
    
    /* 配列を割り当て */
    new_argv = (char **)kmalloc((argc + 1) * sizeof(char *));
    if (new_argv == NULL) {
        return NULL;
    }
    
    /* 各引数をコピー */
    for (int i = 0; i < argc; i++) {
        size_t len = strlen(argv[i]) + 1;
        new_argv[i] = (char *)kmalloc(len);
        if (new_argv[i] == NULL) {
            /* エラー時はクリーンアップ */
            for (int j = 0; j < i; j++) {
                kfree(new_argv[j]);
            }
            kfree(new_argv);
            return NULL;
        }
        strcpy(new_argv[i], argv[i]);
    }
    
    new_argv[argc] = NULL;
    return new_argv;
}

/**
 * 引数配列を解放
 */
static void free_argv(char **argv) {
    if (argv == NULL) {
        return;
    }
    
    for (int i = 0; argv[i] != NULL; i++) {
        kfree(argv[i]);
    }
    kfree(argv);
}

/**
 * プロセスラッパー関数
 * 新しいプロセスのエントリポイントから呼ばれる
 */
static int process_wrapper(int argc, char **argv) {
    struct process *proc = process_get_current();
    int ret = 0;
    
    kprintf("[SPAWN] Process %d started: %s\n", proc->pid, proc->name);
    
    /* エントリポイントを実行 */
    if (proc->entry) {
        ret = proc->entry(argc, argv);
    }
    
    /* プロセスを終了 */
    process_exit(ret);
    
    /* ここには到達しない */
    return ret;
}

/**
 * POSIX spawn実装
 */
int posix_spawn(pid_t *pid, const char *path,
                const posix_spawn_file_actions_t *file_actions,
                const posix_spawnattr_t *attrp,
                char *const argv[], char *const envp[]) {
    pid_t new_pid;
    int (*entry_point)(int, char**);
    char **new_argv = NULL;
    int argc = 0;
    
    kprintf("[SPAWN] posix_spawn: %s\n", path);
    
    /* パスをチェック */
    if (path == NULL) {
        kprintf("[SPAWN] Invalid path\n");
        return -1;
    }
    
    /* エントリポイントを解決 */
    entry_point = resolve_entry_point(path);
    if (entry_point == NULL) {
        kprintf("[SPAWN] Failed to resolve entry point for %s\n", path);
        return -1;
    }
    
    /* 引数をコピー */
    if (argv) {
        new_argv = copy_argv(argv);
        if (new_argv == NULL) {
            kprintf("[SPAWN] Failed to copy arguments\n");
            return -1;
        }
        while (argv[argc] != NULL) {
            argc++;
        }
    }
    
    /* TODO: file_actionsの処理 */
    /* TODO: attrpの処理 */
    /* TODO: envpの処理 */
    
    /* プロセスを作成 */
    new_pid = process_create(path, entry_point, argc, new_argv);
    if (new_pid < 0) {
        kprintf("[SPAWN] Failed to create process\n");
        if (new_argv) {
            free_argv(new_argv);
        }
        return -1;
    }
    
    /* PIDを返す */
    if (pid) {
        *pid = new_pid;
    }
    
    kprintf("[SPAWN] Created new process with PID %d\n", new_pid);
    return 0;
}

/**
 * 簡易版spawn (テスト用)
 */
pid_t spawn_simple(const char *name, int (*func)(int, char**)) {
    char *argv[] = {(char *)name, NULL};
    pid_t pid;
    
    /* 直接エントリポイントを指定してプロセスを作成 */
    pid = process_create(name, func, 1, argv);
    
    return pid;
}