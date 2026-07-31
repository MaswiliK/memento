// lib/app/theme.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/constants/app_colors.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    scaffoldBackgroundColor: AppColors.background,

    colorScheme: const ColorScheme.dark(
      primary: AppColors.accent,
      secondary: AppColors.accent,
      surface: AppColors.surface,
    ),

    // ------------------------------------------------
    // APP BAR
    // ------------------------------------------------
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      surfaceTintColor: Colors.transparent,
    ),

    // ------------------------------------------------
    // CARDS
    // ------------------------------------------------
    cardTheme: const CardThemeData(
      color: AppColors.card,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
    ),

    // ------------------------------------------------
    // BUTTONS
    // ------------------------------------------------
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.accent,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(58),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
    ),

    // ------------------------------------------------
    // INPUTS
    // ------------------------------------------------
    inputDecorationTheme: const InputDecorationTheme(
      border: InputBorder.none,
      enabledBorder: InputBorder.none,
      focusedBorder: InputBorder.none,
      hintStyle: TextStyle(color: AppColors.textSecondary, fontSize: 17),
    ),

    // ------------------------------------------------
    // TEXT SELECTION
    // ------------------------------------------------
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: AppColors.accent,
      selectionColor: Color(0x665A8DFF),
      selectionHandleColor: AppColors.accent,
    ),

    // ------------------------------------------------
    // RIPPLE
    // ------------------------------------------------
    splashFactory: InkRipple.splashFactory,
    splashColor: const Color(0x225A8DFF),
    highlightColor: Colors.transparent,

    // ------------------------------------------------
    // PAGE TRANSITIONS
    // ------------------------------------------------
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {TargetPlatform.android: FadeForwardsPageTransitionsBuilder()},
    ),

    // ------------------------------------------------
    // TYPOGRAPHY
    // ------------------------------------------------
    textTheme: GoogleFonts.interTextTheme(
      const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 42,
          fontWeight: FontWeight.bold,
          letterSpacing: -1,
          color: AppColors.textPrimary,
        ),

        headlineMedium: TextStyle(
          fontSize: 34,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),

        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),

        bodyLarge: TextStyle(
          fontSize: 20,
          height: 1.6,
          color: AppColors.textPrimary,
        ),

        bodyMedium: TextStyle(
          fontSize: 16,
          height: 1.5,
          color: AppColors.textSecondary,
        ),

        bodySmall: TextStyle(fontSize: 13, color: AppColors.textSecondary),

        labelLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    ),
  );
}
