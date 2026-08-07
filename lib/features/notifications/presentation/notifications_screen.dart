import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/app_card.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> todayNotifications = [
      {
        'title': 'Payment Received',
        'body': '₹1,500.00 credited from failed UPI rollback.',
        'type': 'Payment',
        'icon': Icons.check_circle_rounded,
        'color': AppColors.success
      },
      {
        'title': 'Login Detected',
        'body': 'A new login was detected on macOS Safari at 04:30 PM.',
        'type': 'Security',
        'icon': Icons.security_rounded,
        'color': Colors.indigo
      },
    ];

    final List<Map<String, dynamic>> yesterdayNotifications = [
      {
        'title': 'Bill Due Reminder',
        'body': 'Your Electricity bill of ₹84.60 is due by Aug 18.',
        'type': 'Bill',
        'icon': Icons.pending_actions_rounded,
        'color': Colors.orange
      },
      {
        'title': 'Mega Cashback Offer',
        'body': 'Get up to ₹150 cashback on your next travel flight booking.',
        'type': 'Offer',
        'icon': Icons.local_offer_rounded,
        'color': Colors.red
      },
    ];

    final List<Map<String, dynamic>> earlierNotifications = [
      {
        'title': 'KYC Verified',
        'body': 'Congratulations! Your document verification is complete.',
        'type': 'KYC',
        'icon': Icons.verified_rounded,
        'color': AppColors.primary
      },
    ];

    Widget _buildNotificationList(List<Map<String, dynamic>> list) {
      return Column(
        children: list.map((notif) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.s12),
            child: AppCard(
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.s12),
                    decoration: BoxDecoration(
                      color: (notif['color'] as Color).withOpacity(0.08),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(notif['icon'] as IconData, color: notif['color'] as Color, size: 20),
                  ),
                  const SizedBox(width: AppSpacing.s16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notif['title'] as String,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          notif['body'] as String,
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
          );
        }).toList(),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Alerts & Updates'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.s24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (todayNotifications.isNotEmpty) ...[
              const Text(
                'Today',
                style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textSecondary),
              ),
              const SizedBox(height: AppSpacing.s12),
              _buildNotificationList(todayNotifications),
              const SizedBox(height: AppSpacing.s20),
            ],
            if (yesterdayNotifications.isNotEmpty) ...[
              const Text(
                'Yesterday',
                style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textSecondary),
              ),
              const SizedBox(height: AppSpacing.s12),
              _buildNotificationList(yesterdayNotifications),
              const SizedBox(height: AppSpacing.s20),
            ],
            if (earlierNotifications.isNotEmpty) ...[
              const Text(
                'Earlier',
                style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textSecondary),
              ),
              const SizedBox(height: AppSpacing.s12),
              _buildNotificationList(earlierNotifications),
            ],
            const SizedBox(height: AppSpacing.s40),
          ],
        ),
      ),
    );
  }
}
