> Written by Claude

- - -

GNU Coreutilsのソースを転用できるようにするには、WebVMのアーキテクチャを大幅に拡張する必要があります。以下のアプローチを提案します:

### 1. POSIX互換システムコールレイヤーの実装

必要なシステムコール群

```c
// ファイルI/O
open(), close(), read(), write(), lseek()
stat(), lstat(), fstat(), access()
chmod(), chown(), chgrp()
link(), symlink(), unlink(), rename()
opendir(), readdir(), closedir()

// プロセス管理  
fork(), execve(), wait(), waitpid()
getpid(), getppid(), getuid(), getgid()
signal(), kill(), alarm()

// メモリ管理
mmap(), munmap(), brk(), sbrk()
```

システムコール番号の標準化

- Linux/POSIX のシステムコール番号に準拠
- WebAssembly 制約の代替実装 (`fork` → `posix_spawn` 等)

### 2. 完全なlibcの実装

標準ライブラリ関数群

```c
// stdio.h
printf(), scanf(), fopen(), fclose()
fread(), fwrite(), fseek(), ftell()
getchar(), putchar(), gets(), puts()

// stdlib.h  
malloc(), free(), realloc(), calloc()
atoi(), atol(), strtol(), strtod()
getenv(), setenv(), system()

// string.h
strcpy(), strcat(), strlen(), strcmp()
memcpy(), memset(), memcmp()

// time.h
time(), ctime(), gmtime(), strftime()
```

### 3. アーキテクチャの再設計

スタンドアロンバイナリ方式への移行

現在: `shell.c` 内のビルトイン関数

↓

将来: 独立したWASMバイナリ
```
    /bin/ls.wasm
    /bin/cat.wasm
    /bin/cp.wasm
```

### 4. ビルドツールチェーンの構築

GNU Autotools サポート

coreutilsの標準ビルド
```bash
./configure --host=wasm32-unknown-unknown
make CC=clang --target=wasm32
```

WebVM 専用ツールチェーン
```bash
./webvm-clang -o ls.wasm ls.c -lwebvm-libc
./webvm-ld --export=main ls.o -o /bin/ls.wasm
```

### 5. 段階的な実装戦略

Phase 1: コア機能の拡張

- システムコールテーブルの実装
- 基本的なlibc関数群
- プロセスローダーの作成

Phase 2: 互換性レイヤー

- POSIX準拠のファイルAPI
- シグナル処理の基本実装
- 環境変数管理

Phase 3: GNU Coreutils 移植

- 単純なコマンドから開始（cat, echo, true, false）
- 徐々に複雑なコマンドに拡張（ls, cp, mv）
- 最終的に高度なコマンド（grep, sort, find）

### 6. WebAssembly 制約への対応

- メモリ分離

- `fork()` の代替実装

### 7. 開発ツールとデバッグ環境

互換性テストスイート

```bash
# GNU coreutils テストの実行
make check-coreutils
```

クロスコンパイル環境
```dockerfile
FROM emscripten/emsdk
RUN apt-get install autotools-dev
COPY webvm-toolchain /usr/local/bin/
```

### 実装の優先順位

1. libc基盤 → malloc, stdio, string関数
2. ファイルシステムAPI → open/read/write/stat
3. プロセスローダー → 独立したWASM実行
4. シンプルなcoreutils → cat, echo, true, false
5. 複雑なcoreutils → ls, cp, mv, rm
6. 高度な機能 → grep, sort, find

この段階的アプローチにより、GNU Coreutils の豊富なコマンド群を WebVM に移植し、本格的な Unix 環境を実現できます。
