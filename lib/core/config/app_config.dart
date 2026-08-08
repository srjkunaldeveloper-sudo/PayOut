// Global Application Configuration
// Environment-specific configs (mock vs api) and feature flags.

enum RepositoryMode {
  mock,
  api,
}

class AppConfig {
  // Central Repository & Environment Mode
  static const RepositoryMode repositoryMode = RepositoryMode.mock;

  // Environment configurations
  static const bool isDemoMode = true;
  static const bool enableMockRepository = true;
  static const bool enableLogs = true;
  static const bool enableAnimations = true;

  // Base API configuration (for future backend integration)
  static const String apiBaseUrl = 'https://api.payout.app/v1';
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);

  // Future features configurations
  static const bool enableCrashReporting = false;
  static const bool enableAnalytics = false;
  static const bool enableBiometric = true;
  static const bool enableNotifications = true;
  static const bool enableLocation = false;
}
