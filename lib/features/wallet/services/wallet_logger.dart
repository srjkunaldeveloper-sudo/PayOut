import 'package:flutter/foundation.dart';

class WalletLogger {
  static void log(String message) {
    if (kDebugMode) {
      print('[WALLET_LOG] ${DateTime.now().toIso8601String()}: $message');
    }
  }

  static void logWalletOpened() {
    log('Wallet dashboard opened.');
  }

  static void logWalletRefreshed() {
    log('Wallet balance refreshed.');
  }

  static void logMoneyAdded(double amount) {
    log('Money added to wallet: ₹${amount.toStringAsFixed(2)}');
  }

  static void logMoneyWithdrawn(double amount) {
    log('Money withdrawn from wallet: ₹${amount.toStringAsFixed(2)}');
  }

  static void logBankLinked(String bankName) {
    log('New bank linked: $bankName');
  }

  static void logCardLinked(String cardBrand) {
    log('New card linked: $cardBrand');
  }

  static void logRewardViewed() {
    log('Rewards section viewed.');
  }

  static void logTransactionViewed(String id) {
    log('Transaction detail viewed: $id');
  }
}
