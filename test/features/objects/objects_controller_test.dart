import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:gop_makro_chincha/features/objects/data/demo_objects_repository.dart';
import 'package:gop_makro_chincha/features/objects/data/objects_repository.dart';
import 'package:gop_makro_chincha/features/objects/models/lost_object.dart';
import 'package:gop_makro_chincha/features/objects/presentation/objects_controller.dart';

void main() {
  late ObjectsController controller;

  setUp(() {
    controller = ObjectsController(const DemoObjectsRepository());
  });
  tearDown(() => controller.dispose());

  test('busca sin distinguir mayúsculas, tildes ni espacios extra', () async {
    await controller.load();
    controller.setQuery('  TELEFONO   movil  ');
    expect(controller.visibleObjects.single.reference, 'OBJ-0002');
  });

  test('busca por código y ubicación', () async {
    await controller.load();
    controller.setQuery('obj-0004');
    expect(controller.visibleObjects.single.name, 'Llaves');
    controller.setQuery('area cajas');
    expect(controller.visibleObjects.length, 2);
  });

  test('combina lugar y fechas inclusivas y permite limpiarlos', () async {
    await controller.load();
    controller.setLocation('AREA cajas');
    controller.setDateRange(DateTime(2026, 10, 1), DateTime(2026, 10, 1));
    expect(controller.visibleObjects.single.reference, 'OBJ-0001');
    controller.setDateRange(DateTime(2026, 10, 5), DateTime(2026, 10, 5));
    expect(controller.visibleObjects.single.reference, 'OBJ-0005');
    controller.setQuery('mochila');
    expect(controller.visibleObjects, isEmpty);
    controller.clearFilters();
    expect(controller.hasFilters, isFalse);
    expect(controller.visibleObjects.length, 6);
  });

  test('combina categoría, estado y búsqueda como una intersección', () async {
    await controller.load();
    controller.setCategory(ObjectCategory.electronics);
    controller.setStatus(ObjectStatus.inCustody);
    expect(controller.visibleObjects.single.reference, 'OBJ-0002');
    controller.setQuery('audifonos');
    expect(controller.visibleObjects, isEmpty);
  });

  test('limpiar filtros recupera el conjunto completo', () async {
    await controller.load();
    controller.setQuery('sin coincidencias');
    controller.setCategory(ObjectCategory.documents);
    controller.setStatus(ObjectStatus.returned);
    controller.clearFilters();
    expect(controller.hasFilters, isFalse);
    expect(controller.visibleObjects.length, 6);
  });

  test('permite reintentar después de un error de carga', () async {
    final repository = _FailOnceRepository();
    final retryController = ObjectsController(repository);
    addTearDown(retryController.dispose);
    await retryController.load();
    expect(retryController.hasError, isTrue);
    expect(retryController.isLoading, isFalse);
    await retryController.load();
    expect(retryController.hasError, isFalse);
    expect(retryController.visibleObjects.length, 6);
  });

  test(
    'completar una carga tras dispose no notifica al widget eliminado',
    () async {
      final repository = _PendingRepository();
      final pendingController = ObjectsController(repository);
      final load = pendingController.load();
      pendingController.dispose();
      repository.result.complete(DemoObjectsRepository.objects);
      await expectLater(load, completes);
    },
  );
}

class _FailOnceRepository implements ObjectsRepository {
  bool _failed = false;

  @override
  Future<List<LostObject>> loadObjects() async {
    if (!_failed) {
      _failed = true;
      throw StateError('Fallo de prueba');
    }
    return DemoObjectsRepository.objects;
  }
}

class _PendingRepository implements ObjectsRepository {
  final result = Completer<List<LostObject>>();

  @override
  Future<List<LostObject>> loadObjects() => result.future;
}
