import { test, expect } from '@playwright/test';

for (const [width, height] of [[360, 800], [768, 1024], [1440, 1000]]) {
  test(`FP-01 responsive ${width}: assets, geometría, obligatorios y navegación`, async ({ page }) => {
    await page.setViewportSize({ width, height });
    await page.goto('/');
    await expect(page.getByRole('heading', { name: 'Inicio de sesión' })).toBeVisible();
    await page.waitForURL('**/#/acceso');
    await page.evaluate(() => document.fonts.ready);
    await expect(page.locator('.access-card')).toHaveCSS('max-width', '480px');
    const geometry = await page.evaluate(() => ({
      viewport: innerWidth, scroll: document.documentElement.scrollWidth,
      images: [...document.images].map(img => ({ src: new URL(img.src).pathname, loaded: img.complete && img.naturalWidth > 0, width: img.width, height: img.height })),
      card: document.querySelector('.access-card')!.getBoundingClientRect().toJSON(),
    }));
    expect(geometry.scroll).toBeLessThanOrEqual(width);
    expect(geometry.images.every(img => img.loaded)).toBe(true);
    expect(geometry.images.map(img => [img.width, img.height])).toEqual([[108, 26], [18, 18], [18, 18]]);
    expect(geometry.card.width).toBe(width === 360 ? 320 : 480);
    expect(geometry.card.y).toBe(98);
    await page.screenshot({ path: `docs/evidencias/login-${width}.png`, fullPage: true });
    await test.info().attach('geometría', { body: JSON.stringify(geometry), contentType: 'application/json' });
    let apiRequests = 0;
    page.on('request', request => { if (request.url().includes('/api/')) apiRequests++; });
    await page.getByRole('button', { name: 'Ingresar', exact: true }).click();
    await expect(page.getByText('Ingresa tu usuario.', { exact: true })).toBeVisible();
    await expect(page.getByText('Ingresa tu contraseña.', { exact: true })).toBeVisible();
    await expect(page.getByLabel('Usuario *')).toBeFocused();
    expect(apiRequests).toBe(0);
    await page.goto('/#/sesion');
    await expect(page).toHaveURL(/#\/acceso$/);
    await expect(page.getByRole('heading', { name: 'Inicio de sesión' })).toBeVisible();
  });
}

test('intento real desde navegador: error de conexión; sin interceptar ni simular API', async ({ page }) => {
  await page.goto('/');
  await page.getByLabel('Usuario *').fill('qa-conexion-no-existe');
  await page.getByLabel('Contraseña *').fill('qa-sin-cuenta');
  const requestPromise = page.waitForRequest(request => request.url().endsWith('/api/auth/login'));
  await page.getByRole('button', { name: 'Ingresar', exact: true }).click();
  const request = await requestPromise;
  expect(request.method()).toBe('POST');
  expect(request.postDataJSON()).toEqual({ username: 'qa-conexion-no-existe', password: 'qa-sin-cuenta' });
  await expect(page.getByRole('alert')).toContainText('No se pudo conectar con el servicio', { timeout: 15000 });
  await expect(page.getByRole('button', { name: 'Ingresar', exact: true })).toBeEnabled();
  await expect(page.getByLabel('Contraseña *')).toHaveValue('');
  expect(await page.evaluate(() => [localStorage.length, sessionStorage.length])).toEqual([0, 0]);
  await page.screenshot({ path: 'docs/evidencias/login-error-conexion.png', fullPage: true });
});
