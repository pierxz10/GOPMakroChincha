import { useCallback, useEffect, useRef, useState } from 'react';
import { BrandHeader } from './components/BrandHeader';
import { LoginPage } from './pages/LoginPage';
import { SessionPage } from './pages/SessionPage';
import { readConfig } from './config';
import { ApiError, createHttpClient } from './services/http';
import { createAuthService, type AuthSession } from './services/auth';
import { tokenExpiry } from './services/session';

function configureAuth() {
  try {
    const config = readConfig();
    return createAuthService(createHttpClient(config.apiBaseUrl, config.timeoutMs));
  } catch { return null; }
}
const auth = configureAuth();

export function App() {
  return <><BrandHeader /><main id="app" className="px-5 py-8">
    {auth ? <AccessFlow auth={auth} /> : <p className="access-card notice error" role="alert">
      La configuración del servicio no es válida. Contacta al responsable de la aplicación.
    </p>}
  </main></>;
}

function AccessFlow({ auth }: { auth: ReturnType<typeof createAuthService> }) {
  const [session, setSession] = useState<AuthSession | null>(null);
  const [notice, setNotice] = useState('');
  const active = useRef<AuthSession | null>(null);

  const endSession = useCallback((message: string) => {
    active.current = null;
    setSession(null);
    setNotice(message);
  }, []);

  const acceptSession = useCallback((value: AuthSession) => {
    const expiry = tokenExpiry(value.token);
    if (!expiry || expiry <= Date.now()) throw new ApiError('contract', 'La API devolvió una sesión no válida.');
    active.current = value;
    setNotice('');
    setSession(value);
  }, []);

  useEffect(() => {
    const expected = session ? (session.cambiarClave ? '#/cambio-requerido' : '#/sesion') : '#/acceso';
    const guard = () => { if (location.hash !== expected) location.hash = expected; };
    guard();
    document.title = `${session ? 'Sesión' : 'Inicio de sesión'} | Makro Chincha`;
    window.addEventListener('hashchange', guard);
    return () => window.removeEventListener('hashchange', guard);
  }, [session]);

  useEffect(() => {
    const resetRestoredPage = (event: PageTransitionEvent) => {
      if (event.persisted) endSession('Inicia sesión nuevamente.');
    };
    window.addEventListener('pageshow', resetRestoredPage);
    return () => window.removeEventListener('pageshow', resetRestoredPage);
  }, [endSession]);

  useEffect(() => {
    if (!session) return;
    const expiry = tokenExpiry(session.token)!;
    // La fecha local expireTimeToken no trae zona; se usa exp solo para programar.
    const timer = setTimeout(async () => {
      if (active.current !== session) return;
      try {
        const renewed = await auth.refresh(session);
        if (active.current === session) acceptSession(renewed);
      } catch {
        if (active.current === session) endSession('La sesión terminó. Inicia sesión nuevamente.');
      }
    }, Math.max(1000, Math.min(expiry - Date.now() - Math.min(30000, (expiry - Date.now()) / 2), 2147483647)));
    return () => clearTimeout(timer);
  }, [session, auth, acceptSession, endSession]);

  if (!session) return <LoginPage login={auth.login} onSuccess={acceptSession} notice={notice} />;
  return <SessionPage session={session} onLogout={async () => {
    // Una renovación pendiente nunca puede restaurar una sesión que ya se cerró.
    active.current = null;
    try {
      await auth.logout(session);
      endSession('Sesión cerrada.');
    } catch {
      endSession('Saliste de esta pestaña. El servicio no pudo confirmar el cierre remoto.');
    }
  }} />;
}
