/**
 * WASI (WebAssembly System Interface) 実装
 */

// WASI I/O vector 構造体のサイズとオフセット
const IOVEC_SIZE = 8;  // buf(4) + buf_len(4)

/**
 * WASI システムコールの実装
 */
export function createWasiImports(memory: WebAssembly.Memory) {
  return {
    proc_exit: (code: number) => {
      console.log(`[WASI] Process exited with code: ${code}`);
      // TODO: プロセス終了処理
    },
    
    fd_write: (fd: number, iovs_ptr: number, iovs_len: number, nwritten_ptr: number) => {
      const view = new DataView(memory.buffer);
      const u8 = new Uint8Array(memory.buffer);
      let totalWritten = 0;
      
      // 各 iovec 処理
      for (let i = 0; i < iovs_len; i++) {
        const iovec_ptr = iovs_ptr + i * IOVEC_SIZE;
        const buf_ptr = view.getUint32(iovec_ptr, true);  // little endian
        const buf_len = view.getUint32(iovec_ptr + 4, true);
        
        // バッファから文字列を読み取り
        const bytes = u8.slice(buf_ptr, buf_ptr + buf_len);
        const str = new TextDecoder().decode(bytes);
        
        // fd に応じて出力先を切り替え
        if (fd === 1) {  // STDOUT
          // ターミナルウィンドウに出力
          if (globalThis.terminalWrite) {
            globalThis.terminalWrite(str);
          }
          // デバッグ用にコンソールにも出力
          console.log("[STDOUT]", str.replace(/\n$/, ""));
        } else if (fd === 2) {  // STDERR  
          if (globalThis.terminalWrite) {
            globalThis.terminalWrite(str);
          }
          console.error("[STDERR]", str.replace(/\n$/, ""));
        }
        
        totalWritten += buf_len;
      }
      
      // 書き込み済みバイト数を返す
      view.setUint32(nwritten_ptr, totalWritten, true);
      return 0;  // success
    },
    
    fd_read: (fd: number, iovs_ptr: number, iovs_len: number, nread_ptr: number) => {
      const view = new DataView(memory.buffer);
      const u8 = new Uint8Array(memory.buffer);
      
      if (fd === 0 && globalThis.inputReady && globalThis.inputBuffer) {  // STDIN
        // 入力バッファから読み取り
        const input = globalThis.inputBuffer + '\n';
        const encoder = new TextEncoder();
        const inputBytes = encoder.encode(input);
        
        let totalRead = 0;
        for (let i = 0; i < iovs_len && totalRead < inputBytes.length; i++) {
          const iovec_ptr = iovs_ptr + i * IOVEC_SIZE;
          const buf_ptr = view.getUint32(iovec_ptr, true);
          const buf_len = view.getUint32(iovec_ptr + 4, true);
          
          const copyLen = Math.min(buf_len, inputBytes.length - totalRead);
          u8.set(inputBytes.slice(totalRead, totalRead + copyLen), buf_ptr);
          totalRead += copyLen;
        }
        
        view.setUint32(nread_ptr, totalRead, true);
        globalThis.inputBuffer = '';
        globalThis.inputReady = false;
        return 0;
      }
      
      view.setUint32(nread_ptr, 0, true);
      return 0;
    },
    
    clock_time_get: (clock_id: number, precision: bigint, time_ptr: number) => {
      const view = new DataView(memory.buffer);
      const now = BigInt(Date.now()) * 1000000n; // ミリ秒からナノ秒へ
      view.setBigUint64(time_ptr, now, true);
      return 0;
    },
  };
}