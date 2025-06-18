/*
 * WebVM コンソールドライバ
 *
 * 標準入出力の処理
 */

#include "../include/drivers.h"
#include "../include/kernel.h"
#include "../include/wasi_syscalls.h"

/* 外部関数宣言 */
int kprintf(const char *format, ...);
int kputchar(int c);
int kputs(const char *str);

/* コンソールバッファサイズ */
#define CONSOLE_BUFFER_SIZE 4096

/* コンソール構造体 */
struct console {
  char input_buffer[CONSOLE_BUFFER_SIZE];
  int input_pos;
  int echo_enabled;
};

/* グローバル変数 */
static struct console console_dev = {
    .input_pos = 0,
    .echo_enabled = 1,
};

/**
 * コンソールドライバの初期化
 */
int console_init(void) {
  /* コンソールを初期化 */
  console_dev.input_pos = 0;
  console_dev.echo_enabled = 1;

  KDEBUG("Console driver initialized");

  return KERNEL_SUCCESS;
}

/**
 * コンソールに文字を出力
 */
int console_putc(char c) { return kputchar(c); }

/**
 * コンソールに文字列を出力
 */
int console_puts(const char *str) { return kputs(str); }

/**
 * コンソールから文字を読み込み
 */
int console_getc(void) {
  char c;
  wasi_read(STDIN_FILENO, &c, 1);
  return c;
}

/**
 * コンソールから行を読み込み
 */
char *console_gets(char *buffer, int size) {
  int i = 0;
  char c;

  while (i < size - 1) {
    if (wasi_read(STDIN_FILENO, &c, 1) <= 0)
      break;
    if (c == '\n')
      break;
    buffer[i++] = c;
  }
  buffer[i] = '\0';

  return i > 0 ? buffer : NULL;
}

/**
 * コンソールをクリア
 */
void console_clear(void) {
  /* ANSI エスケープシーケンスでクリア */
  const char *clear_seq = "\033[2J\033[H";
  wasi_write(STDOUT_FILENO, clear_seq, 7);
}

/**
 * カーソル位置を設定
 */
void console_set_cursor(int x, int y) {
  char buf[32];
  int len = 0;

  /* 簡易的なsprintf実装 */
  buf[len++] = '\033';
  buf[len++] = '[';
  /* TODO: 数値変換 */
  buf[len++] = 'H';

  wasi_write(STDOUT_FILENO, buf, len);
}

/**
 * テキスト色を設定
 */
void console_set_color(int fg, int bg) {
  char buf[16];
  int len = 0;

  if (fg >= 0) {
    buf[len++] = '\033';
    buf[len++] = '[';
    buf[len++] = '3';
    buf[len++] = '0' + fg;
    buf[len++] = 'm';
    wasi_write(STDOUT_FILENO, buf, len);
  }

  if (bg >= 0) {
    len = 0;
    buf[len++] = '\033';
    buf[len++] = '[';
    buf[len++] = '4';
    buf[len++] = '0' + bg;
    buf[len++] = 'm';
    wasi_write(STDOUT_FILENO, buf, len);
  }
}

/**
 * テキスト属性をリセット
 */
void console_reset_attr(void) {
  const char *reset_seq = "\033[0m";
  wasi_write(STDOUT_FILENO, reset_seq, 4);
}