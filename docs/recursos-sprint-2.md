# Recursos e implementación del Sprint 2

Fuente: `Makro_Recursos_Codex_Flutter.zip`, extraído en `design_resources/`.
La referencia del paquete corresponde al 05/10/2026; no se ha consultado una revisión remota posterior.

Aplicado al módulo de objetos:

- Logo PNG original y colores de `design/tokens.json`.
- Fondo claro, cabecera azul, campos con borde y tarjetas con indicadores de estado.
- Listado de una, dos o tres columnas según el espacio; una columna con texto ampliado.
- Búsqueda, categoría, estado, lugar del hallazgo y rango de fechas inclusivo.
- Recuperación de filtros, carga, error con reintento y resultados vacíos.

Los seis objetos originales se mantienen para conservar los escenarios existentes; se añadieron fechas ficticias del 1 al 6 de octubre de 2026 para probar el filtro. Los campos y estados siguen siendo provisionales.

Las tarjetas utilizan los SVG originales del paquete con `flutter_svg`; los controles mantienen los iconos Material. Los SVG y sus licencias se conservan en `assets/`. No se incluyen fotografías ni binarios de Roboto en el ZIP. El tema solicita Roboto y utiliza la sustitución disponible en el sistema si no está instalada.

Alcance pendiente: pantalla separada de filtros, navegación global, detalle y registro de objetos, integración API y comparación visual con los frames de Figma. No se presentan acciones de esos módulos como si ya estuvieran implementadas.

Validación del 09/10/2026: `flutter analyze` sin problemas y las 20 pruebas de `flutter test` aprobadas, incluidas búsquedas combinadas con lugar y fechas, limpieza y tamaños desde 320 hasta 1920 con texto normal y ampliado al doble. La ejecución en Android sigue pendiente.
