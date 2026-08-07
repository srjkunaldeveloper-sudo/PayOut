import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/avatar.dart';

class TransactionTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String date;
  final double amount;
  final bool isCredit;
  final VoidCallback? onTap;

  const TransactionTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.date,
    required this.amount,
    required this.isCredit,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.s12, horizontal: AppSpacing.s4),
        child: Row(
          children: [
            CustomAvatar(
              name: title,
              size: 44,
              backgroundColor: isCredit ? AppColors.success.withOpacity(0.1) : AppColors.primaryLight,
              textColor: isCredit ? AppColors.success : AppColors.primary,
            ),
            const SizedBox(width: AppSpacing.s12),
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
                  const SizedBox(height: AppSpacing.s2),
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
            const SizedBox(width: AppSpacing.s8),
            Text(
              '${isCredit ? '+' : '-'}\$${amount.toStringAsFixed(2)}',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
                color: isCredit ? AppColors.success : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
