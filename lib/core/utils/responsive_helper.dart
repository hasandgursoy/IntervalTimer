import 'package:flutter/material.dart';

/// Helper class for responsive design utilities
/// 
/// Provides methods to detect screen sizes, calculate responsive dimensions,
/// and scale fonts and padding based on screen size.
class ResponsiveHelper {
  /// Mobile breakpoint - screen width < 600
  static const double mobileBreakpoint = 600;
  
  /// Tablet breakpoint - screen width < 900
  static const double tabletBreakpoint = 900;

  /// Check if the current screen is mobile size
  /// Mobile: screen width < 600
  static bool isMobile(BuildContext context) {
    return getScreenWidth(context) < mobileBreakpoint;
  }

  /// Check if the current screen is tablet size
  /// Tablet: 600 <= width < 900
  static bool isTablet(BuildContext context) {
    final width = getScreenWidth(context);
    return width >= mobileBreakpoint && width < tabletBreakpoint;
  }

  /// Check if the current screen is desktop size
  /// Desktop: width >= 900
  static bool isDesktop(BuildContext context) {
    return getScreenWidth(context) >= tabletBreakpoint;
  }

  /// Get the screen width in logical pixels
  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  /// Get the screen height in logical pixels
  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  /// Calculate responsive font size based on screen size
  /// 
  /// Scales the base font size:
  /// - Mobile: baseSize * 0.9 (minimum 14)
  /// - Tablet: baseSize * 1.0
  /// - Desktop: baseSize * 1.1
  static double responsiveFontSize(BuildContext context, double baseSize) {
    double scaleFactor;
    
    if (isMobile(context)) {
      scaleFactor = 0.9;
    } else if (isTablet(context)) {
      scaleFactor = 1.0;
    } else {
      scaleFactor = 1.1;
    }
    
    final scaledSize = baseSize * scaleFactor;
    
    // Ensure minimum readable font size of 14
    return scaledSize < 14 ? 14 : scaledSize;
  }

  /// Calculate responsive padding based on screen size
  /// 
  /// Scales the base padding:
  /// - Mobile: basePadding * 0.75
  /// - Tablet: basePadding * 1.0
  /// - Desktop: basePadding * 1.25
  static double responsivePadding(BuildContext context, double basePadding) {
    if (isMobile(context)) {
      return basePadding * 0.75;
    } else if (isTablet(context)) {
      return basePadding;
    } else {
      return basePadding * 1.25;
    }
  }

  /// Get responsive content width with maximum constraint
  /// 
  /// Returns appropriate content width:
  /// - Mobile: Full width with horizontal padding
  /// - Tablet/Desktop: Constrained to maxWidth (default 600)
  static double getContentWidth(BuildContext context, {double maxWidth = 600}) {
    final screenWidth = getScreenWidth(context);
    
    if (isMobile(context)) {
      return screenWidth - 32; // 16px padding on each side
    } else {
      return screenWidth > maxWidth ? maxWidth : screenWidth - 64; // 32px padding on each side
    }
  }

  /// Get horizontal padding based on screen size
  /// 
  /// Returns appropriate horizontal padding:
  /// - Mobile: 16px
  /// - Tablet: 32px
  /// - Desktop: 48px
  static double getHorizontalPadding(BuildContext context) {
    if (isMobile(context)) {
      return 16;
    } else if (isTablet(context)) {
      return 32;
    } else {
      return 48;
    }
  }

  /// Get vertical spacing based on screen size
  /// 
  /// Returns appropriate vertical spacing:
  /// - Mobile: Reduced spacing
  /// - Tablet/Desktop: Standard spacing
  static double getVerticalSpacing(BuildContext context, double baseSpacing) {
    return isMobile(context) ? baseSpacing * 0.75 : baseSpacing;
  }

  /// Get responsive button height
  /// 
  /// Returns appropriate button height:
  /// - Mobile: 48px (minimum touch target)
  /// - Tablet: 56px
  /// - Desktop: 64px
  static double getButtonHeight(BuildContext context) {
    if (isMobile(context)) {
      return 48;
    } else if (isTablet(context)) {
      return 56;
    } else {
      return 64;
    }
  }

  /// Get responsive circular progress indicator size
  /// 
  /// Returns appropriate size:
  /// - Mobile: 200x200
  /// - Tablet: 280x280
  /// - Desktop: 320x320
  static double getCircularProgressSize(BuildContext context) {
    if (isMobile(context)) {
      return 200;
    } else if (isTablet(context)) {
      return 280;
    } else {
      return 320;
    }
  }

  /// Get responsive timer font size
  /// 
  /// Returns appropriate font size for countdown timer:
  /// - Mobile: 80-100sp
  /// - Tablet: 120sp
  /// - Desktop: 140sp
  static double getTimerFontSize(BuildContext context) {
    if (isMobile(context)) {
      // Scale between 80-100 based on screen width
      final width = getScreenWidth(context);
      return 80 + (width - 320) / (600 - 320) * 20; // Linear interpolation
    } else if (isTablet(context)) {
      return 120;
    } else {
      return 140;
    }
  }

  /// Check if screen is in landscape orientation
  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  /// Get appropriate grid column count for responsive grid
  /// 
  /// Returns column count:
  /// - Mobile: 1 column
  /// - Tablet: 2 columns
  /// - Desktop: 3 columns (or custom)
  static int getGridColumnCount(BuildContext context, {int desktopColumns = 3}) {
    if (isMobile(context)) {
      return 1;
    } else if (isTablet(context)) {
      return 2;
    } else {
      return desktopColumns;
    }
  }

  /// Get safe area padding
  static EdgeInsets getSafeAreaPadding(BuildContext context) {
    return MediaQuery.of(context).padding;
  }

  /// Get responsive EdgeInsets for screen padding
  static EdgeInsets getScreenPadding(BuildContext context) {
    final horizontal = getHorizontalPadding(context);
    return EdgeInsets.symmetric(horizontal: horizontal, vertical: 16);
  }

  /// Get responsive EdgeInsets for card padding
  static EdgeInsets getCardPadding(BuildContext context) {
    return EdgeInsets.all(responsivePadding(context, 16));
  }

  /// Get responsive border radius
  static double getResponsiveBorderRadius(BuildContext context, {double baseBorderRadius = 12}) {
    return responsivePadding(context, baseBorderRadius);
  }
}