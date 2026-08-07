import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/app_card.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> alerts = [
      {
        'title': 'Deposit Succeeded',
        'body': 'Your bank deposit of \$500.00 to your wallet was successful.',
        'time': '2 hours ago',
        'icon': Icons.arrow_downward_rounded,
        'color': AppColors.success,
      },
      {
        'title': 'New Cashback Perk!',
        'body': 'Earn \$10 cashback when you buy travel flight tickets today.',
        'time': '1 day ago',
        'icon': Icons.percent_rounded,
        'color': AppColors.primary,
      },
      {
        'title': 'Security Alert',
        'body': 'Your MPIN security configuration was updated successfully.',
        'time': '3 days ago',
        'icon': Icons.security_rounded,
        'color': AppColors.warning,
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Notifications'),
      body: ListView.builder(
        padding: const EdgeInsets.all(AppSpacing.s24),
        itemCount: alerts.length,
        itemBuilder: (context, index) {
          final item = alerts[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.s12),
            child: AppCard(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.s8),
                    decoration: BoxDecoration(
                      color: item['color'].withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(item['icon'] as IconData, color: item['color'] as Color, size: 20),
                  ),
                  const SizedBox(width: AppSpacing.s16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['title'] as String,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item['body'] as String,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12.0,
                            color: AppColors.textSecondary,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item['time'] as String,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 10.0,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
