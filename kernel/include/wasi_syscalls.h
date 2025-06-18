/*
 * WebVM WASI システムコール定義
 */

#ifndef __WEBVM_WASI_SYSCALLS_H__
#define __WEBVM_WASI_SYSCALLS_H__

#include <stdint.h>
#include <stddef.h>

/* WASI インポート関数 */
__attribute__((import_module("wasi_snapshot_preview1"), import_name("proc_exit")))
extern void __wasi_proc_exit(int exit_code);

__attribute__((import_module("wasi_snapshot_preview1"), import_name("fd_write")))
extern int __wasi_fd_write(int fd, const void* iovs, int iovs_len, int* nwritten);

__attribute__((import_module("wasi_snapshot_preview1"), import_name("fd_read")))
extern int __wasi_fd_read(int fd, const void* iovs, int iovs_len, int* nread);

__attribute__((import_module("wasi_snapshot_preview1"), import_name("clock_time_get")))
extern int __wasi_clock_time_get(int clock_id, uint64_t precision, uint64_t* time);

/* iovec構造体 */
typedef struct {
    const void* buf;
    size_t buf_len;
} wasi_iovec_t;

/* ファイルディスクリプタ */
#define STDIN_FILENO  0
#define STDOUT_FILENO 1
#define STDERR_FILENO 2

/* クロックID */
#define WASI_CLOCK_REALTIME 0
#define WASI_CLOCK_MONOTONIC 1

/* ラッパー関数 */
int wasi_write(int fd, const char* str, size_t len);
int wasi_read(int fd, char* buf, size_t len);
void wasi_exit(int code);
uint64_t wasi_get_time_ns(void);

#endif /* __WEBVM_WASI_SYSCALLS_H__ */