# Planificación y backlog — primera entrega

Airton · Developer 1 — Frontend · Scrum Adaptativo. Preparación: 18/10/2026. Presentación: **lunes 19/10/2026**; no se recibió hora de presentación ni capacidad del equipo.

## Base de la planificación

**Orden propuesto**, pendiente de contrastar con el Product Backlog oficial, que no fue adjuntado. Las estimaciones son horas de trabajo provisionales por tarea, no horas ya registradas ni compromisos de fecha. Se refinan con Developer 2, María y la disponibilidad del equipo. Los códigos FP proceden de Figma; los RF solo se citan cuando aparecen en una fuente inspeccionada. No se asignan números de requerimiento oficiales a funcionalidades sin documento.

Objetivo de esta entrega: presentar los prototipos corregidos existentes, una arquitectura coherente y la planificación; añadir únicamente base técnica y acceso conectado al contrato disponible. El resultado de integración debe ser demostrable como éxito o bloqueo con evidencia, sin datos simulados.

## Backlog de esta primera entrega

| ID | Tarea / requerimiento relacionado | Prioridad propuesta | Dependencia | Criterio de aceptación verificable | Entregable | Responsable propuesto | Estimación provisional | Estado al corte |
|---|---|---|---|---|---|---|---|---|
| E1-01 | Inspeccionar Figma y Backend; alcance de entrega | P0 | Accesos y referencias compartidas | Registrar commit, stack, configuración, endpoints y limitaciones sin inferir funcionamiento por commits | 04-backend-integracion.md y evidencias | Airton + Developer 2 para confirmar ambiente | 2–3 h | Verificado en código; runtime bloqueado |
| E1-02 | Índice de correcciones FP-02/09/11 y FP-01/03/04/13/20 | P0 | Figma V2 existente | Enlaces directos por tamaño, 24 frames resueltos, calificaciones originales separadas de revisión interna | 01-prototipos.md y JSON/capturas | Airton | 3–4 h | Verificado internamente; Patricia pendiente |
| E1-03 | Arquitectura de páginas/componentes/servicios/ambientes | P0 | E1-01; stack React/TS/Vite/Tailwind definido | Diagrama distingue existente, implementado y futuro; API y MySQL separados del navegador | 02-arquitectura.md y diagrama | Airton; revisión técnica Developer 2 | 3–4 h | Implementado como documentación |
| E1-04 | Base técnica web y componentes de FP-01 | P0 | E1-02; diseño/componentes reales | Compila, usa logo/iconos originales y variables públicas; tarjeta sin desbordes a 360/768/1440 | src/, package-lock.json, .env.example | Airton | 3–4 h | Implementado y verificado |
| E1-05 | Login mínimo; FP-01 / RF-01 según AuthService | P0 | Contrato real de E1-01 | Envía username/password al endpoint existente; comprueba isSuccess, carga, errores y sesión basada en respuesta real; no habilita cuenta con cambiarClave | LoginPage, cliente HTTP, auth y sesión | Airton | 4–6 h | Implementado; éxito real bloqueado |
| E1-06 | Pruebas de build, formulario, responsive y conexión | P0 | E1-04/05 | Informe distingue pruebas aisladas, navegador y API; adjunta comandos, resultados y capturas | 05-verificacion.md y evidencias | Airton | 2–3 h | Verificado en lo disponible |
| E1-07 | Proveer ambiente Backend y cuenta de pruebas | P0 | Config externa, esquema MySQL y datos gestionados por Developer 2 | Backend inicia; API disponible en dirección confirmada; cuenta real sin cambiar reglas para la demostración | Ambiente de pruebas y datos de acceso gestionados fuera del repo | Developer 2 | 2–4 h, revisar al recibir BD | Bloqueado; no disponible |
| E1-08 | Verificar acceso real válido/inválido y ciclo de sesión | P0 | E1-07, CORS y cuenta autorizada | Navegador obtiene respuesta real, muestra éxito solo con isSuccess=true, error genérico para inválidas, restricción cambiarClave y cierre/renovación comprobados | Evidencias sanitizadas del flujo completo | Airton + Developer 2; Patricia revisa | 2–3 h | Bloqueado |
| E1-09 | Contrastar requerimientos, evaluación y Product Backlog | P0 | Documentos oficiales no adjuntos | Ajustar trazabilidad, prioridad y diferencias con respaldo documental, manteniendo este alcance | Backlog refinado y decisiones | María; Airton actualiza | 1–2 h | Bloqueado por documentos |
| E1-10 | Reevaluación de correcciones | P0 | E1-02, disponibilidad de Patricia | Registrar resultado de Patricia por FP; no sustituir la evaluación original con revisión interna | Acta o comentarios de reevaluación | Patricia; Airton atiende hallazgos de su alcance | 1–2 h | Pendiente de Patricia |

