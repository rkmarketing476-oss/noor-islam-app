import 'package:flutter/material.dart';

class AppColors {
  // Primary palette
  static const Color primaryGreen = Color(0xFF1B8A5A);
  static const Color lightGreen = Color(0xFF2DBE7C);
  static const Color darkGreen = Color(0xFF0F5C3A);
  static const Color accentGold = Color(0xFFD4AF37);

  // Backgrounds
  static const Color bgLight = Color(0xFFF5F7F5);
  static const Color bgDark = Color(0xFF0D1B16);
  static const Color surfaceLight = Colors.white;
  static const Color surfaceDark = Color(0xFF1A2E24);
  static const Color cardDark = Color(0xFF1F3A2B);

  // Text
  static const Color textDark = Color(0xFF1A1A2E);
  static const Color textLight = Color(0xFFF0F4F0);
  static const Color textMuted = Color(0xFF8A9A8E);

  // Glass
  static const Color glassLight = Color(0x20FFFFFF);
  static const Color glassDark = Color(0x15FFFFFF);

  // Gradient presets
  static const List<Color> greenGradient = [Color(0xFF1B8A5A), Color(0xFF0F5C3A)];
  static const List<Color> goldGradient = [Color(0xFFD4AF37), Color(0xFFA07C20)];
  static const List<Color> skyDayGradient = [Color(0xFF87CEEB), Color(0xFF4FC3F7), Color(0xFFFFF176)];
  static const List<Color> skyNightGradient = [Color(0xFF0D1B4B), Color(0xFF1A2A6C), Color(0xFF2D1B69)];
  static const List<Color> skyDuskGradient = [Color(0xFFFF7043), Color(0xFFFF8A65), Color(0xFFFFCC80)];

  static Color getGlassColor(bool isDark) => isDark ? glassDark : glassLight;
}
