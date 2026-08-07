import 'package:payout/features/notifications/models/notification_models.dart';

class DummyNotificationData {
  static final List<NotificationModel> dummyNotifications = [
    const NotificationModel(
      id: 'NOT-001',
      title: 'Payment Successful',
      description: 'Your payment of ₹320.00 to Starbucks Coffee was successful.',
      category: 'Payment',
      time: '2 mins ago',
      isRead: false,
    ),
    const NotificationModel(
      id: 'NOT-002',
      title: 'Security Alert',
      description: 'Your Payout account was logged in from a new macOS device.',
      category: 'Security',
      time: '1 hour ago',
      isRead: false,
    ),
    const NotificationModel(
      id: 'NOT-003',
      title: 'Domino\'s Weekend Deal',
      description: 'Get Flat 15% discount on Domino\'s Pizzas on payments above ₹500.',
      category: 'Offers',
      time: '3 hours ago',
      isRead: true,
    ),
    const NotificationModel(
      id: 'NOT-004',
      title: 'Electricity Bill Paid',
      description: 'Your electricity payment of ₹3,200.00 to BESCOM was completed.',
      category: 'Bills',
      time: '1 day ago',
      isRead: true,
    ),
  ];
}
