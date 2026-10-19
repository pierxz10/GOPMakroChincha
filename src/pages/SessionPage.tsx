import { useEffect, useRef, useState } from 'react';
import type { AuthSession } from '../services/auth';
import { Button } from '../components/Button';

export function SessionPage({ session, onLogout }: { session: AuthSession; onLogout: () => Promise<void> }) {
  const heading = useRef<HTMLHeadingElement>(null);
  const dialog = useRef<HTMLDialogElement>(null);
  const [pending, setPending] = useState(false);
  useEffect(() => { heading.current?.focus(); }, []);
  return <>
    <section className="access-card" aria-labelledby="page-title">
      <h1 id="page-title" ref={heading} tabIndex={-1}>Sesión iniciada</h1>
      <p role="status">Bienvenido, {session.names}.</p>
      <p>Rol: {session.role}</p>
      {session.cambiarClave && <p className="notice">Tu cuenta requiere un cambio de contraseña antes de continuar.</p>}
      <Button variant="secondary" onClick={() => dialog.current?.showModal()}>Cerrar sesión</Button>
    </section>
    <dialog ref={dialog} aria-labelledby="logout-title" aria-describedby="logout-description"
      onCancel={event => { if (pending) event.preventDefault(); }}>
      <div className="flex flex-col gap-5">
        <h2 id="logout-title">¿Cerrar sesión?</h2>
        <p id="logout-description">Tu sesión finalizará. Para volver a entrar necesitarás iniciar sesión nuevamente.</p>
        <Button disabled={pending} onClick={async () => {
          if (pending) return;
          setPending(true);
          await onLogout();
        }}>{pending ? 'Cerrando…' : 'Cerrar sesión'}</Button>
        <Button variant="secondary" disabled={pending} onClick={() => dialog.current?.close()}>Cancelar</Button>
      </div>
    </dialog>
  </>;
}
