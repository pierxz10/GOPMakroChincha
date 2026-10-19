export function readConfig() {
  return {
    apiBaseUrl: import.meta.env.VITE_API_BASE_URL || 'http://localhost:9090',
    timeoutMs: Number(import.meta.env.VITE_API_TIMEOUT_MS || 10000),
  };
}
