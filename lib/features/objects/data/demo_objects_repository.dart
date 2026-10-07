import '../models/lost_object.dart';
import 'objects_repository.dart';

class DemoObjectsRepository implements ObjectsRepository {
  const DemoObjectsRepository();

  @override
  Future<List<LostObject>> loadObjects() async => objects;

  // Datos ficticios para desarrollar y verificar el frontend sin backend.
  static const objects = [
    LostObject(
      reference: 'OBJ-0001',
      name: 'Mochila azul',
      description: 'Mochila de tela con cierre frontal.',
      location: 'Área de cajas',
      category: ObjectCategory.accessories,
      status: ObjectStatus.inCustody,
    ),
    LostObject(
      reference: 'OBJ-0002',
      name: 'Teléfono móvil',
      description: 'Teléfono negro con funda transparente.',
      location: 'Atención al cliente',
      category: ObjectCategory.electronics,
      status: ObjectStatus.inCustody,
    ),
    LostObject(
      reference: 'OBJ-0003',
      name: 'Documento de identidad',
      description: 'Documento encontrado en la tienda.',
      location: 'Entrada principal',
      category: ObjectCategory.documents,
      status: ObjectStatus.inCustody,
    ),
    LostObject(
      reference: 'OBJ-0004',
      name: 'Llaves',
      description: 'Juego de llaves con llavero rojo.',
      location: 'Estacionamiento',
      category: ObjectCategory.accessories,
      status: ObjectStatus.returned,
    ),
    LostObject(
      reference: 'OBJ-0005',
      name: 'Audífonos',
      description: 'Audífonos inalámbricos en su estuche.',
      location: 'Área de cajas',
      category: ObjectCategory.electronics,
      status: ObjectStatus.returned,
    ),
    LostObject(
      reference: 'OBJ-0006',
      name: 'Paraguas',
      description: 'Paraguas plegable de color gris.',
      location: 'Entrada principal',
      category: ObjectCategory.other,
      status: ObjectStatus.inCustody,
    ),
  ];
}
