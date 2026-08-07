import 'package:flutter/foundation.dart';

class AuthLogger {
  static void log(String message) {
    if (kDebugMode) {
      print('[AUTH_LOG] ${DateTime.now().toIso8601String()}: $message');
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
