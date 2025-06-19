/*
 * WebVM パイプ実装
 */

#include "../include/ipc.h"
#include "../include/kernel.h"
#include "../include/mm.h"
#include "../include/process.h"

/* 外部関数宣言 */
int kprintf(const char *format, ...);

/* 文字列関数 */
static void *memcpy(void *dest, const void *src, size_t n) {
    unsigned char *d = dest;
    const unsigned char *s = src;
    while (n--) {
        *d++ = *s++;
    }
    return dest;
}

static size_t min(size_t a, size_t b) {
    return a < b ? a : b;
}

/* パイプ定数 */
#define PIPE_BUFFER_SIZE 4096
#define MAX_PIPES 32

/* パイプファイルディスクリプタのベース */
#define PIPE_FD_BASE 100

/* パイプテーブル */
static struct {
    struct pipe pipes[MAX_PIPES];
    bool used[MAX_PIPES];
    int next_fd;
} pipe_table = {
    .next_fd = PIPE_FD_BASE
};

/**
 * 空きパイプスロットを探す
 */
static int find_free_pipe(void) {
    for (int i = 0; i < MAX_PIPES; i++) {
        if (!pipe_table.used[i]) {
            return i;
        }
    }
    return -1;
}

/**
 * ファイルディスクリプタからパイプインデックスを取得
 */
static int fd_to_pipe_index(int fd) {
    if (fd < PIPE_FD_BASE || fd >= PIPE_FD_BASE + MAX_PIPES) {
        return -1;
    }
    return fd - PIPE_FD_BASE;
}

/**
 * パイプを作成
 */
int ipc_create_pipe(int *read_fd, int *write_fd) {
    struct pipe *pipe;
    struct process *current;
    int index;
    
    if (read_fd == NULL || write_fd == NULL) {
        return -1;
    }
    
    /* 空きスロットを探す */
    index = find_free_pipe();
    if (index < 0) {
        kprintf("[PIPE] No free pipe slots\n");
        return -1;
    }
    
    /* 現在のプロセスを取得 */
    current = process_get_current();
    if (current == NULL) {
        return -1;
    }
    
    /* パイプを初期化 */
    pipe = &pipe_table.pipes[index];
    pipe->buffer = kmalloc(PIPE_BUFFER_SIZE);
    if (pipe->buffer == NULL) {
        kprintf("[PIPE] Failed to allocate pipe buffer\n");
        return -1;
    }
    
    pipe->size = PIPE_BUFFER_SIZE;
    pipe->read_pos = 0;
    pipe->write_pos = 0;
    pipe->reader_pid = current->pid;
    pipe->writer_pid = current->pid;
    pipe->closed_read = false;
    pipe->closed_write = false;
    
    pipe_table.used[index] = true;
    
    /* ファイルディスクリプタを設定 */
    *read_fd = PIPE_FD_BASE + index;
    *write_fd = PIPE_FD_BASE + index;  /* 簡略化のため同じFDを使用 */
    
    kprintf("[PIPE] Created pipe: read_fd=%d, write_fd=%d\n", *read_fd, *write_fd);
    
    return 0;
}

/**
 * パイプから読み込み
 */
int ipc_pipe_read(int fd, void *buf, size_t count) {
    struct pipe *pipe;
    struct process *current;
    int index;
    size_t available, to_read;
    
    if (buf == NULL || count == 0) {
        return 0;
    }
    
    /* パイプインデックスを取得 */
    index = fd_to_pipe_index(fd);
    if (index < 0 || !pipe_table.used[index]) {
        kprintf("[PIPE] Invalid pipe fd: %d\n", fd);
        return -1;
    }
    
    pipe = &pipe_table.pipes[index];
    
    /* 読み込み側がクローズされているかチェック */
    if (pipe->closed_read) {
        kprintf("[PIPE] Pipe read end closed\n");
        return -1;
    }
    
    /* 現在のプロセスを確認 */
    current = process_get_current();
    if (current == NULL) {
        return -1;
    }
    
    /* データが利用可能になるまで待機 */
    while (1) {
        /* 利用可能なデータ量を計算 */
        if (pipe->write_pos >= pipe->read_pos) {
            available = pipe->write_pos - pipe->read_pos;
        } else {
            available = pipe->size - pipe->read_pos + pipe->write_pos;
        }
        
        /* データがある場合は読み込み */
        if (available > 0) {
            to_read = min(count, available);
            
            /* リングバッファから読み込み */
            if (pipe->read_pos + to_read <= pipe->size) {
                memcpy(buf, pipe->buffer + pipe->read_pos, to_read);
                pipe->read_pos = (pipe->read_pos + to_read) % pipe->size;
            } else {
                /* バッファの終端をまたぐ場合 */
                size_t first_part = pipe->size - pipe->read_pos;
                memcpy(buf, pipe->buffer + pipe->read_pos, first_part);
                memcpy((char *)buf + first_part, pipe->buffer, to_read - first_part);
                pipe->read_pos = to_read - first_part;
            }
            
            return to_read;
        }
        
        /* 書き込み側がクローズされている場合はEOF */
        if (pipe->closed_write) {
            return 0;
        }
        
        /* データを待機 */
        kprintf("[PIPE] Process %d waiting for pipe data\n", current->pid);
        current->state = PROCESS_STATE_WAITING;
        scheduler_yield();
    }
}

