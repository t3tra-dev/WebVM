/*
 * WebVM ファイルシステムヘッダ
 */

#ifndef __WEBVM_FS_H__
#define __WEBVM_FS_H__

/* ファイルシステム操作 */
int fs_mount(const char *path, int fs_type);
int fs_umount(const char *path);
int fs_get_type(const char *path);

/* VFS構造体 (将来の拡張用)  */
struct vfs_operations {
    int (*open)(const char *path, int flags);
    int (*read)(int fd, void *buf, size_t count);
    int (*write)(int fd, const void *buf, size_t count);
    int (*close)(int fd);
};

/* inode構造体 (簡易版)  */
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
