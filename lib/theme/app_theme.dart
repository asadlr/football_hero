// lib/theme/app_theme.dart

import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Centralized theme configuration for FootballHero app
class AppTheme {
  // Prevent instantiation
  AppTheme._();
  
  /// Get the main ThemeData for the application
  static ThemeData get theme {
    return ThemeData(
      // Primary colors
      primaryColor: AppColors.primaryBlue,
      primaryColorLight: Color.fromRGBO(0, 160, 254, 0.7),
      primaryColorDark: AppColors.primaryBlue,
      
      // Scaffold background
      scaffoldBackgroundColor: AppColors.background,
      
      // App bar theme
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        foregroundColor: AppColors.textPrimary,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
        titleTextStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 20.0,
          fontWeight: FontWeight.w600,
          fontFamily: 'VarelaRound',
        ),
      ),
      
      // Color scheme
      colorScheme: ColorScheme(
        primary: AppColors.primaryBlue,
        secondary: AppColors.primaryGreen,
        surface: Colors.white,
        // Using surface instead of background (fixing deprecation)
        background: Colors.white,
        error: AppColors.primaryRed,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.textPrimary,
        // Using onSurface instead of onBackground (fixing deprecation)
        onBackground: AppColors.textPrimary,
        onError: Colors.white,
        brightness: Brightness.light,
      ),
      
      // Text themes
      fontFamily: 'VarelaRound',
      textTheme: _buildTextTheme(),
      
      // Card themes
      cardTheme: CardTheme(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        color: Color.fromRGBO(255, 255, 255, AppColors.cardOpacity),
        margin: const EdgeInsets.all(8.0),
        clipBehavior: Clip.antiAlias,
      ),
      
