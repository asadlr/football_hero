// lib\theme\app_colors.dart

import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF3498DB);
  static const Color secondary = Color(0xFF2ECC71);
  static const Color accent = Color(0xFFE74C3C);
  
  // Base vibrant colors
  static const Color primaryBlue = Color(0xFF2979FF);
  static const Color vibrantGreen = Color(0xFF00E676);
  static const Color energeticOrange = Color(0xFFFF9100);
  static const Color brightPurple = Color(0xFFAA00FF);
  static const Color livelyPink = Color(0xFFFF4081);
  
  // Card background colors - semi-transparent
  static const Color achievements = Color.fromRGBO(25, 99, 184, 0.867); // Light blue with 85% opacity
  static const Color team = Color(0xDDF0FFF0);         // Light green with 85% opacity
  static const Color events = Color(0xDDFFF8E1);       // Light amber with 85% opacity
  static const Color news = Color(0xDDF8BBD0);         // Light pink with 85% opacity
  
  // Gradient definitions
  static final LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primary.withOpacity(0.7)],
  );
  
  static final LinearGradient blueGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryBlue, primaryBlue.withOpacity(0.7)],
  );
  
  static final LinearGradient greenGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [vibrantGreen, vibrantGreen.withOpacity(0.7)],
  );
  
  static final LinearGradient orangeGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [energeticOrange, energeticOrange.withOpacity(0.7)],
  );
  
  static final LinearGradient purpleGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [brightPurple, brightPurple.withOpacity(0.7)],
  );
  
  static final LinearGradient pinkGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [livelyPink, livelyPink.withOpacity(0.7)],
  );
  
  // Achievement box colors
  static const Color challengesBox = Color(0x552979FF); // Blue with transparency
  static const Color starsBox = Color(0x55FF9100);      // Orange with transparency
  static const Color profileBox = Color.fromRGBO(236, 255, 246, 0.333);    // Green with transparency
}