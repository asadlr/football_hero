import 'package:flutter/material.dart';
import 'app_colors.dart';

// Moved ThemeConstants to top-level
class ThemeConstants {
  // Consistent spacing
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;

  // Icon sizes with semantic naming
  static const double iconSmall = 16.0;
  static const double iconMedium = 24.0;
  static const double iconLarge = 32.0;

  // Card and component styling
  static const double borderRadius = 15.0;
  static const double cardElevation = 4.0;
  static const double buttonElevation = 2.0;

  // Padding and margins
  static const EdgeInsets cardPadding = EdgeInsets.all(16.0);
  static const EdgeInsets cardMargin = EdgeInsets.all(8.0);
  static const EdgeInsets buttonPadding = EdgeInsets.symmetric(
    horizontal: 16.0,
    vertical: 12.0,
  );

  // Added card opacity constant to replace AppColors reference
  static const double cardOpacity = 0.85;

  static var smTriple;
}

/// Centralized theme configuration for FootballHero app
class AppTheme {
  // Prevent direct instantiation
  const AppTheme._();

  /// Primary application theme
  static ThemeData get theme {
    return ThemeData(
      primaryColor: AppColors.primaryBlue,
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: 'VarelaRound',
      
      // Comprehensive theme configurations
      appBarTheme: _appBarTheme,
      colorScheme: _colorScheme,
      textTheme: _textTheme,
      cardTheme: _cardTheme,
      
      // Component themes
      bottomNavigationBarTheme: _bottomNavBarTheme,
      elevatedButtonTheme: _elevatedButtonTheme,
      textButtonTheme: _textButtonTheme,
      inputDecorationTheme: _inputDecorationTheme,
      floatingActionButtonTheme: _floatingActionButtonTheme,
    );
  }
  
  /// Get light theme method for the provider
  static ThemeData getLightTheme() {
    return theme;
  }
  
  /// Get dark theme method for the provider
  static ThemeData getDarkTheme() {
    return darkTheme;
  }
  
  static ThemeData get darkTheme {
    return ThemeData.dark().copyWith(
      primaryColor: AppColors.primaryBlue,
      scaffoldBackgroundColor: Colors.grey[900],
      
      // Dark theme specific configurations
      colorScheme: ColorScheme.dark(
        primary: AppColors.primaryBlue,
        secondary: AppColors.primaryGreen,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        surface: Colors.grey[850]!,
        onSurface: Colors.white,
        error: AppColors.primaryRed,
        onError: Colors.white,
      ),
      
      // Card theme for dark mode
      cardTheme: _cardTheme.copyWith(
        color: Colors.grey[800]?.withAlpha(217), // 0.85 opacity
      ),
      
      // Text theme for dark mode
      textTheme: _textTheme.apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
      
      // Other components
      appBarTheme: _appBarTheme.copyWith(
        backgroundColor: Colors.grey[900],
        foregroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      
      // Inherit other styles from light theme with dark mode adjustments
      bottomNavigationBarTheme: _bottomNavBarTheme.copyWith(
        backgroundColor: Colors.grey[850],
        selectedItemColor: AppColors.primaryBlue,
        unselectedItemColor: Colors.grey[400],
      ),
    );
  }

  /// Reusable text style generator with sensible defaults
  static TextStyle _textStyle({
    required double fontSize,
    FontWeight? fontWeight,
    Color? color,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight ?? FontWeight.normal,
      color: color ?? AppColors.textPrimary,
      fontFamily: 'VarelaRound',
    );
  }

  /// Comprehensive text theme with semantic naming
  static TextTheme get _textTheme {
    return TextTheme(
      // Display (Large Titles)
      displayLarge: _textStyle(
        fontSize: 28.0, 
        fontWeight: FontWeight.bold,
      ),
      displayMedium: _textStyle(
        fontSize: 24.0, 
        fontWeight: FontWeight.bold,
      ),
      displaySmall: _textStyle(
        fontSize: 22.0, 
        fontWeight: FontWeight.bold,
      ),
      
      // Headlines
      headlineLarge: _textStyle(
        fontSize: 20.0, 
        fontWeight: FontWeight.w600,
      ),
      headlineMedium: _textStyle(
        fontSize: 18.0, 
        fontWeight: FontWeight.w600,
      ),
      headlineSmall: _textStyle(
        fontSize: 16.0, 
        fontWeight: FontWeight.w600,
      ),
      
      // Body Text
      bodyLarge: _textStyle(fontSize: 16.0),
      bodyMedium: _textStyle(fontSize: 14.0),
      bodySmall: _textStyle(
        fontSize: 12.0, 
        color: AppColors.textSecondary,
      ),
      
      // Label Text
      labelLarge: _textStyle(
        fontSize: 16.0, 
        fontWeight: FontWeight.w500,
      ),
      labelMedium: _textStyle(
        fontSize: 14.0, 
        fontWeight: FontWeight.w500,
      ),
      labelSmall: _textStyle(
        fontSize: 12.0, 
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
      ),
      
      // Title Text
      titleLarge: _textStyle(
        fontSize: 20.0, 
        fontWeight: FontWeight.bold,
      ),
      titleMedium: _textStyle(
        fontSize: 16.0, 
        fontWeight: FontWeight.bold,
      ),
      titleSmall: _textStyle(
        fontSize: 14.0, 
        fontWeight: FontWeight.bold,
      ),
    );
  }

  /// Localization and Layout Utilities
  static TextDirection resolveTextDirection(Locale locale) {
    const rtlLanguages = ['he', 'ar'];
    return rtlLanguages.contains(locale.languageCode) 
        ? TextDirection.rtl 
        : TextDirection.ltr;
  }

  /// Alignment based on text direction
  static Alignment resolveStartAlignment(Locale locale) {
    return resolveTextDirection(locale) == TextDirection.rtl 
        ? Alignment.centerRight 
        : Alignment.centerLeft;
  }

  /// End alignment based on text direction
  static Alignment resolveEndAlignment(Locale locale) {
    return resolveTextDirection(locale) == TextDirection.rtl 
        ? Alignment.centerLeft 
        : Alignment.centerRight;
  }

  // Private theme components (extracted for readability)
  static final AppBarTheme _appBarTheme = AppBarTheme(
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
  );

  static final ColorScheme _colorScheme = ColorScheme(
    primary: AppColors.primaryBlue,
    secondary: AppColors.primaryGreen,
    surface: Colors.white,
    background: Colors.white, 
    error: AppColors.primaryRed,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: AppColors.textPrimary,
    onBackground: AppColors.textPrimary,
    onError: Colors.white,
    brightness: Brightness.light,
  );

  static final CardTheme _cardTheme = CardTheme(
    elevation: ThemeConstants.cardElevation,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(ThemeConstants.borderRadius),
    ),
    color: Color.fromRGBO(255, 255, 255, ThemeConstants.cardOpacity),
    margin: ThemeConstants.cardMargin,
    clipBehavior: Clip.antiAlias,
  );

