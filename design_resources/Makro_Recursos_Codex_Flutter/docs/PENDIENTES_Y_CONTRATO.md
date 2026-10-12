# Pendientes y contrato de datos

## Estado de la referencia

Se construyeron 60 mockups editables y conexiones de prototipo. El registro local del trabajo del 5 de octubre dejó pendientes: wireframes grises en la página 01, ajustes de textos multilínea, variantes verdaderas de campos multilínea, separación del encabezado de acceso y puntos de inicio del prototipo con nombre. El paquete de continuación preparado posteriormente no fue aplicado en Figma. No se ha actualizado la lectura remota para este handoff.

Por eso no se debe presentar esta referencia como una primera entrega aprobada ni marcar la tarea de bocetos como concluida sin revisión del equipo.

## Ajustes al pasar a Flutter

- Los títulos multilínea del dashboard y el panel de login pueden superponerse al subtítulo por alturas fijadas en los scripts. Calcular la altura natural del texto.
- Las instancias de descripción intentaban ocupar 154 de alto, pero su caja base permanecía en 44. Crear un campo multilínea real que use minLines/maxLines o tamaño adaptable.
- El encabezado de login necesita separación de 24 entre el logo y el título.
- Se corrigieron en Figma el escalado de vectores, las etiquetas de estado y el ancho adaptable del texto de las tarjetas después del primer script de componentes. Los scripts conservan el contenido original y no todas esas correcciones posteriores. Usar los tokens, SVG y especificación para reconstruirlos correctamente.
- Todas las tarjetas del prototipo abren Mochila negra. La app debe resolver cada detalle mediante el ID seleccionado.
- Los gráficos, métricas y fechas son ejemplos. Actualizarlos desde los datos del repositorio y revisar el significado del periodo de reporte.
- Los espacios para firmas son elementos visuales; no implican una captura de firma ni generación de PDF ya implementadas.

## Decisiones que debe acordar el equipo

| Tema | Definición necesaria |
| --- | --- |
| Plataformas RNF-01 | Android, iOS, web o escritorio que realmente se entregarán y probarán. |
| Autenticación | Identificador de acceso, sesión, cierre de sesión y manejo de credenciales. |
| Objetos | Campos obligatorios, catálogos, identificadores y estados permitidos. |
| Fotografías | Formato, tamaño, carga, almacenamiento y URL/identificador de imagen. |
| Búsqueda | Criterios, combinación de filtros, paginación y orden. |
| Reclamos | Datos necesarios, verificación, aprobación/rechazo y quién puede hacerlo. |
| Entrega | Regla de conformidad, firmantes, confirmación y restricciones después de entregar. |
| Constancia | Código, formato, descarga o impresión y conservación. |
| Reportes | Periodo, fuente de cada indicador y exportaciones requeridas. |
| Administración | Roles reales, permisos y gestión de usuarios. |
| Errores | Formato de error general, errores por campo y respuesta de sesión expirada. |
| Fechas | Zona horaria, formato de intercambio y formato visual local. |

## Handoff con Dayron

No hay URLs de API aprobadas en el material de esta entrega. `demo-data.json` ofrece ejemplos para pensar modelos de objetos, reclamos y entregas; no representa el JSON definitivo de ningún endpoint.

Para cada operación, acordar método y ruta, request, response, error y permisos. Operaciones previstas: iniciar sesión, listar/buscar objetos, registrar/actualizar/ver objeto, cargar fotografía, listar/crear/revisar reclamo, confirmar entrega, obtener constancia, consultar reportes y administrar usuarios. Conservar un repositorio mock con la misma interfaz que el futuro repositorio remoto para poder reemplazarlo sin reescribir las pantallas.

Las cadenas de documento y teléfono enmascaradas deben mostrarse como texto de ejemplo o datos de lectura. Para probar validaciones, usar fixtures ficticios definidos por el equipo; no tratar los puntos de enmascaramiento como una entrada válida.
