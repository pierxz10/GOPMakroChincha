# Permisos propuestos · Demostración del 12/10/2026

Tres roles internos y una modalidad pública de cliente/visitante, según la indicación de Airton. Esta matriz es una propuesta para la segunda revisión; requiere acuerdo con el equipo backend.

| Operación | Administrador | Supervisor | Responsable | Cliente / visitante |
| --- | --- | --- | --- | --- |
| Entrar sin cuenta | Puede usar catálogo público | Puede usar catálogo público | Puede usar catálogo público | Sí |
| Dashboard e indicadores internos | Sí | Sí | Sí | No |
| Consultar listado interno y detalles | Sí | Sí | Sí | No |
| Buscar y filtrar catálogo público limitado | Sí | Sí | Sí | Sí |
| Registrar hallazgo de prueba | Sí | Sí | Sí | No |
| Revisar y aprobar reclamos | Permiso previsto | Permiso previsto | No | No |
| Reportes | Permiso previsto | Permiso previsto | No | No |
| Administrar usuarios y roles | Permiso previsto | No | No | No |

Las cuatro pantallas implementadas son Acceso, Dashboard, Objetos y Búsqueda/filtros. Registro y detalle se ofrecen en diálogos de demostración para que los botones tengan un resultado verificable. Reclamos, Reportes y Administración quedan para próximas entregas: los permisos están declarados, pero sus páginas y operaciones no están implementadas.

## Acceso público

El cliente no necesita registrar una cuenta para consultar. Se muestran solo objetos disponibles que no sean documentos, con tipo de objeto, categoría, icono y fecha del hallazgo. Se omiten el nombre detallado/color, descripción identificadora, código del inventario, hora y ubicación exacta. El cliente debe acudir a Atención al Cliente y describir sus características para que el personal compruebe la propiedad.

Se aplica una proyección pública antes de buscar, evitando que las coincidencias revelen información oculta. Los visitantes no pueden abrir rutas de dashboard ni registrar objetos, aunque invoquen directamente los controladores de sesión.

## Alcance de seguridad

Son cuentas y controles locales ficticios para probar el frontend. Todo el inventario de demostración se incluye en el cliente. En producción, la API debe entregar el catálogo público redactado desde el servidor y validar permisos en cada operación. La revisión visual o las pruebas locales no constituyen una verificación de seguridad del backend.

## Pruebas relevantes

- Acceso válido para los tres usuarios y rechazo de credenciales erróneas.
- Cierre de sesión y bloqueo de rutas internas para visitantes.
- Registro denegado a visitantes y permitido al personal.
- Omisión de documentos y datos internos en el catálogo público.
- Búsquedas públicas por características privadas no devuelven coincidencias.
- Registro de un objeto actualiza los indicadores y el listado compartido.
