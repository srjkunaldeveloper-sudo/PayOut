import 'package:payout/features/notifications/models/notification_models.dart';
import 'package:payout/features/notifications/dummy/dummy_notification_data.dart';
import 'package:payout/features/notifications/services/notification_logger.dart';

abstract class NotificationRepository {
  Future<List<NotificationModel>> getNotifications();
  Future<bool> markAsRead(String id);
  Future<bool> markAllRead();
  Future<bool> deleteNotification(String id);
  Future<int> getUnreadCount();
}

class MockNotificationRepository implements NotificationRepository {
  @override
  Future<List<NotificationModel>> getNotifications() async {
    // TODO: Connect push notifications history feed endpoint
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(DummyNotificationData.dummyNotifications);
  }

  @override
  Future<bool> markAsRead(String id) async {
    // TODO: Connect update status endpoint
    await Future.delayed(const Duration(milliseconds: 200));
    NotificationLogger.logNotificationRead(id);
    final idx = DummyNotificationData.dummyNotifications.indexWhere((n) => n.id == id);
    if (idx != -1) {
      final old = DummyNotificationData.dummyNotifications[idx];
      DummyNotificationData.dummyNotifications[idx] = old.copyWith(isRead: true);
      return true;
    }
    return false;
  }

  @override
  Future<bool> markAllRead() async {
    // TODO: Connect bulk status read gateway
    await Future.delayed(const Duration(milliseconds: 300));
    NotificationLogger.logAllNotificationsRead();
    for (int i = 0; i < DummyNotificationData.dummyNotifications.length; i++) {
      DummyNotificationData.dummyNotifications[i] = DummyNotificationData.dummyNotifications[i].copyWith(isRead: true);
    }
    return true;
  }

  @override
  Future<bool> deleteNotification(String id) async {
    // TODO: Connect delete notification endpoint
    await Future.delayed(const Duration(milliseconds: 200));
    NotificationLogger.logNotificationDeleted(id);
    DummyNotificationData.dummyNotifications.removeWhere((n) => n.id == id);
    return true;
  }

  @override
  Future<int> getUnreadCount() async {
    // TODO: Connect unread count quick fetch
    await Future.delayed(const Duration(milliseconds: 100));
    return DummyNotificationData.dummyNotifications.where((n) => !n.isRead).length;
  }
}
