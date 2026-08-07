import 'package:flutter/foundation.dart';
import 'package:payout/core/config/app_config.dart';

class MerchantLogger {
  static void log(String message) {
    if (kDebugMode && AppConfig.enableLogs) {
      final prefix = AppConfig.isDemoMode ? '[DEMO MODE] ' : '';
      print('[MERCHANT_LOG] ${DateTime.now().toIso8601String()}: $prefix$message');
    }
  }

  static void logProfileLoaded(String id) {
    log('Merchant profile loaded: $id');
  }

  static void logSettlementTriggered(double amount) {
    log('Settlement triggered for amount: ₹${amount.toStringAsFixed(2)}');
  }

  static void logStatementDownloaded(String date) {
    log('Monthly earnings statement downloaded for: $date');
  }
}
