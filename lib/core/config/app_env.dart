/// Central Environment Configuration Layer.
/// Reads environment configuration passed via Dart environment defines
/// (`--dart-define=APP_ENV=production` etc.) with fallbacks for local development.
///
/// IMPORTANT SECURITY NOTICE:
/// Flutter client applications are compiled into public binaries. Any client-side
/// environment variables or API keys are extractable by reverse engineering.
/// Server private keys, database passwords, and service accounts must NEVER
/// be stored in client-side code or .env files.
class AppEnv {
  /// Current environment name: development, staging, production
  static const String appEnv = String.fromEnvironment(
    'APP_ENV',
    defaultValue: 'development',
  );

  /// Base URL for backend API endpoints
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.payout.app/v1',
  );

  /// Environment helpers
  static const bool isProduction = appEnv == 'production';
  static const bool isStaging = appEnv == 'staging';
  static const bool isDevelopment = appEnv == 'development';
}
