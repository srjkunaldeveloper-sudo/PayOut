import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/app_card.dart';
import 'package:payout/features/notifications/models/notification_models.dart';
import 'package:payout/features/notifications/repositories/notification_repository.dart';
import 'package:payout/features/notifications/services/notification_service.dart';
import 'package:payout/features/transactions/repositories/transaction_repository.dart';
import 'package:payout/features/transactions/presentation/transaction_detail_screen.dart';
import 'package:payout/features/transactions/presentation/transaction_history_screen.dart';
import 'package:payout/features/rewards/presentation/rewards_screen.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final NotificationRepository _notificationRepository = MockNotificationRepository();
  final TransactionRepository _transactionRepository = MockTransactionRepository();

  List<NotificationModel> _notifications = [];
  bool _isLoading = true;
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    setState(() {
      _isLoading = true;
    });
    final list = await _notificationRepository.getNotifications();
    if (mounted) {
      setState(() {
        _notifications = list;
        _isLoading = false;
      });
    }
  }

  Future<void> _markAllAsRead() async {
    await _notificationRepository.markAllRead();
    _loadNotifications();
  }

  Future<void> _deleteNotification(String id) async {
    await _notificationRepository.deleteNotification(id);
    _loadNotifications();
  }

  void _onNotificationTap(NotificationModel notif) async {
    if (!notif.isRead) {
      await _notificationRepository.markAsRead(notif.id);
      _loadNotifications();
    }

    if (!mounted) return;

    if (notif.actionRoute == 'transaction_details') {
      final txs = await _transactionRepository.getTransactions();
      final matchingTx = txs.where((t) => t.id == notif.relatedEntityId || t.id == notif.relatedTransactionId).firstOrNull;

      if (!mounted) return;
      if (matchingTx != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TransactionDetailScreen(transaction: matchingTx),
          ),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const TransactionHistoryScreen(),
          ),
        );
      }
    } else if (notif.actionRoute == 'rewards') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const RewardsScreen(),
        ),
      );
    }
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'payment':
        return AppColors.success;
      case 'security':
        return Colors.indigo;
      case 'offers':
        return Colors.red;
      case 'bills':
        return AppColors.warning;
      default:
        return AppColors.primary;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'payment':
        return Icons.check_circle_rounded;
      case 'security':
        return Icons.security_rounded;
      case 'offers':
        return Icons.local_offer_rounded;
      case 'bills':
        return Icons.receipt_long_rounded;
      default:
        return Icons.notifications_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = NotificationService.filterByCategory(_notifications, _selectedCategory);
    final categories = ['All', 'Payment', 'Security', 'Offers', 'Bills'];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Alerts & Updates',
        actions: [
          if (_notifications.any((n) => !n.isRead))
            TextButton(
              onPressed: _markAllAsRead,
              child: const Text(
                'Mark all read',
                style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.primary),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Filter Chips
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24, vertical: AppSpacing.s12),
            child: SizedBox(
              height: 32,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final cat = categories[index];
                  final isSelected = cat == _selectedCategory;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(
                        cat,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          color: isSelected ? Colors.white : AppColors.textPrimary,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: AppColors.primary,
                      backgroundColor: AppColors.surface,
                      checkmarkColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _selectedCategory = cat;
                          });
                        }
                      },
                    ),
                  );
                },
              ),
            ),
          ),
          const Divider(height: 1, color: AppColors.divider),
          
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary)),
                  )
                : filtered.isEmpty
                    ? const Center(
                        child: Text(
                          'No alerts at the moment.',
                          style: TextStyle(fontFamily: 'Inter', color: AppColors.textSecondary),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16, vertical: AppSpacing.s12),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final notif = filtered[index];
                          final catColor = _getCategoryColor(notif.category);
                          final catIcon = _getCategoryIcon(notif.category);

                          return Dismissible(
                            key: Key(notif.id),
                            direction: DismissDirection.endToStart,
                            onDismissed: (_) => _deleteNotification(notif.id),
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: AppSpacing.s24),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(AppRadius.lg),
                              ),
                              child: const Icon(Icons.delete_sweep_rounded, color: Colors.white),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: AppSpacing.s12),
                              child: AppCard(
                                onTap: () => _onNotificationTap(notif),
                                child: Row(
                                  children: [
                                    Stack(
                                      alignment: Alignment.topRight,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(AppSpacing.s12),
                                          decoration: BoxDecoration(
                                            color: catColor.withOpacity(0.08),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(catIcon, color: catColor, size: 20),
                                        ),
                                        if (!notif.isRead)
                                          Container(
                                            width: 8,
                                            height: 8,
                                            decoration: const BoxDecoration(
                                              color: AppColors.primary,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                      ],
                                    ),
                                    const SizedBox(width: AppSpacing.s16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  notif.title,
                                                  style: TextStyle(
                                                    fontFamily: 'Inter',
                                                    fontWeight: notif.isRead ? FontWeight.w600 : FontWeight.bold,
                                                    fontSize: 14,
                                                    color: AppColors.textPrimary,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                notif.time,
                                                style: const TextStyle(
                                                  fontFamily: 'Inter',
                                                  fontSize: 11,
                                                  color: AppColors.textSecondary,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            notif.description,
                                            style: const TextStyle(
                                              fontFamily: 'Inter',
                                              fontSize: 12,
                                              color: AppColors.textSecondary,
                                              height: 1.4,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
