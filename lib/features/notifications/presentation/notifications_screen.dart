import 'package:flutter/material.dart';
import 'package:payout/core/di/app_dependencies.dart';
import 'package:payout/core/error/error_message_mapper.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/app_card.dart';
import 'package:payout/core/widgets/states.dart';
import 'package:payout/features/notifications/models/notification_models.dart';
import 'package:payout/features/notifications/repositories/notification_repository.dart';
import 'package:payout/features/notifications/services/notification_service.dart';
import 'package:payout/features/transactions/repositories/transaction_repository.dart';
import 'package:payout/features/transactions/presentation/transaction_detail_screen.dart';
import 'package:payout/features/transactions/presentation/transaction_history_screen.dart';
import 'package:payout/features/rewards/presentation/rewards_screen.dart';

class NotificationsScreen extends StatefulWidget {
  final NotificationRepository? notificationRepository;
  final TransactionRepository? transactionRepository;

  const NotificationsScreen({
    super.key,
    this.notificationRepository,
    this.transactionRepository,
  });

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late final NotificationRepository _notificationRepository;
  late final TransactionRepository _transactionRepository;

  List<NotificationModel> _notifications = [];
  bool _isLoading = true;
  String? _errorMessage;
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    _notificationRepository = widget.notificationRepository ?? AppDependencies.instance.notificationRepository;
    _transactionRepository = widget.transactionRepository ?? AppDependencies.instance.transactionRepository;
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final list = await _notificationRepository.getNotifications();
      if (mounted) {
        setState(() {
          _notifications = list;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = ErrorMessageMapper.map(e, fallback: 'Unable to load notifications.');
          _isLoading = false;
        });
      }
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
          MaterialPageRoute(builder: (context) => const TransactionHistoryScreen()),
        );
      }
    } else if (notif.actionRoute == 'rewards') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const RewardsScreen()),
      );
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'payment':
        return Icons.payment_rounded;
      case 'security':
        return Icons.security_rounded;
      case 'offers':
        return Icons.local_offer_rounded;
      default:
        return Icons.notifications_rounded;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'payment':
        return AppColors.primary;
      case 'security':
        return Colors.amber;
      case 'offers':
        return AppColors.success;
      default:
        return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: const CustomAppBar(title: 'Alerts & Updates'),
        body: const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        ),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: const CustomAppBar(title: 'Alerts & Updates'),
        body: SafeArea(
          child: ErrorState(
            description: _errorMessage!,
            onRetry: _loadNotifications,
          ),
        ),
      );
    }

    final filtered = NotificationService.filterByCategory(_notifications, _selectedCategory);
    final unreadCount = NotificationService.getUnreadCount(_notifications);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Alerts & Updates',
        actions: [
          if (unreadCount > 0)
            TextButton.icon(
              onPressed: _markAllAsRead,
              icon: const Icon(Icons.done_all_rounded, size: 16, color: AppColors.primary),
              label: const Text('Mark all read', style: TextStyle(fontFamily: 'Geist Sans', fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary)),
            ),
        ],
      ),
      body: Column(
        children: [
          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16, vertical: AppSpacing.s8),
            child: Row(
              children: ['All', 'Payment', 'Offers', 'Security'].map((cat) {
                final isSelected = _selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.s8),
                  child: FilterChip(
                    label: Text(cat),
                    selected: isSelected,
                    onSelected: (val) {
                      setState(() {
                        _selectedCategory = cat;
                      });
                    },
                    selectedColor: AppColors.primary.withValues(alpha: 0.1),
                    checkmarkColor: AppColors.primary,
                    labelStyle: TextStyle(
                      fontFamily: 'Geist Sans',
                      color: isSelected ? AppColors.primary : AppColors.textPrimary,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const Divider(height: 1, color: AppColors.divider),

          // Notification List
          Expanded(
            child: filtered.isEmpty
                ? const EmptyState(
                    title: 'No Notifications',
                    description: 'You are all caught up! Important updates will appear here.',
                    icon: Icons.notifications_none_rounded,
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
                                        color: catColor.withValues(alpha: 0.08),
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
                                                fontFamily: 'Geist Sans',
                                                fontSize: 14.0,
                                                fontWeight: notif.isRead ? FontWeight.w600 : FontWeight.bold,
                                                color: AppColors.textPrimary,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Text(
                                            notif.time,
                                            style: const TextStyle(
                                              fontFamily: 'Geist Sans',
                                              fontSize: 11.0,
                                              color: AppColors.textSecondary,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: AppSpacing.s4),
                                      Text(
                                        notif.description,
                                        style: const TextStyle(
                                          fontFamily: 'Geist Sans',
                                          fontSize: 12.0,
                                          color: AppColors.textSecondary,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
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
