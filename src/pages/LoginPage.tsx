import { useEffect, useRef, useState, type FormEvent } from 'react';
import { FormField } from '../components/FormField';
import { Button } from '../components/Button';
import { loginErrorMessage, type AuthSession } from '../services/auth';

interface LoginPageProps {
  login: (username: string, password: string) => Promise<AuthSession>;
  onSuccess: (session: AuthSession) => void;
  notice: string;
}

export function LoginPage({ login, onSuccess, notice }: LoginPageProps) {
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');
  const [errors, setErrors] = useState<{ username?: string; password?: string }>({});
  const [error, setError] = useState('');
  const [pending, setPending] = useState(false);
  const submitting = useRef(false);
  const userInput = useRef<HTMLInputElement>(null);
  const passwordInput = useRef<HTMLInputElement>(null);
  const errorRef = useRef<HTMLParagraphElement>(null);
  useEffect(() => { if (error) errorRef.current?.focus(); }, [error]);

  async function submit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    if (submitting.current) return;
    setError('');
    const nextErrors = {
      username: username.trim() ? undefined : 'Ingresa tu usuario.',
      password: password ? undefined : 'Ingresa tu contraseña.',
    };
    setErrors(nextErrors);
    if (nextErrors.username || nextErrors.password) {
      (nextErrors.username ? userInput : passwordInput).current?.focus();
      return;
    }
    submitting.current = true;
    setPending(true);
    try { onSuccess(await login(username, password)); }
    catch (reason) { setError(loginErrorMessage(reason)); }
    finally {
      submitting.current = false;
      setPending(false);
      setPassword('');
    }
  }

  return <section className="access-card" aria-labelledby="page-title">
    <h1 id="page-title">Inicio de sesión</h1>
    {notice && <p className="notice" role="status">{notice}</p>}
    <form onSubmit={submit} noValidate aria-busy={pending} className="flex flex-col gap-5">
      <FormField id="username" label="Usuario" type="text" autoComplete="username" value={username}
        inputRef={userInput} readOnly={pending} error={errors.username} onChange={value => {
          setUsername(value); setErrors(current => ({ ...current, username: undefined })); setError('');
        }} />
      <FormField id="password" label="Contraseña" type="password" autoComplete="current-password" value={password}
        inputRef={passwordInput} readOnly={pending} error={errors.password} onChange={value => {
          setPassword(value); setErrors(current => ({ ...current, password: undefined })); setError('');
        }} />
      <p ref={errorRef} className="notice error" role="alert" tabIndex={-1} hidden={!error}>{error}</p>
      <Button type="submit" icon="arrow-right" disabled={pending}>{pending ? 'Ingresando…' : 'Ingresar'}</Button>
    </form>
    <Button variant="secondary" icon="key-round" onClick={() => window.alert('En proceso')}>
      Recuperar acceso
    </Button>
  </section>;
}
