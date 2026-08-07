import 'package:flutter/foundation.dart';
import 'package:payout/core/config/app_config.dart';

class RechargeLogger {
  static void log(String message) {
    if (kDebugMode && AppConfig.enableLogs) {
      final prefix = AppConfig.isDemoMode ? '[DEMO MODE] ' : '';
      print('[RECHARGE_LOG] ${DateTime.now().toIso8601String()}: $prefix$message');
    }
  }

  static void logOperatorSelected(String name) {
    log('Operator selected: $name');
  }

  static void logPlanSelected(String planId, double amount) {
    log('Plan ID: $planId selected (Amount: ₹${amount.toStringAsFixed(2)})');
  }

  static void logRechargeSubmitted(String mobile, double amount) {
    log('Recharge request submitted for $mobile (Amount: ₹${amount.toStringAsFixed(2)})');
  }
}
