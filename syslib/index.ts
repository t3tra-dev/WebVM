/**
 * WebVM システムライブラリ エントリポイント
 */

import './types.js';
import { loadKernel, setupCommandHandler } from './kernel.js';

/**
 * WebVMを起動
 */
export async function boot() {
  // カーネルの max-memory=134217728 (128MB) に合わせる
  // 1ページ = 64KB なので 128MB = 2048ページ
  const memory = new WebAssembly.Memory({
    initial: 2048,
    maximum: 2048,
    shared: true
  });

  // カーネルをロード
  const { instance, module } = await loadKernel(memory);

  // グローバル変数に保存
  globalThis.wasm = {
    instance,
    module,
  };

  console.log("WebAssembly exports:", Object.keys(instance.exports));

  // カーネルを起動
  const exports = instance.exports as any;
  const startFunction = exports._start as Function;
  startFunction();
  console.log("Kernel started successfully.");

  // コマンドハンドラを設定
  setupCommandHandler(instance, memory);
}
