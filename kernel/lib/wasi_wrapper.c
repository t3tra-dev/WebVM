/*
 * WebVM WASI システムコールラッパー
 */

#include "../include/wasi_syscalls.h"

/**
 * 文字列を指定したファイルディスクリプタに書き込む
 */
int wasi_write(int fd, const char *str, size_t len) {
  wasi_iovec_t iov = {.buf = str, .buf_len = len};
  int nwritten;
  return __wasi_fd_write(fd, &iov, 1, &nwritten);
}

/**
 * 指定したファイルディスクリプタから読み込む
 */
int wasi_read(int fd, char *buf, size_t len) {
  wasi_iovec_t iov = {.buf = buf, .buf_len = len};
  int nread;
  int ret = __wasi_fd_read(fd, &iov, 1, &nread);
  if (ret == 0) {
    return nread;
  }
  return -1;
}

/**
 * プロセスを終了
 */
void wasi_exit(int code) { __wasi_proc_exit(code); }

/**
 * 現在時刻をナノ秒で取得
 */
uint64_t wasi_get_time_ns(void) {
  uint64_t time;
  __wasi_clock_time_get(WASI_CLOCK_REALTIME, 1000000, &time);
  return time;
}