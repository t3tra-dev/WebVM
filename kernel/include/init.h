/*
 * WebVM カーネル初期化ヘッダ
 */

#ifndef __WEBVM_INIT_H__
#define __WEBVM_INIT_H__

/* 各サブシステムの初期化関数 */
int mm_init(void);      /* メモリ管理初期化 */
int fs_init(void);      /* ファイルシステム初期化 */
int drivers_init(void); /* デバイスドライバ初期化 */

/* 初期化順序定義 */
#define INIT_LEVEL_EARLY    0
#define INIT_LEVEL_CORE     1
#define INIT_LEVEL_DRIVERS  2
#define INIT_LEVEL_FS       3
#define INIT_LEVEL_LATE     4

/* 初期化エントリ構造体 */
struct init_entry {
    const char *name;
    int (*init_func)(void);
    int level;
};

/* 初期化マクロ */
#define __init __attribute__((section(".init.text")))
#define __initdata __attribute__((section(".init.data")))

#endif /* __WEBVM_INIT_H__ */