import 'package:flutter_test/flutter_test.dart';
import 'package:gop_makro_chincha/features/auth/session_controller.dart';
import 'package:gop_makro_chincha/features/objects/data/demo_objects_repository.dart';
import 'package:gop_makro_chincha/features/objects/models/lost_object.dart';
import 'package:gop_makro_chincha/features/objects/presentation/objects_controller.dart';

void main() {
  test('matriz de permisos: tres perfiles internos y visitante', () {
    expect(UserRole.administrator.canManageUsers, isTrue);
    expect(UserRole.supervisor.canManageUsers, isFalse);
    expect(UserRole.supervisor.canReviewClaims, isTrue);
    expect(UserRole.supervisor.canViewReports, isTrue);
    expect(UserRole.responsible.canReviewClaims, isFalse);
    expect(UserRole.responsible.canViewReports, isFalse);
    expect(UserRole.responsible.canRegister, isTrue);
    expect(UserRole.visitor.canRegister, isFalse);
    expect(UserRole.visitor.canManageUsers, isFalse);
    expect(UserRole.visitor.canViewReports, isFalse);
  });
  test(
    'el acceso requiere una cuenta válida y el cierre elimina la sesión',
    () {
      final session = SessionController();
      addTearDown(session.dispose);
      expect(session.signIn('admin.demo', 'incorrecta'), isFalse);
      expect(session.role, isNull);
      expect(
        session.signIn(' ADMIN.DEMO ', SessionController.demoPassword),
        isTrue,
      );
      expect(session.role, UserRole.administrator);
      session.signOut();
      expect(session.role, isNull);
      expect(session.canOpen('/objetos'), isFalse);
    },
  );
  test(
    'catálogo público: datos redactados y búsqueda sin información interna',
    () async {
      final objects = ObjectsController(const DemoObjectsRepository());
      addTearDown(objects.dispose);
      await objects.load();
      objects.setPublicMode(true);
      expect(objects.visibleObjects.length, 3);
      expect(objects.visibleObjects.every((o) => o.location.isEmpty), isTrue);
      expect(objects.visibleObjects.every((o) => o.foundAt!.hour == 0), isTrue);
      objects.setQuery('negra');
      expect(objects.visibleObjects, isEmpty);
      objects.setQuery('OBJ-001');
      expect(objects.visibleObjects, isEmpty);
      objects.setQuery('mochila');
      expect(objects.visibleObjects.length, 2);
    },
  );
  test('visitante no registra y no abre el dashboard', () async {
    final session = SessionController();
    final objects = ObjectsController(const DemoObjectsRepository());
    addTearDown(session.dispose);
    addTearDown(objects.dispose);
    await objects.load();
    session.enterAsVisitor();
    final object = DemoObjectsRepository.objects.first;
    expect(session.registerObject(objects, object), isFalse);
    expect(objects.allObjects.length, 6);
    expect(session.canOpen('/inicio'), isFalse);
    expect(session.canOpen('/filtros'), isTrue);
  });
  test('los documentos no aparecen en el catálogo público', () async {
    final objects = ObjectsController(const DemoObjectsRepository());
    addTearDown(objects.dispose);
    await objects.load();
    objects.addObject(
      const LostObject(
        reference: 'DOC-001',
        name: 'Documento',
        description: 'Información interna',
        location: 'Custodia interna',
        category: ObjectCategory.documents,
        status: ObjectStatus.inCustody,
      ),
    );
    objects.setPublicMode(true);
    expect(objects.visibleObjects.length, 3);
    expect(
      objects.visibleObjects.where(
        (o) => o.category == ObjectCategory.documents,
      ),
      isEmpty,
    );
  });
}
