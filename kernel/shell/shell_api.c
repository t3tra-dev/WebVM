/*
 * WebVM シェルAPI
 *
 * JavaScript側から呼び出せるシェル関数
 */

#include "../include/fs.h"
#include "../include/kernel.h"
#include "../include/wasi_syscalls.h"

/* 外部関数 */
extern void execute_command(char *cmd);

/**
 * コマンドハンドラ (JavaScriptから呼び出される)
 */
void handle_command(const char *command) {
  static char cmd_buffer[256];
  int i;

  /* コマンドをコピー */
  for (i = 0; i < 255 && command[i]; i++) {
    cmd_buffer[i] = command[i];
  }
  cmd_buffer[i] = '\0';

  /* コマンドを実行 */
  execute_command(cmd_buffer);

  /* 次のプロンプトを表示 (現在のディレクトリ付き) */
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
}