/**
 * パイプに書き込み
 */
int ipc_pipe_write(int fd, const void *buf, size_t count) {
    struct pipe *pipe;
    struct process *current;
    struct process *reader;
    int index;
    size_t available, to_write;
    
    if (buf == NULL || count == 0) {
        return 0;
    }
    
    /* パイプインデックスを取得 */
    index = fd_to_pipe_index(fd);
    if (index < 0 || !pipe_table.used[index]) {
        kprintf("[PIPE] Invalid pipe fd: %d\n", fd);
        return -1;
    }
    
    pipe = &pipe_table.pipes[index];
    
    /* 書き込み側がクローズされているかチェック */
    if (pipe->closed_write) {
        kprintf("[PIPE] Pipe write end closed\n");
        return -1;
    }
    
    /* 読み込み側がクローズされている場合はSIGPIPE */
    if (pipe->closed_read) {
        kprintf("[PIPE] Broken pipe\n");
        /* TODO: SIGPIPEを送信 */
        return -1;
    }
    
    /* 現在のプロセスを確認 */
    current = process_get_current();
    if (current == NULL) {
        return -1;
    }
    
    /* 利用可能な空き容量を計算 */
    if (pipe->write_pos >= pipe->read_pos) {
        available = pipe->size - (pipe->write_pos - pipe->read_pos) - 1;
    } else {
        available = pipe->read_pos - pipe->write_pos - 1;
    }
    
    /* 書き込めるサイズを計算 */
    to_write = min(count, available);
    if (to_write == 0) {
        /* バッファフル - 簡略化のためエラーを返す */
        kprintf("[PIPE] Pipe buffer full\n");
        return -1;
    }
    
    /* リングバッファに書き込み */
    if (pipe->write_pos + to_write <= pipe->size) {
        memcpy(pipe->buffer + pipe->write_pos, buf, to_write);
        pipe->write_pos = (pipe->write_pos + to_write) % pipe->size;
    } else {
        /* バッファの終端をまたぐ場合 */
        size_t first_part = pipe->size - pipe->write_pos;
        memcpy(pipe->buffer + pipe->write_pos, buf, first_part);
        memcpy(pipe->buffer, (const char *)buf + first_part, to_write - first_part);
        pipe->write_pos = to_write - first_part;
    }
    
    /* 読み込みプロセスを起床 */
    reader = process_find(pipe->reader_pid);
    if (reader && reader->state == PROCESS_STATE_WAITING) {
        reader->state = PROCESS_STATE_READY;
        scheduler_add_ready(reader);
    }
    
    return to_write;
}

/**
 * パイプをクローズ
 */
int ipc_pipe_close(int fd) {
    struct pipe *pipe;
    struct process *current;
    int index;
    
    /* パイプインデックスを取得 */
    index = fd_to_pipe_index(fd);
    if (index < 0 || !pipe_table.used[index]) {
        kprintf("[PIPE] Invalid pipe fd: %d\n", fd);
        return -1;
    }
    
    pipe = &pipe_table.pipes[index];
    current = process_get_current();
    if (current == NULL) {
        return -1;
    }
    
    /* 読み込み側/書き込み側を判定してクローズ */
    if (current->pid == pipe->reader_pid) {
        pipe->closed_read = true;
    }
    if (current->pid == pipe->writer_pid) {
        pipe->closed_write = true;
    }
    
    /* 両端がクローズされたらパイプを解放 */
    if (pipe->closed_read && pipe->closed_write) {
        kfree(pipe->buffer);
        pipe->buffer = NULL;
        pipe_table.used[index] = false;
        kprintf("[PIPE] Pipe destroyed: fd=%d\n", fd);
    }
    
    return 0;
}