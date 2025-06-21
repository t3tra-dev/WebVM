/**
 * 型定義
 */

// グローバル変数の型定義
declare global {
  var terminalWrite: (text: string) => void;
  var terminalWriteLine: (text: string) => void;
  var handleCommand: (command: string) => void;
  var sendInput: (input: string) => void;
}

export {};
