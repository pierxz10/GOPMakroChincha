# Registro de comprobación — primera entrega

Corte: **18/10/2026, America/Lima**. Algunas evidencias usan fecha UTC del 19/10; corresponden todavía a la noche del 18/10 en Lima. Stack final: React + TypeScript + Vite + Tailwind CSS.

**Historia comprobada:** desde el acceso responsive, el usuario completa el formulario; React valida y el cliente HTTP intenta POST `/api/auth/login` en Spring Boot. El Backend debe consultar MySQL, generar la sesión y responder para que se muestre nombre/rol. En este entorno el servicio no arranca, por lo que se comprobó hasta la solicitud y su error visible; no se verificó acceso exitoso ni datos persistidos.

## Resultados ejecutados

| Comprobación | Resultado observado | Evidencia y límite |
|---|---|---|
| Acceso a Figma | Verificado mediante herramientas conectadas; índice y pantallas leídos | [Índice exportado](evidencias/figma-indice.json). Sin escrituras en Figma |
| Acceso a Bitbucket | Git ls-remote y clone de master correctos; commit ded2115c reconfirmado al retomar | [Inventario y hashes](evidencias/backend-fuentes.json) |
| Compilación Backend | `.\mvnw.cmd -DskipTests package`: BUILD SUCCESS | [Registro](evidencias/backend-arranque.txt); tests Backend omitidos expresamente |
| Arranque Backend | Código 1; NumberFormatException al cargar expiración JWT, configuración externa ausente | Mismo registro; MySQL y login completo no alcanzados |
| `npm run build` | Código 0; incluye `tsc --noEmit`; Vite genera dist/ | [Registro Frontend](evidencias/frontend-checks.txt) |
| `npm test` | Código 0, **8 pruebas aisladas aprobadas** | [Pruebas](../tests/http.test.ts), registro Frontend; dobles de transporte explícitos, no integración con Backend |
| `npm run dev` | Vite disponible en 127.0.0.1:5173 | Navegador probado sobre este servidor; puerto estricto |
| `npm run preview` | Build local disponible en 127.0.0.1:4173, HTTP 200 y sin errores JavaScript de página | [Registro de preview](evidencias/preview.json); solo render, sin autenticar |
| `npm run test:browser` | Código 0, **4 pruebas aprobadas**, 0 omitidas | [Reporte Playwright](evidencias/browser-results.json); Edge, sin interceptación ni sustitución de API |
| Responsive y recursos | 360/768/1440; tarjeta 320/480/480 px, inicio y=98 px, sin scroll horizontal; logo 108×26 e iconos 18×18, todos cargados | [360](evidencias/login-360.png), [768](evidencias/login-768.png), [1440](evidencias/login-1440.png). Recursos locales: [hashes](evidencias/assets.json) |
| Campos obligatorios | Error visible, foco en usuario y ninguna solicitud API al enviar vacío | Casos responsive en Playwright; labels/aria-invalid/aria-describedby |
| Navegación sin sesión | Acceso directo a #/sesion vuelve a #/acceso | Casos responsive en Playwright |
| Función pendiente Recuperar acceso | Alerta nativa con texto exacto «En proceso»; misma página, una sola pestaña y ninguna solicitud a Figma | [Comprobación sobre build actualizado](evidencias/funciones-pendientes.json); build posterior al cambio también correcto |
| Solicitud real de login | Navegador envía POST a la ruta real con username/password; el fallo se muestra y permite reintentar; contraseña borrada | [Error de conexión](evidencias/login-error-conexion.png), caso Playwright. Los valores introducidos son texto negativo de prueba; no son una cuenta existente ni se incluyen como credenciales de demostración |
| `npm run verify:api` | Código 1 esperado por bloqueo: ECONNREFUSED en OpenAPI, preflight y validación de vacíos | [Sonda real](evidencias/api-local.json). Node no verifica por sí solo CORS del navegador |
| Login correcto/inválido real | **Bloqueado**, sin URL/cuenta y con Backend detenido | No se fabricó respuesta ni se usó un modo simulado |
| Renovación/salida y cambio obligatorio | Implementados en código; contrato y restricción leídos; ejecución remota bloqueada | [App](../src/App.tsx), [servicio](../src/services/auth.ts). No se afirma prueba completa de estos escenarios |
| Diagrama | SVG abierto y revisado visualmente en Edge, sin recortes de etiquetas | [SVG](diagrama-arquitectura.svg), [render de evidencia](evidencias/diagrama-arquitectura.png) |

## Qué cubren las pruebas aisladas

Se verifica la ruta/cuerpo de login y ausencia de cookies; HTTP 200 con isSuccess=false; rechazo de HTML/JSON ajeno al contrato; red, timeout y HTTP 503; rutas/cuerpos de refresh y logout y cabecera Bearer; rechazo de sesión incompleta y conservación de cambiarClave; exp numérico del JWT; rechazo de URL con credenciales/ruta equivocada y tiempo de espera inválido. Ninguna prueba aislada acredita que la API esté operativa.

