import 'package:flutter/foundation.dart';
import 'package:payout/core/config/app_config.dart';

class UserLogger {
  static void log(String message) {
    if (kDebugMode && AppConfig.enableLogs) {
      final prefix = AppConfig.isDemoMode ? '[DEMO MODE] ' : '';
      print('[USER_LOG] ${DateTime.now().toIso8601String()}: $prefix$message');
    }
  }

  static void logProfileUpdated() {
    log('User profile settings updated successfully.');
  }

  static void logKycDocumentUploaded(String type) {
    log('KYC Verification document uploaded: $type');
  }

  static void logPreferenceChanged(String key, String val) {
    log('User preference changed: $key = $val');
  }
}
