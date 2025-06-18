/*
 * WebVM カーネル初期化エントリポイント
 *
 * WASI システムコール直接実装版
 */

#include "../include/init.h"
#include "../include/kernel.h"
#include "../include/shell.h"
#include "../include/wasi_syscalls.h"

/* 外部関数宣言 */
int kprintf(const char *format, ...);
int kputs(const char *str);
int kfprintf(int fd, const char *format, ...);

/* カーネルバージョン情報 */
#define KERNEL_VERSION "0.1.0"
#define KERNEL_NAME "WebVM"

/* グローバル変数 */
static int kernel_initialized = 0;

/**
 * カーネルバナーを表示
 */
static void print_banner(void) {
  kputs("=====================================");
  kputs("  WebVM Kernel v0.1.0");
  kputs("  POSIX-compatible WebAssembly OS");
  kputs("=====================================");
  kputs("");
}

/**
 * カーネル初期化のメインシーケンス
 */
static int kernel_init(void) {
  kputs("[INIT] Starting kernel initialization...");

  /* メモリ管理の初期化 */
  if (mm_init() < 0) {
    kfprintf(STDERR_FILENO, "[INIT] Failed to initialize memory management\n");
    return -1;
  }
  kputs("[INIT] Memory management initialized");

  /* ファイルシステムの初期化 */
  if (fs_init() < 0) {
    kfprintf(STDERR_FILENO, "[INIT] Failed to initialize filesystem\n");
    return -1;
  }
  kputs("[INIT] Filesystem initialized");

  /* デバイスドライバの初期化 */
  if (drivers_init() < 0) {
    kfprintf(STDERR_FILENO, "[INIT] Failed to initialize drivers\n");
    return -1;
  }
  kputs("[INIT] Device drivers initialized");

  kernel_initialized = 1;
  kputs("[INIT] Kernel initialization complete");

  return 0;
}

/**
 * カーネルメインループ
 */
static void kernel_main_loop(void) {
  kputs("[KERNEL] Entering main loop...");

  /* ここでシェルまたは init プロセスを起動する */
  kputs("[KERNEL] Starting shell...");

  /* シェルを起動 */
  shell_main();

  /* シェルが終了した場合 (通常は到達しない)  */
  kputs("[KERNEL] Shell exited, halting system...");
}

/**
 * カーネルエントリポイント
 */
void kernel_main(void) {
  kputs("[DEBUG] kernel_main() started");

  /* カーネルバナーを表示 */
  print_banner();

  /* カーネル初期化 */
  if (kernel_init() < 0) {
    kfprintf(STDERR_FILENO, "[KERNEL] Initialization failed, halting.\n");
    wasi_exit(1);
  }

  /* メインループ */
  kernel_main_loop();

  kputs("[DEBUG] kernel_main() finished");
  wasi_exit(0);
}

/**
 * WASI環境用の _start エントリポイント
 */
void _start(void) {
  kernel_main();
}