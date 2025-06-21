import { defineConfig } from 'vite';
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));

export default defineConfig({
  root: './gui', 
  publicDir: false,
  plugins: [
    {
      name: 'serve-wasm',
      configureServer(server) {
        server.middlewares.use((req, res, next) => {
          if (req.url === '/kernel.wasm') {
            try {
              const wasmPath = path.resolve(__dirname, 'build/kernel.wasm');
              const wasmBuffer = fs.readFileSync(wasmPath);
              res.setHeader('Content-Type', 'application/wasm');
              res.setHeader('Cache-Control', 'no-cache');
              res.end(wasmBuffer);
            } catch (error) {
              res.statusCode = 404;
              res.end('kernel.wasm not found');
            }
          } else {
            next();
          }
        });
      }
    }
  ],
  server: {
    https: {
      key: fs.readFileSync(path.resolve(__dirname, 'certs/key.pem')),
      cert: fs.readFileSync(path.resolve(__dirname, 'certs/cert.pem')),
    },
    headers: {
      // SharedArrayBuffer用のヘッダー
      'Cross-Origin-Embedder-Policy': 'require-corp',
      'Cross-Origin-Opener-Policy': 'same-origin',
    },
    port: 8080,
    host: '127.0.0.1',
    fs: {
      allow: ['..', '../build', '../syslib']
    },
  },
  resolve: {
    alias: {
      '@': path.resolve(__dirname, './'),
      '@build': path.resolve(__dirname, './build'),
      '@gui': path.resolve(__dirname, './gui'),
      '@syslib': path.resolve(__dirname, './syslib')
    }
  },
  build: {
    target: 'esnext',
    outDir: 'dist',
    rollupOptions: {
      external: [],
    },
  },
  worker: {
    format: 'es',
  },
  optimizeDeps: {
    exclude: ['fs-worker.ts', 'wasm-worker.ts'],
  },
  assetsInclude: ['**/*.wasm'],
});