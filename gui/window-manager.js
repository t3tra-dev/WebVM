/**
 * ウィンドウマネージャー
 */

// ドラッグ状態
let isDragging = false;
let currentWindow = null;
let startX = 0;
let startY = 0;
let windowX = 0;
let windowY = 0;

/**
 * ウィンドウマネージャーを初期化
 */
export function initializeWindowManager() {
  // ウィンドウドラッグ機能
  setupWindowDragging();

  // ウィンドウコントロール
  setupWindowControls();
}

/**
 * ウィンドウドラッグ機能を設定
 */
function setupWindowDragging() {
  document.querySelectorAll(".window-header").forEach((header) => {
    header.addEventListener("mousedown", (e) => {
      if (e.target.classList.contains("window-control")) return;

      isDragging = true;
      currentWindow = header.parentElement;
      startX = e.clientX;
      startY = e.clientY;
      const rect = currentWindow.getBoundingClientRect();
      windowX = rect.left;
      windowY = rect.top;

      // 最前面に移動
      bringToFront(currentWindow);

      e.preventDefault();
    });
  });

  document.addEventListener("mousemove", (e) => {
    if (!isDragging) return;

    const deltaX = e.clientX - startX;
    const deltaY = e.clientY - startY;

    currentWindow.style.left = windowX + deltaX + "px";
    currentWindow.style.top = windowY + deltaY + "px";
  });

  document.addEventListener("mouseup", () => {
    isDragging = false;
    currentWindow = null;
  });
}

/**
 * ウィンドウコントロールを設定
 */
function setupWindowControls() {
  // 閉じるボタン
  document.querySelectorAll(".close").forEach((btn) => {
    btn.addEventListener("click", () => {
      btn.closest(".window").style.display = "none";
    });
  });

  // 最小化ボタン
  document.querySelectorAll(".minimize").forEach((btn) => {
    btn.addEventListener("click", () => {
      // TODO: 最小化実装
      console.log("Minimize not implemented yet");
    });
  });

  // 最大化ボタン
  document.querySelectorAll(".maximize").forEach((btn) => {
    btn.addEventListener("click", () => {
      const window = btn.closest(".window");
      toggleMaximize(window);
    });
  });
}

/**
 * ウィンドウを最前面に移動
 */
function bringToFront(window) {
  const windows = document.querySelectorAll(".window");
  let maxZ = 0;

  windows.forEach((w) => {
    const z = parseInt(w.style.zIndex || "0");
    if (z > maxZ) maxZ = z;
  });

  window.style.zIndex = maxZ + 1;
}

/**
 * ウィンドウの最大化をトグル
 */
function toggleMaximize(window) {
  if (window.dataset.maximized === "true") {
    // 元のサイズに戻す
    window.style.width = window.dataset.originalWidth;
    window.style.height = window.dataset.originalHeight;
    window.style.left = window.dataset.originalLeft;
    window.style.top = window.dataset.originalTop;
    window.dataset.maximized = "false";
  } else {
    // 現在のサイズを保存
    window.dataset.originalWidth = window.style.width;
    window.dataset.originalHeight = window.style.height;
    window.dataset.originalLeft = window.style.left;
    window.dataset.originalTop = window.style.top;

    // 最大化
    window.style.width = "100vw";
    window.style.height = "100vh";
    window.style.left = "0";
    window.style.top = "0";
    window.dataset.maximized = "true";
  }
}
