/*
 * WebVM メモリ管理
 *
 * 簡易的なメモリアロケータ実装
 */

#include <stddef.h>
#include <stdint.h>

#include "../include/kernel.h"
#include "../include/wasi_syscalls.h"

/* 外部関数宣言 */
int kprintf(const char *format, ...);
int kfprintf(int fd, const char *format, ...);

/* メモリプールサイズ (32MB)  */
#define MEMORY_POOL_SIZE (32 * 1024 * 1024)

/* メモリブロックヘッダ */
struct mem_block {
  size_t size;
  int free;
  struct mem_block *next;
  struct mem_block *prev;
};

/* グローバル変数 */
static uint8_t *memory_pool = NULL;
static struct mem_block *free_list = NULL;
static size_t total_memory = 0;
static size_t used_memory = 0;

/**
 * メモリ管理の初期化
 */
int mm_init(void) {
  /* メモリプールを静的に確保 */
  static uint8_t static_memory_pool[MEMORY_POOL_SIZE];
  memory_pool = static_memory_pool;

  /* 初期ブロックを作成 */
  free_list = (struct mem_block *)memory_pool;
  free_list->size = MEMORY_POOL_SIZE - sizeof(struct mem_block);
  free_list->free = 1;
  free_list->next = NULL;
  free_list->prev = NULL;

  total_memory = MEMORY_POOL_SIZE;
  used_memory = sizeof(struct mem_block);

  KDEBUG("Memory manager initialized");

  return KERNEL_SUCCESS;
}

/**
 * メモリ確保
 */
void *kmalloc(size_t size) {
  struct mem_block *block = free_list;

  /* アライメント調整 */
  size = ALIGN(size, 8);

  /* 空きブロックを探す */
  while (block) {
    if (block->free && block->size >= size) {
      /* ブロックが大きすぎる場合は分割 */
      if (block->size > size + sizeof(struct mem_block) + 64) {
        struct mem_block *new_block =
            (struct mem_block *)((uint8_t *)block + sizeof(struct mem_block) +
                                 size);
        new_block->size = block->size - size - sizeof(struct mem_block);
        new_block->free = 1;
        new_block->next = block->next;
        new_block->prev = block;

        if (block->next) {
          block->next->prev = new_block;
        }

        block->size = size;
        block->next = new_block;
      }

      block->free = 0;
      used_memory += size;

      return (uint8_t *)block + sizeof(struct mem_block);
    }
    block = block->next;
  }

  KDEBUG("kmalloc: no memory available");
  return NULL;
}

/**
 * メモリ解放
 */
void kfree(void *ptr) {
  if (!ptr)
    return;

  struct mem_block *block =
      (struct mem_block *)((uint8_t *)ptr - sizeof(struct mem_block));
  block->free = 1;
  used_memory -= block->size;

  /* 前後の空きブロックと結合 */
  if (block->prev && block->prev->free) {
    block->prev->size += sizeof(struct mem_block) + block->size;
    block->prev->next = block->next;
    if (block->next) {
      block->next->prev = block->prev;
    }
    block = block->prev;
  }

  if (block->next && block->next->free) {
    block->size += sizeof(struct mem_block) + block->next->size;
    block->next = block->next->next;
    if (block->next) {
      block->next->prev = block;
    }
  }
}

/**
 * メモリ統計を取得
 */
void mm_get_stats(void *stats_ptr) { /* TODO: mm_stats構造体を定義後に実装 */ }
