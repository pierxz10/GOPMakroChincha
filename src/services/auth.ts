import { ApiError, type HttpClient } from './http.ts';

// AuthResponse.java; sin inventar permisos o traducir códigos de rol.
export interface AuthSession {
  token: string;
  refreshToken: string;
  typeToken: string;
  expireTimeToken: string;
  role: string;
  names: string;
  username: string;
  idUser: number;
  permisos: string[];
  cambiarClave: boolean;
}

export function parseSession(value: unknown): AuthSession {
  if (!value || typeof value !== 'object') throw new ApiError('contract', 'Sesión no válida.');
  const data = value as Record<string, unknown>;
  const strings = ['token', 'refreshToken', 'expireTimeToken', 'role', 'names', 'username'];
  if (strings.some(key => typeof data[key] !== 'string' || !data[key]) ||
      data.typeToken !== 'Bearer' || !Number.isInteger(data.idUser) || Number(data.idUser) <= 0 ||
      typeof data.cambiarClave !== 'boolean' || !Array.isArray(data.permisos) ||
      !data.permisos.every(p => typeof p === 'string')) {
    throw new ApiError('contract', 'La API no devolvió una sesión completa.');
  }
  return data as unknown as AuthSession;
}

export function createAuthService(http: HttpClient) {
  return {
    async login(username: string, password: string) {
      return parseSession(await http.request('/api/auth/login', {
        method: 'POST', body: { username: username.trim(), password },
      }));
    },
    async refresh(session: AuthSession) {
      return parseSession(await http.request('/api/auth/refresh', {
        method: 'POST', body: { username: session.username, refreshToken: session.refreshToken },
      }));
    },
    async logout(session: AuthSession) {
      await http.request('/api/auth/logout', {
        method: 'POST', body: { refreshToken: session.refreshToken }, token: session.token,
      });
    },
  };
}

export function loginErrorMessage(error: unknown): string {
  if (error instanceof ApiError) {
    if (error.kind === 'application' || error.status === 401 || error.status === 403) {
      return 'No pudimos iniciar sesión. Revisa tu usuario y contraseña.';
    }
    if (error.kind === 'timeout') return 'El servicio está tardando en responder. Intenta nuevamente.';
    if (error.kind === 'network') return 'No se pudo conectar con el servicio. Intenta nuevamente en unos momentos.';
    if (error.kind === 'contract') return 'El servicio devolvió una respuesta inesperada. Comunica el problema al equipo de soporte.';
    if (error.status === 400) return 'Revisa los datos ingresados e intenta nuevamente.';
  }
  return 'El servicio no está disponible en este momento. Intenta nuevamente más tarde.';
}
