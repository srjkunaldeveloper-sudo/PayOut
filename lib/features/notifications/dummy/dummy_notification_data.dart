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
      actionRoute: 'transaction_details',
      relatedEntityId: 'TXN-901',
      relatedTransactionId: 'TXN-901',
    ),
    const NotificationModel(
      id: 'NOT-002',
      title: 'Security Alert',
      description: 'Your Payout account was logged in from a new device.',
      category: 'Security',
      time: '1 hour ago',
      isRead: false,
      actionRoute: 'security',
    ),
    const NotificationModel(
      id: 'NOT-003',
      title: 'Domino\'s Weekend Deal',
      description: 'Get Flat 15% discount on Domino\'s Pizzas on payments above ₹500.',
      category: 'Offers',
      time: '3 hours ago',
      isRead: true,
      actionRoute: 'rewards',
    ),
    const NotificationModel(
      id: 'NOT-004',
      title: 'Electricity Bill Paid',
      description: 'Your electricity payment of ₹1,248.00 to BESCOM was completed.',
      category: 'Bills',
      time: '1 day ago',
      isRead: true,
      actionRoute: 'transaction_details',
      relatedEntityId: 'BILL-ELE-01',
      relatedTransactionId: 'TXN-BILL-01',
    ),
  ];
}
