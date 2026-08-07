import 'package:flutter/foundation.dart';
import 'package:payout/core/config/app_config.dart';

class RewardLogger {
  static void log(String message) {
    if (kDebugMode && AppConfig.enableLogs) {
      final prefix = AppConfig.isDemoMode ? '[DEMO MODE] ' : '';
      print('[REWARD_LOG] ${DateTime.now().toIso8601String()}: $prefix$message');
    }
  }

  static void logScratchCardOpened(String id, double amount) {
    log('Scratch card opened: $id (Amount won: ₹${amount.toStringAsFixed(2)})');
  }

  static void logCouponRedeemed(String code) {
    log('Coupon code discount redeemed: $code');
  }
}
