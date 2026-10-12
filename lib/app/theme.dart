import 'package:flutter/material.dart';

abstract final class MakroColors {
  static const blue = Color(0xFF0036B3);
  static const yellow = Color(0xFFFFF200);
  static const page = Color(0xFFF5F8FF);
  static const ink = Color(0xFF14234B);
  static const muted = Color(0xFF566580);
  static const line = Color(0xFFDCE5F4);
  static const softBlue = Color(0xFFEAF0FF);
}

ThemeData buildAppTheme() {
  return ThemeData(
    useMaterial3: true,
    fontFamily: 'Roboto',
    scaffoldBackgroundColor: MakroColors.page,
    colorScheme: ColorScheme.fromSeed(seedColor: MakroColors.blue).copyWith(
      primary: MakroColors.blue,
      surface: Colors.white,
      onSurface: MakroColors.ink,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: MakroColors.blue,
      foregroundColor: Colors.white,
      toolbarHeight: 72,
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: MakroColors.line),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: MakroColors.yellow,
        foregroundColor: MakroColors.blue,
        minimumSize: const Size(48, 48),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: MakroColors.line),
      ),
    ),
  );
}
