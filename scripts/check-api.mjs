import { mkdir, writeFile } from 'node:fs/promises';

const base = new URL(process.env.API_BASE_URL || 'http://localhost:9090');
if (!['http:', 'https:'].includes(base.protocol) || base.username || base.password || base.pathname !== '/' || base.search || base.hash) {
  throw new Error('API_BASE_URL debe contener solo el origen HTTP(S).');
}
const origin = process.env.FRONTEND_ORIGIN || 'http://127.0.0.1:5173';
const results = [];
async function probe(name, path, options = {}) {
  try {
    const response = await fetch(`${base.origin}${path}`, {
      ...options, redirect: 'error', signal: AbortSignal.timeout(10000),
    });
    let body;
    try { body = await response.json(); } catch { body = null; }
    const result = {
      name, status: response.status,
      allowOrigin: response.headers.get('access-control-allow-origin'),
      allowMethods: response.headers.get('access-control-allow-methods'),
      allowHeaders: response.headers.get('access-control-allow-headers'),
      allowCredentials: response.headers.get('access-control-allow-credentials'),
    };
    if (path === '/v3/api-docs') {
      result.openapi = body?.openapi ?? null;
      result.paths = body?.paths ? Object.keys(body.paths) : [];
    } else if (options.method === 'POST') {
      result.isSuccess = typeof body?.isSuccess === 'boolean' ? body.isSuccess : null;
      result.errorCode = body?.errorCode ?? null;
      result.hasToken = typeof body?.data?.token === 'string' && body.data.token.length > 0;
    }
    results.push(result);
    return result;
  } catch (error) {
    results.push({ name, status: null, result: 'bloqueado', reason: error.cause?.code || error.name });
    return null;
  }
}

await probe('OpenAPI real', '/v3/api-docs');
await probe('Preflight login', '/api/auth/login', {
  method: 'OPTIONS', headers: { Origin: origin, 'Access-Control-Request-Method': 'POST', 'Access-Control-Request-Headers': 'content-type' },
});
await probe('Validación de obligatorios', '/api/auth/login', {
  method: 'POST', headers: { Origin: origin, 'Content-Type': 'application/json' }, body: JSON.stringify({ username: '', password: '' }),
});
// Activación explícita: un intento con usuario inexistente genera una auditoría real.
if (process.env.API_TEST_INVALID_LOGIN === '1') {
  await probe('Credenciales inválidas (real)', '/api/auth/login', {
    method: 'POST', headers: { Origin: origin, 'Content-Type': 'application/json' },
    body: JSON.stringify({ username: `qa-no-existe-${crypto.randomUUID()}`, password: crypto.randomUUID() }),
  });
}
const report = {
  checkedAt: new Date().toISOString(), apiOrigin: base.origin, frontendOrigin: origin,
  scope: 'Solicitudes HTTP reales desde Node; no sustituyen una prueba CORS desde navegador.', results,
};
await mkdir('docs/evidencias', { recursive: true });
await writeFile('docs/evidencias/api-local.json', JSON.stringify(report, null, 2) + '\n');
console.log(JSON.stringify(report, null, 2));
if (results.some(r => r.status === null || r.status >= 500)) process.exitCode = 1;
