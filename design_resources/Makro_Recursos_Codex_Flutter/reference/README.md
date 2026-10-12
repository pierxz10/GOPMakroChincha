# Código de construcción de Figma

Estos tres archivos son copias del código que se utilizó para crear el diseño. Conservan los valores y la estructura original; no son una exportación automática actual del documento ni código Dart.

| Archivo | Contenido y dependencias |
| --- | --- |
| figma-foundations.js | Variables de color, geometría, estilos de texto y páginas. Requiere figma, createVariableCollection y createSemanticTokens del entorno utilizado. |
| figma-components.js | Componentes, variantes, logo e iconos. Requiere STATE.foundations, ASSETS y createComponentWithVariants. |
| figma-views.js | Pantallas y conexiones. Requiere STATE.foundations, STATE.components, STATE.frames y CURRENT = desktop, tablet o mobile. |

Algunas funciones, como figma.createAutoLayout y los helpers anteriores, pertenecen al entorno del conector utilizado. Los archivos incluyen await y return a nivel del cuerpo de ejecución. No se deben copiar directamente como plugin Figma estándar ni ejecutar como Node/Flutter sin adaptar ese entorno.

Para Codex, leerlos como referencia: tx describe texto, al describe un contenedor con auto layout, field un campo, button una acción, object una tarjeta, shell la estructura adaptable y tap una conexión. Esos conceptos se pueden traducir a Text, Column/Row/Wrap, TextFormField, botones, tarjetas, shell de navegación y callbacks/rutas de Flutter.

Los scripts no incluyen todos los parches posteriores aplicados a las tarjetas e iconos; las correcciones conocidas y pendientes están en docs/PENDIENTES_Y_CONTRATO.md. Los JSON de design/ permiten revisar el contenido sin ejecutar los scripts. Si Figma es accesible, contrastar los frames y componentes actuales allí.
