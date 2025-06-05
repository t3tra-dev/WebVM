// WASI imports
__attribute__((import_module("wasi_snapshot_preview1"), import_name("proc_exit")))
extern void __wasi_proc_exit(int exit_code);

__attribute__((import_module("wasi_snapshot_preview1"), import_name("fd_write")))
extern int __wasi_fd_write(int fd, const void* iovs, int iovs_len, int* nwritten);

// writev を console に出力するための構造体
typedef struct {
    const void* buf;
    int buf_len;
} iovec_t;

// stdio ファイルディスクリプタ
#define STDOUT_FILENO 1
#define STDERR_FILENO 2

int wasi_write(int fd, const char* str, int len) {
    iovec_t iov = { .buf = str, .buf_len = len };
    int nwritten;
    return __wasi_fd_write(fd, &iov, 1, &nwritten);
}

int strlen_wasi(const char* str) {
    int len = 0;
    while (str[len] != '\0') len++;
    return len;
}

void _start(void) {
    const char* message = "Hello, WebVM!\n";
    wasi_write(STDOUT_FILENO, message, strlen_wasi(message));
    
    // 正常終了
    __wasi_proc_exit(0);
}
