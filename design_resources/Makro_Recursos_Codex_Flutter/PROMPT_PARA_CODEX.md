# Prompt para iniciar el desarrollo

Estoy desarrollando el front end en Flutter del módulo de objetos perdidos de Makro Chincha. Soy Airton, Developer 1. Dayron desarrolla el back end. Este paquete contiene las referencias de diseño de nuestra primera entrega; no asumas que ya existe una app ni que los contratos del back end están aprobados.

Lee primero README.md, docs/UI_SPEC.md, docs/PENDIENTES_Y_CONTRATO.md y los JSON de design/. Usa los scripts de reference/ para comprender la estructura y el contenido de los frames, y los archivos de assets/ como recursos gráficos. Si tienes Figma conectado, consulta los enlaces de design/screens.json para contrastar los frames actuales y respeta las instrucciones de las habilidades Figma disponibles.

Después de revisar el repositorio y sus instrucciones existentes:

1. Explica brevemente cómo transformarás el diseño en widgets reutilizables y qué decisiones siguen pendientes. Adapta la solución a la estructura ya existente; evita sustituir la arquitectura sin necesidad.
2. Para Sprint 1, prepara el tema, los componentes base, el shell responsive y la navegación. Prioriza acceso, dashboard y objetos como primeras pantallas, y deja las rutas del resto previstas en la estructura. El alcance de implementación detallada de otros sprints se acordará por separado.
3. Usa los colores y estilos de tokens.json. Reutiliza botones, campos, tarjetas, indicadores, badges y mensajes. La tipografía de referencia es Roboto; documenta cómo se resuelve en las plataformas acordadas antes de incorporar fuentes.
4. Trabaja con repositorios mock separados de la UI. Trata demo-data.json como ejemplos y mantén coherencia al registrar objetos, revisar reclamos o entregar objetos. Deriva los indicadores de los datos cuando corresponda. Usa el ID del registro seleccionado al navegar al detalle.
5. Implementa layouts que se adapten al espacio disponible. Valida los anchos de referencia 390, 834 y 1440 y evita desbordamientos al cambiar el ancho o el tamaño del texto. Incluye scroll, foco y navegación por teclado donde corresponda.
6. Corrige al implementar los problemas de texto multilínea y campos descritos en PENDIENTES_Y_CONTRATO.md. Muestra cargas, errores y vacío en las pantallas afectadas. No copies las alturas defectuosas de los scripts.
7. No inventes endpoints, credenciales, políticas de permisos ni reglas definitivas de aprobación. Deja las dudas del contrato de datos para revisarlas con Dayron y el Product Owner.
8. Ejecuta los análisis y verificaciones pertinentes del proyecto. Comprueba navegación, validación de formularios y los layouts en los tamaños acordados. Indica qué implementaste y qué falta. No marques requisitos ni tareas de sprints como cumplidos sin su validación.

El código JS de los frames es una referencia de diseño; el código de la aplicación debe ser Dart/Flutter. Las acciones del prototipo son simulaciones de navegación y deben convertirse en comportamiento real o mock coherente.
