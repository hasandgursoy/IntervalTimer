import 'package:flutter/material.dart';
import 'package:interval_timer/core/constants/app_constants.dart';

/// App theme configuration
/// 
/// This file defines the visual appearance of the app including colors,
/// typography, and component styles. We define both light and dark themes
/// for user preference support in the future.
class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  // ============================================
  // Light Theme
  // ============================================
  
  /// Light theme for the app (default)
  /// Suitable for well-lit environments
  static ThemeData get lightTheme {
    return ThemeData(
      // Use Material 3 design system
      useMaterial3: true,
      
      // Color scheme
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppConstants.workIntervalColor,
        brightness: Brightness.light,
      ),
      
      // AppBar styling
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      
      // Card styling (for setup screen, presets, etc.)
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        ),
      ),
      
      // Elevated button styling (primary action buttons)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(120, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.largePadding,
            vertical: AppConstants.defaultPadding,
          ),
        ),
      ),
      
      // Text button styling (secondary actions)
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(100, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
          ),
        ),
      ),
      
      // Input decoration (for text fields)
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppConstants.defaultPadding,
          vertical: AppConstants.defaultPadding,
        ),
      ),
      
      // Font family (using default system font for now)
      fontFamily: 'Roboto',
      
      // Text theme
      textTheme: const TextTheme(
        // Large numbers (timer countdown)
        displayLarge: TextStyle(
          fontSize: AppConstants.timerFontSize,
          fontWeight: FontWeight.bold,
          letterSpacing: -2.0,
        ),
        // Interval labels (WORK, REST, etc.)
        displayMedium: TextStyle(
          fontSize: AppConstants.intervalLabelFontSize,
          fontWeight: FontWeight.bold,
          letterSpacing: 2.0,
        ),
        // Headings
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
        // Body text
        bodyLarge: TextStyle(
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
        ),
      ),
    );
  }

  // ============================================
  // Dark Theme
  // ============================================
  
  /// Dark theme for the app
  /// Suitable for low-light environments and reduces eye strain
  static ThemeData get darkTheme {
    return ThemeData(
      // Use Material 3 design system
      useMaterial3: true,
      
      // Color scheme
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppConstants.workIntervalColor,
        brightness: Brightness.dark,
      ),
      
      // AppBar styling
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      
      // Card styling
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        ),
      ),
      
      // Elevated button styling
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(120, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.largePadding,
            vertical: AppConstants.defaultPadding,
          ),
        ),
      ),
      
      // Text button styling
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(100, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
          ),
        ),
      ),
      
      // Input decoration
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppConstants.defaultPadding,
          vertical: AppConstants.defaultPadding,
        ),
      ),
      
      // Font family
      fontFamily: 'Roboto',
      
      // Text theme (same as light theme)
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: AppConstants.timerFontSize,
          fontWeight: FontWeight.bold,
          letterSpacing: -2.0,
        ),
        displayMedium: TextStyle(
          fontSize: AppConstants.intervalLabelFontSize,
          fontWeight: FontWeight.bold,
          letterSpacing: 2.0,
        ),
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
        ),
      ),
    );
  }
}
