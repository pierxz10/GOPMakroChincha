import 'package:flutter/material.dart';

import 'app/app.dart';
import 'features/objects/data/demo_objects_repository.dart';

void main() {
  runApp(const GopApp(repository: DemoObjectsRepository()));
}
