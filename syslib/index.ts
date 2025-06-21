/**
 * WebVM Multi-Worker System Library Entry Point
 */

import './types.js';
import { loadKernel } from './kernel.js';

/**
 * Boot WebVM with the new multi-worker architecture
 */
export async function boot() {
  try {
    console.log('[WebVM] Starting multi-worker architecture...');
    
    // Initialize the multi-worker kernel
    await loadKernel();
    
    console.log('[WebVM] Multi-worker architecture started successfully.');
    
  } catch (error) {
    console.error('[WebVM] Failed to start:', error);
    throw error;
  }
}
