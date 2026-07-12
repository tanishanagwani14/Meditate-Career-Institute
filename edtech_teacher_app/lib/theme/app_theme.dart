import 'package:flutter/material.dart';

import 'app_colors.dart';

ThemeData buildAppTheme(Brightness brightness) {
  final isDark = brightness == Brightness.dark;
  final bg = isDark ? AppColors.backgroundDark : AppColors.backgroundLight;
  final fg = isDark ? AppColors.foregroundDark : AppColors.foregroundLight;
  final card = isDark ? AppColors.cardDark : AppColors.cardLight;
  final border = isDark ? AppColors.borderDark : AppColors.borderLight;
  final mutedFg = isDark ? AppColors.mutedForegroundDark : AppColors.mutedForegroundLight;
  final primary = isDark ? AppColors.primaryDark : AppColors.primary;

  final radius = BorderRadius.circular(14); // ~0.75rem

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      brightness: brightness,
      primary: primary,
      onPrimary: Colors.white,
      surface: card,
      onSurface: fg,
      error: AppColors.destructive,
    ),
    scaffoldBackgroundColor: bg,
    dividerColor: border,
    appBarTheme: AppBarTheme(
      backgroundColor: bg,
      foregroundColor: fg,
      elevation: 0,
      scrolledUnderElevation: 0,
    ),
    cardTheme: CardThemeData(
      color: card,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: radius,
        side: BorderSide(color: border),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: isDark ? AppColors.inputBackgroundDark : AppColors.inputBackgroundLight,
      hintStyle: TextStyle(color: mutedFg),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(borderRadius: radius, borderSide: BorderSide(color: border)),
      enabledBorder: OutlineInputBorder(borderRadius: radius, borderSide: BorderSide(color: border)),
      focusedBorder: OutlineInputBorder(borderRadius: radius, borderSide: BorderSide(color: primary, width: 2)),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(0, 44),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(borderRadius: radius),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(0, 44),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        side: BorderSide(color: border),
        shape: RoundedRectangleBorder(borderRadius: radius),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        foregroundColor: primary,
      ),
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: fg, fontSize: 16, height: 1.5),
      bodyMedium: TextStyle(color: fg, fontSize: 14, height: 1.5),
      bodySmall: TextStyle(color: mutedFg, fontSize: 12, height: 1.4),
      titleLarge: TextStyle(color: fg, fontSize: 22, fontWeight: FontWeight.w600),
      titleMedium: TextStyle(color: fg, fontSize: 18, fontWeight: FontWeight.w600),
      labelLarge: TextStyle(color: fg, fontSize: 14, fontWeight: FontWeight.w500),
    ),
  );
}

