import '../models/lost_object.dart';
import 'objects_repository.dart';

class DemoObjectsRepository implements ObjectsRepository {
  const DemoObjectsRepository();

  @override
  Future<List<LostObject>> loadObjects() async => objects;

  // Datos ficticios para desarrollar y verificar el frontend sin backend.
  static final objects = [
    LostObject(
      reference: 'OBJ-001',
      foundAt: DateTime(2026, 10, 5, 10, 35),
      name: 'Mochila negra',
      description: 'Mochila negra con dos compartimentos y cierre frontal.',
      location: 'Zona de cajas',
      iconName: 'backpack',
      category: ObjectCategory.accessories,
      status: ObjectStatus.inCustody,
    ),
    LostObject(
      reference: 'OBJ-002',
      foundAt: DateTime(2026, 10, 4, 17, 20),
      name: 'Llaves con llavero azul',
      description: 'Juego de llaves con llavero azul.',
      location: 'Atención al Cliente',
      category: ObjectCategory.accessories,
      status: ObjectStatus.claimed,
      iconName: 'key-round',
    ),
    LostObject(
      reference: 'OBJ-003',
      foundAt: DateTime(2026, 10, 4, 15, 10),
      name: 'Billetera marrón',
      description: 'Billetera marrón encontrada en la tienda.',
      location: 'Pasillo de abarrotes',
      category: ObjectCategory.accessories,
      iconName: 'wallet',
      status: ObjectStatus.inCustody,
    ),
    LostObject(
      reference: 'OBJ-004',
      foundAt: DateTime(2026, 10, 3, 11, 5),
      name: 'Celular gris',
      description:
          'Teléfono gris entregado a su propietario en la demostración.',
      location: 'Ingreso principal',
      category: ObjectCategory.electronics,
      iconName: 'smartphone',
      status: ObjectStatus.returned,
    ),
    LostObject(
      reference: 'OBJ-005',
      foundAt: DateTime(2026, 10, 2, 9, 40),
      name: 'Mochila azul',
      description: 'Mochila azul de tela.',
      location: 'Zona de estacionamiento',
      category: ObjectCategory.accessories,
      status: ObjectStatus.inCustody,
      iconName: 'backpack',
    ),
    LostObject(
      reference: 'OBJ-006',
      foundAt: DateTime(2026, 10, 1, 16, 45),
      name: 'Llaves plateadas',
      description: 'Juego de llaves plateadas entregado en la demostración.',
      location: 'Zona de cajas',
      category: ObjectCategory.accessories,
      status: ObjectStatus.returned,
      iconName: 'key-round',
    ),
  ];
}
