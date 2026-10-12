# Especificación de interfaz para el handoff

## Contexto y requisitos

Aplicación interna para el personal autorizado de Makro Chincha: registrar hallazgos, encontrar objetos, tramitar reclamos y documentar entregas. Front end: Airton; coordinación de datos: Dayron.

| Requisito | Aplicación al desarrollo |
| --- | --- |
| RNF-01 | Implementar con Flutter y verificar su funcionamiento en las plataformas definidas por el equipo. Las plataformas de despliegue siguen por confirmar. |
| RNF-02 | Acciones claras, etiquetas consistentes, estados visibles, navegación reconocible y mensajes que permitan recuperarse. |
| RNF-07 | Adaptar la composición al tamaño disponible; comprobar móvil, tablet y escritorio como referencias de diseño. |

Los frames documentan una propuesta visual. No prueban por sí solos que Flutter funcione en cada plataforma ni que se hayan cumplido los requisitos.

## Pantallas y estados

| Clave | Nombre en Figma | Contenido |
| --- | --- | --- |
| login | Acceso | Acceso del personal; usuario, contraseña, ingresar. |
| dashboard | Dashboard | Resumen de gestión, registrar objeto y actividad reciente. |
| objects | Objetos | Buscar, filtrar, registrar y abrir tarjetas de objetos. |
| filters | Búsqueda y filtros | Texto, categoría, estado, fechas y lugar del hallazgo. |
| register | Registro de objeto | Nombre, categoría, fecha/hora, descripción, hallazgo, custodia y fotografía. |
| detail | Detalle del objeto | Foto, estado, datos del hallazgo, custodia, descripción e historial. |
| claims | Reclamos | Lista de solicitudes, registrar y revisar reclamo. |
| claim | Registrar reclamo | Identidad, contacto, descripción aportada, observaciones y revisión. |
| approved | Reclamo aprobado | Resumen del reclamo aprobado y continuar a entrega. |
| delivery | Entrega | Persona que recibe, documento, fecha/hora, personal y conformidad. |
| confirm | Confirmar entrega | Confirmación previa al registro de entrega y constancia. |
| receipt | Constancia | Constancia asociada al objeto, datos de entrega y espacios para firmas. |
| reports | Reportes | Periodo, indicadores y comparación de registros/entregas. |
| admin | Administración | Usuarios y perfiles propuestos; crear y editar acceso. |
| userForm | Nuevo usuario | Nombre, correo, perfil, estado y nombre de usuario. |
| loginError | Acceso con error | Estado de error del formulario de acceso. |
| empty | Sin resultados | Estado sin coincidencias; limpiar filtros. |
| failure | Error de conexión | Error de conexión al cargar objetos; reintentar. |
| loading | Cargando objetos | Estado de carga de objetos; indicadores de espera. |
| registerError | Registro con errores | Errores de descripción y lugar en el formulario de objeto. |

Los errores, carga y vacío pueden representarse mediante estados de las pantallas base. `design/screens.json` conserva el ID de cada uno de los 60 frames; sus dimensiones no son restricciones del tamaño de un widget.

## Identidad y componentes

Azul #0036B3 como marca; amarillo #FFF200 para la acción primaria con texto azul; fucsia #EE0099 como acento visual. Para acciones con texto blanco se usó #B90078. Usar los 24 roles semánticos del archivo de tokens, incluidos éxito, advertencia y error. El estado debe indicarse también mediante texto o iconos.

La tipografía usada en los frames es Roboto: tamaños, pesos y alturas de línea están en `design/tokens.json`. Gruffy/F37Gruffy fue la referencia del sitio de Makro; no está incorporada en este paquete.

| Componente del diseño | Variantes y propiedades |
| --- | --- |
| Button | Primary / Secondary / Accent × Default / Hover / Disabled / Loading; Label. |
| Field | Empty / Filled / Error / Disabled; Label, Value y Helper. El campo multilínea necesita una implementación propia con altura adaptable. |
| NavItem | Default / Selected; Label e Icon. |
| Badge | Available / Claim / Delivered / Error; Label. |
| ObjectCard | Expanded / Compact × Available / Claim / Delivered; Name, Code, Location, Date e Icon. |
| Metric | Label, Value e Hint. |
| Logo e iconos | PNG de logo 128 × 31; 31 SVG con viewBox 24 × 24. |
| Mensajes | Banner de éxito, advertencia o error con título, explicación y recuperación cuando corresponda. |

Los títulos y cuerpos deben crecer según el texto. Los campos deben distinguir etiqueta, ayuda y error. Los botones requieren feedback, bloqueo mientras guardan y un área táctil adecuada. Conservar el estilo visual sin bloquear la accesibilidad ni el escalado de texto.

## Responsive

| Referencia | Frame | Composición original |
| --- | --- | --- |
| Móvil | 390 × 844 | Cabecera de 64, navegación inferior de 72, contenido con padding 16, formularios de una columna, tarjetas de una columna. Dashboard de dos columnas. |
| Tablet | 834 × 1112 | Cabecera de 64, barra lateral de 88 con iconos y etiquetas abreviadas, padding 24, formularios y tarjetas de dos columnas. |
| Escritorio | 1440 × 1000 | Cabecera de 72, barra lateral de 240, padding 32, formularios de dos columnas y listado de objetos de tres columnas. Dashboard de cuatro columnas. |

El login usa cabecera de 72 en las tres referencias. En escritorio añade un panel azul de presentación al lado del formulario; tablet y móvil muestran el formulario centrado.

Como propuesta inicial se pueden estudiar cortes en 600 y 1024 unidades lógicas. No son requisitos aprobados ni aparecen como breakpoints en Figma: los scripts generaron tres composiciones independientes. Elegir los cortes con LayoutBuilder y el espacio útil del contenido. Reducir columnas si las tarjetas o los textos no caben; permitir scroll vertical y evitar alturas rígidas en formularios, encabezados y mensajes.

El menú móvil abre Administración en el prototipo; debe revisarse su finalidad y sus permisos antes de replicarlo. Secciones globales: Inicio, Objetos, Reclamos, Reportes y Administración. Los perfiles que ven cada sección todavía deben acordarse.

## Flujos

Flujo principal: acceso → dashboard → objetos → detalle → registrar reclamo → aprobado → entrega → confirmar → constancia. Registro de hallazgo: objetos → registro → detalle. El usuario puede volver o cancelar desde los formularios.

Las conexiones registradas por tablet y móvil están en `design/navigation.json`. El script `reference/figma-views.js` conserva los nombres de las acciones y destinos del diseño. En el prototipo, guardar, aprobar o ingresar solo navegan: no hay servicios ni datos persistidos. Al implementar, cada acción debe usar el repositorio mock o el back end acordado y esperar su resultado antes de mostrar éxito.

## Revisión de implementación

Verificar ausencia de desbordamientos a los tres anchos y entre ellos; textos largos y escalados; formularios desplazables; navegación de ida, vuelta y cancelación; selección del objeto correcto; carga, vacío, error y reintento; validación y mensajes junto al campo; y consistencia de estados y métricas en el mock. La constancia y sus firmas necesitan reglas de negocio acordadas antes de definir su persistencia o exportación.
