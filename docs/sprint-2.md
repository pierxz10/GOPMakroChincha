# Sprint 2 · Pantallas de objetos, búsqueda y filtros

Responsable frontend: Airton · Developer 1. Objetivo: Android y web con adaptación desde el inicio.

## Primer incremento

Base Flutter y listado funcional con datos ficticios. Búsqueda y filtros operan en memoria sobre esos datos. No hay autenticación, persistencia, registro, edición, eliminación, devolución real ni integración con una API en este incremento.

Los campos de ejemplo (código, nombre, descripción, ubicación, categoría y estado) son hipótesis de trabajo; no constituyen un contrato de API aprobado.

## Próximos pasos

1. Completar las compilaciones web y Android. La resolución de dependencias, el análisis sin problemas, las 19 pruebas y el inicio en Chrome fueron confirmados por Airton el 07/10/2026; se incluye `pubspec.lock`.
2. Revisar los frames de objetos, búsqueda y filtros del archivo Figma y confirmar el recorrido de pantallas.
3. Sustituir el tema provisional por colores, tipografía, espaciado y recursos verificados del diseño.
4. Ajustar categorías, estados y campos a los requisitos del equipo.
5. Acordar el contrato de API y agregar una implementación de `ObjectsRepository`.
6. Verificar Android real/emulado, navegador, teclado y escalado de texto; capturar evidencias de aceptación.

Figma de referencia: https://www.figma.com/design/O4gcl0QTTDip5xw2vHRThr/Makro-Chincha-%C2%B7-Objetos-perdidos-%C2%B7-Mockups-y-prototipo?node-id=0-1

## Coordinación con backend

Flutter utiliza Dart; el servidor puede utilizar otro lenguaje. Debemos acordar URL por entorno, autenticación, campos y tipos del objeto, valores de categoría/estado, formato de errores y la forma de buscar, filtrar, ordenar y paginar.

El contrato actual `loadObjects()` sirve para la demostración local. Si la API ofrece búsqueda/filtros/paginación en servidor, el contrato debe ampliarse; no se debe descargar todo el inventario para filtrarlo localmente en producción.

## Criterios propuestos de aceptación

- RNF-01: ejecutar y demostrar las funciones en Android y web.
- RNF-02: mantener coherencia con los frames aprobados; comprobar búsqueda, combinación de filtros, limpieza y estados vacíos/error.
- RNF-07: comprobar que el contenido sigue siendo utilizable al cambiar ancho, orientación y escala de texto, sin desbordamientos.

Las 19 pruebas automatizadas y el inicio en Chrome fueron confirmados en el entorno local del desarrollador. La aceptación completa de estos criterios sigue pendiente: falta verificar Android y la fidelidad a Figma, además de completar las comprobaciones manuales de uso.
