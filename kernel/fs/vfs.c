/*
 * WebVM 仮想ファイルシステム (VFS)
 *
 * 基本的なファイルシステム抽象化レイヤー
 */

#include <stddef.h>

#include "../include/fs.h"
#include "../include/kernel.h"
#include "../include/wasi_syscalls.h"

/* 外部関数宣言 */
int kprintf(const char *format, ...);
int kfprintf(int fd, const char *format, ...);

/* 文字列関数 */
static int strcmp(const char *s1, const char *s2) {
  while (*s1 && (*s1 == *s2)) {
    s1++;
    s2++;
  }
  return *(unsigned char *)s1 - *(unsigned char *)s2;
}

static int strncmp(const char *s1, const char *s2, size_t n) {
  while (n && *s1 && (*s1 == *s2)) {
    s1++;
    s2++;
    n--;
  }
  if (n == 0)
    return 0;
  return *(unsigned char *)s1 - *(unsigned char *)s2;
}

static size_t strlen(const char *s) {
  size_t len = 0;
  while (s[len])
    len++;
  return len;
}

static char *strncpy(char *dest, const char *src, size_t n) {
  size_t i;
  for (i = 0; i < n && src[i] != '\0'; i++)
    dest[i] = src[i];
  for (; i < n; i++)
    dest[i] = '\0';
  return dest;
}

/* ファイルシステムタイプ */
#define FS_TYPE_ROOTFS 1
#define FS_TYPE_DEVFS 2
#define FS_TYPE_PROCFS 3

/* マウントポイント構造体 */
struct mount_point {
  char path[256];
  int fs_type;
  struct mount_point *next;
};

/* グローバル変数 */
static struct mount_point *mount_list = NULL;
static int vfs_initialized = 0;

/**
 * ファイルシステムの初期化
 */
int fs_init(void) {
  /* ルートファイルシステムをマウント */
  if (fs_mount("/", FS_TYPE_ROOTFS) < 0) {
    kfprintf(STDERR_FILENO, "[FS] Failed to mount root filesystem\n");
    return KERNEL_ERROR;
  }

  /* /dev をマウント */
  if (fs_mount("/dev", FS_TYPE_DEVFS) < 0) {
    kfprintf(STDERR_FILENO, "[FS] Failed to mount /dev\n");
    return KERNEL_ERROR;
  }

  /* /proc をマウント */
  if (fs_mount("/proc", FS_TYPE_PROCFS) < 0) {
    kfprintf(STDERR_FILENO, "[FS] Failed to mount /proc\n");
    return KERNEL_ERROR;
  }

  /* 基本ディレクトリを作成 - TODO: 実装 */

  vfs_initialized = 1;
  KDEBUG("VFS initialized");

  return KERNEL_SUCCESS;
}

/**
 * ファイルシステムをマウント
 */
int fs_mount(const char *path, int fs_type) {
  struct mount_point *mp;

  /* マウントポイントを作成 */
  static struct mount_point mount_points[10];
  static int mount_count = 0;

  if (mount_count >= 10) {
    return KERNEL_ERROR;
  }

  mp = &mount_points[mount_count++];

  strncpy(mp->path, path, sizeof(mp->path) - 1);
  mp->path[sizeof(mp->path) - 1] = '\0';
  mp->fs_type = fs_type;
  mp->next = mount_list;
  mount_list = mp;

  /* ディレクトリを作成 - TODO: 実装 */

  KDEBUG("Mounted filesystem");

  return KERNEL_SUCCESS;
}

/**
 * ファイルシステムをアンマウント
 */
int fs_umount(const char *path) {
  struct mount_point *mp, *prev = NULL;

  /* マウントポイントを探す */
  for (mp = mount_list; mp; prev = mp, mp = mp->next) {
    if (strcmp(mp->path, path) == 0) {
      if (prev) {
        prev->next = mp->next;
      } else {
        mount_list = mp->next;
      }
      /* 静的配列なのでfree不要 */
      return KERNEL_SUCCESS;
    }
  }

  return KERNEL_ERROR;
}

/**
 * ファイルシステムの種類を取得
 */
int fs_get_type(const char *path) {
  struct mount_point *mp;
  int best_match_len = 0;
  int fs_type = FS_TYPE_ROOTFS;

  /* 最長一致でマウントポイントを探す */
  for (mp = mount_list; mp; mp = mp->next) {
    int len = strlen(mp->path);
    if (strncmp(path, mp->path, len) == 0) {
      if (len > best_match_len) {
        best_match_len = len;
        fs_type = mp->fs_type;
      }
    }
  }

  return fs_type;
}

/**
 * /proc ファイルシステムの内容を生成
 */
static int procfs_read(const char *path, char *buffer, size_t size) {
  /* TODO: procfs実装 */
  return -1;
}
