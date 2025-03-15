import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class AppConfig {
  static const String appName = 'Football Hero';
  
  static const List<Locale> supportedLocales = [
    Locale('he', ''),
    Locale('en', ''),
  ];
  
  static const Locale defaultLocale = Locale('he', '');
  
  static const localizationsDelegates = [
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];
}