/*
 * WebVM ファイルシステムヘッダ
 */

#ifndef __WEBVM_FS_H__
#define __WEBVM_FS_H__

#include <stddef.h>

/* Forward declarations */
struct inode;

/* ファイルシステム操作 */
int fs_init(void);
int fs_mount(const char *path, int fs_type);
int fs_umount(const char *path);
int fs_get_type(const char *path);

/* ファイル操作 */
int fs_open(const char *path, int flags, int mode);
int fs_read(int fd, void *buf, size_t count);
int fs_write(int fd, const void *buf, size_t count);
int fs_close(int fd);
long fs_lseek(int fd, long offset, int whence);

/* ディレクトリ操作 */
int fs_mkdir(const char *path, int mode);
int fs_rmdir(const char *path);
int fs_unlink(const char *path);

/* ファイル情報 */
int fs_stat(const char *path, struct inode *stat_buf);

/* 作業ディレクトリ操作 */
int fs_chdir(const char *path);
char *fs_getcwd(char *buf, size_t size);

/* ディレクトリエントリタイプ */
#define DT_UNKNOWN 0
#define DT_REG 1 /* 通常ファイル */
#define DT_DIR 2 /* ディレクトリ */
#define DT_CHR 3 /* キャラクタデバイス */
#define DT_BLK 4 /* ブロックデバイス */

/* ディレクトリエントリ */
struct dirent {
  unsigned long ino;
  char name[256];
  unsigned char type;
};

/* ディレクトリ読み込み */
int fs_opendir(const char *path);
int fs_readdir(int fd, struct dirent *entry);
int fs_closedir(int fd);

/* VFS構造体 (将来の拡張用) */
struct vfs_operations {
  int (*open)(const char *path, int flags);
  int (*read)(int fd, void *buf, size_t count);
  int (*write)(int fd, const void *buf, size_t count);
  int (*close)(int fd);
};

/* ファイルフラグ */
#define O_RDONLY 0x0000
#define O_WRONLY 0x0001
#define O_RDWR 0x0002
#define O_CREAT 0x0040
#define O_EXCL 0x0080
#define O_TRUNC 0x0200
#define O_APPEND 0x0400

/* シーク定数 */
#define SEEK_SET 0
#define SEEK_CUR 1
#define SEEK_END 2

/* ファイルタイプ */
#define S_IFMT 0170000  /* ファイルタイプマスク */
#define S_IFREG 0100000 /* 通常ファイル */
#define S_IFDIR 0040000 /* ディレクトリ */
#define S_IFCHR 0020000 /* キャラクタデバイス */
#define S_IFBLK 0060000 /* ブロックデバイス */

/* パーミッション */
#define S_IRWXU 0000700 /* オーナー読み書き実行 */
#define S_IRUSR 0000400 /* オーナー読み */
#define S_IWUSR 0000200 /* オーナー書き */
#define S_IXUSR 0000100 /* オーナー実行 */
#define S_IRWXG 0000070 /* グループ読み書き実行 */
#define S_IRGRP 0000040 /* グループ読み */
#define S_IWGRP 0000020 /* グループ書き */
#define S_IXGRP 0000010 /* グループ実行 */
#define S_IRWXO 0000007 /* その他読み書き実行 */
#define S_IROTH 0000004 /* その他読み */
#define S_IWOTH 0000002 /* その他書き */
#define S_IXOTH 0000001 /* その他実行 */

/* ファイル記述子テーブル */
#define MAX_OPEN_FILES 256

struct file_descriptor {
  int in_use;
  char path[256];
  int flags;
  long position;
  size_t size;
  char *data; /* 廃止予定: IndexedDBベースでは不使用 */
};

/* inode構造体 (簡易版) */
struct inode {
  unsigned long ino;
  unsigned int mode;
  unsigned int uid;
  unsigned int gid;
  unsigned long size;
  unsigned long atime;
  unsigned long mtime;
  unsigned long ctime;
};

#endif /* __WEBVM_FS_H__ */
