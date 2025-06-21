/*
 * WebVM シェル実装
 *
 * 基本的なコマンドラインインターフェース
 */

#include "../include/fs.h"
#include "../include/ipc.h"
#include "../include/kernel.h"
#include "../include/process.h"
#include "../include/wasi_syscalls.h"

/* 外部関数宣言 */
int kprintf(const char *format, ...);
int kputs(const char *str);
int kfprintf(int fd, const char *format, ...);
extern pid_t spawn_simple(const char *name, int (*func)(int, char **));

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
  kputs("  ls      - List files");
  kputs("  cat     - Display file contents");
  kputs("  touch   - Create empty file");
  kputs("  rm      - Remove file or directory (use -r for directories)");
  kputs("  cp      - Copy file");
  kputs("  mv      - Move/rename file");
  kputs("  mkdir   - Create directory");
  kputs("  cd      - Change directory");
  kputs("  pwd     - Print working directory");
  kputs("  exit    - Exit the shell");
  kputs("  about   - Show system information");
}

static void cmd_clear(void) {
  /* ANSI エスケープシーケンスでクリア */
  const char *clear_seq = "\033[2J\033[H";
  wasi_write(STDOUT_FILENO, clear_seq, 7);
}

static void cmd_echo(const char *args) {
  int fd = -1;
  int use_stdout = 1;
  int append_mode = 0;
  char text_buffer[512];
  char filename_buffer[128];
  const char *output_text;
  const char *filename;

  if (!args) {
    kputs("");
    return;
  }


  /* 作業用のコピーを作成 */
  if (strlen(args) >= sizeof(text_buffer)) {
    kputs("echo: command line too long");
    return;
  }
  strcpy(text_buffer, args);

  /* リダイレクション ('>' や '>>') をチェック */
  char *redirect_pos = text_buffer;
  while (*redirect_pos && *redirect_pos != '>') {
    redirect_pos++;
  }

  if (*redirect_pos == '>') {
    use_stdout = 0;

    /* '>>' か '>' かを判定 */
    if (redirect_pos > text_buffer && *(redirect_pos - 1) == '>') {
      append_mode = 1;
      *(redirect_pos - 1) = '\0'; /* '>>' の最初の '>' を削除 */
      output_text = text_buffer;
    } else {
      append_mode = 0;
      *redirect_pos = '\0'; /* '>' の位置で分離 */
      output_text = text_buffer;
    }

    filename = redirect_pos + 1;

    /* ファイル名の先頭の空白をスキップ */
    while (*filename == ' ' || *filename == '\t')
      filename++;

    /* ファイル名をコピー */
    int i = 0;
    while (*filename && *filename != ' ' && *filename != '\t' && i < sizeof(filename_buffer) - 1) {
      filename_buffer[i++] = *filename++;
    }
    filename_buffer[i] = '\0';

    if (filename_buffer[0] == '\0') {
      kputs("echo: missing filename for redirection");
      return;
    }


    /* ファイルを開く */
    if (append_mode) {
      fd = fs_open(filename_buffer, O_CREAT | O_WRONLY | O_APPEND,
                   S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
    } else {
      fd = fs_open(filename_buffer, O_CREAT | O_WRONLY | O_TRUNC,
                   S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
    }

    if (fd < 0) {
      kprintf("echo: cannot create %s\n", filename_buffer);
      return;
    }

    /* 出力テキストの末尾の空白を削除 */
    char *end = text_buffer + strlen(text_buffer) - 1;
    while (end > text_buffer && (*end == ' ' || *end == '\t')) {
      *end = '\0';
      end--;
    }
  } else {
    output_text = args;
  }


  /* クォートの処理 */
  char final_text[512];
  int final_len = 0;
  const char *src = output_text;
  int in_quotes = 0;

  /* 先頭の空白をスキップ */
  while (*src == ' ' || *src == '\t') src++;

  while (*src && final_len < sizeof(final_text) - 1) {
    if (*src == '"') {
      in_quotes = !in_quotes;
      src++; /* クォートをスキップ */
    } else {
      final_text[final_len++] = *src++;
    }
  }
  final_text[final_len] = '\0';


  if (use_stdout) {
    /* 標準出力に出力 */
    if (final_text[0]) {
      kputs(final_text);
    } else {
      kputs("");
    }
  } else {
    /* ファイルに出力 */
    if (final_text[0]) {
      fs_write(fd, final_text, strlen(final_text));
      fs_write(fd, "\n", 1);
    } else {
      fs_write(fd, "\n", 1);
    }
    fs_close(fd);
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

static void cmd_ls(const char *args) {
  int fd;
  struct dirent entry;
  const char *path;
  char cwd[256];
  int result;
  int file_count = 0;

  /* 引数がない場合は現在のディレクトリを使用 */
  if (!args || !*args) {
    if (fs_getcwd(cwd, sizeof(cwd))) {
      path = cwd;
    } else {
      path = "/";
    }
  } else {
    path = args;
  }

  /* ディレクトリを開く */
  fd = fs_opendir(path);
  if (fd < 0) {
    kprintf("ls: cannot access '%s': No such file or directory\n", path);
    return;
  }

  /* ディレクトリエントリを読み込み */
  while ((result = fs_readdir(fd, &entry)) == 0) {
    if (file_count > 0 && file_count % 8 == 0) {
      kputs(""); /* 改行 */
    }

    if (entry.type == DT_DIR) {
      kprintf("%-10s", entry.name);
    } else {
      kprintf("%-10s", entry.name);
    }
    file_count++;
  }

  if (file_count > 0) {
    kputs(""); /* 最後の改行 */
  }

  fs_closedir(fd);
}

static void cmd_cd(const char *args) {
  const char *path;

  /* 引数がない場合はホームディレクトリ (/) に移動 */
  if (!args || !*args) {
    path = "/";
  } else {
    path = args;
  }

  if (fs_chdir(path) < 0) {
    kprintf("cd: %s: No such file or directory\n", path);
  }
}

static void cmd_pwd(void) {
  char cwd[256];

  if (fs_getcwd(cwd, sizeof(cwd))) {
    kputs(cwd);
  } else {
    kputs("pwd: error getting current directory");
  }
}

static void cmd_touch(const char *args) {
  int fd;

  if (!args || !*args) {
    kputs("touch: missing file operand");
    return;
  }


  /* ファイルを作成 */
  fd = fs_open(args, O_CREAT | O_WRONLY, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
  if (fd < 0) {
    kprintf("touch: cannot touch '%s': Permission denied or error\n", args);
    return;
  }

  /* すぐに閉じる */
  fs_close(fd);
  kprintf("Created file: %s\n", args);
}

static void cmd_mkdir(const char *args) {
  if (!args || !*args) {
    kputs("mkdir: missing operand");
    return;
  }

  if (fs_mkdir(args, S_IRWXU | S_IRGRP | S_IXGRP | S_IROTH | S_IXOTH) < 0) {
    kprintf("mkdir: cannot create directory '%s'\n", args);
  } else {
    kprintf("Created directory: %s\n", args);
  }
}

static void cmd_rm(const char *args) {
  char *target_path;
  int recursive = 0;

  if (!args || !*args) {
    kputs("rm: missing operand");
    return;
  }

  /* -r オプションをチェック */
  target_path = (char *)args;
  if (strncmp(args, "-r ", 3) == 0 || strncmp(args, "-r\t", 3) == 0) {
    recursive = 1;
    target_path = (char *)args + 3;
    /* 先頭の空白をスキップ */
    while (*target_path == ' ' || *target_path == '\t') {
      target_path++;
    }
  }

  if (!*target_path) {
    kputs("rm: missing operand");
    return;
  }

  /* ファイルかディレクトリかを確認 */
  struct inode stat_buf;
  if (fs_stat(target_path, &stat_buf) < 0) {
    kprintf("rm: cannot remove '%s': No such file or directory\n", target_path);
    return;
  }


  /* ディレクトリの場合 */
  if (stat_buf.mode & S_IFDIR) {
    if (!recursive) {
      kprintf("rm: cannot remove '%s': Is a directory (use -r for "
              "directories)\n",
              target_path);
      return;
    }

    /* ディレクトリを削除 */
    if (fs_rmdir(target_path) < 0) {
      kprintf("rm: cannot remove directory '%s': Permission denied or "
              "not empty\n",
              target_path);
    } else {
      kprintf("Removed directory: %s\n", target_path);
    }
  } else {
    /* 通常ファイルを削除 */
    if (fs_unlink(target_path) < 0) {
      kprintf("rm: cannot remove '%s': Permission denied or error\n",
              target_path);
    } else {
      kprintf("Removed: %s\n", target_path);
    }
  }
}

static void cmd_cat(const char *args) {
  int fd;
  char buffer[256];
  int bytes_read;

  if (!args || !*args) {
    kputs("cat: missing file operand");
    return;
  }

  /* 特殊なファイルの処理 */
  if (strcmp(args, "/proc/version") == 0) {
    kputs("WebVM version 0.1.0");
    return;
  } else if (strcmp(args, "/etc/passwd") == 0) {
    kputs("root:x:0:0:root:/root:/bin/sh");
    kputs("user:x:1000:1000:user:/home/user:/bin/sh");
    return;
  }

  /* 実際のファイルを読み込み */
  fd = fs_open(args, O_RDONLY, 0);
  if (fd < 0) {
    kprintf("cat: %s: No such file or directory\n", args);
    return;
  }

  /* ファイル内容を読み込んで表示 */
  while ((bytes_read = fs_read(fd, buffer, sizeof(buffer) - 1)) > 0) {
    buffer[bytes_read] = '\0';
    kprintf("%s", buffer);
  }

  fs_close(fd);
}

static void cmd_cp(const char *args) {
  char *space_pos;
  char *src_file, *dst_file;
  int src_fd, dst_fd;
  char buffer[256];
  int bytes_read;

  if (!args || !*args) {
    kputs("cp: missing file operand");
    return;
  }

  /* 引数を分割 (src dst) */
  src_file = (char *)args;
  space_pos = src_file;
  while (*space_pos && *space_pos != ' ')
    space_pos++;
  if (!*space_pos) {
    kputs("cp: missing destination file operand");
    return;
  }

  *space_pos = '\0';
  dst_file = space_pos + 1;
  while (*dst_file == ' ')
    dst_file++;
  if (!*dst_file) {
    kputs("cp: missing destination file operand");
    return;
  }

  /* ソースファイルを開く */
  src_fd = fs_open(src_file, O_RDONLY, 0);
  if (src_fd < 0) {
    kprintf("cp: cannot open '%s': No such file or directory\n", src_file);
    return;
  }

  /* 宛先ファイルを作成 */
  dst_fd = fs_open(dst_file, O_CREAT | O_WRONLY | O_TRUNC,
                   S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
  if (dst_fd < 0) {
    kprintf("cp: cannot create '%s'\n", dst_file);
    fs_close(src_fd);
    return;
  }

  /* ファイル内容をコピー */
  while ((bytes_read = fs_read(src_fd, buffer, sizeof(buffer))) > 0) {
    if (fs_write(dst_fd, buffer, bytes_read) != bytes_read) {
      kprintf("cp: write error\n");
      break;
    }
  }

  fs_close(src_fd);
  fs_close(dst_fd);
  kprintf("Copied '%s' to '%s'\n", src_file, dst_file);
}

static void cmd_mv(const char *args) {
  char *space_pos;
  char *src_file, *dst_file;

  if (!args || !*args) {
    kputs("mv: missing file operand");
    return;
  }

  /* 引数を分割 (src dst) */
  src_file = (char *)args;
  space_pos = src_file;
  while (*space_pos && *space_pos != ' ')
    space_pos++;
  if (!*space_pos) {
    kputs("mv: missing destination file operand");
    return;
  }

  *space_pos = '\0';
  dst_file = space_pos + 1;
  while (*dst_file == ' ')
    dst_file++;
  if (!*dst_file) {
    kputs("mv: missing destination file operand");
    return;
  }

  /* コピーしてから削除 (簡易実装) */
  cmd_cp(args);     /* 元の引数を復元してコピー */
  *space_pos = ' '; /* 元に戻す */

  if (fs_unlink(src_file) < 0) {
    kprintf("mv: cannot remove '%s'\n", src_file);
  } else {
    kprintf("Moved '%s' to '%s'\n", src_file, dst_file);
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
    cmd_ls(args);
  } else if (strcmp(cmd, "cat") == 0) {
    cmd_cat(args);
  } else if (strcmp(cmd, "touch") == 0) {
    cmd_touch(args);
  } else if (strcmp(cmd, "mkdir") == 0) {
    cmd_mkdir(args);
  } else if (strcmp(cmd, "rm") == 0) {
    cmd_rm(args);
  } else if (strcmp(cmd, "cp") == 0) {
    cmd_cp(args);
  } else if (strcmp(cmd, "mv") == 0) {
    cmd_mv(args);
  } else if (strcmp(cmd, "cd") == 0) {
    cmd_cd(args);
  } else if (strcmp(cmd, "pwd") == 0) {
    cmd_pwd();
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

  /* 最初のプロンプトを表示 (現在のディレクトリ付き) */
  char cwd[256];
  char prompt[300];
  int len = 0;

  if (fs_getcwd(cwd, sizeof(cwd))) {
    /* cwd:$ の形式でプロンプトを作成 */
    int i;
    for (i = 0; cwd[i] && len < sizeof(prompt) - 3; i++) {
      prompt[len++] = cwd[i];
    }
    prompt[len++] = ':';
    prompt[len++] = '$';
    prompt[len++] = ' ';
    prompt[len] = '\0';
    wasi_write(STDOUT_FILENO, prompt, len);
  } else {
    wasi_write(STDOUT_FILENO, "$ ", 2);
  }

  /* 初期化が終わったらカーネルは終了する */
  /* JavaScriptからの入力は handleCommand 経由で処理される */
}
