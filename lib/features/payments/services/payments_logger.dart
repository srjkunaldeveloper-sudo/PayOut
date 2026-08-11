import 'package:flutter/foundation.dart';
import 'package:payout/core/config/app_config.dart';

class PaymentsLogger {
  static void log(String message) {
    if (kDebugMode && AppConfig.enableLogs) {
      final prefix = AppConfig.isDemoMode ? '[DEMO MODE] ' : '';
      debugPrint('[PAYMENTS_LOG] ${DateTime.now().toIso8601String()}: $prefix$message');
    }
  }

  static void logPaymentOpened() {
    log('Payments section opened.');
  }

  static void logSearchBeneficiary(String query) {
    log('Searching beneficiary contacts with query: "$query"');
  }

  static void logPaymentProcessing(double amount) {
    log('Processing transfer amount: ₹${amount.toStringAsFixed(2)}');
  }

  static void logPaymentSuccess(String txnId, String utr) {
    log('Payment execution success. Transaction ID: $txnId, UTR: $utr');
  }

  static void logPaymentFailed(String errorMessage) {
    log('Payment execution failed: $errorMessage');
  }
}
