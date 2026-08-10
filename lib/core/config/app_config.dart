import 'package:payout/core/config/app_env.dart';

enum RepositoryMode {
  mock,
  api,
}

class AppConfig {
  // Central Repository & Environment Mode (switched to real Firebase Authentication in api mode)
  static const RepositoryMode repositoryMode = RepositoryMode.api;

  // Environment configurations (production runtime: no demo/mock auth bypass)
  static const bool isDemoMode = false;
  static const bool enableMockRepository = false;
  static const bool enableLogs = true;
  static const bool enableAnimations = true;

  // Base API configuration referencing central AppEnv
  static const String apiBaseUrl = AppEnv.apiBaseUrl;
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);

  // Future features configurations
  static const bool enableCrashReporting = false;
  static const bool enableAnalytics = false;
  static const bool enableBiometric = true;
  static const bool enableNotifications = true;
  static const bool enableLocation = false;
}
