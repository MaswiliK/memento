import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    scaffoldBackgroundColor: const Color(0xFF0D0D0D),

    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFFFF8A3D),
      brightness: Brightness.dark,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
    ),

    cardTheme: const CardThemeData(color: Color(0xFF171717), elevation: 0),
  );
}
