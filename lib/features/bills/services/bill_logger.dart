import 'package:flutter/foundation.dart';
import 'package:payout/core/config/app_config.dart';

class BillLogger {
  static void log(String message) {
    if (kDebugMode && AppConfig.enableLogs) {
      final prefix = AppConfig.isDemoMode ? '[DEMO MODE] ' : '';
      debugPrint('[BILL_LOG] ${DateTime.now().toIso8601String()}: $prefix$message');
    }
  }

  static void logBillerSelected(String name) {
    log('Biller utility vendor selected: $name');
  }

  static void logBillFetched(String consumerNo, double amount) {
    log('Outstanding balance resolved for customer ID: $consumerNo (Amount: ₹${amount.toStringAsFixed(2)})');
  }

  static void logBillPaid(String billId, double amount) {
    log('Payment submitted for Bill ID: $billId (Amount: ₹${amount.toStringAsFixed(2)})');
  }
}
