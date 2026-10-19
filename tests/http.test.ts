import { test } from 'node:test';
import assert from 'node:assert/strict';
import { createHttpClient, ApiError } from '../src/services/http.ts';
import { createAuthService, loginErrorMessage, parseSession } from '../src/services/auth.ts';
import { tokenExpiry } from '../src/services/session.ts';

// Dobles de transporte SOLO en pruebas unitarias. La aplicación usa fetch real.
const fixture = {
  token: 'unit-test-only', refreshToken: 'unit-test-only', typeToken: 'Bearer',
  expireTimeToken: '2026-10-18T20:00:00', role: 'ASISTENTE', names: '<b>Prueba</b>',
  username: 'prueba', idUser: 1, permisos: [], cambiarClave: false,
};
const response = (data: unknown, isSuccess = true) => new Response(JSON.stringify({ isSuccess, data }), {
  headers: { 'Content-Type': 'application/json' },
});

test('login envía ruta y campos reales, sin cookies y sin modificar la contraseña', async () => {
  const http = createHttpClient('http://localhost:9090', 1000, async (url, options) => {
    assert.equal(url, 'http://localhost:9090/api/auth/login');
    assert.equal(options?.method, 'POST');
    assert.equal(options?.credentials, 'omit');
    assert.deepEqual(JSON.parse(String(options?.body)), { username: 'prueba', password: ' clave ' });
    return response(fixture);
  });
  assert.equal((await createAuthService(http).login(' prueba ', ' clave ')).idUser, 1);
});

test('HTTP 200 con isSuccess false se rechaza y no revela el mensaje del servidor', async () => {
  const http = createHttpClient('http://localhost:9090', 1000, async () => response(null, false));
  await assert.rejects(http.request('/api/auth/login'), (error: unknown) => {
    assert.ok(error instanceof ApiError);
    assert.equal(error.kind, 'application');
    assert.match(loginErrorMessage(error), /Revisa tu usuario y contraseña/);
    return true;
  });
});

test('rechaza una página HTML o un JSON ajeno al contrato', async () => {
  for (const result of [new Response('<html>Error</html>'), response(null).clone()]) {
    const transport: typeof fetch = async () => result;
    const http = createHttpClient('http://localhost:9090', 1000, transport);
    if ((await result.clone().text()).startsWith('<')) {
      await assert.rejects(http.request('/api/auth/login'), (e: unknown) => e instanceof ApiError && e.kind === 'contract');
    }
  }
  const http = createHttpClient('http://localhost:9090', 1000, async () => new Response('{}'));
  await assert.rejects(http.request('/api/auth/login'), (e: unknown) => e instanceof ApiError && e.kind === 'contract');
});

test('distingue red, tiempo agotado y rechazo HTTP', async () => {
  const offline = createHttpClient('http://localhost:9090', 500, async () => { throw new TypeError('fetch failed'); });
  await assert.rejects(offline.request('/api/auth/login'), (e: unknown) => e instanceof ApiError && e.kind === 'network');
  const slow = createHttpClient('http://localhost:9090', 500, async (_url, options) => new Promise((_resolve, reject) => {
    options?.signal?.addEventListener('abort', () => reject(new DOMException('Aborted', 'AbortError')));
  }));
  await assert.rejects(slow.request('/api/auth/login'), (e: unknown) => e instanceof ApiError && e.kind === 'timeout');
  const unavailable = createHttpClient('http://localhost:9090', 500, async () => new Response('', { status: 503 }));
  await assert.rejects(unavailable.request('/api/auth/login'), (e: unknown) => e instanceof ApiError && e.status === 503);
});

test('refresh y logout usan el contrato real y el Bearer solo en la cabecera', async () => {
  const calls: { url: string; options?: RequestInit }[] = [];
  const auth = createAuthService(createHttpClient('http://localhost:9090', 1000, async (url, options) => {
    calls.push({ url: String(url), options });
    return response(String(url).endsWith('/refresh') ? fixture : null);
  }));
  await auth.refresh(fixture);
  await auth.logout(fixture);
  assert.equal(calls[0].url, 'http://localhost:9090/api/auth/refresh');
  assert.deepEqual(JSON.parse(String(calls[0].options?.body)), { username: 'prueba', refreshToken: 'unit-test-only' });
  assert.equal(calls[1].url, 'http://localhost:9090/api/auth/logout');
  assert.deepEqual(calls[1].options?.headers, { Accept: 'application/json', 'Content-Type': 'application/json', Authorization: 'Bearer unit-test-only' });
});

test('rechaza sesiones incompletas y conserva la restricción cambiarClave', () => {
  assert.throws(() => parseSession({ token: 'x' }), ApiError);
  assert.equal(parseSession({ ...fixture, cambiarClave: true }).cambiarClave, true);
});

test('usa exp del JWT y rechaza expiraciones ausentes o no numéricas', () => {
  const token = (payload: object) => `header.${Buffer.from(JSON.stringify(payload)).toString('base64url')}.signature`;
  assert.equal(tokenExpiry(token({ exp: 1802900000 })), 1802900000000);
  assert.equal(tokenExpiry(token({ exp: '2026-10-18T20:00:00' })), null);
  assert.equal(tokenExpiry('invalid'), null);
});

test('rechaza URL con secretos, ruta /api duplicada y timeout incorrecto', () => {
  for (const url of ['http://user:secret@localhost:9090', 'http://localhost:9090/api', 'file:///tmp/a']) {
    assert.throws(() => createHttpClient(url));
  }
  assert.throws(() => createHttpClient('http://localhost:9090', NaN));
});
