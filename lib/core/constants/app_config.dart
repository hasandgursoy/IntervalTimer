/// Application configuration constants
/// 
/// Contains app-level metadata and configuration values used throughout the app.
class AppConfig {
  /// Private constructor to prevent instantiation
  AppConfig._();

  /// Application display name
  static const String appName = 'Interval Timer';

  /// Application version (matches pubspec.yaml)
  static const String version = '1.0.0';

  /// Application build number
  static const int buildNumber = 1;

  /// Full version string
  static String get fullVersion => '$version+$buildNumber';

  /// Support email for user inquiries
  /// TODO: Replace with actual support email before release
  static const String supportEmail = 'support@intervaltimer.app';

  /// Privacy policy URL
  /// TODO: Host privacy policy and update this URL before release
  static const String privacyPolicyUrl = 'https://intervaltimer.app/privacy';

  /// Terms of service URL
  /// TODO: Host terms of service and update this URL before release
  static const String termsOfServiceUrl = 'https://intervaltimer.app/terms';

  /// GitHub repository (optional)
  static const String? githubUrl = null; // Set to your repo URL if open source

  /// App Store ID (iOS)
  /// TODO: Set this after app is published to App Store
  static const String? appStoreId = null;

  /// Play Store package name (Android)
  /// TODO: Ensure this matches your actual package name
  static const String playStorePackage = 'com.example.interval_timer';

  /// Copyright notice
  static String get copyright => '© ${DateTime.now().year} $appName';
}
