import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

class AppTheme {
  static ThemeData light({Color primary = AppColors.primaryGreen, String fontFamily = 'Lato'}) {
    final base = _baseText(fontFamily, false);
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        brightness: Brightness.light,
        primary: primary,
        secondary: AppColors.accentGold,
        background: AppColors.bgLight,
        surface: AppColors.surfaceLight,
      ),
      scaffoldBackgroundColor: AppColors.bgLight,
      textTheme: base,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: base.titleLarge?.copyWith(
          color: AppColors.textDark,
          fontWeight: FontWeight.w700,
        ),
        iconTheme: const IconThemeData(color: AppColors.textDark),
      ),
      cardTheme: CardTheme(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: primary,
        unselectedItemColor: AppColors.textMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
    );
  }

  static ThemeData dark({Color primary = AppColors.primaryGreen, String fontFamily = 'Lato'}) {
    final base = _baseText(fontFamily, true);
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        brightness: Brightness.dark,
        primary: primary,
        secondary: AppColors.accentGold,
        background: AppColors.bgDark,
        surface: AppColors.surfaceDark,
      ),
      scaffoldBackgroundColor: AppColors.bgDark,
      textTheme: base,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: base.titleLarge?.copyWith(
          color: AppColors.textLight,
          fontWeight: FontWeight.w700,
        ),
        iconTheme: const IconThemeData(color: AppColors.textLight),
      ),
      cardTheme: CardTheme(
        color: AppColors.cardDark,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.surfaceDark,
        selectedItemColor: AppColors.lightGreen,
        unselectedItemColor: AppColors.textMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
    );
  }

  static TextTheme _baseText(String family, bool isDark) {
    final color = isDark ? AppColors.textLight : AppColors.textDark;
    TextStyle Function(TextStyle) fn;
    try {
      switch (family) {
        case 'Noto Sans Bengali':
          fn = (s) => GoogleFonts.notoSansBengali(textStyle: s);
          break;
        case 'Hind Siliguri':
          fn = (s) => GoogleFonts.hindSiliguri(textStyle: s);
          break;
        case 'Lora':
          fn = (s) => GoogleFonts.lora(textStyle: s);
          break;
        case 'Poppins':
          fn = (s) => GoogleFonts.poppins(textStyle: s);
          break;
        default:
          fn = (s) => GoogleFonts.lato(textStyle: s);
      }
    } catch (_) {
      fn = (s) => s;
    }

    return TextTheme(
      displayLarge: fn(TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: color)),
      displayMedium: fn(TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: color)),
      displaySmall: fn(TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: color)),
      headlineLarge: fn(TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: color)),
      headlineMedium: fn(TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: color)),
      headlineSmall: fn(TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: color)),
      titleLarge: fn(TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: color)),
      titleMedium: fn(TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: color)),
      titleSmall: fn(TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: color)),
      bodyLarge: fn(TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: color)),
      bodyMedium: fn(TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: color)),
      bodySmall: fn(TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: color.withOpacity(0.75))),
      labelLarge: fn(TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: color)),
    );
  }
}
