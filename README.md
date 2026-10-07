# GOP Makro Chincha · Frontend Flutter

Base inicial del Sprint 2: listado de objetos, búsqueda y filtros. Plataformas objetivo: **Android y web**.

## Estado de esta entrega

- Pantalla de objetos con datos ficticios claramente identificados.
- Búsqueda local por nombre, código, descripción y ubicación, tolerante a mayúsculas y tildes.
- Filtros combinables por categoría y estado; limpieza de búsqueda y filtros.
- Estados de carga, error con reintento y colección vacía.
- Contenido desplazable, chips que fluyen según el ancho y ancho máximo en escritorio.
- Repositorio inyectable para conectar la API cuando se acuerde con backend.

**El tema es Material provisional. No se ha implementado ni validado la apariencia de Figma.** El conector devolvió un límite de consultas. Categorías, estados y campos de ejemplo requieren confirmación con diseño y backend.

## Ejecutar

Entorno encontrado: Flutter **3.47.6**, Dart **3.13.5**. El paquete requiere Dart >=3.11 y Flutter >=3.41; esos mínimos todavía no se han probado.

Desde una terminal local en este repositorio:

```powershell
flutter pub get
flutter run -d chrome
```

Para Android, iniciar un emulador o conectar un dispositivo con depuración USB:

```powershell
flutter devices
flutter run -d <id-del-dispositivo>
```

No se han configurado identificadores definitivos ni firma de producción. `com.example.gop_makro_chincha` es provisional. Los iconos son los predeterminados de Flutter.

## Estructura

```text
lib/
  main.dart
  app/                         Aplicación y tema
  shared/widgets/              Contenedor responsive
  features/objects/
    models/                    Modelo provisional y búsqueda
    data/                      Contrato de repositorio y datos de demostración
    presentation/              Pantalla, controlador y widgets
test/features/objects/         Pruebas de lógica e interfaz
docs/                          Alcance y coordinación del sprint
android/                       Configuración Android/Kotlin
web/                           Entrada web
```

## Validar antes de integrar

```powershell
dart format lib test
flutter analyze
flutter test
flutter build web
flutter build apk --debug
```

Las pruebas cubren búsqueda y filtros combinados, limpieza, reintento, eliminación durante una carga, redimensionamiento y tamaños 320×568, 360×800, 768×1024, 1440×900 y 1920×1080 con texto a escala 1 y 2.

**Validación local del 07/10/2026:** Airton ejecutó `flutter pub get`, `flutter analyze`, `flutter test` y `flutter run -d chrome`. El análisis terminó sin problemas, las **19 pruebas pasaron** y la aplicación inició en Chrome; se aportó una captura del listado. Se incluye `pubspec.lock` para fijar las dependencias resueltas.

Quedan pendientes las compilaciones de distribución, la ejecución en Android y la comparación visual con Figma. El runtime de Flutter/Dart sigue sin poder ejecutarse dentro del aislamiento de Codex; los resultados anteriores corresponden al entorno local del desarrollador.

Las carpetas Android/web se prepararon a partir de las plantillas oficiales del SDK instalado, al fallar `flutter create`. Gradle, AGP y Kotlin coinciden con ese SDK. Android requiere que `flutter run` genere `android/local.properties` con las rutas locales del SDK; ese archivo se ignora en Git. No se modificó código del SDK.
