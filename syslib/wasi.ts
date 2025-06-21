/**
 * WebAssembly メインスレッドマネージャー
 * Wasm WorkerとFS Workerの通信を調整
 */

// SharedArrayBufferのバッファサイズ (64KB + ヘッダー)
const SHARED_BUFFER_SIZE = 64 * 1024 + 20; // ヘッダー用に20ワード

// グローバルワーカーと通信
let wasmWorker: Worker | null = null;
let fsWorker: Worker | null = null;
let fsSharedBuffer: SharedArrayBuffer | null = null;
let initialized = false;

// ターミナル出力用メッセージバッファリング
let messageBuffer: string[] = [];
let terminalReady = false;

/**
 * マルチワーカーアーキテクチャを初期化
 */
export async function initFileSystem(): Promise<void> {
  if (initialized) return;
  
  try {
    // SharedArrayBufferが利用可能かチェック
    if (typeof SharedArrayBuffer === 'undefined') {
      throw new Error(
        'SharedArrayBuffer is not available. To enable SharedArrayBuffer:\n' +
        '1. Generate HTTPS certificates: pnpm run generate-certs\n' +
        '2. Start HTTPS server: pnpm run serve\n' +
        '3. Access https://127.0.0.1:8080 (accept security warning)\n' +
        '4. Ensure these headers are set:\n' +
        '   - Cross-Origin-Embedder-Policy: require-corp\n' +
        '   - Cross-Origin-Opener-Policy: same-origin'
      );
    }
    
    // FS通信用SharedArrayBuffer作成
    fsSharedBuffer = new SharedArrayBuffer(SHARED_BUFFER_SIZE);
    
    // FS Worker作成・初期化
    fsWorker = new Worker(new URL('./fs-worker.js', import.meta.url), { type: 'module' });
    await initializeWorker(fsWorker, 'FS Worker', { sharedBuffer: fsSharedBuffer });
    
    // kernel.wasmロード (GitHub Pages 対応)
    const basePath = (typeof window !== 'undefined' && window.location.pathname.includes('/WebVM/')) ? '/WebVM' : '';
    const wasmResponse = await fetch(`${basePath}/kernel.wasm`);
    const wasmBytes = new Uint8Array(await wasmResponse.arrayBuffer());
    
    // Wasm Worker作成・初期化
    wasmWorker = new Worker(new URL('./wasm-worker.js', import.meta.url), { type: 'module' });
    
    // ワーカー初期化前にターミナル通信設定
    setupTerminalCommunication();
    
    await initializeWorker(wasmWorker, 'Wasm Worker', { 
      wasmBytes, 
      fsSharedBuffer 
    });
    
    initialized = true;
    console.log('[Main] Multi-worker architecture initialized');
    
  } catch (error) {
    console.error('[Main] Initialization failed:', error);
    throw error;
  }
}

function initializeWorker(worker: Worker, name: string, data: any): Promise<void> {
  return new Promise((resolve, reject) => {
    const timeout = setTimeout(() => {
      reject(new Error(`${name} initialization timeout`));
    }, 10000);
    
    worker.onmessage = (event) => {
      const { type } = event.data;
      
      if (type === 'ready') {
        clearTimeout(timeout);
        // Wasm Worker用恒久的メッセージハンドラー設定
        if (name === 'Wasm Worker') {
          setupWasmWorkerMessageHandler(worker);
        }
        resolve();
      } else if (type === 'error') {
        clearTimeout(timeout);
        reject(new Error(`${name} error: ${event.data.error}`));
      } else if (name === 'Wasm Worker' && type === 'output') {
        // 初期化中の出力メッセージ処理
        handleWasmOutput(event.data.text);
      }
    };
    
    worker.onerror = (error) => {
      clearTimeout(timeout);
      reject(error);
    };
    
    worker.postMessage({ type: 'init', data });
  });
}

function handleWasmOutput(text: string) {
  if (globalThis.terminalWrite && terminalReady) {
    globalThis.terminalWrite(text);
  } else {
    messageBuffer.push(text);
  }
}

function setupWasmWorkerMessageHandler(worker: Worker) {
  worker.onmessage = (event) => {
    const { type, text, code } = event.data;
    
    switch (type) {
      case 'output':
        handleWasmOutput(text);
        break;
      case 'exit':
        console.log(`[Main] WASM process exited with code: ${code}`);
        break;
      default:
        // Handle other message types as needed
        break;
    }
  };
}

function setupTerminalCommunication() {
  // ターミナル統合用グローバル関数設定
  globalThis.handleCommand = (command: string) => {
    if (wasmWorker) {
      wasmWorker.postMessage({ type: 'command', data: { command } });
    }
  };
  
  // 入力処理設定
  (globalThis as any).sendInput = (input: string) => {
    if (wasmWorker) {
      wasmWorker.postMessage({ type: 'input', data: { input } });
    }
  };
  
  // ターミナル準備完了時にバッファされたメッセージをフラッシュする関数設定
  (globalThis as any).setTerminalReady = () => {
    terminalReady = true;
    
    if (globalThis.terminalWrite) {
      for (const message of messageBuffer) {
        globalThis.terminalWrite(message);
      }
      messageBuffer = [];
    }
  };
}

// 後方互換性用ユーティリティ関数エクスポート
export function createWasiImports() {
  throw new Error('createWasiImports is deprecated. Use the new multi-worker architecture.');
}
