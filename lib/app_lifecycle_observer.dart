// lib/app_lifecycle_observer.dart
import 'package:flutter/material.dart';
import './config/dependency_injection.dart';

class AppLifecycleObserver with WidgetsBindingObserver {
  AppLifecycleObserver() {
    WidgetsBinding.instance.addObserver(this);
  }
  
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final analyticsService = dependencyInjection.analyticsService;
    
    switch (state) {
      case AppLifecycleState.resumed:
        // App came to the foreground
        analyticsService.trackUserAction('app_resumed');
        break;
      case AppLifecycleState.paused:
        // App went to background
        analyticsService.trackUserAction('app_paused');
        break;
      case AppLifecycleState.detached:
        // App is about to be terminated
        analyticsService.trackAppClose();
        break;
      default:
        break;
    }
  }
  
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
  }
}