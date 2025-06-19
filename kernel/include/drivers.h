/*
 * WebVM デバイスドライバヘッダ
 */

#ifndef __WEBVM_DRIVERS_H__
#define __WEBVM_DRIVERS_H__

/* ドライバ管理 */
int register_driver(const char *name, int (*init)(void), int (*exit)(void));
int drivers_exit(void);

/* コンソールドライバ */
int console_init(void);
int console_putc(char c);
int console_puts(const char *str);
int console_getc(void);
char *console_gets(char *buffer, int size);
void console_clear(void);
void console_set_cursor(int x, int y);
void console_set_color(int fg, int bg);
void console_reset_attr(void);

/* 色定義 */
#define COLOR_BLACK     0
#define COLOR_RED       1
#define COLOR_GREEN     2
#define COLOR_YELLOW    3
#define COLOR_BLUE      4
#define COLOR_MAGENTA   5
#define COLOR_CYAN      6
#define COLOR_WHITE     7

/* デバイス番号 */
#define MAJOR(dev) ((dev) >> 8)
#define MINOR(dev) ((dev) & 0xff)
#define MKDEV(maj, min) (((maj) << 8) | (min))

#endif /* __WEBVM_DRIVERS_H__ */
