// lib/localization/localization_manager.dart
import 'package:flutter/material.dart';

class LocalizationManager extends ChangeNotifier {
  static final LocalizationManager _instance = LocalizationManager._internal();
  factory LocalizationManager() => _instance;
  
  // Private constructor
  LocalizationManager._internal();
  
  // Current locale with default
  Locale _currentLocale = const Locale('he', '');
  
  // Getters
  Locale get currentLocale => _currentLocale;
  bool get isRTL => _currentLocale.languageCode == 'he' || _currentLocale.languageCode == 'ar';
  TextDirection get textDirection => isRTL ? TextDirection.rtl : TextDirection.ltr;
  
  // Change locale
  void setLocale(Locale locale) {
    if (_currentLocale.languageCode != locale.languageCode) {
      _currentLocale = locale;
      notifyListeners();
    }
  }
}