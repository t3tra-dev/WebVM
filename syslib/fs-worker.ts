/**
 * IndexedDB操作用ファイルシステムワーカー
 * 非同期ファイルシステム操作を処理し、SharedArrayBuffer経由で通信
 */

import {
  FS_OFFSET_REQUEST_ID,
  FS_OFFSET_OP_TYPE,
  FS_OFFSET_STATUS,
  FS_OFFSET_DATA_LENGTH,
  FS_OFFSET_RESULT_CODE,
  FS_OFFSET_DATA_START,
  FS_OP_CREATE_DIRECTORY,
  FS_OP_DIRECTORY_EXISTS,
  FS_OP_LIST_DIRECTORY,
  FS_OP_DELETE_DIRECTORY,
  FS_OP_CREATE_FILE,
  FS_OP_READ_FILE,
  FS_OP_WRITE_FILE,
  FS_OP_DELETE_FILE,
  FS_OP_FILE_EXISTS,
  FS_OP_FILE_STAT,
  FS_STATUS_IDLE,
  FS_STATUS_PENDING,
  FS_STATUS_COMPLETED,
  FS_STATUS_ERROR
} from './shared-constants.js';

// IndexedDBファイルシステム実装
class IndexedDBFileSystem {
  private db: IDBDatabase | null = null;
  private dbName = 'webvm-fs';
  private dbVersion = 1;
  
  async init(): Promise<void> {
    return new Promise((resolve, reject) => {
      const request = indexedDB.open(this.dbName, this.dbVersion);
      
      request.onerror = () => reject(request.error);
      request.onsuccess = () => {
        this.db = request.result;
        resolve();
      };
      
      request.onupgradeneeded = (event: IDBVersionChangeEvent) => {
        const db = (event.target as IDBOpenDBRequest).result;
        
        // ファイル用オブジェクトストア
        if (!db.objectStoreNames.contains('files')) {
          const fileStore = db.createObjectStore('files', { keyPath: 'path' });
          fileStore.createIndex('parentPath', 'parentPath', { unique: false });
        }
        
        // ディレクトリ用オブジェクトストア
        if (!db.objectStoreNames.contains('directories')) {
          const dirStore = db.createObjectStore('directories', { keyPath: 'path' });
          dirStore.createIndex('parentPath', 'parentPath', { unique: false });
        }
      };
    });
  }
  
  async createDirectory(path: string, mode: number = 0o755): Promise<void> {
    if (!this.db) throw new Error('Database not initialized');
    
    
    const transaction = this.db.transaction(['directories'], 'readwrite');
    const store = transaction.objectStore('directories');
    
    const dirRecord = {
      path,
      mtime: Date.now(),
      ctime: Date.now(),
      parentPath: path.substring(0, path.lastIndexOf('/')) || '/',
      mode: mode,
      uid: 0,
      gid: 0
    };
    
    
    return new Promise((resolve, reject) => {
      const request = store.put(dirRecord);
      request.onerror = () => {
        console.error(`[IndexedDBFS] createDirectory: IndexedDB put failed for "${path}":`, request.error);
        reject(request.error);
      };
      request.onsuccess = () => {
        resolve();
      };
    });
  }
  
  async directoryExists(path: string): Promise<boolean> {
    if (!this.db) throw new Error('Database not initialized');
    
    
    const transaction = this.db.transaction(['directories'], 'readonly');
    const store = transaction.objectStore('directories');
    
    return new Promise((resolve, reject) => {
      const request = store.get(path);
      request.onerror = () => {
        console.error(`[IndexedDBFS] directoryExists: IndexedDB get failed for "${path}":`, request.error);
        reject(request.error);
      };
      request.onsuccess = () => {
        const exists = !!request.result;
        if (request.result) {
        }
        resolve(exists);
      };
    });
  }
  
