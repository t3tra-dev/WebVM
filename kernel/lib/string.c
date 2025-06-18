/*
 * WebVM カーネル文字列関数
 *
 * wasi-libc に含まれない追加の文字列関数
 */

#include "../include/kernel.h"
#include <stddef.h>

/* 文字列関数のプロトタイプ */
size_t strlen(const char *s);
void *memcpy(void *dest, const void *src, size_t n);

/**
 * strlen実装
 */
size_t strlen(const char *s) {
  size_t len = 0;
  while (s[len])
    len++;
  return len;
}

/**
 * memcpy実装
 */
void *memcpy(void *dest, const void *src, size_t n) {
  unsigned char *d = dest;
  const unsigned char *s = src;
  while (n--) {
    *d++ = *s++;
  }
  return dest;
}

/**
 * 安全な文字列コピー (NUL終端を保証)
 */
size_t strlcpy(char *dst, const char *src, size_t size) {
  size_t src_len = strlen(src);

  if (size > 0) {
    size_t copy_len = MIN(src_len, size - 1);
    memcpy(dst, src, copy_len);
    dst[copy_len] = '\0';
  }

  return src_len;
}

/**
 * 安全な文字列連結 (NUL終端を保証)
 */
size_t strlcat(char *dst, const char *src, size_t size) {
  size_t dst_len = strlen(dst);
  size_t src_len = strlen(src);

  if (dst_len >= size) {
    return size + src_len;
  }

  size_t remain = size - dst_len;
  size_t copy_len = MIN(src_len, remain - 1);

  memcpy(dst + dst_len, src, copy_len);
  dst[dst_len + copy_len] = '\0';

  return dst_len + src_len;
}

/**
 * 文字列を複製 (メモリ確保付き)
 */
char *kstrdup(const char *s) {
  /* TODO: kmalloc実装後に有効化 */
  return NULL;
}

/**
 * 文字列内の文字を置換
 */
char *strreplace(char *str, char old, char new) {
  char *p = str;

  while (*p) {
    if (*p == old) {
      *p = new;
    }
    p++;
  }

  return str;
}