// ignore_for_file: avoid_print
import 'package:flutter/foundation.dart';

class RewardLogger {
  static void log(String message) {
    if (kDebugMode) {
      print('[REWARD_LOG] ${DateTime.now().toIso8601String()}: [DEMO MODE] $message');
    }
  }

  static void logScratchCardOpened(String cardId, double amount) {
    log('Scratch card opened: $cardId (Amount won: ₹${amount.toStringAsFixed(2)})');
  }

  static void logCouponRedeemed(String couponCode) {
    log('Coupon code discount redeemed: $couponCode');
  }

  static void logCashbackCredited(double amount) {
    log('Cashback reward credited: ₹${amount.toStringAsFixed(2)}');
  }
}
