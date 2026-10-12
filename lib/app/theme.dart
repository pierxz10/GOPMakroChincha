import 'package:flutter/material.dart';

abstract final class MakroColors {
  static const blue = Color(0xFF0036B3);
  static const yellow = Color(0xFFFFF200);
  static const page = Color(0xFFF5F8FF);
  static const ink = Color(0xFF14234B);
  static const muted = Color(0xFF566580);
  static const line = Color(0xFFDCE5F4);
  static const softBlue = Color(0xFFEAF0FF);
  static const success = Color(0xFF096846);
  static const softSuccess = Color(0xFFEAF7F0);
  static const warning = Color(0xFF805A00);
  static const softWarning = Color(0xFFFFF7DB);
  static const error = Color(0xFFAA213D);
}

ThemeData buildAppTheme() {
  return ThemeData(
    useMaterial3: true,
    fontFamily: 'Roboto',
    scaffoldBackgroundColor: MakroColors.page,
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 40,
        height: 1.2,
        fontWeight: FontWeight.w700,
      ),
      headlineMedium: TextStyle(
        fontSize: 28,
        height: 1.28,
        fontWeight: FontWeight.w700,
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        height: 1.4,
        fontWeight: FontWeight.w700,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        height: 1.5,
        fontWeight: FontWeight.w500,
      ),
      bodyMedium: TextStyle(fontSize: 14, height: 1.57),
      bodySmall: TextStyle(fontSize: 12, height: 1.5),
    ).apply(bodyColor: MakroColors.ink, displayColor: MakroColors.ink),
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(48, 48),
        side: const BorderSide(color: MakroColors.line),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
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