  async listDirectory(path: string): Promise<string[]> {
    if (!this.db) throw new Error('Database not initialized');
    
    const transaction = this.db.transaction(['files', 'directories'], 'readonly');
    const fileStore = transaction.objectStore('files');
    const dirStore = transaction.objectStore('directories');
    
    const results: string[] = [];
    
    return new Promise((resolve, reject) => {
      let completed = 0;
      const complete = () => {
        completed++;
        if (completed === 2) {
          resolve(results);
        }
      };
      
      // ファイルを検索
      const fileIndex = fileStore.index('parentPath');
      const fileRequest = fileIndex.openCursor(path);
      fileRequest.onerror = () => reject(fileRequest.error);
      fileRequest.onsuccess = () => {
        const cursor = fileRequest.result;
        if (cursor) {
          const filePath = cursor.value.path;
          const parentPath = cursor.value.parentPath;
          
          // 親パスが一致するかチェック
          if (parentPath === path) {
            const fileName = filePath.substring(filePath.lastIndexOf('/') + 1);
            if (fileName && !fileName.includes('/')) {
              results.push(fileName);
            }
          }
          cursor.continue();
        } else {
          complete();
        }
      };
      
      // ディレクトリを検索
      const dirIndex = dirStore.index('parentPath');
      const dirRequest = dirIndex.openCursor(path);
      dirRequest.onerror = () => reject(dirRequest.error);
      dirRequest.onsuccess = () => {
        const cursor = dirRequest.result;
        if (cursor) {
          const dirPath = cursor.value.path;
          const parentPath = cursor.value.parentPath;
          
          // 親パスが一致するかチェック
          if (parentPath === path) {
            const dirName = dirPath.substring(dirPath.lastIndexOf('/') + 1);
            if (dirName && !dirName.includes('/')) {
              results.push(dirName + '/');
            }
          }
          cursor.continue();
        } else {
          complete();
        }
      };
    });
  }
  
  async deleteDirectory(path: string): Promise<void> {
    if (!this.db) throw new Error('Database not initialized');
    
    
    // まず存在確認
    const exists = await this.directoryExists(path);
    
    if (!exists) {
      throw new Error(`Directory "${path}" does not exist`);
    }
    
    const transaction = this.db.transaction(['directories'], 'readwrite');
    const store = transaction.objectStore('directories');
    
    return new Promise((resolve, reject) => {
      const request = store.delete(path);
      request.onerror = () => {
        console.error(`[IndexedDBFS] deleteDirectory: IndexedDB delete failed for "${path}":`, request.error);
        reject(request.error);
      };
      request.onsuccess = () => {
        resolve();
      };
    });
  }
  
  async createFile(path: string, mode: number = 0o644): Promise<void> {
    if (!this.db) throw new Error('Database not initialized');
    
    
    const transaction = this.db.transaction(['files'], 'readwrite');
    const store = transaction.objectStore('files');
    
    const parentPath = path.substring(0, path.lastIndexOf('/')) || '/';
    const fileRecord = {
      path,
      data: new Uint8Array(0), // 空ファイル
      size: 0,
      mtime: Date.now(),
      ctime: Date.now(),
      parentPath: parentPath,
      mode: mode,
      uid: 0,
      gid: 0
    };
    
    
    return new Promise((resolve, reject) => {
      const request = store.put(fileRecord);
      request.onerror = () => {
        console.error(`[IndexedDBFS] createFile: IndexedDB put failed for "${path}":`, request.error);
        reject(request.error);
      };
      request.onsuccess = () => {
        resolve();
      };
    });
  }
  
  async readFile(path: string): Promise<Uint8Array> {
    if (!this.db) throw new Error('Database not initialized');
    
    
    const transaction = this.db.transaction(['files'], 'readonly');
    const store = transaction.objectStore('files');
    
    return new Promise((resolve, reject) => {
      const request = store.get(path);
      request.onerror = () => {
        console.error(`[IndexedDBFS] readFile: IndexedDB get failed for "${path}":`, request.error);
        reject(request.error);
      };
      request.onsuccess = () => {
        const result = request.result;
        if (result) {
          resolve(result.data);
        } else {
          console.error(`[IndexedDBFS] readFile: file "${path}" not found`);
          reject(new Error('File not found'));
        }
      };
    });
  }
  
  async writeFile(path: string, data: Uint8Array): Promise<void> {
    if (!this.db) throw new Error('Database not initialized');
    
    
    const transaction = this.db.transaction(['files'], 'readwrite');
    const store = transaction.objectStore('files');
    
    // 既存ファイルの取得
    const getRequest = store.get(path);
    
    return new Promise((resolve, reject) => {
      getRequest.onerror = () => {
        console.error(`[IndexedDBFS] writeFile: failed to get existing file "${path}":`, getRequest.error);
        reject(getRequest.error);
      };
      getRequest.onsuccess = () => {
        const existing = getRequest.result;
        
        const fileRecord = {
          path,
          data: data,
          size: data.length,
          mtime: Date.now(),
          ctime: existing ? existing.ctime : Date.now(),
          parentPath: path.substring(0, path.lastIndexOf('/')) || '/',
          mode: existing ? existing.mode : 0o644,
          uid: 0,
          gid: 0
        };
        
        
        const putRequest = store.put(fileRecord);
        putRequest.onerror = () => {
          console.error(`[IndexedDBFS] writeFile: IndexedDB put failed for "${path}":`, putRequest.error);
          reject(putRequest.error);
        };
        putRequest.onsuccess = () => {
          resolve();
        };
      };
    });
  }
  
