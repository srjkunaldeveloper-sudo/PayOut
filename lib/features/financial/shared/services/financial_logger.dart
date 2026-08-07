import 'package:flutter/foundation.dart';
import 'package:payout/core/config/app_config.dart';

class FinancialLogger {
  static void log(String message) {
    if (kDebugMode && AppConfig.enableLogs) {
      final prefix = AppConfig.isDemoMode ? '[DEMO MODE] ' : '';
      print('[FINANCIAL_LOG] ${DateTime.now().toIso8601String()}: $prefix$message');
    }
  }

  static void logLoanApplied(String category, double amount) {
    log('Loan application submitted: $category (Amount: ₹${amount.toStringAsFixed(2)})');
  }

  static void logPolicyPurchased(String policyName, double premium) {
    log('Insurance policy premium paid: $policyName (Premium: ₹${premium.toStringAsFixed(2)})');
  }

  static void logInvestmentExecuted(String fundName, double amount) {
    log('Investment processed successfully: $fundName (Amount: ₹${amount.toStringAsFixed(2)})');
  }
}
