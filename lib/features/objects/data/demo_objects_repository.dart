import '../models/lost_object.dart';
import 'objects_repository.dart';

class DemoObjectsRepository implements ObjectsRepository {
  const DemoObjectsRepository();

  @override
  Future<List<LostObject>> loadObjects() async => objects;

  // Datos ficticios para desarrollar y verificar el frontend sin backend.
  static final objects = [
    LostObject(
      reference: 'OBJ-0001',
      foundAt: DateTime(2026, 10, 1, 10, 30),
      name: 'Mochila azul',
      description: 'Mochila de tela con cierre frontal.',
      location: 'Área de cajas',
      category: ObjectCategory.accessories,
      status: ObjectStatus.inCustody,
    ),
    LostObject(
      reference: 'OBJ-0002',
      foundAt: DateTime(2026, 10, 2, 10, 30),
      name: 'Teléfono móvil',
      description: 'Teléfono negro con funda transparente.',
      location: 'Atención al cliente',
      category: ObjectCategory.electronics,
      status: ObjectStatus.inCustody,
    ),
    LostObject(
      reference: 'OBJ-0003',
      foundAt: DateTime(2026, 10, 3, 10, 30),
      name: 'Documento de identidad',
      description: 'Documento encontrado en la tienda.',
      location: 'Entrada principal',
      category: ObjectCategory.documents,
      status: ObjectStatus.inCustody,
    ),
    LostObject(
      reference: 'OBJ-0004',
      foundAt: DateTime(2026, 10, 4, 10, 30),
      name: 'Llaves',
      description: 'Juego de llaves con llavero rojo.',
      location: 'Estacionamiento',
      category: ObjectCategory.accessories,
      status: ObjectStatus.returned,
    ),
    LostObject(
      reference: 'OBJ-0005',
      foundAt: DateTime(2026, 10, 5, 10, 30),
      name: 'Audífonos',
      description: 'Audífonos inalámbricos en su estuche.',
      location: 'Área de cajas',
      category: ObjectCategory.electronics,
      status: ObjectStatus.returned,
    ),
    LostObject(
      reference: 'OBJ-0006',
      foundAt: DateTime(2026, 10, 6, 10, 30),
      name: 'Paraguas',
      description: 'Paraguas plegable de color gris.',
      location: 'Entrada principal',
      category: ObjectCategory.other,
      status: ObjectStatus.inCustody,
    ),
  ];
}
