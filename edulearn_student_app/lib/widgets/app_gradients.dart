import 'package:flutter/material.dart';

abstract final class AppGradients {
  static const LinearGradient primaryHeader = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF6366F1), Color(0xFF9333EA)],
  );

  static const Map<String, LinearGradient> presets = {
    'from-orange-500 to-red-600': LinearGradient(
      colors: [Color(0xFFF97316), Color(0xFFDC2626)],
    ),
    'from-green-500 to-emerald-600': LinearGradient(
      colors: [Color(0xFF22C55E), Color(0xFF059669)],
    ),
    'from-blue-500 to-indigo-600': LinearGradient(
      colors: [Color(0xFF3B82F6), Color(0xFF4F46E5)],
    ),
    'from-purple-500 to-pink-600': LinearGradient(
      colors: [Color(0xFFA855F7), Color(0xFFDB2777)],
    ),
    'from-orange-500 to-red-600-thumb': LinearGradient(
      colors: [Color(0xFFF97316), Color(0xFFDC2626)],
    ),
  };

  static LinearGradient tailwind(String name) => presets[name] ?? primaryHeader;
}
