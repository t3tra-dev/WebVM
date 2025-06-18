/**
 * 型定義
 */

// グローバル変数の型定義
declare global {
  var wasm: {
    instance: WebAssembly.Instance;
    module: WebAssembly.Module;
  };
  var terminalWrite: (text: string) => void;
  var terminalWriteLine: (text: string) => void;
  var handleCommand: (command: string) => void;
  var inputBuffer: string;
  var inputReady: boolean;
}

export {};