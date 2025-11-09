import 'package:flutter/material.dart';

/// App-wide constants for the Interval Timer
/// 
/// This file contains all default values, colors, and configuration
/// that are used throughout the app. Centralizing these makes it easy
/// to adjust the app's behavior and appearance in one place.
class AppConstants {
  // Private constructor to prevent instantiation
  AppConstants._();

  // ============================================
  // Timer Default Values
  // ============================================
  
  /// Default duration for work intervals (in seconds)
  /// Example: 30 seconds of exercise
  static const int defaultWorkDuration = 30;
  
  /// Default duration for rest intervals (in seconds)
  /// Example: 10 seconds of rest between exercises
  static const int defaultRestDuration = 10;
  
  /// Default number of rounds in a workout
  /// Example: 8 rounds of work/rest cycles (like Tabata)
  static const int defaultRounds = 8;
  
  /// Default preparation time before workout starts (in seconds)
  /// Gives user time to get ready before first work interval
  static const int defaultPrepDuration = 5;

  // ============================================
  // Timer Limits
  // ============================================
  
  /// Minimum duration for any interval (in seconds)
  /// Prevents accidentally setting 0 or negative values
  static const int minIntervalDuration = 1;
  
  /// Maximum duration for any interval (in seconds)
  /// Prevents setting unreasonably long intervals (60 minutes)
  static const int maxIntervalDuration = 3600;
  
  /// Minimum number of rounds
  static const int minRounds = 1;
  
  /// Maximum number of rounds
  /// Prevents setting too many rounds (100 rounds = very long workout)
  static const int maxRounds = 100;

  // ============================================
  // Interval Colors
  // ============================================
  
  /// Color for WORK intervals
  /// Green suggests "go" and activity
  static const Color workIntervalColor = Color(0xFF4CAF50); // Material Green
  
  /// Color for REST intervals
  /// Blue suggests calm and recovery
  static const Color restIntervalColor = Color(0xFF2196F3); // Material Blue
  
  /// Color for PREPARATION intervals
  /// Yellow/amber suggests "get ready"
  static const Color prepIntervalColor = Color(0xFFFF9800); // Material Orange
  
  /// Color for COMPLETED state
  /// Purple/deep purple for completion
  static const Color completedColor = Color(0xFF673AB7); // Material Deep Purple

  // ============================================
  // UI Constants
  // ============================================
  
  /// Default padding for screens
  static const double defaultPadding = 16.0;
  
  /// Large padding for main content areas
  static const double largePadding = 24.0;
  
  /// Small padding for compact areas
  static const double smallPadding = 8.0;
  
  /// Border radius for rounded elements
  static const double defaultBorderRadius = 12.0;
  
  /// Timer display font size (for main countdown)
  static const double timerFontSize = 72.0;
  
  /// Interval label font size (for WORK/REST text)
  static const double intervalLabelFontSize = 32.0;

  // ============================================
  // Animation Durations
  // ============================================
  
  /// Duration for quick animations (state changes, color transitions)
  static const Duration quickAnimation = Duration(milliseconds: 300);
  
  /// Duration for standard animations (screen transitions)
  static const Duration standardAnimation = Duration(milliseconds: 500);

  // ============================================
  // Timer Configuration
  // ============================================
  
  /// How often the timer ticks (updates the UI)
  /// 1 second is sufficient for countdown display
  static const Duration timerTickDuration = Duration(seconds: 1);
  
  /// Acceptable timer accuracy drift (in milliseconds)
  /// Used for drift correction in timer logic
  static const int timerAccuracyThreshold = 100;

  // ============================================
  // App Information
  // ============================================
  
  /// App name
  static const String appName = 'Interval Timer';
  
  /// App version (should match pubspec.yaml)
  static const String appVersion = '1.0.0';
}
