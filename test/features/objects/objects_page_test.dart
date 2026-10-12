import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gop_makro_chincha/app/app.dart';
import 'package:gop_makro_chincha/features/auth/session_controller.dart';
import 'package:gop_makro_chincha/features/objects/data/demo_objects_repository.dart';

void main() {
  const screens = ['/', '/inicio', '/objetos', '/filtros'];
  const sizes = [
    Size(320, 568),
    Size(390, 844),
    Size(834, 1112),
    Size(1440, 1000),
  ];
  for (final size in sizes) {
    for (final scale in [1.0, 2.0]) {
      for (final screen in screens) {
        testWidgets('responsive $screen · $size · texto x$scale', (
          tester,
        ) async {
          tester.view.devicePixelRatio = 1;
          tester.view.physicalSize = size;
          tester.platformDispatcher.textScaleFactorTestValue = scale;
          addTearDown(tester.view.resetDevicePixelRatio);
          addTearDown(tester.view.resetPhysicalSize);
          addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
          await tester.pumpWidget(
            GopApp(
              repository: const DemoObjectsRepository(),
              initialRole: screen == '/' ? null : UserRole.responsible,
            ),
          );
          await tester.pumpAndSettle();
          if (screen == '/objetos' || screen == '/filtros') {
            tester
                .state<NavigatorState>(find.byType(Navigator).first)
                .pushNamed(screen);
            await tester.pumpAndSettle();
          }
          expect(tester.takeException(), isNull);
          for (var i = 0; i < 3; i++) {
            await tester.drag(
              find
                  .byWidgetPredicate(
                    (w) =>
                        w is Scrollable &&
                        w.axisDirection == AxisDirection.down,
                  )
                  .last,
              const Offset(0, -350),
            );
            await tester.pumpAndSettle();
            expect(tester.takeException(), isNull);
          }
        });
      }
    }
  }

  for (final entry in SessionController.demoAccounts.entries) {
    testWidgets('ingresa y cierra sesión como ${entry.value.label}', (
      tester,
    ) async {
      await tester.pumpWidget(
        const GopApp(repository: DemoObjectsRepository()),
      );
      await tester.pumpAndSettle();
      final chip = find.widgetWithText(ActionChip, entry.value.label);
      await tester.ensureVisible(chip);
      await tester.pumpAndSettle();
      await tester.tap(chip);
      final submit = find.byKey(const ValueKey('login-submit'));
      await tester.ensureVisible(submit);
      await tester.pumpAndSettle();
      await tester.tap(submit);
      await tester.pumpAndSettle();
      expect(find.text('Buen día, equipo'), findsOneWidget);
      expect(find.byKey(const ValueKey('metric-Registrados')), findsOneWidget);
      final logout = find.byKey(const ValueKey('session-exit'));
      await tester.tap(logout);
      await tester.pumpAndSettle();
      expect(find.text('Bienvenido'), findsOneWidget);
      expect(find.text('Buen día, equipo'), findsNothing);
    });
  }

  testWidgets('visitante sin cuenta: catálogo limitado y rutas protegidas', (
    tester,
  ) async {
    await tester.pumpWidget(const GopApp(repository: DemoObjectsRepository()));
    await tester.pumpAndSettle();
    final visitor = find.byKey(const ValueKey('guest-entry'));
    await tester.ensureVisible(visitor);
    await tester.pumpAndSettle();
    await tester.tap(visitor);
    await tester.pumpAndSettle();
    expect(find.text('3 objetos disponibles'), findsOneWidget);
    expect(find.byKey(const ValueKey('register-object')), findsNothing);
    expect(find.text('Mochila negra'), findsNothing);
    expect(find.text('OBJ-001 · Accesorios'), findsNothing);
    expect(find.text('Zona de cajas'), findsNothing);
    tester
        .state<NavigatorState>(find.byType(Navigator).first)
        .pushNamed('/inicio');
    await tester.pumpAndSettle();
    expect(find.text('Acceso no autorizado'), findsOneWidget);
    expect(find.text('Buen día, equipo'), findsNothing);
  });

  testWidgets('búsqueda y filtros se aplican y se conservan al redimensionar', (
    tester,
  ) async {
    await tester.pumpWidget(
      const GopApp(
        repository: DemoObjectsRepository(),
        initialRole: UserRole.responsible,
      ),
    );
    await tester.pumpAndSettle();
    tester
        .state<NavigatorState>(find.byType(Navigator).first)
        .pushNamed('/objetos');
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('open-filters')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('filter-query')),
      'mochila',
    );
    await tester.ensureVisible(find.byKey(const ValueKey('apply-filters')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('apply-filters')));
    await tester.pumpAndSettle();
    expect(find.text('2 objetos registrados'), findsOneWidget);
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<TextField>(find.byKey(const ValueKey('objects-search')))
          .controller!
          .text,
      'mochila',
    );
    await tester.ensureVisible(find.text('Limpiar filtros'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Limpiar filtros'));
    await tester.pumpAndSettle();
    expect(find.text('6 objetos registrados'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('usuario equivocado no obtiene acceso', (tester) async {
    await tester.pumpWidget(const GopApp(repository: DemoObjectsRepository()));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('login-user')),
      'no-existe',
    );
    await tester.enterText(
      find.byKey(const ValueKey('login-password')),
      'incorrecta',
    );
    final submit = find.byKey(const ValueKey('login-submit'));
    await tester.ensureVisible(submit);
    await tester.pumpAndSettle();
    await tester.tap(submit);
    await tester.pumpAndSettle();
    expect(
      find.text(
        'Usuario o contraseña incorrectos. Usa una cuenta de demostración.',
      ),
      findsOneWidget,
    );
    expect(find.text('Buen día, equipo'), findsNothing);
  });

  testWidgets('un registro actualiza el dashboard y el listado', (
    tester,
  ) async {
    await tester.pumpWidget(
      const GopApp(
        repository: DemoObjectsRepository(),
        initialRole: UserRole.responsible,
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Registrar objeto'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('new-object-name')),
      'Mochila de prueba',
    );
    await tester.ensureVisible(
      find.byKey(const ValueKey('new-object-location')),
    );
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('new-object-location')),
      'Entrada principal',
    );
    await tester.ensureVisible(
      find.byKey(const ValueKey('new-object-description')),
    );
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('new-object-description')),
      'Mochila de tela con cierre frontal.',
    );
    await tester.tap(find.text('Guardar objeto'));
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<Text>(find.byKey(const ValueKey('metric-Registrados')))
          .data,
      '7',
    );
    tester
        .state<NavigatorState>(find.byType(Navigator).first)
        .pushNamed('/objetos');
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('objects-search')),
      'Mochila de prueba',
    );
    await tester.pumpAndSettle();
    expect(find.text('1 objeto registrado'), findsOneWidget);
    await tester.ensureVisible(find.byKey(const ValueKey('OBJ-007')));
    await tester.pumpAndSettle();
    expect(
      find.descendant(
        of: find.byKey(const ValueKey('OBJ-007')),
        matching: find.text('Mochila de prueba'),
      ),
      findsOneWidget,
    );
  });
}
