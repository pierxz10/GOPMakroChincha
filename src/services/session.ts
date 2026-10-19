// exp solo programa la renovación; la validez criptográfica la comprueba la API.
export function tokenExpiry(token: string): number | null {
  try {
    const part = token.split('.')[1];
    const claims = JSON.parse(atob(part.replace(/-/g, '+').replace(/_/g, '/')));
    return typeof claims.exp === 'number' && Number.isFinite(claims.exp) ? claims.exp * 1000 : null;
  } catch { return null; }
}
