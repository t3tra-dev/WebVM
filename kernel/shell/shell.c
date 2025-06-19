/*
 * WebVM シェル実装
 *
 * 基本的なコマンドラインインターフェース
 */

#include "../include/kernel.h"
#include "../include/wasi_syscalls.h"
#include "../include/process.h"
#include "../include/ipc.h"

/* 外部関数宣言 */
int kprintf(const char *format, ...);
int kputs(const char *str);
int kfprintf(int fd, const char *format, ...);
extern pid_t spawn_simple(const char *name, int (*func)(int, char**));

/* 文字列関数 */
static int strcmp(const char *s1, const char *s2) {
  while (*s1 && (*s1 == *s2)) {
    s1++;
    s2++;
  }
  return *(unsigned char *)s1 - *(unsigned char *)s2;
}

static int strncmp(const char *s1, const char *s2, size_t n) {
  while (n && *s1 && (*s1 == *s2)) {
    s1++;
    s2++;
    n--;
  }
  if (n == 0)
    return 0;
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

static int atoi(const char *str) {
  int result = 0;
  int sign = 1;
  
  /* スキップ空白 */
  while (*str == ' ' || *str == '\t')
    str++;
  
  /* 符号チェック */
  if (*str == '-') {
    sign = -1;
    str++;
  } else if (*str == '+') {
    str++;
  }
  
  /* 数字を変換 */
  while (*str >= '0' && *str <= '9') {
    result = result * 10 + (*str - '0');
    str++;
  }
  
  return result * sign;
}

/* コマンドバッファ */
#define CMD_BUFFER_SIZE 256
static char cmd_buffer[CMD_BUFFER_SIZE];

/* ビルトインコマンド */
static void cmd_help(void) {
  kputs("WebVM Shell - Available commands:");
  kputs("  help    - Show this help message");
  kputs("  clear   - Clear the terminal");
  kputs("  echo    - Echo arguments to stdout");
  kputs("  ps      - List running processes");
  kputs("  kill    - Terminate a process (kill <pid>)");
  kputs("  spawn   - Spawn a test process");
  kputs("  ls      - List files (stub)");
  kputs("  cat     - Display file contents (stub)");
  kputs("  exit    - Exit the shell");
  kputs("  about   - Show system information");
}

static void cmd_clear(void) {
  /* ANSI エスケープシーケンスでクリア */
  const char *clear_seq = "\033[2J\033[H";
  wasi_write(STDOUT_FILENO, clear_seq, 7);
}

static void cmd_echo(const char *args) {
  if (args && *args) {
    kputs(args);
  } else {
    kputs("");
  }
}

static void cmd_about(void) {
  kputs("WebVM - POSIX-compatible WebAssembly OS");
  kputs("Version: 0.1.0");
  kputs("Architecture: wasm32");
  kputs("Memory: 128MB shared");
  kputs("");
  kputs("This is a minimal UNIX-like operating system");
  kputs("running entirely in your web browser.");
}

static void cmd_ps(void) {
  /* プロセステーブルをダンプ */
  process_dump_table();
}

static void cmd_ls(void) { kputs("bin  dev  etc  home  proc  tmp  usr  var"); }

static void cmd_cat(const char *args) {
  if (!args || !*args) {
    kputs("cat: missing file operand");
    return;
  }

  /* 仮の実装 */
  if (strcmp(args, "/proc/version") == 0) {
    kputs("WebVM version 0.1.0");
  } else if (strcmp(args, "/etc/passwd") == 0) {
    kputs("root:x:0:0:root:/root:/bin/sh");
    kputs("user:x:1000:1000:user:/home/user:/bin/sh");
  } else {
    kprintf("cat: %s: No such file or directory\n", args);
  }
}

static void cmd_kill(const char *args) {
  pid_t pid;
  int result;
  
  if (!args || !*args) {
    kputs("kill: usage: kill <pid>");
    return;
  }
  
  /* PIDを解析 */
  pid = atoi(args);
  if (pid < 0) {
    kprintf("kill: invalid pid: %s\n", args);
    return;
  }
  
  /* 現在のシェルプロセスは終了できない */
  if (pid == 1) {
    kputs("kill: cannot kill current shell");
    return;
  }
  
  /* プロセスを終了 */
  result = process_kill(pid, 9); /* SIGKILL */
  if (result < 0) {
    kprintf("kill: failed to kill process %d\n", pid);
  } else {
    kprintf("Process %d terminated\n", pid);
  }
}

/* テストプロセスのエントリポイント */
static int test_process_entry(int argc, char **argv) {
  int count = 0;
  kprintf("[TEST] Test process started (pid=%d)\n", process_get_current()->pid);
  
  /* 簡単なループ */
  while (count < 5) {
    kprintf("[TEST] Test process running... count=%d\n", count);
    count++;
    
    /* CPUを譲る */
    scheduler_yield();
  }
  
  kprintf("[TEST] Test process exiting\n");
  return 0;
}

static void cmd_spawn(const char *args) {
  pid_t pid;
  
  /* テストプロセスを生成 */
  pid = spawn_simple("test_process", test_process_entry);
  if (pid < 0) {
    kputs("spawn: failed to create process");
  } else {
    kprintf("Spawned test process with PID %d\n", pid);
  }
}

/* コマンドを解析して実行 */
void execute_command(char *cmd) {
  char *args = NULL;

  /* コマンドと引数を分離 */
  char *space = cmd;
  while (*space && *space != ' ')
    space++;
  if (*space) {
    *space = '\0';
    args = space + 1;
    /* 先頭の空白をスキップ */
    while (*args == ' ')
      args++;
  }

  /* コマンドを実行 */
  if (strcmp(cmd, "help") == 0) {
    cmd_help();
  } else if (strcmp(cmd, "clear") == 0) {
    cmd_clear();
  } else if (strcmp(cmd, "echo") == 0) {
    cmd_echo(args);
  } else if (strcmp(cmd, "about") == 0) {
    cmd_about();
  } else if (strcmp(cmd, "ps") == 0) {
    cmd_ps();
  } else if (strcmp(cmd, "kill") == 0) {
    cmd_kill(args);
  } else if (strcmp(cmd, "spawn") == 0) {
    cmd_spawn(args);
  } else if (strcmp(cmd, "ls") == 0) {
    cmd_ls();
  } else if (strcmp(cmd, "cat") == 0) {
    cmd_cat(args);
  } else if (strcmp(cmd, "exit") == 0) {
    kputs("Goodbye!");
    /* WebAssembly環境では実際の終了は行えない */
    /* JavaScriptから制御を切断する必要がある */
  } else if (*cmd) { /* 空コマンドは無視 */
    kprintf("sh: %s: command not found\n", cmd);
  }
}

/* 1行読み込み (シンプル版)  */
static int read_line(char *buffer, int size) {
  int n = wasi_read(STDIN_FILENO, buffer, size - 1);
  if (n > 0) {
    /* 改行を削除 */
    if (buffer[n - 1] == '\n') {
      buffer[n - 1] = '\0';
      return n - 1;
    }
    buffer[n] = '\0';
    return n;
  }
  return -1;
}

/* シェルのメインループ */
void shell_main(void) {
  kputs("");
  kputs("Welcome to WebVM Shell!");
  kputs("Type 'help' for available commands.");
  kputs("");

  /* 最初のプロンプトを表示 */
  wasi_write(STDOUT_FILENO, "$ ", 2);

  /* 初期化が終わったらカーネルは終了する */
  /* JavaScriptからの入力は handleCommand 経由で処理される */
}
