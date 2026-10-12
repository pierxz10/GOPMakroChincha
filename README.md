# GOP Makro Chincha · Frontend Flutter

Entrega del 12/10/2026: **Acceso, Dashboard, Objetos y Búsqueda/filtros**, con datos de demostración y adaptación a móvil, tablet y escritorio. Rama de trabajo: `2026-10-12`.

## Ejecutar en Chrome

Desde la carpeta del repositorio:

```powershell
flutter pub get
flutter run -d chrome
```

El programa comienza en Acceso. Pulsa uno de los perfiles de demostración para completar usuario y contraseña y después **Ingresar**. Para clientes, pulsa **Consultar objetos sin cuenta**.

| Perfil | Usuario | Contraseña de prueba |
| --- | --- | --- |
| Administrador | admin.demo | MakroDemo2026 |
| Supervisor | supervisor.demo | MakroDemo2026 |
| Responsable | responsable.demo | MakroDemo2026 |
| Cliente / visitante | No requiere cuenta | No requiere contraseña |

Las cuentas son ficticias y están diseñadas exclusivamente para la revisión del frontend.

## Alcance funcional

- Inicio y cierre de sesión local de demostración; mensajes por campos vacíos o credenciales incorrectas.
- Navegación entre las cuatro pantallas, vuelta desde filtros y bloqueo de rutas internas para visitantes.
- Seis objetos del paquete de diseño con estados Disponible, En reclamo y Entregado.
- Dashboard calculado desde los mismos objetos: 6 registrados, 4 en custodia, 1 en reclamo y 2 entregados.
- Búsqueda por texto y filtros combinables de categoría, estado, lugar y fechas inclusivas.
- Limpieza de filtros, conservación al navegar/redimensionar, carga, error/reintento y estado vacío.
- Detalle en diálogo y registro validado de hallazgos en memoria para los tres roles internos. El registro actualiza listado e indicadores.
- Catálogo público de objetos disponibles, sin documentos, descripción identificadora, código interno, hora exacta o lugar del hallazgo. No permite registro ni consulta del dashboard.
- Logo original, SVG del paquete, colores y tipografía del diseño; componentes que crecen según el texto y permiten desplazamiento.

Reclamos, Reportes y Administración aparecen como secciones futuras cuando el perfil corresponde, pero sus controles están deshabilitados y no se presentan como módulos implementados. La matriz propuesta está en `docs/permisos-demo.md`.

## Responsive

Escritorio: navegación lateral y tres columnas de objetos. Tablet: navegación lateral compacta y dos columnas. Móvil: navegación inferior para personal, tarjetas compactas de una columna y formularios apilados. Con texto ampliado se reducen columnas y se permite desplazamiento.

Referencias visuales: 1440×1000, 834×1112 y 390×844. Las pruebas también incluyen 320×568 y texto al doble de tamaño.

## Estructura

```text
lib/app/app.dart                         Arranque, sesión compartida y rutas protegidas
lib/app/app_shell.dart                   Cabecera y navegación responsive
lib/app/theme.dart                       Tema y colores
lib/features/auth/                      Acceso y roles de demostración
lib/features/dashboard/                 Resumen e indicadores
lib/features/objects/models/            Modelo y proyección pública
lib/features/objects/data/               Contrato de repositorio y datos ficticios
lib/features/objects/presentation/       Listado, filtros, controlador y diálogos
lib/shared/widgets/                      Marca, iconos y componentes comunes
test/                                    Pruebas de permisos, lógica y pantallas
```

## Validación

Entorno validado: Flutter 3.47.6 y Dart 3.13.5. `flutter analyze` sin problemas; **52 pruebas aprobadas**. `flutter build web --no-pub` completado. Se comprobó en Chrome el acceso interno, el catálogo público y filtros combinados con fechas; hay capturas de las cuatro pantallas a tamaños de escritorio, tablet y móvil.

```powershell
dart format lib test
flutter analyze
flutter test
flutter build web
flutter build apk --debug
```

La compilación y ejecución Android en dispositivo se documentan por separado en `docs/revision-2026-10-12.md`; no se consideran aprobadas por las pruebas de viewport de Chrome.

## Límites de la demostración

No hay conexión con la API, autenticación real ni persistencia. Los nuevos registros desaparecen al reiniciar o recargar la aplicación. Las restricciones de interfaz y rutas simulan permisos; el backend deberá autenticar usuarios, autorizar operaciones y devolver una respuesta pública limitada. No utilizar esta demostración como control de acceso de producción.

Se reconstruyó la composición con las capturas entregadas y el paquete `design_resources/`, porque el conector de Figma alcanzó su límite durante la implementación. Las variantes públicas y los permisos son propuestas adicionales para revisar con el docente y el equipo.

`pubspec.lock` fija las dependencias. El identificador Android `com.example.gop_makro_chincha` y la firma de depuración siguen siendo provisionales.