La aplicación productiva importa fetch real; las respuestas sintéticas de `tests/http.test.ts` son únicamente dobles de pruebas. El navegador no contiene route.fulfill, servidor simulado, usuario demo ni alternativa silenciosa. El botón de recuperación muestra solo una alerta «En proceso»; no abre Figma ni simula un envío de correo.

La revisión de React comprobó componentes separados, tipos estrictos, efectos con limpieza, sincronización de navegación, prevención de doble envío, etiquetas/foco y ausencia de HTML sin escapar o almacenamiento persistente de tokens. El tema de Tailwind conserva los recursos y medidas del contexto de Figma. No se implementó autorización por rol a partir de suposiciones.

Se comprobaron los enlaces locales de los siete documentos Markdown de la entrega: ninguno apunta a un archivo inexistente. La comprobación no constituye disponibilidad pública de los enlaces externos ni reevaluación de sus contenidos.

## Límites y repetición pendiente

La primera frontera rota es la disponibilidad del Backend: falla su arranque antes de poder completar login → MySQL → respuesta. No se intentó superar esa frontera con datos simulados ni se declara verificada la persistencia, CORS real, rechazo real de credenciales, renovación ni revocación remota. Las acciones de desbloqueo y sus responsables están en [04-backend-integracion.md](04-backend-integracion.md#pasos-concretos-para-desbloquear).

Figma se revisó por lectura de índice, 24 frames y muestra de acciones/textos, renders de acceso y FP-02/09/11, dimensiones y desplazamiento. No se repitieron todos los escenarios condicionales del prototipo; el índice conserva sus evaluaciones originales. No hay reevaluación de Patricia disponible.

No se recibieron requerimientos, evaluación original, imagen del diagrama ni Product Backlog oficial como archivos verificables. Las instrucciones del usuario sustentan las reglas confirmadas; el resto se diferencia de propuestas. Para cerrar la integración, Developer 2 debe entregar ambiente/BD/configuración y cuenta real, Airton debe ejecutar el recorrido completo y Patricia debe registrar la reevaluación que corresponda.

## Matriz final de entrega

| Requisito de esta entrega | Archivo o enlace de evidencia | Resultado | Pendiente |
|---|---|---|---|
| Prototipos corregidos FP-02/09/11 y demás prioritarios | [01-prototipos.md](01-prototipos.md), [Figma V2](https://www.figma.com/design/WkZ5czgTYiW7neXRYMM67l/Makro-Chincha?node-id=182-105) | Verificado internamente | Reevaluación de Patricia; contraste con acta original |
| Referencias responsive 360/768/1440 | JSON Figma y capturas enlazados en 01-prototipos; login-360/768/1440.png | Verificado en los frames inspeccionados y en FP-01 implementado | Recorrido completo del resto de prototipos por QA |
| Arquitectura con separación de responsabilidades | [02-arquitectura.md](02-arquitectura.md), [diagrama](diagrama-arquitectura.svg) | Implementado como documento; coherencia contrastada con código | Confirmar ambiente y API futura de fotografías |
| Planificación y backlog | [03-planificacion.md](03-planificacion.md) | Propuesto | Product Backlog oficial, capacidad y decisiones de María |
| Base React/TypeScript/Vite/Tailwind | [package.json](../package.json), [src](../src/main.tsx), registro Frontend | Implementado y verificado por build | Ninguno para compilar la base local |
| Inicio de sesión y validaciones | [LoginPage](../src/pages/LoginPage.tsx), [reporte navegador](evidencias/browser-results.json) | Implementado; validación y fallo de red verificados | Acceso exitoso y credenciales inválidas reales |
| Cliente HTTP y autenticación reales | [auth](../src/services/auth.ts), [http](../src/services/http.ts), [04-backend-integracion.md](04-backend-integracion.md) | Implementado contra contrato verificado en código | Comprobar sesión completa, renovación/salida y CORS con API operativa |
| Configuración por ambiente sin secretos | [.env.example](../.env.example), [.env.production.example](../.env.production.example) | Implementado | URL HTTPS real para producción |
| Backend ejecutable y comunicación completa | [backend-arranque](evidencias/backend-arranque.txt), [api-local](evidencias/api-local.json) | Bloqueado | Config externa, esquema/ambiente MySQL y cuenta real de Developer 2 |
| README y comandos | [README](../README.md) | Implementado; comandos ejecutados diferenciados en el registro | Repetir recorrido real al recibir ambiente |
| Alcance funcional y permisos | [00-entrega-1](00-entrega-1.md), decisiones D-01 a D-04 en planificación | Documentado; módulos posteriores propuestos | María confirma permisos pendientes; no se incorporaron reglas no aprobadas |
