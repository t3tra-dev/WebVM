/**
 * WebAssembly Worker
 * 専用ワーカースレッドでkernel.wasmを実行
 * SharedArrayBuffer + AtomicsでFS Workerと通信
 */

import {
  FS_OFFSET_REQUEST_ID,
  FS_OFFSET_OP_TYPE,
  FS_OFFSET_STATUS,
  FS_OFFSET_DATA_LENGTH,
  FS_OFFSET_RESULT_CODE,
  FS_OFFSET_DATA_START,
  FS_OP_CREATE_DIRECTORY,
  FS_OP_DIRECTORY_EXISTS,
  FS_OP_LIST_DIRECTORY,
  FS_OP_DELETE_DIRECTORY,
  FS_OP_CREATE_FILE,
  FS_OP_READ_FILE,
  FS_OP_WRITE_FILE,
  FS_OP_DELETE_FILE,
  FS_OP_FILE_EXISTS,
  FS_OP_FILE_STAT,
  FS_STATUS_IDLE,
  FS_STATUS_PENDING,
  FS_STATUS_COMPLETED,
  FS_STATUS_ERROR
} from './shared-constants';

// グローバル変数
let wasmModule: WebAssembly.Module | null = null;
let wasmInstance: WebAssembly.Instance | null = null;
let wasmMemory: WebAssembly.Memory | null = null;
let fsSharedBuffer: SharedArrayBuffer | null = null;
let fsSharedArray: Int32Array | null = null;
let requestId = 1;

// 入力処理
let inputBuffer = '';
let inputReady = false;

// ワーカー初期化
self.onmessage = async (event) => {
  const { type, data } = event.data;
  
  switch (type) {
    case 'init':
      await initializeWasm(data);
      break;
    case 'command':
      handleCommand(data.command);
      break;
    case 'input':
      handleInput(data.input);
      break;
  }
};

async function initializeWasm(data: { wasmBytes: Uint8Array, fsSharedBuffer: SharedArrayBuffer }) {
  try {
    // FS通信設定
    fsSharedBuffer = data.fsSharedBuffer;
    fsSharedArray = new Int32Array(fsSharedBuffer);
    
    // WASMモジュールコンパイル
    wasmModule = await WebAssembly.compile(data.wasmBytes);
    
    // スレッドサポート付きメモリ作成 - カーネル要件に合わせる
    wasmMemory = new WebAssembly.Memory({
      initial: 594,  // 37.1MB - カーネル要件に合致
      maximum: 2048, // 128MB  
      shared: true
    });
    
    // WASIインポート作成
    const wasiImports = createWasiImports();
    
    // WASMインスタンス化
    wasmInstance = await WebAssembly.instantiate(wasmModule, {
      wasi_snapshot_preview1: wasiImports,
      env: {
        memory: wasmMemory
      }
    });
    
    // カーネル開始
    if (wasmInstance.exports._start) {
      try {
        (wasmInstance.exports._start as Function)();
      } catch (error) {
        console.error('[Wasm Worker] _start error:', error);
      }
    }
    
    self.postMessage({ type: 'ready' });
    
  } catch (error) {
    console.error('[Wasm Worker] Initialization failed:', error);
    self.postMessage({ type: 'error', error: String(error) });
  }
}

function handleCommand(command: string) {
  if (wasmInstance && wasmInstance.exports.handle_command) {
    // コマンドをWASMメモリにコピー
    const encoder = new TextEncoder();
    const commandBytes = encoder.encode(command + '\0');
    
    const memory = new Uint8Array((wasmMemory as WebAssembly.Memory).buffer);
    const cmdPtr = allocateString(commandBytes);
    
    // WASM関数呼び出し
    (wasmInstance.exports.handle_command as Function)(cmdPtr, commandBytes.length - 1);
  }
}

function handleInput(input: string) {
  inputBuffer = input;
  inputReady = true;
}

function allocateString(bytes: Uint8Array): number {
  // 使用メモリの末尾での簡易割り当て
  // 実際の実装では適切なアロケーターが必要
  const memory = new Uint8Array((wasmMemory as WebAssembly.Memory).buffer);
  const ptr = memory.length - 1024; // 末尾1KBを一時割り当てに使用
  memory.set(bytes, ptr);
  return ptr;
}

