/**
 * ターミナル機能
 */

// ターミナル要素
const terminalOutput = document.getElementById("terminal-output");
const terminalInput = document.getElementById("terminal-input");
const terminalPrompt = document.querySelector(".terminal-prompt");

// プロンプト管理
let currentPrompt = "$ ";
let commandInProgress = false;

/**
 * ターミナルAPIを初期化
 */
export function initializeTerminal() {
  // ターミナル出力関数
  globalThis.terminalWrite = function (text) {
    // 出力をバッファに追加
    terminalOutput.textContent += text;
    terminalOutput.scrollTop = terminalOutput.scrollHeight;
    
    // プロンプトパターン検出（最後の行のみチェック）
    const outputText = terminalOutput.textContent;
    const lines = outputText.split('\n');
    const lastLine = lines[lines.length - 1];
    
    // 最後の行がプロンプトパターンにマッチするかチェック
    // パターン: "/path:$ " または "$ "
    const promptMatch = lastLine.match(/^([\/\w\-\.\s]*:\$|\$)\s*$/);
    if (promptMatch && lines.length > 1) {  // 少なくとも2行以上ある場合のみプロンプト処理
      // プロンプト更新
      updatePrompt(promptMatch[1]); // キャプチャグループ使用
      // プロンプト行をターミナル出力から削除
      lines.pop();
      terminalOutput.textContent = lines.join('\n');
      if (lines.length > 0 && !terminalOutput.textContent.endsWith('\n')) {
        terminalOutput.textContent += '\n';
      }
    }
  };

  globalThis.terminalWriteLine = function (text) {
    globalThis.terminalWrite(text + "\n");
  };

  globalThis.terminalClear = function () {
    terminalOutput.textContent = "";
  };

  // プロンプト更新関数
  window.updatePrompt = updatePrompt;

  // 入力ハンドラー設定
  setupInputHandler();
}

/**
 * プロンプトを更新
 */
function updatePrompt(promptText) {
  currentPrompt = promptText.trim();
  commandInProgress = false;
  
  // HTMLのプロンプト表示を更新
  if (terminalPrompt) {
    terminalPrompt.textContent = currentPrompt + " ";
  }
  
  // 入力欄を有効化
  if (terminalInput) {
    terminalInput.disabled = false;
    terminalInput.focus();
  }
}

/**
 * 入力ハンドラー設定
 */
function setupInputHandler() {
  terminalInput.addEventListener("keydown", (e) => {
    if (e.key === "Enter" && !commandInProgress) {
      const command = terminalInput.value.trim();
      
      // コマンドラインを表示（現在のプロンプト付き）
      terminalOutput.textContent += currentPrompt + " " + command + "\n";
      terminalOutput.scrollTop = terminalOutput.scrollHeight;
      
      commandInProgress = true;
      
      // 入力欄を無効化
      terminalInput.disabled = true;

      // カーネルにコマンドを送信
      if (globalThis.handleCommand && command) {
        globalThis.handleCommand(command);
      } else if (!command) {
        // 空のコマンドの場合は即座にプロンプトを表示
        updatePrompt(currentPrompt);
      }

      terminalInput.value = "";
    }
  });

  // 自動フォーカス
  terminalInput.focus();

  // クリック時にフォーカス
  document.getElementById("terminal").addEventListener("click", () => {
    if (!terminalInput.disabled) {
      terminalInput.focus();
    }
  });
}
