import 'package:flutter/material.dart';

// Tema Material provisional. Se reemplazará con los tokens verificados de Figma.
ThemeData buildAppTheme() {
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
    ),
  );
}