      // Bottom Navigation Bar theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primaryBlue,
        unselectedItemColor: AppColors.textSecondary,
        selectedLabelStyle: const TextStyle(
          fontSize: 12.0,
          fontWeight: FontWeight.w500,
          fontFamily: 'VarelaRound',
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 12.0,
          fontFamily: 'VarelaRound',
        ),
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        elevation: 8.0,
      ),
      
      // Elevated Button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: AppColors.primaryBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 12.0,
          ),
          elevation: 2.0,
          textStyle: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
            fontFamily: 'VarelaRound',
          ),
        ),
      ),
      
      // Text Button theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0, 
            vertical: 12.0,
          ),
          textStyle: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
            fontFamily: 'VarelaRound',
          ),
        ),
      ),
      
      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        fillColor: Colors.white,
        filled: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 12.0,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: AppColors.divider,
            width: 1.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: AppColors.divider,
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: AppColors.primaryBlue,
            width: 2.0,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: AppColors.primaryRed,
            width: 1.0,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: AppColors.primaryRed,
            width: 2.0,
          ),
        ),
        hintStyle: TextStyle(
          color: Color.fromRGBO(127, 140, 141, 0.7),
          fontSize: 14.0,
          fontFamily: 'VarelaRound',
        ),
        labelStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 16.0,
          fontFamily: 'VarelaRound',
        ),
      ),

      // FloatingActionButton theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
        elevation: 4.0,
        extendedPadding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 12.0,
        ),
      ),
    );
  }
  
  /// Build custom text theme with VarelaRound font family
  static TextTheme _buildTextTheme() {
    const String fontFamily = 'VarelaRound';
    
    return const TextTheme(
      // Large titles
      displayLarge: TextStyle(
        fontSize: 28.0, 
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
        fontFamily: fontFamily,
      ),
      displayMedium: TextStyle(
        fontSize: 24.0, 
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
        fontFamily: fontFamily,
      ),
      displaySmall: TextStyle(
        fontSize: 22.0, 
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
        fontFamily: fontFamily,
      ),
      
      // Headlines
      headlineLarge: TextStyle(
        fontSize: 20.0, 
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        fontFamily: fontFamily,
      ),
      headlineMedium: TextStyle(
        fontSize: 18.0, 
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        fontFamily: fontFamily,
      ),
      headlineSmall: TextStyle(
        fontSize: 16.0, 
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        fontFamily: fontFamily,
      ),
      
      // Body text
      bodyLarge: TextStyle(
        fontSize: 16.0, 
        color: AppColors.textPrimary,
        fontFamily: fontFamily,
      ),
      bodyMedium: TextStyle(
        fontSize: 14.0, 
        color: AppColors.textPrimary,
        fontFamily: fontFamily,
      ),
      bodySmall: TextStyle(
        fontSize: 12.0, 
        color: AppColors.textSecondary,
        fontFamily: fontFamily,
      ),
      
      // Label text
      labelLarge: TextStyle(
        fontSize: 16.0, 
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
        fontFamily: fontFamily,
      ),
      labelMedium: TextStyle(
        fontSize: 14.0, 
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
        fontFamily: fontFamily,
      ),
      labelSmall: TextStyle(
        fontSize: 12.0, 
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
        fontFamily: fontFamily,
      ),
      
      // Title text (added for completeness)
      titleLarge: TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
        fontFamily: fontFamily,
      ),
      titleMedium: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
        fontFamily: fontFamily,
      ),
      titleSmall: TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
        fontFamily: fontFamily,
      ),
    );
  }
  
  // Card styling helpers
  
  /// Standard card margin
  static const EdgeInsets cardMargin = EdgeInsets.all(8.0);
  
  /// Standard card padding
  static const EdgeInsets cardPadding = EdgeInsets.all(16.0);
  
  /// Standard card border radius
  static const double cardBorderRadius = 15.0;
  
  /// Standard card elevation
  static const double cardElevation = 4.0;
  
  /// Apply consistent opacity to card background color
  static Color applyCardOpacity(Color? backgroundColor) {
    if (backgroundColor == null) {
      return Color.fromRGBO(255, 255, 255, AppColors.cardOpacity);
    }
    return Color.fromRGBO(
      backgroundColor.red,
      backgroundColor.green,
      backgroundColor.blue,
      AppColors.cardOpacity
    );
  }
  
  /// Get standard card decoration
  static BoxDecoration standardCardDecoration({Color? backgroundColor}) {
    return BoxDecoration(
      color: applyCardOpacity(backgroundColor),
      borderRadius: BorderRadius.circular(cardBorderRadius),
      boxShadow: const [
        BoxShadow(
          color: Color.fromRGBO(0, 0, 0, 0.1),
          blurRadius: 4,
          offset: Offset(0, 2),
        ),
      ],
    );
  }
  
  // Size constants
  
  /// Standard icon size
  static const double iconSize = 24.0;
  
  /// Small icon size
  static const double iconSizeSmall = 16.0;
  
  /// Large icon size
  static const double iconSizeLarge = 32.0;
  
  /// Standard spacing between elements
  static const double spacing = 8.0;
  
  /// Double spacing for larger gaps
  static const double spacingDouble = 16.0;
  
  /// Triple spacing for sections
  static const double spacingTriple = 24.0;
  
  // Role-specific styling
  
  /// Get color based on user role
  static Color getRoleColor(String role) {
    return AppColors.getRoleColor(role);
  }
  
  /// Get gradient based on user role
  static LinearGradient getRoleGradient(String role) {
    return AppColors.getRoleGradient(role);
  }
  
  /// Get card color based on role
  static Color getRoleCardColor(String role) {
    final Color baseColor = getRoleColor(role);
    return Color.fromRGBO(
      baseColor.red,
      baseColor.green,
      baseColor.blue,
      0.12
    ); // Light background for cards
  }
  
  // RTL support
  
  /// Get text direction based on locale
  static TextDirection getTextDirection(Locale locale) {
    if (locale.languageCode == 'he' || locale.languageCode == 'ar') {
      return TextDirection.rtl;
    }
    return TextDirection.ltr;
  }
  
  /// Get alignment based on locale for RTL support
  static Alignment getStartAlignment(Locale locale) {
    return getTextDirection(locale) == TextDirection.rtl 
        ? Alignment.centerRight 
        : Alignment.centerLeft;
  }
  
  /// Get alignment based on locale for RTL support
  static Alignment getEndAlignment(Locale locale) {
    return getTextDirection(locale) == TextDirection.rtl 
        ? Alignment.centerLeft 
        : Alignment.centerRight;
  }
  
  // Generate home screen card colors based on user role
  static Map<String, Color> getCardColorsForRole(String role) {
    final baseColor = getRoleColor(role);
    
    return {
      'achievements': baseColor,
      'team': AppColors.primaryGreen,
      'events': AppColors.primaryAmber,
      'news': AppColors.primaryRed,
    };
  }
}