## Desarrollo posterior — no implementado ahora

Todas las filas siguientes son **propuestas** y requieren refinamiento. P1/P2 ordenan dependencias de esta propuesta; no sustituyen la prioridad de María. No se prometen endpoints aún inexistentes.

| ID | Tarea / referencia funcional | Prioridad propuesta | Dependencia | Criterio de aceptación verificable | Entregable posterior | Responsable propuesto | Estimación provisional |
|---|---|---|---|---|---|---|---|
| P-01 | Cambio obligatorio y recuperación de acceso; FP-02/03, RF-04/03 vistos en código | P1 | E1-08; política validada por María; revisión de DTO nulos y correo por Developer 2 | Cambio exige actual/nueva/confirmación; no permite continuar antes del éxito real; recuperación da respuesta genérica | Páginas y pruebas de ambos flujos | Airton (UI), Developer 2 (API/correo), Patricia (pruebas) | FE 8–12 h; BE por refinar |
| P-02 | Dashboard, FP-05 | P2 | API de indicadores no encontrada; visibilidad por rol | Cinco indicadores reales con carga/error/vacío y acceso autorizado | Página y servicio de indicadores | Airton + Developer 2 | FE 6–8 h; BE por refinar |
| P-03 | Catálogos de categorías/lugares, FP-18 | P1 | Contrato y permisos de María; API faltante | Opciones reales, validación y errores, sin URL de disco | Servicios y vistas de catálogos | Developer 2 (contrato), Airton (UI) | FE 6–10 h; BE por refinar |
| P-04 | Listado, registro y detalle de objetos; FP-06/07/08 | P1 | P-03, API de objetos, estados y acceso por rol | Buscar/filtrar/registrar/ver historial; fotos mediante URL HTTP y límites validados por API | Páginas de objetos y servicio | Airton + Developer 2 | FE 12–16 h; BE por refinar |
| P-05 | Edición de objeto, FP-09 | P1 | P-04; decisión D-02; contrato de edición | Conserva trazabilidad, valida campos; no cambia estado final; edición de datos de ENTREGADO conforme a decisión documentada | Formulario y confirmación conectados | Airton + Developer 2; María define D-02 | FE 6–10 h; BE por refinar |
| P-06 | Registro, consulta y anulación de reclamaciones; FP-10/11/12 | P1 | P-04, API de reclamaciones, D-04 | Buscar por documento/código, filtrar, estados propios de reclamación, datos por permiso, motivo de anulación y confirmación | Páginas, servicio y pruebas | Airton + Developer 2 | FE 12–16 h; BE por refinar |
| P-07 | Verificación de identidad, FP-13; RF-22/23 citados en Figma | P1 | P-06 y reglas de verificación/permisos | Captura documento presentado; aprobar/rechazar con motivo según contrato; rechazo bloquea entrega | Flujo de verificación conectado | Airton + Developer 2; María valida reglas | FE 8–12 h; BE por refinar |
| P-08 | Entrega y constancia, FP-14/15 | P1 | P-07; D-01; API transaccional de entrega | Solo autorizados por decisión confirmada; Supervisor/Administrador sin entrega excepcional; ENTREGADO final, sin segunda entrega | Entrega y constancia real | Airton + Developer 2; María decide D-01 | FE 10–16 h; BE por refinar |
| P-09 | Reportes, FP-16 | P2 | APIs de datos y D-04 | Filtros y resultados reales, estados de carga/error/vacío, acceso autorizado | Reportes y exportación si se confirma | Airton + Developer 2 | FE 8–12 h; BE por refinar |
| P-10 | Usuarios, roles y permisos; FP-17/19 | P2 | E1-08, API existente, D-04 y esquema real | UI respeta respuestas 401/403, no inventa asignación de permisos; cambios auditados | Administración conectada | Airton (UI), Developer 2 (API/BD), María (matriz) | FE 12–16 h; revisión BE por refinar |
| P-11 | Bitácora de consulta, FP-20; RF-32 mencionado en AuthService | P2 | Endpoint de consulta faltante, política de consulta y D-04 | Solo lectura, búsqueda/detalle y acceso definido; no permite editar/eliminar registros | Página y API de consulta de eventos | Developer 2 + Airton; María valida alcance de consulta | FE 6–10 h; BE por refinar |
| P-12 | Cambios manuales de estado | P2 | D-03; catálogo confirmado de cinco estados | Únicamente transiciones/roles autorizados; ENTREGADO sin salida; toda transición auditada | Flujo acordado y pruebas | María (reglas), Developer 2 (garantía), Airton (UI) | Sin estimar hasta resolver D-03 |

