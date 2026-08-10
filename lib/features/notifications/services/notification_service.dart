import 'package:payout/features/notifications/models/notification_models.dart';

class NotificationService {
  static List<NotificationModel> filterByCategory(List<NotificationModel> list, String category) {
    if (category == 'All') {
      return list;
    }
    return list.where((n) => n.category.toLowerCase() == category.toLowerCase()).toList();
  }

  static int getUnreadCount(List<NotificationModel> list) {
    return list.where((n) => !n.isRead).length;
  }
}
