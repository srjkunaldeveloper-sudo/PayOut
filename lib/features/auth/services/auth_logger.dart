import 'package:flutter/foundation.dart';
import 'package:payout/core/config/app_config.dart';

class AuthLogger {
  static void log(String message) {
    if (kDebugMode && AppConfig.enableLogs) {
      final prefix = AppConfig.isDemoMode ? '[DEMO MODE] ' : '';
      debugPrint('[AUTH_LOG] ${DateTime.now().toIso8601String()}: $prefix$message');
    }
  }

  static void logLoginAttempt(String phone) {
    log('Login requested for phone: $phone');
  }

  static void logOTPRequested(String phone) {
    log('OTP requested for phone: $phone');
  }

  static void logOTPVerified(String phone) {
    log('OTP verification successful for phone: $phone');
  }

  static void logMPINCreated() {
    log('MPIN security configuration created successfully.');
  }

  static void logBiometricEnabled() {
    log('Biometric authentication enabled.');
  }

  static void logLogout() {
    log('User logged out. Session cleared.');
  }
}
