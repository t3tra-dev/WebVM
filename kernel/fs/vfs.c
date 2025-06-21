/*
 * WebVM 仮想ファイルシステム (VFS)
 *
 * 基本的なファイルシステム抽象化レイヤー
 */

#include <stddef.h>

#include "../include/fs.h"
#include "../include/kernel.h"
#include "../include/mm.h"
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

static char *strcpy(char *dest, const char *src) {
  char *d = dest;
  while ((*d++ = *src++))
    ;
  return dest;
}

static char *strcat(char *dest, const char *src) {
  char *d = dest;
  while (*d)
    d++;
  while ((*d++ = *src++))
    ;
  return dest;
}

static char *strrchr(const char *s, int c) {
  const char *last = NULL;
  while (*s) {
    if (*s == c) {
      last = s;
    }
    s++;
  }
  return (char *)last;
}

static void *memcpy(void *dest, const void *src, size_t n) {
  unsigned char *d = dest;
  const unsigned char *s = src;
  for (size_t i = 0; i < n; i++)
    d[i] = s[i];
  return dest;
}

static void *memset(void *s, int c, size_t n) {
  unsigned char *p = s;
  for (size_t i = 0; i < n; i++)
    p[i] = c;
  return s;
}

/* 前方宣言 */
static int check_permission(const char *path, int required_mode);
static int normalize_path(const char *input_path, const char *base_path,
                          char *output_path, size_t output_size);
static char *strtok_r(char *str, const char *delim, char **saveptr);

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

/* 現在の作業ディレクトリ */
static char current_working_directory[256] = "/";

/* ファイル記述子テーブル */
static struct file_descriptor fd_table[MAX_OPEN_FILES];
static int next_fd = 3; /* 0,1,2 はstdin,stdout,stderr用に予約 */

/* 読み書き用の一時バッファ (POSIXファイル操作のため) */
#define TEMP_BUFFER_SIZE 4096 // 4KB
static char temp_read_buffer[TEMP_BUFFER_SIZE];
static char temp_write_buffer[TEMP_BUFFER_SIZE];

/* ディレクトリキャッシュ用の静的バッファ */
static char dir_cache[1024];
static int dir_cache_count = 0;
static char dir_cache_path[256] = "";

/**
 * ファイルシステムの初期化
 */
