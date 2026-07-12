import 'package:flutter/material.dart';

/// Matches [Student Mobile App UI/src/styles/theme.css] light and dark tokens.
abstract final class AppColors {
  static const Color primary = Color(0xFF6366F1);
  static const Color primaryDarkMode = Color(0xFF818CF8);
  static const Color purple600 = Color(0xFF9333EA);

  static const Color backgroundLight = Color(0xFFF8F9FB);
  static const Color foregroundLight = Color(0xFF1A1D29);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color mutedLight = Color(0xFFF1F5F9);
  static const Color mutedForegroundLight = Color(0xFF64748B);
  static const Color borderLight = Color(0xFFE2E8F0);
  static const Color inputLight = Color(0xFFE2E8F0);

  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color destructive = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  static const Color backgroundDark = Color(0xFF0F1116);
  static const Color foregroundDark = Color(0xFFF1F5F9);
  static const Color cardDark = Color(0xFF1A1D29);
  static const Color mutedDark = Color(0xFF1E293B);
  static const Color mutedForegroundDark = Color(0xFF94A3B8);
  static const Color borderDark = Color(0xFF334155);
}
