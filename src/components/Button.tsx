import type { ButtonHTMLAttributes } from 'react';

type ButtonProps = ButtonHTMLAttributes<HTMLButtonElement> & {
  variant?: 'primary' | 'secondary';
  icon?: 'arrow-right' | 'key-round';
};

export function Button({ variant = 'primary', icon, children, className = '', type = 'button', ...props }: ButtonProps) {
  return <button {...props} type={type} className={`button ${variant} ${className}`}>
    {icon && <img src={`/assets/${icon}.svg`} alt="" width={18} height={18} className="h-[18px] w-[18px] shrink-0" />}
    <span className="flex-1 text-center">{children}</span>
  </button>;
}
