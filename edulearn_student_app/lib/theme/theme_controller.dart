import 'package:flutter/material.dart';

/// App-wide theme toggle (splash of Home / Profile match React `ThemeToggle`).
final appThemeController = ThemeController();

class ThemeController extends ChangeNotifier {
  ThemeMode _mode = ThemeMode.light;

  ThemeMode get mode => _mode;

  bool get isDark => _mode == ThemeMode.dark;

  void toggle() {
    _mode = _mode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void setLight() {
    _mode = ThemeMode.light;
    notifyListeners();
  }
}
