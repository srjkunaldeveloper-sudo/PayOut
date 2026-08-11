import 'package:flutter/foundation.dart';
import 'package:payout/core/config/app_config.dart';

class QrLogger {
  static void log(String message) {
    if (kDebugMode && AppConfig.enableLogs) {
      final prefix = AppConfig.isDemoMode ? '[DEMO MODE] ' : '';
      debugPrint('[QR_LOG] ${DateTime.now().toIso8601String()}: $prefix$message');
    }
  }

  static void logScanInitiated() {
    log('QR camera scanner session initiated.');
  }

  static void logQRScanned(String payload) {
    log('QR payload captured successfully: $payload');
  }

  static void logMerchantFound(String id, String merchantName) {
    log('Merchant verified: $merchantName (ID: $id)');
  }

  static void logPaymentCompleted(String txnId, double amount) {
    log('QR Payment transaction completed. Txn ID: $txnId, Amount: ₹${amount.toStringAsFixed(2)}');
  }

  static void logShareQR() {
    log('QR code details shared by user.');
  }

  static void logDownloadQR() {
    log('QR code downloaded to local photo gallery.');
  }
}
