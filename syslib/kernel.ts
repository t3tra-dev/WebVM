/**
 * カーネル管理モジュール
 */

import { createWasiImports } from './wasi.js';

export interface KernelExports {
  _start: () => void;
  handle_command?: (ptr: number) => void;
}

/**
 * カーネルをロードして起動
 */
export async function loadKernel(memory: WebAssembly.Memory): Promise<WebAssembly.WebAssemblyInstantiatedSource> {
  // WASI インポートオブジェクトを作成
  const importObj = {
    env: { memory },
    wasi_snapshot_preview1: createWasiImports(memory),
  };

  // カーネルWASMをフェッチ
  const res = await fetch("./kernel.wasm");
  const bytes = await res.arrayBuffer();
  const wasm = await WebAssembly.instantiate(bytes, importObj);

  return wasm;
}

/**
 * コマンドハンドラを設定
 */
export function setupCommandHandler(instance: WebAssembly.Instance, memory: WebAssembly.Memory) {
  const exports = instance.exports as unknown as KernelExports;

  if (exports.handle_command) {
    globalThis.handleCommand = (command: string) => {
      // コマンド文字列をメモリに書き込む
      const encoder = new TextEncoder();
      const cmdBytes = encoder.encode(command + '\0');
      const cmdPtr = 0x10000; // 一時的なメモリ位置
      const u8 = new Uint8Array(memory.buffer);
      u8.set(cmdBytes, cmdPtr);

      // handle_commandを呼び出す
      exports.handle_command!(cmdPtr);
    };
  }
}
