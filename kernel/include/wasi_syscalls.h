/*
 * WebVM WASI システムコール定義
 */

#ifndef __WEBVM_WASI_SYSCALLS_H__
#define __WEBVM_WASI_SYSCALLS_H__

#include <stddef.h>
#include <stdint.h>

/* WASI インポート関数 */
__attribute__((import_module("wasi_snapshot_preview1"),
               import_name("proc_exit"))) extern void
__wasi_proc_exit(int exit_code);

__attribute__((import_module("wasi_snapshot_preview1"),
               import_name("fd_write"))) extern int
__wasi_fd_write(int fd, const void *iovs, int iovs_len, int *nwritten);

__attribute__((import_module("wasi_snapshot_preview1"),
               import_name("fd_read"))) extern int
__wasi_fd_read(int fd, const void *iovs, int iovs_len, int *nread);

__attribute__((import_module("wasi_snapshot_preview1"),
               import_name("clock_time_get"))) extern int
__wasi_clock_time_get(int clock_id, uint64_t precision, uint64_t *time);

__attribute__((import_module("wasi_snapshot_preview1"),
               import_name("path_open"))) extern int
__wasi_path_open(int dirfd, int dirflags, const char *path, int path_len,
                 int oflags, uint64_t fs_rights_base,
                 uint64_t fs_rights_inheriting, int fdflags, int *fd);

__attribute__((import_module("wasi_snapshot_preview1"),
               import_name("path_create_directory"))) extern int
__wasi_path_create_directory(int fd, const char *path, int path_len, int mode);

__attribute__((import_module("wasi_snapshot_preview1"),
               import_name("path_remove_directory"))) extern int
__wasi_path_remove_directory(int fd, const char *path, int path_len);

__attribute__((import_module("wasi_snapshot_preview1"),
               import_name("path_filestat_get"))) extern int
__wasi_path_filestat_get(const char *path, int path_len, void *buf);

__attribute__((import_module("wasi_snapshot_preview1"),
               import_name("path_unlink_file"))) extern int
__wasi_path_unlink_file(int fd, const char *path, int path_len);

__attribute__((import_module("wasi_snapshot_preview1"),
               import_name("fd_filestat_get"))) extern int
__wasi_fd_filestat_get(int fd, void *buf);

__attribute__((import_module("wasi_snapshot_preview1"),
               import_name("directory_exists"))) extern int
__wasi_directory_exists(const char *path, int path_len, int *result);

__attribute__((import_module("wasi_snapshot_preview1"),
               import_name("list_directory"))) extern int
__wasi_list_directory(const char *path, int path_len, char *buffer,
                      int buffer_size, int *count);

__attribute__((import_module("wasi_snapshot_preview1"),
               import_name("file_create"))) extern int
__wasi_file_create(const char *path, int path_len, int mode);

__attribute__((import_module("wasi_snapshot_preview1"),
               import_name("file_read"))) extern int
__wasi_file_read(const char *path, int path_len, char *buffer, int buffer_size,
                 int *bytes_read);

__attribute__((import_module("wasi_snapshot_preview1"),
               import_name("file_write"))) extern int
__wasi_file_write(const char *path, int path_len, const char *data,
                  int data_len);

__attribute__((import_module("wasi_snapshot_preview1"),
               import_name("file_delete"))) extern int
__wasi_file_delete(const char *path, int path_len);

__attribute__((import_module("wasi_snapshot_preview1"),
               import_name("file_exists"))) extern int
__wasi_file_exists(const char *path, int path_len, int *result);

__attribute__((import_module("wasi_snapshot_preview1"),
               import_name("file_stat"))) extern int
__wasi_file_stat(const char *path, int path_len, void *stat_buf);

__attribute__((import_module("wasi_snapshot_preview1"),
               import_name("file_get_size"))) extern int
__wasi_file_get_size(const char *path, int path_len, unsigned long *size);

__attribute__((import_module("wasi_snapshot_preview1"),
               import_name("file_read_direct"))) extern int
__wasi_file_read_direct(const char *path, int path_len, char *buffer, int buffer_size, int *bytes_read);

__attribute__((import_module("wasi_snapshot_preview1"),
               import_name("file_close_direct"))) extern int
__wasi_file_close_direct(const char *path, int path_len);

/* iovec構造体 */
typedef struct {
  const void *buf;
  size_t buf_len;
} wasi_iovec_t;

/* ファイルディスクリプタ */
#define STDIN_FILENO 0
#define STDOUT_FILENO 1
#define STDERR_FILENO 2

/* クロックID */
#define WASI_CLOCK_REALTIME 0
#define WASI_CLOCK_MONOTONIC 1

/* ラッパー関数 */
int wasi_write(int fd, const char *str, size_t len);
int wasi_read(int fd, char *buf, size_t len);
void wasi_exit(int code);
uint64_t wasi_get_time_ns(void);

#endif /* __WEBVM_WASI_SYSCALLS_H__ */
