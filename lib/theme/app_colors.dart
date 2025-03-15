import 'package:flutter/material.dart';

/// Enum to represent different user roles in the application
enum AppRole {
  player,
  coach,
  parent,
  mentor,
  communityManager
}

/// Centralized color management for the application
class AppColors {
  // Primary Color Palette
  static const Color primaryBlue = Color(0xFF00A0FE);
  static const Color primaryRed = Color(0xFFF61732);
  static const Color primaryAmber = Color(0xFFFDB10E);
  static const Color primaryGreen = Color(0xFF169A13);
  
  // Main Application Colors
  static const Color primary = primaryBlue;
  static const Color secondary = primaryGreen;
  static const Color accent = primaryRed;
  
  // Role-Specific Colors
  static const Color playerColor = primaryBlue;
  static const Color coachColor = primaryGreen;
  static const Color parentColor = primaryAmber;
  static const Color mentorColor = Color(0xFF8E44AD);
  static const Color communityColor = primaryRed;
  
  // Neutral Palette
  static const Color background = Color(0xFFF5F5F5);
  static const Color cardBackground = Colors.white;
  static const Color textPrimary = Color(0xFF2C3E50);
  static const Color textSecondary = Color(0xFF7F8C8D);
  static const Color divider = Color(0xFFE0E0E0);
  
  // Semantic Colors
  static const Color success = primaryGreen;
  static const Color warning = primaryAmber;
  static const Color error = primaryRed;
  static const Color info = primaryBlue;
  
  // Card Background Colors
  static const Color achievements = Color.fromRGBO(0, 160, 254, 0.12);
  static const Color team = Color.fromRGBO(22, 154, 19, 0.12);
  static const Color events = Color.fromRGBO(253, 177, 14, 0.12);
  static const Color news = Color.fromRGBO(246, 23, 50, 0.12);
  
  // Achievement Box Colors
  static const Color challengesBox = Color.fromRGBO(0, 160, 254, 0.33);
  static const Color starsBox = Color.fromRGBO(253, 177, 14, 0.33);
  static const Color profileBox = Color.fromRGBO(22, 154, 19, 0.33);
  
  /// Utility method to create a gradient from a base color
  static LinearGradient _createGradient(Color baseColor) {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [baseColor, baseColor.withOpacity(0.7)],
    );
  }
  
  /// Create a color with specific opacity
  static Color withOpacity(Color color, double opacity) {
    return color.withOpacity(opacity);
  }
  
  // Predefined Gradients
  static final LinearGradient primaryGradient = _createGradient(primaryBlue);
  static final LinearGradient secondaryGradient = _createGradient(primaryGreen);
  static final LinearGradient accentGradient = _createGradient(primaryRed);
  static final LinearGradient amberGradient = _createGradient(primaryAmber);
  
  // Role-Specific Gradients
  static final LinearGradient playerGradient = primaryGradient;
  static final LinearGradient coachGradient = _createGradient(primaryGreen);
  static final LinearGradient parentGradient = _createGradient(primaryAmber);
  static final LinearGradient mentorGradient = _createGradient(mentorColor);
  static final LinearGradient communityGradient = _createGradient(primaryRed);
  
  /// Get color for a specific role
  static Color getRoleColor(AppRole role) {
    return {
      AppRole.player: playerColor,
      AppRole.coach: coachColor,
      AppRole.parent: parentColor,
      AppRole.mentor: mentorColor,
      AppRole.communityManager: communityColor,
    }[role] ?? primary;
  }
  
  /// Get gradient for a specific role
  static LinearGradient getRoleGradient(AppRole role) {
    return {
      AppRole.player: playerGradient,
      AppRole.coach: coachGradient,
      AppRole.parent: parentGradient,
      AppRole.mentor: mentorGradient,
      AppRole.communityManager: communityGradient,
    }[role] ?? primaryGradient;
  }
}