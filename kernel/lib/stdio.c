/*
 * WebVM 標準入出力関数
 *
 * WASI システムコールを使用した簡易実装
 */

#include "../include/kernel.h"
#include "../include/wasi_syscalls.h"
#include <stdarg.h>

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
  int is_negative = 0;
  unsigned int uvalue;

  if (base < 2 || base > 36) {
    *str = '\0';
    return;
  }

  /* 負の数の処理 */
  if (value < 0 && base == 10) {
    is_negative = 1;
    uvalue = (unsigned int)(-value);
  } else {
    uvalue = (unsigned int)value;
  }

  /* 数値を文字に変換 */
  do {
    *ptr++ = "0123456789abcdefghijklmnopqrstuvwxyz"[uvalue % base];
    uvalue /= base;
  } while (uvalue);

  /* 負の符号を追加 */
  if (is_negative)
    *ptr++ = '-';
  
  *ptr-- = '\0';

  /* 文字列を反転 */
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
  va_list args;
  int total_written = 0;
  
  va_start(args, format);

  /* 簡易的な実装 - %s, %d, %x, %-Nd のみサポート */
  while (format[i] && buf_idx < sizeof(buffer) - 1) {
    if (format[i] == '%' && format[i + 1]) {
      i++;
      
      /* フィールド幅を解析 */
      int field_width = 0;
      int left_align = 0;
      
      if (format[i] == '-') {
        left_align = 1;
        i++;
      }
      
      while (format[i] >= '0' && format[i] <= '9') {
        field_width = field_width * 10 + (format[i] - '0');
        i++;
      }
      
      switch (format[i]) {
      case 's': {
        /* 文字列は直接出力 */
        if (buf_idx > 0) {
          wasi_write(STDOUT_FILENO, buffer, buf_idx);
          total_written += buf_idx;
          buf_idx = 0;
        }
        const char *str = va_arg(args, const char *);
        if (str == NULL) str = "(null)";
        int str_len = strlen_internal(str);
        
        /* フィールド幅の処理 */
        if (field_width > str_len && !left_align) {
          for (int j = 0; j < field_width - str_len; j++) {
            wasi_write(STDOUT_FILENO, " ", 1);
            total_written++;
          }
        }
        
        wasi_write(STDOUT_FILENO, str, str_len);
        total_written += str_len;
        
        if (field_width > str_len && left_align) {
          for (int j = 0; j < field_width - str_len; j++) {
            wasi_write(STDOUT_FILENO, " ", 1);
            total_written++;
          }
        }
        break;
      }
      case 'd': {
        /* 整数は変換して追加 */
        char num_buf[32];
        int num = va_arg(args, int);
        itoa_internal(num, num_buf, 10);
        int num_len = strlen_internal(num_buf);
        
        /* フィールド幅の処理 */
        if (field_width > num_len && !left_align) {
          for (int j = 0; j < field_width - num_len; j++) {
            if (buf_idx < sizeof(buffer) - 1) {
              buffer[buf_idx++] = ' ';
            }
          }
        }
        
        for (int j = 0; j < num_len && buf_idx < sizeof(buffer) - 1; j++) {
          buffer[buf_idx++] = num_buf[j];
        }
        
        if (field_width > num_len && left_align) {
          for (int j = 0; j < field_width - num_len; j++) {
            if (buf_idx < sizeof(buffer) - 1) {
              buffer[buf_idx++] = ' ';
            }
          }
        }
        break;
      }
      case 'x': {
        /* 16進数 */
        char num_buf[32];
        unsigned int num = va_arg(args, unsigned int);
        itoa_internal(num, num_buf, 16);
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
        if (buf_idx < sizeof(buffer) - 1) {
          buffer[buf_idx++] = format[i];
        }
        break;
      }
      i++;
    } else {
      buffer[buf_idx++] = format[i++];
    }
  }

  if (buf_idx > 0) {
    wasi_write(STDOUT_FILENO, buffer, buf_idx);
    total_written += buf_idx;
  }
  
  va_end(args);
  return total_written;
}

/**
 * エラー出力
 */
int kfprintf(int fd, const char *format, ...) {
  char buffer[1024];
  int buf_idx = 0;
  int i = 0;
  va_list args;
  int total_written = 0;
  
  va_start(args, format);

  /* kprintfと同じ実装だが、出力先がfd */
  while (format[i] && buf_idx < sizeof(buffer) - 1) {
    if (format[i] == '%' && format[i + 1]) {
      i++;
      switch (format[i]) {
      case 's': {
        if (buf_idx > 0) {
          wasi_write(fd, buffer, buf_idx);
          total_written += buf_idx;
          buf_idx = 0;
        }
        const char *str = va_arg(args, const char *);
        if (str == NULL) str = "(null)";
        int str_len = strlen_internal(str);
        wasi_write(fd, str, str_len);
        total_written += str_len;
        break;
      }
      case 'd': {
        char num_buf[32];
        int num = va_arg(args, int);
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
        if (buf_idx < sizeof(buffer) - 1) {
          buffer[buf_idx++] = format[i];
        }
        break;
      }
      i++;
    } else {
      buffer[buf_idx++] = format[i++];
    }
  }

  if (buf_idx > 0) {
    wasi_write(fd, buffer, buf_idx);
    total_written += buf_idx;
  }
  
  va_end(args);
  return total_written;
}
