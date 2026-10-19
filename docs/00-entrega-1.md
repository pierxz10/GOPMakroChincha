# Primera entrega — Makro Chincha

**Airton · Developer 1 — Frontend · Scrum Adaptativo**

Presentación: lunes **19 de octubre de 2026**. Preparación y comprobaciones: 18/10/2026, America/Lima.

## Índice de entrega

| Entregable | Archivo | Situación |
|---|---|---|
| Prototipos corregidos existentes | [01-prototipos.md](01-prototipos.md) | Revisión interna documentada; Patricia pendiente |
| Arquitectura y diagrama | [02-arquitectura.md](02-arquitectura.md) | Documentada sobre código y decisiones confirmadas |
| Planificación y backlog | [03-planificacion.md](03-planificacion.md) | Propuesta, pendiente de Product Backlog oficial |
| Inspección y contrato Backend | [04-backend-integracion.md](04-backend-integracion.md) | Verificado en código; bloqueo de ejecución registrado |
| Comprobaciones y límites | [05-verificacion.md](05-verificacion.md) | Build, pruebas, responsive y fallo real de conexión |
| Ejecución Frontend | [README](../README.md) | React/TypeScript/Vite/Tailwind, configuración pública y comandos |

## Alcance y fuentes

La entrega contiene únicamente base técnica, pantalla de inicio de sesión, cliente API y confirmación mínima de sesión con salida. Los demás módulos se representan en arquitectura y planificación. Recuperar acceso muestra únicamente la alerta «En proceso». La aplicación no abre Figma para las funciones pendientes; las referencias de diseño quedan en la documentación. El cambio de clave obligatorio se respeta como restricción, sin desarrollar ahora otro módulo.

Fuentes recibidas: instrucciones consolidadas del usuario en Texto pegado.txt, enlaces de Figma V2 y Bitbucket, y aclaración de que no hay URL ni cuenta de pruebas compartida. El diagrama del equipo fue descrito por el usuario; no se recibió una imagen verificable del mismo. No se recibieron documentos de requerimientos, rúbrica/acta original de evaluación ni Product Backlog oficial. Por tanto, no se puede comprobar su numeración completa, prioridades oficiales, criterios de calificación ni aceptación formal. Las menciones a evaluación original proceden del índice de Figma, no de un acta independiente.

**Confirmado:** aplicación web responsive; roles Asistente, Auxiliar, Supervisor y Administrador; estados de objeto ENCONTRADO, EN_CUSTODIA, RECLAMADO, VERIFICADO y ENTREGADO; ENTREGADO final. Flutter, notificaciones, VENCIDO y DESCARTADO fuera de alcance. Supervisor y Administrador no realizan entregas excepcionales.

**Pendiente de María:** devolución/entrega de Asistente y Auxiliar; edición de información de objetos entregados; cambios manuales de estado; información consultable/modificable por rol. La presencia de permisos en código o en un diagrama no ratifica estas decisiones.

## Estado de la integración

**Implementado:** acceso con contrato real, tipos, manejo de errores, memoria de sesión, renovación y cierre mínimos. **Verificado:** compilación del Frontend, pruebas aisladas, render responsive y solicitud real desde navegador con error de conexión. **Bloqueado:** login exitoso y rechazo real de credenciales por el Backend, renovación y salida remotas, por configuración externa ausente, BD/esquema y cuenta de pruebas no disponibles.

El Backend compiló, pero su proceso terminó al leer una propiedad JWT inexistente. Ninguna compilación ni prueba aislada se presenta como demostración de integración exitosa. El siguiente paso depende de Developer 2, según los pasos de [desbloqueo](04-backend-integracion.md#pasos-concretos-para-desbloquear).
