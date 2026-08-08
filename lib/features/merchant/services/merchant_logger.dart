// ignore_for_file: avoid_print
import 'package:flutter/foundation.dart';

class MerchantLogger {
  static void log(String message) {
    if (kDebugMode) {
      print('[MERCHANT_LOG] ${DateTime.now().toIso8601String()}: [DEMO MODE] $message');
    }
  }

  static void logProfileLoaded(String merchantId) {
    log('Merchant profile loaded: $merchantId');
  }

  static void logSettlementTriggered(double amount) {
    log('Settlement sweep initiated: ₹${amount.toStringAsFixed(2)}');
  }

  static void logOfferCreated(String offerId) {
    log('Store offer published: $offerId');
  }
}
