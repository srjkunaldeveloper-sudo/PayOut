import 'package:flutter/foundation.dart';
import 'package:payout/core/config/app_config.dart';

class TravelLogger {
  static void log(String message) {
    if (kDebugMode && AppConfig.enableLogs) {
      final prefix = AppConfig.isDemoMode ? '[DEMO MODE] ' : '';
      print('[TRAVEL_LOG] ${DateTime.now().toIso8601String()}: $prefix$message');
    }
  }

  static void logBookingSubmitted(String type, String itemId, double cost) {
    log('Travel ticket booked: $type (Item ID: $itemId, Cost: ₹${cost.toStringAsFixed(2)})');
  }

  static void logBookingCancelled(String bookingId) {
    log('Travel booking cancelled: $bookingId');
  }
}
