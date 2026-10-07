import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gop_makro_chincha/app/app.dart';
import 'package:gop_makro_chincha/features/objects/data/demo_objects_repository.dart';
import 'package:gop_makro_chincha/features/objects/data/objects_repository.dart';
import 'package:gop_makro_chincha/features/objects/models/lost_object.dart';

void main() {
  const sizes = [
    Size(320, 568),
    Size(360, 800),
    Size(768, 1024),
    Size(1440, 900),
    Size(1920, 1080),
  ];

  for (final size in sizes) {
    for (final scale in [1.0, 2.0]) {
      testWidgets('sin desbordamientos: $size, texto x$scale', (tester) async {
        tester.view.devicePixelRatio = 1;
        tester.view.physicalSize = size;
        addTearDown(tester.view.resetDevicePixelRatio);
        addTearDown(tester.view.resetPhysicalSize);
        await tester.pumpWidget(
          GopApp(
            repository: const DemoObjectsRepository(),
            // El escalado del sistema se inyecta en la aplicación de prueba.
            key: ValueKey('$size-$scale'),
          ),
        );
        await tester.pumpAndSettle();
        if (scale != 1) {
          tester.platformDispatcher.textScaleFactorTestValue = scale;
          addTearDown(
            tester.platformDispatcher.clearTextScaleFactorTestValue,
          );
          await tester.pumpAndSettle();
        }
        expect(tester.takeException(), isNull);
        await tester.scrollUntilVisible(
          find.text('Paraguas'),
          200,
          scrollable: find.byType(Scrollable).first,
        );
        expect(find.text('Paraguas'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    }
  }

  testWidgets('búsqueda y categoría conservan su estado al redimensionar', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1440, 900);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpWidget(
      const GopApp(repository: DemoObjectsRepository()),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ChoiceChip, 'Electrónicos'));
    await tester.enterText(
      find.byKey(const ValueKey('objects-search')),
      'telefono',
    );
    await tester.pumpAndSettle();
    tester.view.physicalSize = const Size(360, 800);
    await tester.pumpAndSettle();
    expect(
      tester.widget<TextField>(
        find.byKey(const ValueKey('objects-search')),
      ).controller!.text,
      'telefono',
    );
    expect(
      tester.widget<ChoiceChip>(
        find.widgetWithText(ChoiceChip, 'Electrónicos'),
      ).selected,
      isTrue,
    );
    await tester.scrollUntilVisible(
      find.text('Teléfono móvil'),
      150,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Teléfono móvil'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('muestra un resultado vacío y permite limpiar la búsqueda', (
    tester,
  ) async {
    await tester.pumpWidget(
      const GopApp(repository: DemoObjectsRepository()),
    );
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('objects-search')),
      'objeto inexistente',
    );
    await tester.pumpAndSettle();
    final message = find.text(
      'No encontramos objetos con esa búsqueda y esos filtros.',
    );
    await tester.ensureVisible(message);
    expect(message, findsOneWidget);
    final clear = find.text('Limpiar filtros');
    await tester.ensureVisible(clear);
    await tester.tap(clear);
    await tester.pumpAndSettle();
    expect(find.text('6 objetos'), findsOneWidget);
  });

  testWidgets('distingue una colección vacía de una búsqueda sin resultados', (
    tester,
  ) async {
    await tester.pumpWidget(
      const GopApp(repository: _EmptyRepository()),
    );
    await tester.pumpAndSettle();
    expect(find.text('Aún no hay objetos registrados.'), findsOneWidget);
  });
}

class _EmptyRepository implements ObjectsRepository {
  const _EmptyRepository();

  @override
  Future<List<LostObject>> loadObjects() async => const [];
}
