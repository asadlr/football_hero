// lib\theme\app_colors.dart

import 'package:flutter/material.dart';

class AppColors {
  // New primary palette (from your provided colors)
  static const Color primaryBlue = Color(0xFF00A0FE);  // #00A0FE - Brand main color
  static const Color primaryRed = Color(0xFFF61732);   // #F61732 - Accent/warning color
  static const Color primaryAmber = Color(0xFFFDB10E); // #FDB10E - Secondary accent
  static const Color primaryGreen = Color(0xFF169A13); // #169A13 - Success color
  
  // Main application colors (mapped to new palette)
  static const Color primary = primaryBlue;
  static const Color secondary = primaryGreen;
  static const Color accent = primaryRed;
  
  // Legacy colors (maintained for backward compatibility)
  static const Color legacyBlue = Color(0xFF2979FF);
  static const Color legacyGreen = Color(0xFF00E676);
  static const Color legacyOrange = Color(0xFFFF9100);
  static const Color legacyPurple = Color(0xFFAA00FF);
  static const Color legacyPink = Color(0xFFFF4081);
  
  // Role-specific colors (aligned with new palette)
  static const Color playerColor = primaryBlue;     // Players
  static const Color coachColor = primaryGreen;     // Coaches
  static const Color parentColor = primaryAmber;    // Parents
  static const Color mentorColor = Color(0xFF8E44AD); // Mentors - purple variant
  static const Color communityColor = primaryRed;   // Community managers
  
  // Card background colors - semi-transparent
  static const Color achievements = Color.fromRGBO(0, 160, 254, 0.12); // primaryBlue with 12% opacity
  static const Color team = Color.fromRGBO(22, 154, 19, 0.12);         // primaryGreen with 12% opacity
  static const Color events = Color.fromRGBO(253, 177, 14, 0.12);      // primaryAmber with 12% opacity
  static const Color news = Color.fromRGBO(246, 23, 50, 0.12);         // primaryRed with 12% opacity
  
  // Card opacity - for consistent transparency across all cards
  static const double cardOpacity = 0.85; // 85% opacity for all cards
  
  // Semantic colors
  static const Color success = primaryGreen;
  static const Color warning = primaryAmber;
  static const Color error = primaryRed;
  static const Color info = primaryBlue;
  
  // Neutral palette for backgrounds, text, etc.
  static const Color background = Color(0xFFF5F5F5);
  static const Color cardBackground = Colors.white;
  static const Color textPrimary = Color(0xFF2C3E50);
  static const Color textSecondary = Color(0xFF7F8C8D);
  static const Color divider = Color(0xFFE0E0E0);
  
  // Gradient definitions
  // Main gradients aligned to new palette
  static final LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryBlue, Color.fromRGBO(0, 160, 254, 0.7)],
  );
  
  static final LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryGreen, Color.fromRGBO(22, 154, 19, 0.7)],
  );
  
  static final LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryRed, Color.fromRGBO(246, 23, 50, 0.7)],
  );
  
  static final LinearGradient amberGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryAmber, Color.fromRGBO(253, 177, 14, 0.7)],
  );
  
  // Role-specific gradients
  static final LinearGradient playerGradient = primaryGradient;
  
  static final LinearGradient coachGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryGreen, Color.fromRGBO(22, 154, 19, 0.7)],
  );
  
  static final LinearGradient parentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryAmber, Color.fromRGBO(253, 177, 14, 0.7)],
  );
  
  static final LinearGradient mentorGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF8E44AD), Color.fromRGBO(142, 68, 173, 0.7)],
  );
  
  static final LinearGradient communityGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryRed, Color.fromRGBO(246, 23, 50, 0.7)],
  );
  
  // Legacy gradients (maintained for backward compatibility)
  static final LinearGradient blueGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [legacyBlue, Color.fromRGBO(41, 121, 255, 0.7)],
  );
  
  static final LinearGradient greenGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [legacyGreen, Color.fromRGBO(0, 230, 118, 0.7)],
  );
  
  static final LinearGradient orangeGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [legacyOrange, Color.fromRGBO(255, 145, 0, 0.7)],
  );
  
  static final LinearGradient purpleGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [legacyPurple, Color.fromRGBO(170, 0, 255, 0.7)],
  );
  
  static final LinearGradient pinkGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [legacyPink, Color.fromRGBO(255, 64, 129, 0.7)],
  );
  
  // Achievement box colors (aligned with new palette)
  static const Color challengesBox = Color.fromRGBO(0, 160, 254, 0.33);  // primaryBlue with transparency
  static const Color starsBox = Color.fromRGBO(253, 177, 14, 0.33);      // primaryAmber with transparency
  static const Color profileBox = Color.fromRGBO(22, 154, 19, 0.33);     // primaryGreen with transparency
  
  // Helper methods for getting role-specific colors and gradients
  static Color getRoleColor(String role) {
    switch (role.toLowerCase()) {
      case 'player':
        return playerColor;
      case 'coach':
        return coachColor;
      case 'parent':
        return parentColor;
      case 'mentor':
        return mentorColor;
      case 'community_manager':
        return communityColor;
      default:
        return primary;
    }
  }
  
  static LinearGradient getRoleGradient(String role) {
    switch (role.toLowerCase()) {
      case 'player':
        return playerGradient;
      case 'coach':
        return coachGradient;
      case 'parent':
        return parentGradient;
      case 'mentor':
        return mentorGradient;
      case 'community_manager':
        return communityGradient;
      default:
        return primaryGradient;
    }
  }
}