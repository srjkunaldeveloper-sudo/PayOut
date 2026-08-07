// Global Application Configuration
// TODO: Integrate environment-specific configs (development.dart, staging.dart, production.dart) here in the future.

class AppConfig {
  // Environment configurations
  static const bool isDemoMode = true;
  static const bool enableMockRepository = true;
  static const bool enableLogs = true;
  static const bool enableAnimations = true;

  // Future features configurations
  static const bool enableCrashReporting = false;
  static const bool enableAnalytics = false;
  static const bool enableBiometric = true;
  static const bool enableNotifications = true;
  static const bool enableLocation = false;
}
