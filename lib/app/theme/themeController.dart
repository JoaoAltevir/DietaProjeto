import 'package:flutter/material.dart';

class ThemeController extends ChangeNotifier {
  bool _isDark = false;

  bool get isDark => _isDark;

  ThemeMode get themeMode =>
      _isDark ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme(bool value) {
    _isDark = value;
    notifyListeners();
  }
}