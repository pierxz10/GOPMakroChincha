# Makro Chincha · Recursos de diseño para Codex / Flutter

Este paquete reúne el código de construcción de los frames, los tokens, los recursos y el mapa de pantallas del módulo de objetos perdidos. Ayuda a Codex a entender qué interfaz desarrollar.

Diseño: https://www.figma.com/design/O4gcl0QTTDip5xw2vHRThr?node-id=6-77

La referencia corresponde a la construcción del 5 de octubre de 2026: 20 pantallas y estados en escritorio, tablet y móvil, 60 mockups en total. Paquete preparado el 7 de octubre; no se realizó una nueva lectura del archivo remoto. Las ediciones posteriores en Figma deben consultarse directamente.

## Usarlo en Codex

1. Descomprime la carpeta dentro del proyecto o adjunta el ZIP si el entorno permite leer archivos comprimidos.
2. Abre Codex con acceso a esa carpeta.
3. Copia el contenido de `PROMPT_PARA_CODEX.md`. El prompt solicita revisar los recursos y preparar la base de Flutter primero.
4. Usa `design/screens.json` para compartir los enlaces exactos de los frames que vayas a implementar.
5. Revisa la implementación a 390, 834 y 1440 de ancho, y también entre esos tamaños.

Si Figma está conectado mediante su plugin/MCP, Codex puede consultar los frames directamente. Esa conexión debe estar disponible en el Codex donde desarrollarás; compartir solo el enlace no habilita la conexión.

En Codex app, instala Figma desde Plugins y autoriza tu cuenta. Para Codex CLI, la configuración documentada por Figma es:

```bash
codex mcp add figma --url https://mcp.figma.com/mcp
```

Completa la autenticación indicada por el entorno. Si hace falta iniciar OAuth desde CLI: `codex mcp login figma`.

Referencias de configuración:

- https://developers.figma.com/docs/figma-mcp-server/remote-server-installation/
- https://learn.chatgpt.com/docs/extend/mcp?surface=cli

## Qué contiene

| Recurso | Para qué sirve |
| --- | --- |
| `PROMPT_PARA_CODEX.md` | Instrucción lista para iniciar el trabajo en Flutter. |
| `docs/UI_SPEC.md` | Pantallas, componentes, requisitos y comportamiento adaptable. |
| `docs/PENDIENTES_Y_CONTRATO.md` | Ajustes pendientes y decisiones a coordinar con Dayron. |
| `design/tokens.json` | Colores exactos, tipografía, espaciado, radios y sombra. |
| `design/screens.json` | 60 IDs y enlaces de frames, con sus dimensiones de referencia. |
| `design/navigation.json` | Flujo principal y destinos de navegación registrados. |
| `design/demo-data.json` | Datos visuales de demostración para preparar mocks. |
| `reference/*.js` | Código usado para construir fundamentos, componentes y pantallas. |
| `assets/logo/` y `assets/icons/` | Logo PNG y 31 iconos SVG. |
| `manifest.json` | Inventario con hashes para identificar los recursos entregados. |

El JavaScript de referencia describe elementos nativos de Figma; Codex debe traducirlos a widgets Dart. Los scripts son fragmentos del entorno usado para construir el diseño, con dependencias documentadas en `reference/README.md`. El paquete no contiene una aplicación Flutter ejecutable ni una copia nativa `.fig`.

La tipografía usada es Roboto, sustitución de Gruffy/F37Gruffy. No se incluyen archivos de fuentes. Los datos, roles y campos son propuestas que deben revisarse con el equipo. Los RNF se verificarán cuando exista la implementación.
