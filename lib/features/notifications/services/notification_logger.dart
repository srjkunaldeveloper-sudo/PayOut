import 'package:flutter/foundation.dart';
import 'package:payout/core/config/app_config.dart';

class NotificationLogger {
  static void log(String message) {
    if (kDebugMode && AppConfig.enableLogs) {
      final prefix = AppConfig.isDemoMode ? '[DEMO MODE] ' : '';
      debugPrint('[NOTIFICATION_LOG] ${DateTime.now().toIso8601String()}: $prefix$message');
    }
  }

  static void logNotificationRead(String id) {
    log('Notification ID: $id marked as read.');
  }

  static void logAllNotificationsRead() {
    log('All unread notifications marked as read.');
  }

  static void logNotificationDeleted(String id) {
    log('Notification ID: $id deleted from user screen.');
  }
}
