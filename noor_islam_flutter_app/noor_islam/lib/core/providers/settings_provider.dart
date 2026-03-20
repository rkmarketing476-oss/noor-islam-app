import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  final SharedPreferences _prefs;

  SettingsProvider(this._prefs) {
    _load();
  }

  // ── State ──────────────────────────────────────────────────
  bool _isDark = false;
  String _language = 'en'; // 'en' | 'bn'
  String _fontFamily = 'Lato'; // UI font
  Color _themeColor = const Color(0xFF1B8A5A);
  double _glassOpacity = 0.15;
  bool _animationsEnabled = true;
  bool _showTransliteration = true;
  bool _showTranslation = true;

  // ── Getters ────────────────────────────────────────────────
  bool get isDark => _isDark;
  String get language => _language;
  bool get isBangla => _language == 'bn';
  String get fontFamily => _fontFamily;
  Color get themeColor => _themeColor;
  double get glassOpacity => _glassOpacity;
  bool get animationsEnabled => _animationsEnabled;
  bool get showTransliteration => _showTransliteration;
  bool get showTranslation => _showTranslation;

  ThemeMode get themeMode => _isDark ? ThemeMode.dark : ThemeMode.light;

  // ── Load ───────────────────────────────────────────────────
  void _load() {
    _isDark = _prefs.getBool('isDark') ?? false;
    _language = _prefs.getString('language') ?? 'en';
    _fontFamily = _prefs.getString('fontFamily') ?? 'Lato';
    final colorVal = _prefs.getInt('themeColor');
    if (colorVal != null) _themeColor = Color(colorVal);
    _glassOpacity = _prefs.getDouble('glassOpacity') ?? 0.15;
    _animationsEnabled = _prefs.getBool('animationsEnabled') ?? true;
    _showTransliteration = _prefs.getBool('showTransliteration') ?? true;
    _showTranslation = _prefs.getBool('showTranslation') ?? true;
  }

  // ── Setters ────────────────────────────────────────────────
  Future<void> setDarkMode(bool value) async {
    _isDark = value;
    await _prefs.setBool('isDark', value);
    notifyListeners();
  }

  Future<void> setLanguage(String lang) async {
    _language = lang;
    await _prefs.setString('language', lang);
    notifyListeners();
  }

  Future<void> setFontFamily(String font) async {
    _fontFamily = font;
    await _prefs.setString('fontFamily', font);
    notifyListeners();
  }

  Future<void> setThemeColor(Color color) async {
    _themeColor = color;
    await _prefs.setInt('themeColor', color.value);
    notifyListeners();
  }

  Future<void> setGlassOpacity(double value) async {
    _glassOpacity = value;
    await _prefs.setDouble('glassOpacity', value);
    notifyListeners();
  }

  Future<void> setAnimationsEnabled(bool value) async {
    _animationsEnabled = value;
    await _prefs.setBool('animationsEnabled', value);
    notifyListeners();
  }

  Future<void> setShowTransliteration(bool value) async {
    _showTransliteration = value;
    await _prefs.setBool('showTransliteration', value);
    notifyListeners();
  }

  Future<void> setShowTranslation(bool value) async {
    _showTranslation = value;
    await _prefs.setBool('showTranslation', value);
    notifyListeners();
  }
}
