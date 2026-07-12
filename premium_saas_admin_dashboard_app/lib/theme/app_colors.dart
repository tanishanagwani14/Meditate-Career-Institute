import 'package:flutter/material.dart';

/// Derived from `Premium SaaS Admin Dashboard/src/styles/theme.css` (light + dark).
abstract final class AppColors {
  static const Color primaryLight = Color(0xFF030213);
  static const Color backgroundLight = Color(0xFFFFFFFF);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color mutedLight = Color(0xFFECECF0);
  static const Color mutedForegroundLight = Color(0xFF717182);
  static const Color accentLight = Color(0xFFE9EBEF);
  static const Color borderLight = Color(0x1A000000); // rgba(0,0,0,0.1)
  static const Color inputBgLight = Color(0xFFF3F3F5);
  static const Color destructiveLight = Color(0xFFD4183D);

  static const Color backgroundDark = Color(0xFF1A1A1A); // approximation for oklch(0.145)
  static const Color cardDark = Color(0xFF1A1A1A);
  static const Color mutedDark = Color(0xFF2C2C2C);
  static const Color mutedForegroundDark = Color(0xFFB3B3B3);
  static const Color borderDark = Color(0xFF2C2C2C);
}

