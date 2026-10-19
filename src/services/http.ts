export type ApiEnvelope<T> = {
  isSuccess: boolean;
  isWarning: boolean;
  message: string;
  errorCode: string;
  data: T;
};

export type ErrorKind = 'network' | 'timeout' | 'http' | 'application' | 'contract';

export class ApiError extends Error {
  readonly kind: ErrorKind;
  readonly status: number;
  constructor(kind: ErrorKind, message: string, status = 0) {
    super(message);
    this.name = 'ApiError';
    this.kind = kind;
    this.status = status;
  }
}

export function createHttpClient(baseUrl: string, timeoutMs = 10000, transport: typeof fetch = fetch) {
  const base = new URL(baseUrl);
  if (!['http:', 'https:'].includes(base.protocol) || base.username || base.password ||
      base.search || base.hash || base.pathname !== '/') {
    throw new Error('La dirección de la API debe ser un origen HTTP(S), sin rutas ni credenciales.');
  }
  if (!Number.isFinite(timeoutMs) || timeoutMs < 500 || timeoutMs > 60000) {
    throw new Error('El tiempo de espera debe estar entre 500 y 60000 ms.');
  }

  return {
    async request<T>(path: string, options: { method?: string; body?: unknown; token?: string } = {}): Promise<T> {
      if (!path.startsWith('/api/') || path.includes('..') || path.includes('?') || path.includes('#')) {
        throw new Error('Ruta de API no válida.');
      }
      const controller = new AbortController();
      const timer = setTimeout(() => controller.abort(), timeoutMs);
      try {
        const headers: Record<string, string> = { Accept: 'application/json' };
        if (options.body !== undefined) headers['Content-Type'] = 'application/json';
        if (options.token) headers.Authorization = `Bearer ${options.token}`;
        const response = await transport(`${base.origin}${path}`, {
          method: options.method ?? 'GET',
          headers,
          body: options.body === undefined ? undefined : JSON.stringify(options.body),
          credentials: 'omit',
          mode: 'cors',
          redirect: 'error',
          signal: controller.signal,
        });
        // No reflejar cuerpos de error del servidor: pueden contener datos internos.
        if (!response.ok) throw new ApiError('http', 'La API rechazó la solicitud.', response.status);
        let envelope: unknown;
        try { envelope = await response.json(); }
        catch {
          if (controller.signal.aborted) throw new ApiError('timeout', 'La API tardó demasiado en responder.');
          throw new ApiError('contract', 'La API devolvió una respuesta no válida.', response.status);
        }
        if (!envelope || typeof envelope !== 'object' || !('isSuccess' in envelope) ||
            typeof envelope.isSuccess !== 'boolean' || !('data' in envelope)) {
          throw new ApiError('contract', 'La respuesta no coincide con el contrato de la API.', response.status);
        }
        // GlobalControllerAdvice usa HTTP 200 también para errores de aplicación.
        if (!envelope.isSuccess) throw new ApiError('application', 'La operación no pudo completarse.', response.status);
        return envelope.data as T;
      } catch (error) {
        if (error instanceof ApiError) throw error;
        if (controller.signal.aborted) throw new ApiError('timeout', 'La API tardó demasiado en responder.');
        throw new ApiError('network', 'No se pudo conectar con el servicio.');
      } finally {
        clearTimeout(timer);
      }
    },
  };
}

export type HttpClient = ReturnType<typeof createHttpClient>;
