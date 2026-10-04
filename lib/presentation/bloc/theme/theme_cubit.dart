import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  static const String _themePrefKey = 'user_theme_mode';
  final SharedPreferences prefs;

  ThemeCubit(this.prefs) : super(_loadInitialTheme(prefs));

  static ThemeMode _loadInitialTheme(SharedPreferences prefs) {
    final themeStr = prefs.getString(_themePrefKey);
    if (themeStr == 'light') return ThemeMode.light;
    if (themeStr == 'dark') return ThemeMode.dark;
    return ThemeMode.dark; // Default to Dark Theme as requested
  }

  void setThemeMode(ThemeMode mode) {
    emit(mode);
    switch (mode) {
      case ThemeMode.light:
        prefs.setString(_themePrefKey, 'light');
        break;
      case ThemeMode.dark:
        prefs.setString(_themePrefKey, 'dark');
        break;
      case ThemeMode.system:
        prefs.setString(_themePrefKey, 'system');
        break;
    }
  }
}
