import 'package:flutter/material.dart';
import 'package:rbc_flutter_professional/core/theme/app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    final base = ThemeData(
      useMaterial3: true,
      fontFamily: 'SolaimanLipi',
      scaffoldBackgroundColor: RbcColors.surface,
      colorScheme: const ColorScheme.light(
        primary: RbcColors.primary,
        secondary: RbcColors.accent,
        surface: RbcColors.surface,
        onPrimary: RbcColors.surface,
        onSecondary: RbcColors.primary,
        onSurface: RbcColors.primary,
        error: RbcColors.primary,
        onError: RbcColors.surface,
      ),
    );

    return base.copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: RbcColors.primary,
        foregroundColor: RbcColors.surface,
        centerTitle: true,
        elevation: 0,
        titleTextStyle: TextStyle(
          fontFamily: 'SolaimanLipi',
          color: RbcColors.surface,
          fontSize: 19,
          fontWeight: FontWeight.w900,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: RbcColors.primary,
        contentTextStyle: const TextStyle(
          fontFamily: 'SolaimanLipi',
          color: RbcColors.surface,
          fontWeight: FontWeight.w700,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        behavior: SnackBarBehavior.floating,
      ),
      cardTheme: CardThemeData(
        color: RbcColors.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: RbcColors.primary,
          foregroundColor: RbcColors.surface,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          textStyle: const TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: RbcColors.primary,
          side: BorderSide(color: RbcColors.primary.withOpacity(.25)),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          textStyle: const TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: RbcColors.surface,
        hintStyle: TextStyle(color: RbcColors.primary.withOpacity(.55)),
        labelStyle: const TextStyle(color: RbcColors.primary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: RbcColors.primary.withOpacity(.16)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: RbcColors.primary.withOpacity(.16)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: RbcColors.primary, width: 1.4),
        ),
      ),
    );
  }
}
