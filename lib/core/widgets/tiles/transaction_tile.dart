import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/avatar/avatar.dart';

class TransactionTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String date;
  final double amount;
  final bool isCredit;
  final String? status;
  final VoidCallback? onTap;

  const TransactionTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.date,
    required this.amount,
    required this.isCredit,
    this.status,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final statusText = status ?? (isCredit ? 'Received' : 'Cleared');
    final statusColor = isCredit ? AppColors.success : AppColors.textSecondary;
    final statusBg = isCredit ? AppColors.success.withOpacity(0.08) : AppColors.surface;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.xl),
      highlightColor: AppColors.primary.withOpacity(0.04),
      splashColor: AppColors.primary.withOpacity(0.08),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.s12, horizontal: AppSpacing.s12),
        child: Row(
          children: [
            CustomAvatar(
              name: title,
              size: 46,
              backgroundColor: isCredit ? AppColors.success.withOpacity(0.08) : AppColors.primaryContainer.withOpacity(0.4),
              textColor: isCredit ? AppColors.success : AppColors.primary,
            ),
            const SizedBox(width: AppSpacing.s16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.s4),
                  Text(
                    '$subtitle • $date',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12.0,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.s12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${isCredit ? '+' : '-'}₹${amount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    color: isCredit ? AppColors.success : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.s4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: statusBg,
                    borderRadius: BorderRadius.circular(AppRadius.xs),
                  ),
                  child: Text(
                    statusText,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 10.0,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
