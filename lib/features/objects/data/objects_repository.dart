import '../models/lost_object.dart';

abstract interface class ObjectsRepository {
  Future<List<LostObject>> loadObjects();
}
