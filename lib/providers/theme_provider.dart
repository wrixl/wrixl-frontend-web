// lib\providers\theme_provider.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Holds the current [ThemeMode] and notifies listeners on change,
/// persisting the user’s choice to SharedPreferences.
class ThemeProvider extends ChangeNotifier {
  static const _prefKey = 'isLightMode';

  ThemeMode _mode;

  /// Initialize from persisted preference.
  ThemeProvider({bool isLightMode = false})
      : _mode = isLightMode ? ThemeMode.light : ThemeMode.dark;

  ThemeMode get mode => _mode;
  bool get isDark => _mode == ThemeMode.dark;

  /// Toggles between light & dark (or forces one).
  Future<void> toggle([bool? forceLight]) async {
    if (forceLight != null) {
      _mode = forceLight ? ThemeMode.light : ThemeMode.dark;
    } else {
      _mode = isDark ? ThemeMode.light : ThemeMode.dark;
    }
    notifyListeners();

    // Persist the new setting:
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefKey, _mode == ThemeMode.light);
  }

  /// Load saved preference.
  static Future<ThemeProvider> load() async {
    final prefs = await SharedPreferences.getInstance();
    final isLight = prefs.getBool(_prefKey) ?? false;
    return ThemeProvider(isLightMode: isLight);
  }
}