// FS Worker通信付きWASI実装
function createWasiImports() {
  return {
    proc_exit: (code: number) => {
      console.log(`[Wasm Worker] Process exited with code: ${code}`);
      self.postMessage({ type: 'exit', code });
    },
    
    fd_write: (fd: number, iovs_ptr: number, iovs_len: number, nwritten_ptr: number) => {
      const memory = new Uint8Array((wasmMemory as WebAssembly.Memory).buffer);
      const view = new DataView((wasmMemory as WebAssembly.Memory).buffer);
      let totalWritten = 0;
      
      // iovecを処理
      for (let i = 0; i < iovs_len; i++) {
        const iovec_ptr = iovs_ptr + i * 8;
        const buf_ptr = view.getUint32(iovec_ptr, true);
        const buf_len = view.getUint32(iovec_ptr + 4, true);
        
        const bytes = memory.slice(buf_ptr, buf_ptr + buf_len);
        const text = new TextDecoder().decode(bytes);
        
        if (fd === 1 || fd === 2) { // STDOUT/STDERR
          self.postMessage({ type: 'output', text });
        }
        
        totalWritten += buf_len;
      }
      
      view.setUint32(nwritten_ptr, totalWritten, true);
      return 0;
    },
    
    fd_read: (fd: number, iovs_ptr: number, iovs_len: number, nread_ptr: number) => {
      const memory = new Uint8Array((wasmMemory as WebAssembly.Memory).buffer);
      const view = new DataView((wasmMemory as WebAssembly.Memory).buffer);
      
      if (fd === 0 && inputReady) { // STDIN
        const input = inputBuffer + '\n';
        const encoder = new TextEncoder();
        const inputBytes = encoder.encode(input);
        
        let totalRead = 0;
        for (let i = 0; i < iovs_len && totalRead < inputBytes.length; i++) {
          const iovec_ptr = iovs_ptr + i * 8;
          const buf_ptr = view.getUint32(iovec_ptr, true);
          const buf_len = view.getUint32(iovec_ptr + 4, true);
          
          const copyLen = Math.min(buf_len, inputBytes.length - totalRead);
          memory.set(inputBytes.slice(totalRead, totalRead + copyLen), buf_ptr);
          totalRead += copyLen;
        }
        
        view.setUint32(nread_ptr, totalRead, true);
        inputBuffer = '';
        inputReady = false;
        return 0;
      }
      
      view.setUint32(nread_ptr, 0, true);
      return 0;
    },
    
    clock_time_get: (_clock_id: number, _precision: bigint, time_ptr: number) => {
      const view = new DataView((wasmMemory as WebAssembly.Memory).buffer);
      const now = BigInt(Date.now()) * 1000000n;
      view.setBigUint64(time_ptr, now, true);
      return 0;
    },
    
    // Worker RPC経由のFS操作
    path_create_directory: (_fd: number, path_ptr: number, path_len: number, mode: number = 0o755) => {
      const path = readStringFromMemory(path_ptr, path_len);
      
      const result = callFSWorker(FS_OP_CREATE_DIRECTORY, JSON.stringify({ path, mode }));
      
      return result;
    },
    
    directory_exists: (path_ptr: number, path_len: number, result_ptr: number) => {
      const path = readStringFromMemory(path_ptr, path_len);
      
      const result = callFSWorker(FS_OP_DIRECTORY_EXISTS, path);
      
      const view = new DataView((wasmMemory as WebAssembly.Memory).buffer);
      if (result < 0) {
        // エラーの場合は存在しないとして0を設定
        view.setUint32(result_ptr, 0, true);
        return -1;
      } else {
        view.setUint32(result_ptr, result, true);
        return 0;
      }
    },
    
    list_directory: (path_ptr: number, path_len: number, buffer_ptr: number, buffer_size: number, count_ptr: number) => {
      const path = readStringFromMemory(path_ptr, path_len);
      const { result, responseData } = callFSWorkerWithResponse(FS_OP_LIST_DIRECTORY, path);
      
      if (result === 0 && responseData) {
        const entries = JSON.parse(responseData);
        const allEntries = ['.', '..', ...entries];
        
        const memory = new Uint8Array((wasmMemory as WebAssembly.Memory).buffer);
        const view = new DataView((wasmMemory as WebAssembly.Memory).buffer);
        
        let offset = 0;
        let count = 0;
        
        for (const entry of allEntries) {
          const entryBytes = new TextEncoder().encode(entry + '\0');
          if (offset + entryBytes.length > buffer_size) break;
          
          memory.set(entryBytes, buffer_ptr + offset);
          offset += entryBytes.length;
          count++;
        }
        
        view.setUint32(count_ptr, count, true);
      }
      
      return result;
    },
    
    path_remove_directory: (_fd: number, path_ptr: number, path_len: number) => {
      const path = readStringFromMemory(path_ptr, path_len);
      return callFSWorker(FS_OP_DELETE_DIRECTORY, path);
    },
    
    // ファイル操作のWASI実装
    file_create: (path_ptr: number, path_len: number, mode: number = 0o644) => {
      const path = readStringFromMemory(path_ptr, path_len);
      return callFSWorker(FS_OP_CREATE_FILE, JSON.stringify({ path, mode }));
    },
    
    file_read: (path_ptr: number, path_len: number, buffer_ptr: number, buffer_size: number, bytes_read_ptr: number) => {
      const path = readStringFromMemory(path_ptr, path_len);
      
      const { result, responseData } = callFSWorkerWithResponse(FS_OP_READ_FILE, path);
      
      const view = new DataView((wasmMemory as WebAssembly.Memory).buffer);
      
      if (result === 0 && responseData) {
        // Base64デコードしてバイナリデータに変換
        const binaryString = atob(responseData);
        
        const data = new Uint8Array(binaryString.length);
        for (let i = 0; i < binaryString.length; i++) {
          data[i] = binaryString.charCodeAt(i);
        }
        
        const memory = new Uint8Array((wasmMemory as WebAssembly.Memory).buffer);
        
        const copyLen = Math.min(data.length, buffer_size);
        if (copyLen > 0) {
          memory.set(data.slice(0, copyLen), buffer_ptr);
        }
        view.setUint32(bytes_read_ptr, copyLen, true);
      } else {
        // エラーまたは空ファイルの場合
        view.setUint32(bytes_read_ptr, 0, true);
      }
      
      return result;
    },
    
    file_write: (path_ptr: number, path_len: number, data_ptr: number, data_len: number) => {
      const path = readStringFromMemory(path_ptr, path_len);
      
      const memory = new Uint8Array((wasmMemory as WebAssembly.Memory).buffer);
      const data = memory.slice(data_ptr, data_ptr + data_len);
      
      // バイナリデータをBase64エンコード
      const base64Data = btoa(String.fromCharCode(...data));
      
      const result = callFSWorker(FS_OP_WRITE_FILE, JSON.stringify({ path, data: base64Data }));
      
      return result;
    },
    
    file_delete: (path_ptr: number, path_len: number) => {
      const path = readStringFromMemory(path_ptr, path_len);
      return callFSWorker(FS_OP_DELETE_FILE, path);
    },
    
    file_exists: (path_ptr: number, path_len: number, result_ptr: number) => {
      const path = readStringFromMemory(path_ptr, path_len);
      
      const result = callFSWorker(FS_OP_FILE_EXISTS, path);
      
      const view = new DataView((wasmMemory as WebAssembly.Memory).buffer);
      if (result < 0) {
        // エラーの場合は存在しないとして0を設定
        view.setUint32(result_ptr, 0, true);
        return -1;
      } else {
        view.setUint32(result_ptr, result, true);
        return 0;
      }
    },
    
    file_stat: (path_ptr: number, path_len: number, stat_buf_ptr: number) => {
      const path = readStringFromMemory(path_ptr, path_len);
      
      const { result, responseData } = callFSWorkerWithResponse(FS_OP_FILE_STAT, path);
      
      if (result === 0 && responseData) {
        const stat = JSON.parse(responseData);
        
        const view = new DataView((wasmMemory as WebAssembly.Memory).buffer);
        
        // struct inode の正確なレイアウトに合わせて書き込み:
        // unsigned long ino (8 bytes)
        // unsigned int mode (4 bytes) 
        // unsigned int uid (4 bytes)
        // unsigned int gid (4 bytes)
        // unsigned long size (8 bytes)
        // unsigned long atime (8 bytes)
        // unsigned long mtime (8 bytes)
        // unsigned long ctime (8 bytes)
        
        let offset = stat_buf_ptr;
        
        // ino (8 bytes) - inode番号
        view.setBigUint64(offset, BigInt(stat.ino || 1), true);
        offset += 8;
        
        // mode (4 bytes) - ファイルモード
        view.setUint32(offset, stat.mode || 0o644, true);
        offset += 4;
        
        // uid (4 bytes) - ユーザーID
        view.setUint32(offset, stat.uid || 0, true);
        offset += 4;
        
        // gid (4 bytes) - グループID
        view.setUint32(offset, stat.gid || 0, true);
        offset += 4;
        
        // size (8 bytes) - ファイルサイズ
        view.setBigUint64(offset, BigInt(stat.size || 0), true);
        offset += 8;
        
        // atime (8 bytes) - アクセス時刻
        view.setBigUint64(offset, BigInt(stat.atime || stat.mtime || Date.now()), true);
        offset += 8;
        
        // mtime (8 bytes) - 変更時刻
        view.setBigUint64(offset, BigInt(stat.mtime || Date.now()), true);
        offset += 8;
        
        // ctime (8 bytes) - 作成時刻
        view.setBigUint64(offset, BigInt(stat.ctime || stat.mtime || Date.now()), true);
        
        // メモリダンプで実際の書き込み内容を確認
        const dumpBytes = new Uint8Array((wasmMemory as WebAssembly.Memory).buffer, stat_buf_ptr, 56);
      } else {
      }
      
      return result;
    },
    
    // その他のWASI関数の実装
    path_open: () => 10, // ダミーfd
    path_unlink_file: (_fd: number, path_ptr: number, path_len: number) => {
      const path = readStringFromMemory(path_ptr, path_len);
      return callFSWorker(FS_OP_DELETE_FILE, path);
    },
    path_filestat_get: (path_ptr: number, path_len: number, stat_buf_ptr: number) => {
      const path = readStringFromMemory(path_ptr, path_len);
      const { result, responseData } = callFSWorkerWithResponse(FS_OP_FILE_STAT, path);
      
      if (result === 0 && responseData) {
        const stat = JSON.parse(responseData);
        const view = new DataView((wasmMemory as WebAssembly.Memory).buffer);
        
        // 簡易的なstat構造体への書き込み
        view.setUint32(stat_buf_ptr, stat.size, true);        // size
        view.setUint32(stat_buf_ptr + 4, stat.mode, true);    // mode
        view.setUint32(stat_buf_ptr + 8, stat.mtime, true);   // mtime
        view.setUint32(stat_buf_ptr + 12, stat.ctime, true);  // ctime
        view.setUint32(stat_buf_ptr + 16, stat.uid, true);    // uid
        view.setUint32(stat_buf_ptr + 20, stat.gid, true);    // gid
      }
      
      return result;
    },
    
    // 新しい直接アクセス関数 - 構造体レイアウト問題を回避
    file_get_size: (path_ptr: number, path_len: number, size_ptr: number) => {
      const path = readStringFromMemory(path_ptr, path_len);
      
      const { result, responseData } = callFSWorkerWithResponse(FS_OP_FILE_STAT, path);
      
      if (result === 0 && responseData) {
        const stat = JSON.parse(responseData);
        const view = new DataView((wasmMemory as WebAssembly.Memory).buffer);
        view.setBigUint64(size_ptr, BigInt(stat.size || 0), true);
        return 0;
      }
      
      return -1;
    },

    // 位置対応ファイル読み込み関数
    file_read_direct: (path_ptr: number, path_len: number, buffer_ptr: number, buffer_size: number, bytes_read_ptr: number) => {
      const path = readStringFromMemory(path_ptr, path_len);
      
      // 読み取り済みファイルキャッシュをチェック (EOF処理)
      if (!(globalThis as any).readFileCache) {
        (globalThis as any).readFileCache = new Set();
      }
      
      if ((globalThis as any).readFileCache.has(path)) {
        // 既に読み取り済み = EOF
        const view = new DataView((wasmMemory as WebAssembly.Memory).buffer);
        view.setUint32(bytes_read_ptr, 0, true);
        return 0;
      }
      
      const { result, responseData } = callFSWorkerWithResponse(FS_OP_READ_FILE, path);
      
      const view = new DataView((wasmMemory as WebAssembly.Memory).buffer);
      
      if (result === 0 && responseData) {
        // Base64デコードしてバイナリデータに変換
        const binaryString = atob(responseData);
        
        const data = new Uint8Array(binaryString.length);
        for (let i = 0; i < binaryString.length; i++) {
          data[i] = binaryString.charCodeAt(i);
        }
        
        const copyLen = Math.min(data.length, buffer_size);
        
        if (copyLen > 0) {
          const memory = new Uint8Array((wasmMemory as WebAssembly.Memory).buffer);
          memory.set(data.slice(0, copyLen), buffer_ptr);
          view.setUint32(bytes_read_ptr, copyLen, true);
          
          // 重要: ファイルを読み取り済みとしてマーク
          (globalThis as any).readFileCache.add(path);
          
          return 0;
        } else {
          view.setUint32(bytes_read_ptr, 0, true);
          return 0;
        }
      } else {
        // エラーまたは空ファイルの場合
        view.setUint32(bytes_read_ptr, 0, true);
        return result;
      }
    },
    
    // ファイルクローズ時にキャッシュをクリア
    file_close_direct: (path_ptr: number, path_len: number) => {
      const path = readStringFromMemory(path_ptr, path_len);
      
      if ((globalThis as any).readFileCache) {
        (globalThis as any).readFileCache.delete(path);
      }
      
      return 0;
    },
    
    fd_filestat_get: () => 0
  };
}