  async deleteFile(path: string): Promise<void> {
    if (!this.db) throw new Error('Database not initialized');
    
    
    // まず存在確認
    const exists = await this.fileExists(path);
    
    if (!exists) {
      throw new Error(`File "${path}" does not exist`);
    }
    
    const transaction = this.db.transaction(['files'], 'readwrite');
    const store = transaction.objectStore('files');
    
    return new Promise((resolve, reject) => {
      const request = store.delete(path);
      request.onerror = () => {
        console.error(`[IndexedDBFS] deleteFile: IndexedDB delete failed for "${path}":`, request.error);
        reject(request.error);
      };
      request.onsuccess = () => {
        resolve();
      };
    });
  }
  
  async fileExists(path: string): Promise<boolean> {
    if (!this.db) throw new Error('Database not initialized');
    
    
    const transaction = this.db.transaction(['files'], 'readonly');
    const store = transaction.objectStore('files');
    
    return new Promise((resolve, reject) => {
      const request = store.get(path);
      request.onerror = () => {
        console.error(`[IndexedDBFS] fileExists: IndexedDB get failed for "${path}":`, request.error);
        reject(request.error);
      };
      request.onsuccess = () => {
        const exists = !!request.result;
        if (request.result) {
        }
        resolve(exists);
      };
    });
  }
  
  async getFileStat(path: string): Promise<any> {
    if (!this.db) throw new Error('Database not initialized');
    
    
    const transaction = this.db.transaction(['files'], 'readonly');
    const store = transaction.objectStore('files');
    
    return new Promise((resolve, reject) => {
      const request = store.get(path);
      request.onerror = () => {
        console.error(`[IndexedDBFS] getFileStat: IndexedDB get failed for "${path}":`, request.error);
        reject(request.error);
      };
      request.onsuccess = () => {
        const result = request.result;
        if (result) {
          const stat = {
            ino: result.ino || 1,
            size: result.size,
            mode: result.mode,
            mtime: result.mtime,
            ctime: result.ctime,
            uid: result.uid,
            gid: result.gid
          };
          resolve(stat);
        } else {
          console.error(`[IndexedDBFS] getFileStat: file "${path}" not found`);
          reject(new Error('File not found'));
        }
      };
    });
  }
}

// Worker globals
let fs: IndexedDBFileSystem;
let sharedBuffer: SharedArrayBuffer;
let sharedArray: Int32Array;

// Initialize worker
self.onmessage = async (event) => {
  const { type, data } = event.data;
  
  if (type === 'init') {
    sharedBuffer = data.sharedBuffer;
    sharedArray = new Int32Array(sharedBuffer);
    
    fs = new IndexedDBFileSystem();
    await fs.init();
    
    // 基本ディレクトリ構造を作成
    const basicDirs = [
      '/bin', '/dev', '/etc', '/home', '/proc', '/tmp', '/usr', '/var',
      '/home/user', '/usr/bin', '/usr/lib', '/usr/local', '/usr/share'
    ];
    
    try {
      for (const dir of basicDirs) {
        const exists = await fs.directoryExists(dir);
        if (!exists) {
          await fs.createDirectory(dir);
        }
      }
    } catch (e) {
      console.warn('[FS Worker] Failed to create some directories:', e);
    }
    
    self.postMessage({ type: 'ready' });
    
    // Start processing requests
    processRequests();
  }
};

function readStringFromSharedBuffer(): string {
  const length = Atomics.load(sharedArray, FS_OFFSET_DATA_LENGTH);
  const dataArray = new Uint8Array(sharedBuffer, FS_OFFSET_DATA_START * 4, length);
  // Copy to regular ArrayBuffer since TextDecoder doesn't support SharedArrayBuffer
  const copiedArray = new Uint8Array(length);
  copiedArray.set(dataArray);
  return new TextDecoder().decode(copiedArray);
}

