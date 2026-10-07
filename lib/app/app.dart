import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../features/objects/data/objects_repository.dart';
import '../features/objects/presentation/objects_page.dart';
import 'theme.dart';

class GopApp extends StatelessWidget {
  const GopApp({required this.repository, super.key});

  final ObjectsRepository repository;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Objetos perdidos · Makro Chincha',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      locale: const Locale('es', 'PE'),
      supportedLocales: const [Locale('es', 'PE')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      home: ObjectsPage(repository: repository),
    );
  }
}