function readStringFromMemory(ptr: number, len: number): string {
  const memory = new Uint8Array((wasmMemory as WebAssembly.Memory).buffer);
  const bytes = memory.slice(ptr, ptr + len);
  return new TextDecoder().decode(bytes);
}

function writeStringToSharedBuffer(data: string): void {
  const bytes = new TextEncoder().encode(data);
  const dataArray = new Uint8Array(fsSharedBuffer as SharedArrayBuffer, FS_OFFSET_DATA_START * 4, bytes.length);
  dataArray.set(bytes);
  Atomics.store(fsSharedArray as Int32Array, FS_OFFSET_DATA_LENGTH, bytes.length);
}

function readStringFromSharedBuffer(): string {
  const length = Atomics.load(fsSharedArray as Int32Array, FS_OFFSET_DATA_LENGTH);
  const dataArray = new Uint8Array(fsSharedBuffer as SharedArrayBuffer, FS_OFFSET_DATA_START * 4, length);
  // Copy to regular ArrayBuffer since TextDecoder doesn't support SharedArrayBuffer
  const copiedArray = new Uint8Array(length);
  copiedArray.set(dataArray);
  return new TextDecoder().decode(copiedArray);
}

function callFSWorker(opType: number, data: string): number {
  if (!fsSharedArray || !fsSharedBuffer) return -1;
  
  // FS Workerがアイドル状態になるまで待機
  let attempts = 0;
  while (Atomics.load(fsSharedArray, FS_OFFSET_STATUS) !== FS_STATUS_IDLE && attempts < 1000) {
    attempts++;
    // 短時間のビジーウェイト
    for (let i = 0; i < 1000; i++) { /* busy wait */ }
  }
  
  if (attempts >= 1000) return -1; // タイムアウト
  
  // リクエスト準備
  const reqId = requestId++;
  Atomics.store(fsSharedArray, FS_OFFSET_REQUEST_ID, reqId);
  Atomics.store(fsSharedArray, FS_OFFSET_OP_TYPE, opType);
  writeStringToSharedBuffer(data);
  Atomics.store(fsSharedArray, FS_OFFSET_RESULT_CODE, 0);
  
  // リクエスト送信とレスポンス待機
  Atomics.store(fsSharedArray, FS_OFFSET_STATUS, FS_STATUS_PENDING);
  
  const result = Atomics.wait(fsSharedArray, FS_OFFSET_STATUS, FS_STATUS_PENDING, 5000);
  if (result === 'timed-out') return -1;
  
  const status = Atomics.load(fsSharedArray, FS_OFFSET_STATUS);
  if (status === FS_STATUS_ERROR) return -1;
  
  const resultCode = Atomics.load(fsSharedArray, FS_OFFSET_RESULT_CODE);
  
  // ステータスリセット
  Atomics.store(fsSharedArray, FS_OFFSET_STATUS, FS_STATUS_IDLE);
  
  return resultCode;
}

function callFSWorkerWithResponse(opType: number, data: string): { result: number; responseData: string } {
  const result = callFSWorker(opType, data);
  const responseData = result === 0 ? readStringFromSharedBuffer() : '';
  return { result, responseData };
}