  static final BottomNavigationBarThemeData _bottomNavBarTheme = BottomNavigationBarThemeData(
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
  );

  static final ElevatedButtonThemeData _elevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: AppColors.primaryBlue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      padding: ThemeConstants.buttonPadding,
      elevation: ThemeConstants.buttonElevation,
      textStyle: const TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w600,
        fontFamily: 'VarelaRound',
      ),
    ),
  );

  static final TextButtonThemeData _textButtonTheme = TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.primaryBlue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      padding: ThemeConstants.buttonPadding,
      textStyle: const TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w600,
        fontFamily: 'VarelaRound',
      ),
    ),
  );

  static final InputDecorationTheme _inputDecorationTheme = InputDecorationTheme(
    fillColor: Colors.white,
    filled: true,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: 16.0,
      vertical: 12.0,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide(color: AppColors.divider),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide(color: AppColors.divider),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide(color: AppColors.primaryBlue, width: 2.0),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide(color: AppColors.primaryRed),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide(color: AppColors.primaryRed, width: 2.0),
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
  );

  static final FloatingActionButtonThemeData _floatingActionButtonTheme = FloatingActionButtonThemeData(
    backgroundColor: AppColors.primaryBlue,
    foregroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(50.0),
    ),
    elevation: 4.0,
    extendedPadding: ThemeConstants.buttonPadding,
  );

  /// Apply card opacity to a color
// Replace the empty method implementations at the bottom of the file with these:

/// Apply card opacity to a color
static Color applyCardOpacity(Color color) {
  return color.withOpacity(ThemeConstants.cardOpacity);
}

/// Get card colors for a specific user role
static Map<String, Color> getCardColorsForRole(String role) {
  // Default colors
  Map<String, Color> colors = {
    'primary': AppColors.primary,
    'secondary': AppColors.secondary,
    'accent': AppColors.accent,
  };
  
  // Assign colors based on role
  switch (role.toLowerCase()) {
    case 'player':
      colors = {
        'primary': AppColors.playerColor,
        'secondary': AppColors.secondary,
        'accent': AppColors.accent,
      };
      break;
    case 'coach':
      colors = {
        'primary': AppColors.coachColor,
        'secondary': AppColors.secondary,
        'accent': AppColors.accent,
      };
      break;
    case 'parent':
      colors = {
        'primary': AppColors.parentColor,
        'secondary': AppColors.secondary,
        'accent': AppColors.accent,
      };
      break;
    case 'mentor':
      colors = {
        'primary': AppColors.mentorColor,
        'secondary': AppColors.secondary,
        'accent': AppColors.accent,
      };
      break;
    case 'community_manager':
      colors = {
        'primary': AppColors.communityColor,
        'secondary': AppColors.secondary,
        'accent': AppColors.accent,
      };
      break;
  }
  
  return colors;
}

  
}