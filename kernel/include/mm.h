/*
 * WebVM メモリ管理ヘッダ
 */

#ifndef __WEBVM_MM_H__
#define __WEBVM_MM_H__

#include <stddef.h>

/* メモリアロケーション関数 */
void *kmalloc(size_t size);
void kfree(void *ptr);

/* メモリ統計構造体 */
struct mm_stats {
    size_t total_memory;
    size_t used_memory;
    size_t free_memory;
};

/* メモリ統計取得 */
void mm_get_stats(struct mm_stats *stats);

/* ページアロケーション (将来的な実装用)  */
void *get_free_page(void);
void free_page(void *page);

#endif /* __WEBVM_MM_H__ */