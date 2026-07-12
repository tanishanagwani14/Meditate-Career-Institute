import 'package:flutter/material.dart';

import 'app_colors.dart';

ThemeData buildAppTheme(Brightness brightness) {
  final isDark = brightness == Brightness.dark;
  final bg = isDark ? AppColors.backgroundDark : AppColors.backgroundLight;
  final card = isDark ? AppColors.cardDark : AppColors.cardLight;
  final border = isDark ? AppColors.borderDark : AppColors.borderLight;
  final muted = isDark ? AppColors.mutedForegroundDark : AppColors.mutedForegroundLight;
  final primary = isDark ? Colors.white : AppColors.primaryLight;

  final radius = BorderRadius.circular(12); // 0.625rem-ish

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      brightness: brightness,
      primary: primary,
      onPrimary: isDark ? Colors.black : Colors.white,
      surface: card,
      onSurface: isDark ? Colors.white : const Color(0xFF111827),
      error: isDark ? const Color(0xFFEF4444) : AppColors.destructiveLight,
    ),
    scaffoldBackgroundColor: bg,
    dividerColor: border,
    cardTheme: CardThemeData(
      color: card,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: radius, side: BorderSide(color: border)),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: card,
      foregroundColor: isDark ? Colors.white : const Color(0xFF111827),
      elevation: 0,
      scrolledUnderElevation: 0,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: isDark ? AppColors.mutedDark : AppColors.inputBgLight,
      hintStyle: TextStyle(color: muted),
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
  );
}