function writeStringToSharedBuffer(data: string): void {
  const bytes = new TextEncoder().encode(data);
  const dataArray = new Uint8Array(sharedBuffer, FS_OFFSET_DATA_START * 4, bytes.length);
  dataArray.set(bytes);
  Atomics.store(sharedArray, FS_OFFSET_DATA_LENGTH, bytes.length);
}

// Request processing loop
async function processRequests() {
  while (true) {
    // Wait for a new request
    const status = Atomics.load(sharedArray, FS_OFFSET_STATUS);
    if (status === FS_STATUS_PENDING) {
      try {
        await processRequest();
      } catch (error) {
        console.error('[FS Worker] Request processing failed:', error);
        Atomics.store(sharedArray, FS_OFFSET_STATUS, FS_STATUS_ERROR);
        Atomics.store(sharedArray, FS_OFFSET_RESULT_CODE, -1);
        Atomics.notify(sharedArray, FS_OFFSET_STATUS);
      }
    }
    
    // Short sleep to avoid busy waiting
    await new Promise(resolve => setTimeout(resolve, 1));
  }
}

// Process individual request
async function processRequest() {
  const opType = Atomics.load(sharedArray, FS_OFFSET_OP_TYPE);
  const textData = readStringFromSharedBuffer();
  
  let result = 0;
  let responseData = '';
  
  switch (opType) {
    case FS_OP_CREATE_DIRECTORY: {
      const { path, mode } = JSON.parse(textData);
      await fs.createDirectory(path, mode);
      break;
    }
    
    case FS_OP_DIRECTORY_EXISTS: {
      const path = textData;
      try {
        const exists = await fs.directoryExists(path);
        result = exists ? 1 : 0;
      } catch (error) {
        console.error(`[FS Worker] Directory exists check failed for "${path}":`, error);
        result = 0;
      }
      break;
    }
    
    case FS_OP_LIST_DIRECTORY: {
      const path = textData;
      const entries = await fs.listDirectory(path);
      responseData = JSON.stringify(entries);
      break;
    }
    
    case FS_OP_DELETE_DIRECTORY: {
      const path = textData;
      try {
        await fs.deleteDirectory(path);
      } catch (error) {
        console.error(`[FS Worker] Failed to delete directory ${path}:`, error);
        result = -1;
      }
      break;
    }
    
    case FS_OP_CREATE_FILE: {
      const { path, mode } = JSON.parse(textData);
      await fs.createFile(path, mode);
      break;
    }
    
    case FS_OP_READ_FILE: {
      const path = textData;
      const data = await fs.readFile(path);
      // バイナリデータをBase64でエンコード
      const base64Data = btoa(String.fromCharCode(...data));
      responseData = base64Data;
      break;
    }
    
    case FS_OP_WRITE_FILE: {
      const { path, data } = JSON.parse(textData);
      
      try {
        // Base64デコードしてバイナリデータに変換
        const binaryData = Uint8Array.from(atob(data), c => c.charCodeAt(0));
        
        await fs.writeFile(path, binaryData);
      } catch (error) {
        console.error(`[FS Worker] OP_WRITE_FILE: failed to write file ${path}:`, error);
        result = -1;
      }
      break;
    }
    
    case FS_OP_DELETE_FILE: {
      const path = textData;
      try {
        await fs.deleteFile(path);
      } catch (error) {
        console.error(`[FS Worker] Failed to delete file ${path}:`, error);
        result = -1;
      }
      break;
    }
    
    case FS_OP_FILE_EXISTS: {
      const path = textData;
      try {
        const exists = await fs.fileExists(path);
        result = exists ? 1 : 0;
      } catch (error) {
        console.error(`[FS Worker] File exists check failed for "${path}":`, error);
        result = 0;
      }
      break;
    }
    
    case FS_OP_FILE_STAT: {
      const path = textData;
      
      try {
        const stat = await fs.getFileStat(path);
        responseData = JSON.stringify(stat);
      } catch (error) {
        console.error(`[FS Worker] OP_FILE_STAT: failed to get stat for "${path}":`, error);
        result = -1;
      }
      break;
    }
    
    default:
      throw new Error(`Unknown operation type: ${opType}`);
  }
  
  // Write response data if any
  if (responseData) {
    writeStringToSharedBuffer(responseData);
  }
  
  // Mark as completed and notify
  Atomics.store(sharedArray, FS_OFFSET_RESULT_CODE, result);
  Atomics.store(sharedArray, FS_OFFSET_STATUS, FS_STATUS_COMPLETED);
  Atomics.notify(sharedArray, FS_OFFSET_STATUS);
}

