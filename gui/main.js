import { boot } from "../syslib/index.ts";
import { initializeTerminal } from "./terminal.js";
import { initializeWindowManager } from "./window-manager.js";

// ウィンドウマネージャー初期化
initializeWindowManager();

// ターミナル基本機能初期化（setTerminalReady呼び出しは後で）
initializeTerminal();

// カーネル起動後にターミナル準備完了状態にする
boot().then(() => {
  // ブート完了後にターミナル準備完了を通知
  if (globalThis.setTerminalReady) {
    globalThis.setTerminalReady();
  }
}).catch(error => {
  console.error('Failed to boot WebVM:', error);
  document.body.innerHTML += `<div style="color: red; padding: 20px; font-family: monospace;">
    <h2>Failed to boot WebVM</h2>
    <pre>${error.message}</pre>
    <p>Please check the console for more details.</p>
  </div>`;
});