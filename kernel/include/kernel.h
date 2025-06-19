/*
 * WebVM カーネル共通ヘッダ
 */

#ifndef __WEBVM_KERNEL_H__
#define __WEBVM_KERNEL_H__

#include <stdint.h>
#include <stddef.h>

/* カーネル共通定義 */
#define KERNEL_SUCCESS  0
#define KERNEL_ERROR   -1

/* デバッグマクロ */
#ifdef DEBUG
#define KDEBUG(fmt, ...) printf("[DEBUG] " fmt "\n", ##__VA_ARGS__)
#else
#define KDEBUG(fmt, ...) ((void)0)
#endif

/* カーネルパニック */
#define kernel_panic(msg) do { \
    fprintf(stderr, "[PANIC] %s at %s:%d\n", msg, __FILE__, __LINE__); \
    abort(); \
} while(0)

/* アライメントマクロ */
#define ALIGN(x, a) (((x) + (a) - 1) & ~((a) - 1))
#define PAGE_SIZE 4096
#define PAGE_ALIGN(x) ALIGN(x, PAGE_SIZE)

/* 最小/最大マクロ */
#define MIN(a, b) ((a) < (b) ? (a) : (b))
#define MAX(a, b) ((a) > (b) ? (a) : (b))

/* カーネル統計情報 */
struct kernel_stats {
    uint64_t boot_time;
    uint64_t uptime;
    uint32_t processes;
    uint32_t threads;
    uint64_t memory_used;
    uint64_t memory_total;
};

/* グローバル関数宣言 */
int get_kernel_stats(struct kernel_stats *stats);

#endif /* __WEBVM_KERNEL_H__ */
