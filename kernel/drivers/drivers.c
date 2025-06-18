/*
 * WebVM デバイスドライバ管理
 *
 * ドライバの登録と初期化
 */

#include <stddef.h>

#include "../include/drivers.h"
#include "../include/kernel.h"
#include "../include/wasi_syscalls.h"

/* 外部関数宣言 */
int kprintf(const char *format, ...);
int kfprintf(int fd, const char *format, ...);

/* ドライバ登録構造体 */
struct driver_entry {
  const char *name;
  int (*init)(void);
  int (*exit)(void);
  struct driver_entry *next;
};

/* グローバル変数 */
static struct driver_entry *driver_list = NULL;

/* 組み込みドライバの初期化関数 */
extern int console_init(void);

/**
 * ドライバを登録
 */
int register_driver(const char *name, int (*init)(void), int (*exit)(void)) {
  struct driver_entry *entry;

  static struct driver_entry driver_entries[10];
  static int driver_count = 0;

  if (driver_count >= 10) {
    return KERNEL_ERROR;
  }

  entry = &driver_entries[driver_count++];

  entry->name = name;
  entry->init = init;
  entry->exit = exit;
  entry->next = driver_list;
  driver_list = entry;

  KDEBUG("Registered driver");

  return KERNEL_SUCCESS;
}

/**
 * ドライバの初期化
 */
int drivers_init(void) {
  struct driver_entry *entry;
  int ret;

  /* 組み込みドライバを登録 */
  register_driver("console", console_init, NULL);

  /* TODO: 他のドライバを追加 */
  /* register_driver("keyboard", keyboard_init, NULL); */
  /* register_driver("mouse", mouse_init, NULL); */
  /* register_driver("framebuffer", fb_init, NULL); */

  /* 登録されたドライバを初期化 */
  for (entry = driver_list; entry; entry = entry->next) {
    kprintf("[DRIVER] Initializing driver...\n");
    if (entry->init) {
      ret = entry->init();
      if (ret < 0) {
        kfprintf(STDERR_FILENO, "[DRIVER] Failed to initialize driver\n");
        return ret;
      }
    }
  }

  kprintf("[DRIVER] All drivers initialized\n");

  return KERNEL_SUCCESS;
}

/**
 * ドライバの終了処理
 */
int drivers_exit(void) {
  struct driver_entry *entry;

  /* 逆順で終了処理を実行 */
  for (entry = driver_list; entry; entry = entry->next) {
    if (entry->exit) {
      KDEBUG("Exiting driver");
      entry->exit();
    }
  }

  /* 静的配列なので解放不要 */
  driver_list = NULL;

  return KERNEL_SUCCESS;
}