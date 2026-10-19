export function BrandHeader() {
  return (
    <header className="flex items-start gap-5 bg-brand p-5 text-sm font-medium leading-5 text-white">
      <img src="/assets/makro-logo.png" className="h-[26px] w-[108px] shrink-0 object-contain" alt="Makro" width={108} height={26} />
      <span>Chincha</span>
    </header>
  );
}
