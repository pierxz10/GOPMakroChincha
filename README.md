# Sistema Web de Gestión de Objetos Perdidos — Makro Chincha

Primera entrega de **Airton, Developer 1 — Frontend**, con Scrum Adaptativo. Presentación: lunes 19/10/2026. [Abrir índice de entrega](docs/00-entrega-1.md).

React + TypeScript + Vite + Tailwind CSS. Incluye únicamente la base web responsive y el acceso conectado al contrato del Backend Spring Boot. Los módulos posteriores están documentados, sin implementar el sistema completo.

## Estado comprobado

- Build y pruebas unitarias pasan. Pantalla verificada en Microsoft Edge a 360, 768 y 1440 px con los recursos originales de Figma.
- El formulario envía solicitudes reales a `/api/auth/login`. Se comprobó el mensaje de fallo de conexión desde navegador; no hay modo simulado ni credenciales precargadas.
- **Acceso exitoso bloqueado:** el Backend compila pero no arranca en este entorno por configuración externa ausente. Tampoco se entregaron esquema MySQL, cuenta ni URL de pruebas. [Evidencia y pasos concretos](docs/04-backend-integracion.md).
- Patricia todavía debe reevaluar Figma V2. Prioridades/estimaciones propuestas hasta recibir Product Backlog oficial.

## Requisitos

Node.js **22.12 o superior** y npm. Entorno usado: Windows/PowerShell, Node 24.16.0 y npm 11.13.0. Dependencias exactas en package-lock.json: React 19.3.1, TypeScript 7.0.2, Vite 8.3.4 y Tailwind 4.3.3.

Para el Backend: proyecto separado de Bitbucket, Java 17+ (compilado con JDK 21 disponible), Maven Wrapper, MySQL y archivo externo configurado por Developer 2. No se necesita MySQL para abrir el Frontend; sí para autenticar con ese Backend.

## Configuración y desarrollo

En PowerShell, dentro de esta carpeta:

```powershell
npm ci
Copy-Item .env.example .env.local
npm run dev
```

Abrir **http://127.0.0.1:5173**. El servidor exige ese puerto y no cambia silenciosamente a otro. En este equipo puede usarse `npm.cmd` si PowerShell bloquea `npm.ps1`.

```dotenv
VITE_API_BASE_URL=http://localhost:9090
VITE_API_TIMEOUT_MS=10000
```

La dirección debe ser el origen HTTP(S), sin `/api`, query ni credenciales. El puerto 9090 está comprobado en application.properties del Backend. Para otra máquina, Developer 2 debe proporcionar la URL accesible desde el navegador: localhost se refiere al equipo del navegador. El cliente valida la configuración y no intenta otras APIs como alternativa.

Solo se exponen variables públicas. Nunca añadir claves JWT, contraseña de BD, SMTP ni contraseñas de usuario a archivos VITE. .env.local y demás archivos locales están ignorados por Git. El ejemplo de [configuración Backend](config/backend/makroapp.properties.example) es un inventario para Developer 2, sin secretos y no ejecutable por sí solo.

Para producción, copiar `.env.production.example` a `.env.production.local`, reemplazar el dominio reservado por la URL HTTPS real y compilar. No se ha desplegado ni validado un ambiente de producción. Vite incorpora estas variables durante la compilación; editar el ambiente requiere recompilar.

## Comandos de comprobación

```powershell
npm run typecheck
npm run build
npm test
```

`npm run build` ejecuta TypeScript y genera dist/. Para revisar ese resultado localmente:

```powershell
npm run preview
```

Abrir **http://127.0.0.1:4173**. No usar preview como servidor de producción.

Las pruebas de navegador usan Playwright y Microsoft Edge instalado. Mantener `npm run dev` activo en otra terminal y ejecutar:

```powershell
npm run test:browser
```

Son cuatro comprobaciones: tres tamaños responsive y un intento real contra el Backend no disponible. No interceptan ni sustituyen la API. La prueba del fallo de conexión corresponde al ambiente actual; cuando haya Backend operativo debe ejecutarse el recorrido real documentado y actualizar ese caso, en lugar de esperar artificialmente un fallo. Si no hay Edge instalado, se debe configurar un navegador soportado; no se ha validado otro navegador en este entorno.

Sonda HTTP real, sin iniciar el Backend ni inventar respuestas:

```powershell
npm run verify:api
# Solo cuando Developer 2 confirme otra dirección:
$env:API_BASE_URL = 'https://direccion-real-proporcionada-por-el-equipo'
npm run verify:api
```

La sonda guarda docs/evidencias/api-local.json y devuelve código 1 si hay fallo de red/servidor. Prueba OpenAPI, preflight y validación de campos vacíos; no demuestra por sí sola CORS de navegador ni login correcto. La opción `API_TEST_INVALID_LOGIN=1` genera un intento de acceso inexistente y una auditoría real: usarla solo en el ambiente de pruebas coordinado. No hay credenciales válidas incluidas.

## Recorrido mínimo

Abrir el acceso, probar los obligatorios y enviar únicamente una cuenta de pruebas real suministrada por Developer 2 cuando el ambiente esté disponible. Con éxito se muestran nombre y rol de la API. Los tokens viven en memoria; recargar pide acceso nuevamente. Si `cambiarClave=true`, la ubicación queda restringida y se informa el cambio obligatorio. Su formulario conectado queda para la siguiente implementación, sin levantar esa restricción.

El botón Recuperar acceso muestra únicamente la alerta «En proceso». Las funciones pendientes no abren Figma desde la aplicación. Los enlaces de Figma se conservan en la documentación como referencias de diseño. La salida mínima permite cancelar o confirmar y distingue la salida local de una revocación remota no confirmada.

## Documentación

| Documento | Contenido |
|---|---|
| [Prototipos](docs/01-prototipos.md) | Ocho FP prioritarios, enlaces de los tres tamaños, evidencias y límites de revisión |
| [Arquitectura](docs/02-arquitectura.md) | Diagrama, páginas/componentes/servicios, sesión, ambientes y responsabilidades |
| [Planificación](docs/03-planificacion.md) | Backlog de esta entrega y posterior, estimaciones y decisiones pendientes |
| [Backend e integración](docs/04-backend-integracion.md) | Contrato real, autenticación, CORS, ejecución y desbloqueo |
| [Copia local del Backend](docs/06-backend-local.md) | Actualización del 19/10: CORS ya configurado en código y dependencias para ejecución local |
| [Verificación](docs/05-verificacion.md) | Resultados observados y matriz de requisitos/evidencias |

Referencias: [Figma V2](https://www.figma.com/design/WkZ5czgTYiW7neXRYMM67l), [índice de correcciones](https://www.figma.com/design/WkZ5czgTYiW7neXRYMM67l/Makro-Chincha?node-id=182-105), [Backend compartido](https://bitbucket.org/technologycenter1/objetos-personales/commits/branch/master). Se siguieron las guías oficiales de [React con TypeScript](https://react.dev/learn/typescript), [Tailwind con Vite](https://tailwindcss.com/docs/installation/using-vite) y [ambientes de Vite](https://vite.dev/guide/env-and-mode.html) para la configuración técnica; no reemplazan los requerimientos funcionales del equipo.
