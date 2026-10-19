import { defineConfig } from '@playwright/test';

export default defineConfig({
  testDir: './tests/browser',
  workers: 1,
  reporter: [['list'], ['json', { outputFile: 'docs/evidencias/browser-results.json' }]],
  use: { baseURL: 'http://127.0.0.1:5173', channel: 'msedge', trace: 'off', screenshot: 'off' },
  // Iniciar npm run dev en otra terminal. El runner no administra procesos ajenos.
});
