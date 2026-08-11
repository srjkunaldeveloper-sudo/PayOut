import 'package:flutter/foundation.dart';
import 'package:payout/core/config/app_config.dart';

class TransactionLogger {
  static void log(String message) {
    if (kDebugMode && AppConfig.enableLogs) {
      final prefix = AppConfig.isDemoMode ? '[DEMO MODE] ' : '';
      debugPrint('[TRANSACTION_LOG] ${DateTime.now().toIso8601String()}: $prefix$message');
    }
  }

  static void logSearch(String query) {
    log('Searching transactions list with query: "$query"');
  }

  static void logFilter(String key, String val) {
    log('Filtering transactions by: $key = $val');
  }

  static void logExport(String month, String format) {
    log('Exporting transaction statements for: $month (Format: $format)');
  }

  static void logReceiptDownloaded(String txnId) {
    log('Downloading receipt PDF for transaction ID: $txnId');
  }

  static void logReceiptShared(String txnId) {
    log('Sharing receipt details for transaction ID: $txnId');
  }
}