int fs_init(void) {
  /* ファイル記述子テーブルを初期化 */
  memset(fd_table, 0, sizeof(fd_table));

  /* stdin, stdout, stderr を初期化 */
  fd_table[0].in_use = 1;
  strncpy(fd_table[0].path, "/dev/stdin", sizeof(fd_table[0].path));
  fd_table[1].in_use = 1;
  strncpy(fd_table[1].path, "/dev/stdout", sizeof(fd_table[1].path));
  fd_table[2].in_use = 1;
  strncpy(fd_table[2].path, "/dev/stderr", sizeof(fd_table[2].path));

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

  /* ファイルシステムの準備完了 */
  /* ディレクトリ構造はIndexedDB側で管理される */

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
 * ファイルを開く
 */
int fs_open(const char *path, int flags, int mode) {
  int fd;
  struct file_descriptor *fdp;
  int required_perm = 0;
  char full_path[256];


  if (!vfs_initialized) {
    return -1;
  }

  /* 絶対パスに変換 */
  if (path[0] != '/') {
    /* 相対パス - 現在のディレクトリからの相対パス */
    if (strlen(current_working_directory) + strlen(path) + 2 >
        sizeof(full_path)) {
      return -1; /* パスが長すぎる */
    }
    strcpy(full_path, current_working_directory);
    if (strcmp(current_working_directory, "/") != 0) {
      strcat(full_path, "/");
    }
    strcat(full_path, path);
  } else {
    strncpy(full_path, path, sizeof(full_path) - 1);
    full_path[sizeof(full_path) - 1] = '\0';
  }

  /* 必要なパーミッションを決定 */
  if (flags & O_RDWR) {
    required_perm = 6; /* 読み書き */
  } else if (flags & O_WRONLY) {
    required_perm = 2; /* 書き込み */
  } else {
    required_perm = 4; /* 読み込み */
  }

  /* パーミッションをチェック (新規作成以外) */
  if (!(flags & O_CREAT)) {
    if (check_permission(full_path, required_perm) < 0) {
      return -1; /* Permission denied */
    }
  }

  /* 利用可能なファイル記述子を探す */
  for (fd = next_fd; fd < MAX_OPEN_FILES; fd++) {
    if (!fd_table[fd].in_use) {
      break;
    }
  }

  if (fd >= MAX_OPEN_FILES) {
    return -1; /* No more file descriptors */
  }

  fdp = &fd_table[fd];
  fdp->in_use = 1;
  strncpy(fdp->path, full_path, sizeof(fdp->path) - 1);
  fdp->path[sizeof(fdp->path) - 1] = '\0';
  fdp->flags = flags;
  fdp->position = 0;
  fdp->size = 0;
  fdp->data = NULL;

  /* ファイルが存在するかチェック */
  if (!(flags & O_CREAT)) {
    /* 既存ファイルを探す - 簡易実装では常に新規作成 */
  }

  /* ファイルを作成またはオープン */
  if (flags & O_CREAT) {
    /* IndexedDBにファイルを作成 */
    int result = __wasi_file_create(full_path, strlen(full_path), mode);
    if (result != 0) {
      fdp->in_use = 0;
      return -1;
    }
    /* ファイル作成成功時はディレクトリキャッシュを無効化 */
    dir_cache_path[0] = '\0'; /* 完全にキャッシュ無効化 */
  }

  /* ファイル記述子を初期化 (データはIndexedDBから直接読み書き) */
  fdp->size = 0;
  fdp->data = NULL; /* 使用しない - 直接IndexedDB操作 */

  if (fd >= next_fd) {
    next_fd = fd + 1;
  }

  return fd;
}

/**
 * ファイルから読み込み
 */
int fs_read(int fd, void *buf, size_t count) {
  struct file_descriptor *fdp;
  size_t bytes_to_read;


  if (fd < 0 || fd >= MAX_OPEN_FILES || !fd_table[fd].in_use) {
    return -1;
  }

  fdp = &fd_table[fd];


  /* デバイスファイルの特別な処理 */
  if (strncmp(fdp->path, "/dev/", 5) == 0) {
    return 0; /* デバイスファイルは空読み込み */
  }

  /* 直接WASIアプローチ - VFS層の複雑さを完全にバイパス */
  
  int actual_read = 0;
  int result = __wasi_file_read_direct(fdp->path, strlen(fdp->path), 
                                       (char*)buf, count, &actual_read);


  if (result != 0) {
    return -1;
  }

  /* 無限ループ防止のための重要なチェック */
  if (actual_read == 0) {
    return 0;  /* EOF - これが重要！ */
  }

  fdp->position += actual_read;

  return actual_read;
}

/**
 * ファイルに書き込み
 */
int fs_write(int fd, const void *buf, size_t count) {
  struct file_descriptor *fdp;

  if (fd < 0 || fd >= MAX_OPEN_FILES || !fd_table[fd].in_use) {
    return -1;
  }

  fdp = &fd_table[fd];


  /* デバイスファイルの特別な処理 */
  if (strncmp(fdp->path, "/dev/", 5) == 0) {
    return count; /* デバイスファイルは書き込み成功として扱う */
  }

  /* ファイルバッファが未割り当ての場合は割り当て */
  if (fdp->data == NULL) {
    fdp->data = (char *)kmalloc(4096); /* 4KB 初期バッファ */
    if (fdp->data == NULL) {
      return -1;
    }
    fdp->size = 0;
  }

  /* バッファに追記 */
  size_t bytes_to_write = count;
  size_t new_size = fdp->size + bytes_to_write;
  
  /* バッファサイズ制限 (簡易実装) */
  if (new_size > 4096) {
    bytes_to_write = 4096 - fdp->size;
    new_size = 4096;
  }
  
  if (bytes_to_write > 0) {
    memcpy(fdp->data + fdp->size, buf, bytes_to_write);
    fdp->size = new_size;
    fdp->position += bytes_to_write;
    
  }

  return bytes_to_write;
}

/**
 * ファイルを閉じる
 */
int fs_close(int fd) {
  struct file_descriptor *fdp;

  if (fd < 0 || fd >= MAX_OPEN_FILES || !fd_table[fd].in_use) {
    return -1;
  }

  /* stdin, stdout, stderr は閉じない */
  if (fd <= 2) {
    return 0;
  }

  fdp = &fd_table[fd];

  /* バッファされたデータがある場合はIndexedDBに書き込み */
  if (fdp->data != NULL && fdp->size > 0) {
    
    int result = __wasi_file_write(fdp->path, strlen(fdp->path),
                                   fdp->data, fdp->size);
    
    if (result != 0) {
    } else {
    }
    
    /* ファイル書き込み成功時はディレクトリキャッシュを無効化 */
    dir_cache_path[0] = '\0'; /* 完全にキャッシュ無効化 */
  }

  /* ファイル読み取りキャッシュをクリア */
  __wasi_file_close_direct(fdp->path, strlen(fdp->path));

  /* メモリ解放 */
  if (fdp->data != NULL) {
    kfree(fdp->data);
  }

  /* ファイル記述子をクリア */
  fd_table[fd].in_use = 0;
  fd_table[fd].data = NULL;
  fd_table[fd].size = 0;
  fd_table[fd].position = 0;

  return 0;
}

/**
 * ファイルポインタを移動
 */
long fs_lseek(int fd, long offset, int whence) {
  struct file_descriptor *fdp;
  long new_pos;

  if (fd < 0 || fd >= MAX_OPEN_FILES || !fd_table[fd].in_use) {
    return -1;
  }

  fdp = &fd_table[fd];

  switch (whence) {
  case SEEK_SET:
    new_pos = offset;
    break;
  case SEEK_CUR:
    new_pos = fdp->position + offset;
    break;
  case SEEK_END:
    new_pos = fdp->size + offset;
    break;
  default:
    return -1;
  }

  if (new_pos < 0) {
    return -1;
  }

  fdp->position = new_pos;
  return new_pos;
}

/**
 * ディレクトリを作成
 */
int fs_mkdir(const char *path, int mode) {
  char full_path[256];

  (void)mode; /* パーミッションは簡易実装では無視 */

  /* 絶対パスに変換 */
  if (path[0] != '/') {
    /* 相対パス - 現在のディレクトリからの相対パス */
    if (strlen(current_working_directory) + strlen(path) + 2 >
        sizeof(full_path)) {
      return -1; /* パスが長すぎる */
    }
    strcpy(full_path, current_working_directory);
    if (strcmp(current_working_directory, "/") != 0) {
      strcat(full_path, "/");
    }
    strcat(full_path, path);
  } else {
    strncpy(full_path, path, sizeof(full_path) - 1);
    full_path[sizeof(full_path) - 1] = '\0';
  }

  /* WASIを通じてIndexedDBにディレクトリを作成 */
  int result =
      __wasi_path_create_directory(0, full_path, strlen(full_path), mode);
  
  /* 作成成功時はディレクトリキャッシュを無効化 */
  if (result == 0) {
    /* すべてのキャッシュを無効化 (新しく作成されたディレクトリとその親) */
    dir_cache_path[0] = '\0'; /* 完全にキャッシュ無効化 */
  }
  
  return (result == 0) ? 0 : -1;
}

/**
 * ディレクトリを削除
 */
int fs_rmdir(const char *path) {
  char full_path[256];

  if (!path || !*path) {
    return -1;
  }

  /* 絶対パスに変換 */
  if (path[0] != '/') {
    /* 相対パス - 現在のディレクトリからの相対パス */
    if (strlen(current_working_directory) + strlen(path) + 2 >
        sizeof(full_path)) {
      return -1; /* パスが長すぎる */
    }
    strcpy(full_path, current_working_directory);
    if (strcmp(current_working_directory, "/") != 0) {
      strcat(full_path, "/");
    }
    strcat(full_path, path);
  } else {
    strncpy(full_path, path, sizeof(full_path) - 1);
    full_path[sizeof(full_path) - 1] = '\0';
  }

  /* WASIを通じてIndexedDBからディレクトリを削除 */
  int result = __wasi_path_remove_directory(0, full_path, strlen(full_path));

  /* 削除成功時はディレクトリキャッシュを無効化 */
  if (result == 0) {
    /* すべてのキャッシュを無効化 (削除されたディレクトリとその親) */
    dir_cache_path[0] = '\0'; /* 完全にキャッシュ無効化 */
  }

  return (result == 0) ? 0 : -1;
}

/**
 * ファイルを削除
 */
int fs_unlink(const char *path) {
  char full_path[256];

  if (!path || !*path) {
    return -1;
  }

  /* 絶対パスに変換 */
  if (path[0] != '/') {
    /* 相対パス - 現在のディレクトリからの相対パス */
    if (strlen(current_working_directory) + strlen(path) + 2 >
        sizeof(full_path)) {
      return -1; /* パスが長すぎる */
    }
    strcpy(full_path, current_working_directory);
    if (strcmp(current_working_directory, "/") != 0) {
      strcat(full_path, "/");
    }
    strcat(full_path, path);
  } else {
    strncpy(full_path, path, sizeof(full_path) - 1);
    full_path[sizeof(full_path) - 1] = '\0';
  }

  /* WASIを通じてIndexedDBからファイルを削除 */
  int result = __wasi_file_delete(full_path, strlen(full_path));

  /* 削除成功時はディレクトリキャッシュを無効化 */
  if (result == 0) {
    /* すべてのキャッシュを無効化 (削除されたディレクトリとその親) */
    dir_cache_path[0] = '\0'; /* 完全にキャッシュ無効化 */
  }

  return (result == 0) ? 0 : -1;
}

/**
 * パーミッションをチェック
 */
static int check_permission(const char *path, int required_mode) {
  struct inode stat_buf;

  /* ファイル情報を取得 */
  if (fs_stat(path, &stat_buf) < 0) {
    return -1;
  }

  /* root ユーザーは全てのファイルにアクセス可能 */
  if (stat_buf.uid == 0) {
    return 0;
  }

  /* 現在のユーザーID (簡易実装では常に0) */
  int current_uid = 0;
  int current_gid = 0;

  /* オーナーの場合 */
  if (current_uid == stat_buf.uid) {
    int owner_perms = (stat_buf.mode & S_IRWXU) >> 6;
    if ((owner_perms & required_mode) == required_mode) {
      return 0;
    }
  }

  /* グループの場合 */
  if (current_gid == stat_buf.gid) {
    int group_perms = (stat_buf.mode & S_IRWXG) >> 3;
    if ((group_perms & required_mode) == required_mode) {
      return 0;
    }
  }

  /* その他の場合 */
  int other_perms = stat_buf.mode & S_IRWXO;
  if ((other_perms & required_mode) == required_mode) {
    return 0;
  }

  return -1; /* Permission denied */
}

/**
 * ファイル情報を取得
 */
int fs_stat(const char *path, struct inode *stat_buf) {
  int fd;
  struct file_descriptor *fdp;
  char full_path[256];


  if (!stat_buf) {
    return -1;
  }

  /* 絶対パスに変換 */
  if (path[0] != '/') {
    /* 相対パス - 現在のディレクトリからの相対パス */
    if (strlen(current_working_directory) + strlen(path) + 2 >
        sizeof(full_path)) {
      return -1; /* パスが長すぎる */
    }
    strcpy(full_path, current_working_directory);
    if (strcmp(current_working_directory, "/") != 0) {
      strcat(full_path, "/");
    }
    strcat(full_path, path);
  } else {
    strncpy(full_path, path, sizeof(full_path) - 1);
    full_path[sizeof(full_path) - 1] = '\0';
  }

  /* デフォルト値を設定 */
  stat_buf->ino = 1;
  stat_buf->mode = S_IFREG | S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH;
  stat_buf->uid = 0;
  stat_buf->gid = 0;
  stat_buf->size = 0;
  stat_buf->atime = 0;
  stat_buf->mtime = 0;
  stat_buf->ctime = 0;

  /* パスに応じてファイルタイプを設定 */
  if (strncmp(full_path, "/dev/", 5) == 0) {
    stat_buf->mode = S_IFCHR | S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP;
  } else {
    /* IndexedDBでディレクトリまたはファイルの存在確認 */
    int dir_exists = 0;
    int file_exists = 0;

    int dir_result = __wasi_directory_exists(full_path, strlen(full_path), &dir_exists);
    int file_result = __wasi_file_exists(full_path, strlen(full_path), &file_exists);

    /* デバッグ情報を出力 */

    if (dir_result == 0 && dir_exists) {
      /* ディレクトリが存在する */
      stat_buf->mode = S_IFDIR | S_IRUSR | S_IWUSR | S_IXUSR | S_IRGRP |
                       S_IXGRP | S_IROTH | S_IXOTH;
    } else if (file_result == 0 && file_exists) {
      /* ファイルが存在する */
      /* IndexedDBからファイル情報を取得 - 新しいバイパス方式を使用 */
      
      int size_result = __wasi_file_get_size(full_path, strlen(full_path), &stat_buf->size);
      
      if (size_result == 0) {
        /* 基本的なファイル情報を設定 */
        stat_buf->ino = 1;
        stat_buf->mode = S_IFREG | S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH;
        stat_buf->uid = 0;
        stat_buf->gid = 0;
        stat_buf->atime = 0;
        stat_buf->mtime = 0;
        stat_buf->ctime = 0;
        
      } else {
      }
    } else if (strcmp(full_path, "/") == 0) {
      /* ルートディレクトリは常に存在 */
      stat_buf->mode = S_IFDIR | S_IRUSR | S_IWUSR | S_IXUSR | S_IRGRP |
                       S_IXGRP | S_IROTH | S_IXOTH;
    } else {
    }
  }

  /* 開いているファイルの場合、実際のサイズを取得 */
  for (fd = 0; fd < MAX_OPEN_FILES; fd++) {
    if (fd_table[fd].in_use && strcmp(fd_table[fd].path, full_path) == 0) {
      fdp = &fd_table[fd];
      stat_buf->size = fdp->size;
      break;
    }
  }

  return 0;
}

/* パス正規化関数 */
static int normalize_path(const char *input_path, const char *base_path,
                          char *output_path, size_t output_size) {
  char temp_path[512];
  char *components[64];
  int component_count = 0;
  char *token;
  char *saveptr;
  int i;

  /* 絶対パスか相対パスかを判定 */
  if (input_path[0] == '/') {
    strcpy(temp_path, input_path);
  } else {
    if (strlen(base_path) + strlen(input_path) + 2 > sizeof(temp_path)) {
      return -1;
    }
    strcpy(temp_path, base_path);
    if (strcmp(base_path, "/") != 0) {
      strcat(temp_path, "/");
    }
    strcat(temp_path, input_path);
  }

  /* パスをコンポーネントに分割 */
  token = strtok_r(temp_path, "/", &saveptr);
  while (token != NULL && component_count < 64) {
    if (strcmp(token, ".") == 0) {
      /* 現在のディレクトリ - 無視 */
    } else if (strcmp(token, "..") == 0) {
      /* 親ディレクトリ - 一つ前のコンポーネントを削除 */
      if (component_count > 0) {
        component_count--;
      }
    } else {
      /* 通常のディレクトリ名 */
      components[component_count++] = token;
    }
    token = strtok_r(NULL, "/", &saveptr);
  }

  /* 正規化されたパスを構築 */
  if (component_count == 0) {
    strcpy(output_path, "/");
  } else {
    strcpy(output_path, "");
    for (i = 0; i < component_count; i++) {
      strcat(output_path, "/");
      strcat(output_path, components[i]);
    }
  }

  return 0;
}

/* strtok_r の簡易実装 */
static char *strtok_r(char *str, const char *delim, char **saveptr) {
  char *token;

  if (str == NULL) {
    str = *saveptr;
  }

  if (str == NULL) {
    return NULL;
  }

  /* 先頭の区切り文字をスキップ */
  while (*str && *str == *delim) {
    str++;
  }

  if (*str == '\0') {
    *saveptr = NULL;
    return NULL;
  }

  token = str;

  /* 次の区切り文字を探す */
  while (*str && *str != *delim) {
    str++;
  }

  if (*str) {
    *str = '\0';
    *saveptr = str + 1;
  } else {
    *saveptr = NULL;
  }

  return token;
}

/**
 * 作業ディレクトリを変更
 */
int fs_chdir(const char *path) {
  struct inode stat_buf;
  char normalized_path[256];

  if (!path || !*path) {
    return -1;
  }

  /* パスを正規化 */
  if (normalize_path(path, current_working_directory, normalized_path,
                     sizeof(normalized_path)) < 0) {
    return -1;
  }

  /* ディレクトリの存在確認 */
  if (fs_stat(normalized_path, &stat_buf) < 0) {
    return -1; /* ディレクトリが存在しない */
  }

  if (!(stat_buf.mode & S_IFDIR)) {
    return -1; /* ディレクトリではない */
  }

  /* 作業ディレクトリを更新 */
  strcpy(current_working_directory, normalized_path);

  return 0;
}

/**
 * 現在の作業ディレクトリを取得
 */
char *fs_getcwd(char *buf, size_t size) {
  if (!buf || size == 0) {
    return NULL;
  }

  if (strlen(current_working_directory) >= size) {
    return NULL; /* バッファが小さすぎる */
  }

  strcpy(buf, current_working_directory);
  return buf;
}

/**
 * ディレクトリを開く
 */
int fs_opendir(const char *path) {
  struct inode stat_buf;
  int fd;
  struct file_descriptor *fdp;

  if (!vfs_initialized) {
    return -1;
  }

  /* ディレクトリの存在確認 */
  if (fs_stat(path, &stat_buf) < 0) {
    return -1;
  }

  if (!(stat_buf.mode & S_IFDIR)) {
    return -1; /* ディレクトリではない */
  }

  /* ファイル記述子を取得 */
  for (fd = next_fd; fd < MAX_OPEN_FILES; fd++) {
    if (!fd_table[fd].in_use) {
      break;
    }
  }

  if (fd >= MAX_OPEN_FILES) {
    return -1;
  }

  fdp = &fd_table[fd];
  fdp->in_use = 1;
  strncpy(fdp->path, path, sizeof(fdp->path) - 1);
  fdp->path[sizeof(fdp->path) - 1] = '\0';
  fdp->flags = O_RDONLY;
  fdp->position = 0;
  fdp->size = 0;
  fdp->data = NULL;

  return fd;
}

/**
 * ディレクトリエントリを読み込み
 */
int fs_readdir(int fd, struct dirent *entry) {
  struct file_descriptor *fdp;

  if (fd < 0 || fd >= MAX_OPEN_FILES || !fd_table[fd].in_use || !entry) {
    return -1;
  }

  fdp = &fd_table[fd];

  /* 簡易実装: 固定のディレクトリエントリを返す */
  if (fdp->position == 0) {
    /* 最初のエントリ: . */
    entry->ino = 1;
    strcpy(entry->name, ".");
    entry->type = DT_DIR;
    fdp->position++;
    return 0;
  } else if (fdp->position == 1) {
    /* 2番目のエントリ: .. */
    entry->ino = 2;
    strcpy(entry->name, "..");
    entry->type = DT_DIR;
    fdp->position++;
    return 0;
  }

  /* キャッシュが無効または別のディレクトリの場合、新しくロード */
  /* 常に最新のディレクトリ情報をロード (キャッシュを強制更新) */
  if (strcmp(dir_cache_path, fdp->path) != 0 || fdp->position <= 2) {
    int result = __wasi_list_directory(fdp->path, strlen(fdp->path), dir_cache,
                                       sizeof(dir_cache), &dir_cache_count);
    if (result != 0) {
      return 1; /* エラーまたはエントリなし */
    }
    strcpy(dir_cache_path, fdp->path);
  }

  /* キャッシュから適切なエントリを取得 */
  if (dir_cache_count > 0) {
    int target_index = fdp->position - 2; /* . と .. を除く */
    char *entry_name = dir_cache;
    int current_index = 0;

    /* null終端された文字列のリストを解析 */
    for (int i = 0; i < dir_cache_count; i++) {
      /* . と .. をスキップ */
      if (strcmp(entry_name, ".") != 0 && strcmp(entry_name, "..") != 0) {
        if (current_index == target_index) {
          entry->ino = 100 + i;
          strcpy(entry->name, entry_name);
          /* ディレクトリ名の末尾に / がある場合は削除 */
          int name_len = strlen(entry->name);
          if (name_len > 0 && entry->name[name_len - 1] == '/') {
            entry->name[name_len - 1] = '\0';
            entry->type = DT_DIR;
          } else {
            entry->type = DT_REG;
          }
          fdp->position++;
          return 0;
        }
        current_index++;
      }
      /* 次のエントリに進む */
      entry_name += strlen(entry_name) + 1;
    }
  }

  /* エントリがもうない */
  return 1;
}

/**
 * ディレクトリを閉じる
 */
int fs_closedir(int fd) { return fs_close(fd); }

/**
 * /proc ファイルシステムの内容を生成
 */
static int procfs_read(const char *path, char *buffer, size_t size) {
  /* TODO: procfs実装 */
  (void)path;
  (void)buffer;
  (void)size;
  return -1;
}
