/// Standard sizes and dimensions for the app
/// 
/// Provides consistent sizing across the application for padding,
/// margins, button dimensions, icons, and layout constraints.
class AppSizes {
  // Padding and Spacing
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;

  // Margins (same as padding for consistency)
  static const double marginSmall = paddingSmall;
  static const double marginMedium = paddingMedium;
  static const double marginLarge = paddingLarge;
  static const double marginXLarge = paddingXLarge;

  // Button Dimensions
  static const double buttonHeightMobile = 48.0;
  static const double buttonHeightTablet = 56.0;
  static const double buttonHeightDesktop = 64.0;
  static const double buttonMinWidth = 120.0;

  // Minimum Touch Target Size (Material Design Guidelines)
  static const double minTouchTarget = 48.0;

  // Border Radius
  static const double borderRadiusSmall = 8.0;
  static const double borderRadiusMedium = 12.0;
  static const double borderRadiusLarge = 16.0;
  static const double borderRadiusXLarge = 24.0;

  // Icon Sizes
  static const double iconSmall = 20.0;
  static const double iconMedium = 24.0;
  static const double iconLarge = 32.0;
  static const double iconXLarge = 48.0;

  // Font Sizes (base sizes, will be scaled by ResponsiveHelper)
  static const double fontSizeSmall = 12.0;
  static const double fontSizeMedium = 16.0;
  static const double fontSizeLarge = 20.0;
  static const double fontSizeXLarge = 24.0;
  static const double fontSizeXXLarge = 32.0;
  static const double fontSizeDisplay = 48.0;

  // Layout Constraints
  static const double maxContentWidth = 600.0;
  static const double maxInputFieldWidth = 400.0;
  static const double minScreenPadding = 16.0;

  // Card Dimensions
  static const double cardElevation = 2.0;
  static const double cardBorderRadius = borderRadiusMedium;

  // App Bar
  static const double appBarHeight = 56.0;
  static const double appBarElevation = 0.0;

  // Bottom Navigation
  static const double bottomNavHeight = 60.0;

  // Divider
  static const double dividerThickness = 1.0;
  static const double dividerIndent = paddingMedium;

  // Animation Duration
  static const Duration animationDurationShort = Duration(milliseconds: 200);
  static const Duration animationDurationMedium = Duration(milliseconds: 300);
  static const Duration animationDurationLong = Duration(milliseconds: 500);

  // Breakpoints (for consistency with ResponsiveHelper)
  static const double mobileBreakpoint = 600.0;
  static const double tabletBreakpoint = 900.0;
  static const double desktopBreakpoint = 1200.0;

  // Timer Specific Sizes
  static const double timerProgressSizeMobile = 200.0;
  static const double timerProgressSizeTablet = 280.0;
  static const double timerProgressSizeDesktop = 320.0;

  static const double timerFontSizeMobile = 80.0;
  static const double timerFontSizeTablet = 120.0;
  static const double timerFontSizeDesktop = 140.0;

  // Input Field Heights
  static const double inputFieldHeight = 56.0;
  static const double inputFieldBorderWidth = 1.0;
  static const double inputFieldFocusedBorderWidth = 2.0;

  // List Item Heights
  static const double listItemMinHeight = 56.0;
  static const double listItemPadding = paddingMedium;

  // Floating Action Button
  static const double fabSize = 56.0;
  static const double fabMiniSize = 40.0;

  // Snackbar
  static const double snackbarHeight = 48.0;
  static const Duration snackbarDuration = Duration(seconds: 4);

  // Dialog
  static const double dialogMaxWidth = 400.0;
  static const double dialogBorderRadius = borderRadiusLarge;
  static const double dialogPadding = paddingLarge;

  // Grid Spacing
  static const double gridSpacing = 12.0;
  static const double gridRunSpacing = 12.0;

  // Chip
  static const double chipHeight = 32.0;
  static const double chipBorderRadius = borderRadiusMedium;

  // Progress Indicator
  static const double progressIndicatorSize = 24.0;
  static const double progressIndicatorStrokeWidth = 2.0;

  // Slider
  static const double sliderHeight = 40.0;
  static const double sliderThumbSize = 20.0;
  static const double sliderTrackHeight = 4.0;

  // Switch
  static const double switchScale = 0.8;

  // Checkbox and Radio
  static const double checkboxSize = 18.0;
  static const double radioSize = 18.0;

  // Image Aspect Ratios
  static const double aspectRatioSquare = 1.0;
  static const double aspectRatio16x9 = 16 / 9;
  static const double aspectRatio4x3 = 4 / 3;
  static const double aspectRatio3x2 = 3 / 2;

  // Loading Indicator
  static const double loadingIndicatorSize = 32.0;

  // Empty State
  static const double emptyStateIconSize = 64.0;
  static const double emptyStatePadding = paddingXLarge;
}