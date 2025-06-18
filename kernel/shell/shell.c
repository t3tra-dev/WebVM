/*
 * WebVM シェル実装
 *
 * 基本的なコマンドラインインターフェース
 */

#include "../include/kernel.h"
#include "../include/wasi_syscalls.h"

/* 外部関数宣言 */
int kprintf(const char *format, ...);
int kputs(const char *str);
int kfprintf(int fd, const char *format, ...);

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

/* コマンドバッファ */
#define CMD_BUFFER_SIZE 256
static char cmd_buffer[CMD_BUFFER_SIZE];

/* ビルトインコマンド */
static void cmd_help(void) {
  kputs("WebVM Shell - Available commands:");
  kputs("  help    - Show this help message");
  kputs("  clear   - Clear the terminal");
  kputs("  echo    - Echo arguments to stdout");
  kputs("  ps      - List processes (stub)");
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
  kputs("PID  TTY      TIME     CMD");
  kputs("1    tty0     00:00:00 kernel");
  kputs("2    tty0     00:00:00 shell");
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
  } else if (strcmp(cmd, "ls") == 0) {
    cmd_ls();
  } else if (strcmp(cmd, "cat") == 0) {
    cmd_cat(args);
  } else if (strcmp(cmd, "exit") == 0) {
    kputs("Goodbye!");
    wasi_exit(0);
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