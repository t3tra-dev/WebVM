/**
 * ターミナル機能
 */

// ターミナル要素
const terminalOutput = document.getElementById("terminal-output");
const terminalInput = document.getElementById("terminal-input");

/**
 * ターミナルAPIを初期化
 */
export function initializeTerminal() {
  // ターミナル出力関数
  window.terminalWrite = function (text) {
    terminalOutput.textContent += text;
    terminalOutput.scrollTop = terminalOutput.scrollHeight;
  };

  window.terminalWriteLine = function (text) {
    window.terminalWrite(text + "\n");
  };

  window.terminalClear = function () {
    terminalOutput.textContent = "";
  };

  // 入力ハンドラを設定
  setupInputHandler();
}

/**
 * 入力ハンドラを設定
 */
function setupInputHandler() {
  terminalInput.addEventListener("keydown", (e) => {
    if (e.key === "Enter") {
      const command = terminalInput.value;
      window.terminalWriteLine("$ " + command);

      // カーネルにコマンドを送信
      if (window.handleCommand) {
        window.handleCommand(command);
      }

      terminalInput.value = "";
    }
  });

  // 自動フォーカス
  terminalInput.focus();

  // クリック時にフォーカス
  document.getElementById("terminal").addEventListener("click", () => {
    terminalInput.focus();
  });
}
