declare global {
  var wasm: {
    instance: WebAssembly.Instance;
    module: WebAssembly.Module;
  };
}

// WASI I/O vector 構造体のサイズとオフセット
const IOVEC_SIZE = 8;  // buf(4) + buf_len(4)

export async function boot() {
  const memory = new WebAssembly.Memory({
    initial: 17,
    maximum: 1024,
    shared: true
  });

  // WASI import objects
  const importObj = {
    env: {
      memory: memory,
    },
    wasi_snapshot_preview1: {
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
          
          // fd に応じてコンソール出力
          if (fd === 1) {  // STDOUT
            console.log("[STDOUT]", str.replace(/\n$/, ""));
          } else if (fd === 2) {  // STDERR  
            console.error("[STDERR]", str.replace(/\n$/, ""));
          }
          
          totalWritten += buf_len;
        }
        
        // 書き込み済みバイト数を返す
        view.setUint32(nwritten_ptr, totalWritten, true);
        return 0;  // success
      },
    },
  };
  
  const res = await fetch("../kernel.wasm");
  const bytes = await res.arrayBuffer();
  const wasm = await WebAssembly.instantiate(bytes, importObj);
  globalThis.wasm = wasm;

  console.log("WebAssembly exports:", Object.keys(wasm.instance.exports));
  
  const startFunction = (wasm.instance.exports as any)._start as Function;
  startFunction();
  console.log("Kernel started successfully.");
}