## Registro de decisiones y dependencias

| ID | Pregunta pendiente | Responsable de decisión / dependencia | Impacto y tratamiento actual |
|---|---|---|---|
| D-01 | ¿Quién autoriza devoluciones y registra entregas entre Asistente/Auxiliar? | María | Bloquea definir P-08; ningún permiso deducido del nombre del rol |
| D-02 | ¿Quién modifica datos de objetos ENTREGADOS y en qué condiciones? | María | Bloquea caso final de P-05. ENTREGADO ya es final; modificar metadatos no implica reabrir su estado |
| D-03 | ¿Qué cambios de estado son manuales y quién los realiza? | María | Bloquea P-12; no se publican transiciones definitivas |
| D-04 | ¿Qué información puede consultar/modificar cada rol, incluidos datos personales? | María | Bloquea matriz final de módulos y filtrado por rol; requiere validación de permisos reales en MySQL |
| D-05 | ¿Se ratifica la política de contraseñas implementada? | María + Developer 2 | Backend ya exige 8–64, mayúscula/minúscula/número; documentado como implementación, no acuerdo funcional definitivo |
| B-01 | Archivo externo, esquema y ambiente de pruebas | Developer 2 | Bloquea E1-07/08; pasos detallados en 04-backend-integracion.md |
| B-02 | Requerimientos, evaluación original y Product Backlog oficial | María/equipo | No se pudieron contrastar documentos ausentes; prioridades y estimaciones siguen propuestas |
| B-03 | Reevaluación de prototipos | Patricia | Pendiente; la revisión interna no modifica las 12 correctas, 3 X y 5 sin calificación que declara el índice |

## Cadencia propuesta de Scrum Adaptativo

Antes de presentar el 19/10: revisar evidencia y bloqueos con Developer 2, validar que el incremento cumple este alcance y preparar el recorrido de los ocho FP prioritarios. Si no llega el ambiente, presentar el bloqueo documentado junto con la implementación, sin afirmar acceso exitoso. No se asume una hora ni se compromete terminar dependencias ajenas antes de la presentación.

En la siguiente planificación: María ordena el Product Backlog oficial; el equipo refina contratos y decisiones D-01 a D-04, ajusta estimaciones a capacidad y acuerda el objetivo de sprint. Durante el trabajo, registrar avances, impedimentos y cambios de prioridad; una dependencia bloqueada no se mueve a terminado. En la revisión, mostrar incremento funcionando con evidencia; en la retrospectiva, ajustar el proceso y el siguiente plan. La duración del sprint y las ceremonias quedan por acordar con el equipo, sin imponer una cadencia no suministrada.

**Listo para desarrollar (propuesto):** regla aclarada, contrato disponible, diseño localizado y datos de prueba autorizados. **Terminado (propuesto):** criterio aceptado, build/pruebas relevantes pasan, evidencia registrada y aceptación correspondiente; la aprobación de Patricia se registra por separado.

Quedan fuera: Flutter, notificaciones, estados VENCIDO y DESCARTADO, entrega excepcional por Supervisor/Administrador y desarrollo completo del sistema en esta primera entrega.
