import 'package:flutter/material.dart';

import 'app_colors.dart';

ThemeData buildAppTheme(Brightness brightness) {
  final isDark = brightness == Brightness.dark;
  final bg = isDark ? AppColors.backgroundDark : AppColors.backgroundLight;
  final fg = isDark ? AppColors.foregroundDark : AppColors.foregroundLight;
  final card = isDark ? AppColors.cardDark : AppColors.cardLight;
  final mutedFg = isDark ? AppColors.mutedForegroundDark : AppColors.mutedForegroundLight;
  final border = isDark ? AppColors.borderDark : AppColors.borderLight;
  final primary = isDark ? AppColors.primaryDarkMode : AppColors.primary;

  final radius = BorderRadius.circular(16);

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
      error: isDark ? const Color(0xFFF87171) : AppColors.destructive,
    ),
    scaffoldBackgroundColor: bg,
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
        side: BorderSide(color: border.withValues(alpha: 0.5)),
      ),
    ),
    dividerColor: border,
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: isDark ? AppColors.mutedDark : Colors.white,
      border: OutlineInputBorder(borderRadius: radius, borderSide: BorderSide(color: border)),
      enabledBorder: OutlineInputBorder(borderRadius: radius, borderSide: BorderSide(color: border)),
      focusedBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(color: primary, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      hintStyle: TextStyle(color: mutedFg),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(0, 48),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        // Use finite min width: Size.fromHeight uses infinite width and breaks buttons inside Row.
        minimumSize: const Size(0, 48),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(borderRadius: radius),
        elevation: 0,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: fg,
        minimumSize: const Size(0, 48),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        side: BorderSide(color: border),
        shape: RoundedRectangleBorder(borderRadius: radius),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: primary),
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: fg, fontSize: 16, height: 1.5),
      bodyMedium: TextStyle(color: fg, fontSize: 14, height: 1.5),
      bodySmall: TextStyle(color: mutedFg, fontSize: 12, height: 1.4),
      titleLarge: TextStyle(color: fg, fontSize: 22, fontWeight: FontWeight.bold),
      titleMedium: TextStyle(color: fg, fontSize: 18, fontWeight: FontWeight.w600),
      labelLarge: TextStyle(color: fg, fontSize: 14, fontWeight: FontWeight.w500),
    ),
  );
}
