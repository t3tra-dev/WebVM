/*
 * WebVM 標準入出力関数
 *
 * WASI システムコールを使用した簡易実装
 */

#include "../include/kernel.h"
#include "../include/wasi_syscalls.h"

/* 内部関数宣言 */
static int strlen_internal(const char *str);
static void itoa_internal(int value, char *str, int base);

/**
 * 文字列の長さを取得
 */
static int strlen_internal(const char *str) {
  int len = 0;
  while (str[len] != '\0')
    len++;
  return len;
}

/**
 * 整数を文字列に変換
 */
static void itoa_internal(int value, char *str, int base) {
  char *ptr = str;
  char *ptr1 = str;
  char tmp_char;
  int tmp_value;

  if (base < 2 || base > 36) {
    *str = '\0';
    return;
  }

  do {
    tmp_value = value;
    value /= base;
    *ptr++ = "0123456789abcdefghijklmnopqrstuvwxyz"[tmp_value - value * base];
  } while (value);

  if (tmp_value < 0)
    *ptr++ = '-';
  *ptr-- = '\0';

  while (ptr1 < ptr) {
    tmp_char = *ptr;
    *ptr-- = *ptr1;
    *ptr1++ = tmp_char;
  }
}

/**
 * 文字を出力
 */
int kputchar(int c) {
  char ch = (char)c;
  return wasi_write(STDOUT_FILENO, &ch, 1);
}

/**
 * 文字列を出力
 */
int kputs(const char *str) {
  int len = strlen_internal(str);
  wasi_write(STDOUT_FILENO, str, len);
  wasi_write(STDOUT_FILENO, "\n", 1);
  return len + 1;
}

/**
 * 書式付き出力 (簡易版)
 */
int kprintf(const char *format, ...) {
  char buffer[1024];
  int buf_idx = 0;
  int i = 0;

  /* 簡易的な実装 - %s, %d, %x のみサポート */
  while (format[i] && buf_idx < sizeof(buffer) - 1) {
    if (format[i] == '%' && format[i + 1]) {
      i++;
      switch (format[i]) {
      case 's': {
        /* 文字列は直接出力 */
        if (buf_idx > 0) {
          wasi_write(STDOUT_FILENO, buffer, buf_idx);
          buf_idx = 0;
        }
        /* TODO: 可変引数から文字列を取得 */
        const char *str = "TODO";
        wasi_write(STDOUT_FILENO, str, strlen_internal(str));
        break;
      }
      case 'd': {
        /* 整数は変換して追加 */
        char num_buf[32];
        /* TODO: 可変引数から整数を取得 */
        int num = 0;
        itoa_internal(num, num_buf, 10);
        int num_len = strlen_internal(num_buf);
        for (int j = 0; j < num_len && buf_idx < sizeof(buffer) - 1; j++) {
          buffer[buf_idx++] = num_buf[j];
        }
        break;
      }
      case '%':
        buffer[buf_idx++] = '%';
        break;
      default:
        buffer[buf_idx++] = '%';
        buffer[buf_idx++] = format[i];
        break;
      }
      i++;
    } else {
      buffer[buf_idx++] = format[i++];
    }
  }

  if (buf_idx > 0) {
    wasi_write(STDOUT_FILENO, buffer, buf_idx);
  }

  return buf_idx;
}

/**
 * エラー出力
 */
int kfprintf(int fd, const char *format, ...) {
  /* 簡易実装 - formatをそのまま出力 */
  int len = strlen_internal(format);
  wasi_write(fd, format, len);
  return len;
}