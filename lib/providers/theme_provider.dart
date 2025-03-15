// lib/providers/theme_provider.dart
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  
  ThemeMode get themeMode => _themeMode;
  
  // Theme getters for convenience
  ThemeData get lightTheme => AppTheme.getLightTheme();
  ThemeData get darkTheme => AppTheme.getDarkTheme();

  // Constructor
  ThemeProvider() {
    // Initialize with system default
  }

  // Set theme mode (without persistence for now)
  void setThemeMode(ThemeMode mode) {
    if (_themeMode == mode) return;
    
    _themeMode = mode;
    notifyListeners();
  }
  
  // Check if current theme is dark
  bool isDarkMode(BuildContext context) {
    if (_themeMode == ThemeMode.system) {
      return MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    }
    return _themeMode == ThemeMode.dark;
  }
}