import type { Ref } from 'react';

interface FormFieldProps {
  id: string;
  label: string;
  type: 'text' | 'password';
  autoComplete: string;
  value: string;
  onChange: (value: string) => void;
  error?: string;
  readOnly?: boolean;
  inputRef?: Ref<HTMLInputElement>;
}

export function FormField({ id, label, error, inputRef, onChange, ...input }: FormFieldProps) {
  return (
    <div className="flex flex-col gap-1.5">
      <label htmlFor={id} className="text-sm font-medium leading-[22px]">{label} *</label>
      <input {...input} id={id} name={id} ref={inputRef} required
        aria-invalid={Boolean(error)} aria-describedby={`${id}-error`}
        onChange={event => onChange(event.target.value)} className="form-input" />
      <p id={`${id}-error`} className="text-sm leading-5 text-danger" hidden={!error}>{error}</p>
    </div>
  );
}
