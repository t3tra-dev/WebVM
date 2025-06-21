/**
 * Multi-Worker Kernel Manager
 * Coordinates the new Wasm Worker + FS Worker architecture
 */

import { initFileSystem } from './wasi.js';

/**
 * Initialize the multi-worker kernel architecture
 * Replaces the old loadKernel function
 */
export async function loadKernel(): Promise<void> {
  try {
    console.log('[Kernel] Initializing multi-worker architecture...');
    
    // Initialize the multi-worker filesystem
    await initFileSystem();
    
    console.log('[Kernel] Multi-worker architecture ready');
    
  } catch (error) {
    console.error('[Kernel] Failed to initialize:', error);
    throw error;
  }
}

/**
 * Legacy compatibility - no longer needed with worker architecture
 */
export function setupCommandHandler() {
  console.log('[Kernel] setupCommandHandler is deprecated - workers handle commands directly');
}
