import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/widgets.dart';

class AuthErrorWidget extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback? onRetry;
  final VoidCallback? onDismiss;

  const AuthErrorWidget({
    super.key,
    required this.title,
    required this.description,
    this.onRetry,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.s20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: AppColors.error,
            size: 40,
          ),
          const SizedBox(height: AppSpacing.s12),
          Text(
            title,
            style: AppTypography.titleLarge.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.s8),
          Text(
            description,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.s20),
          Row(
            children: [
              if (onDismiss != null)
                Expanded(
                  child: OutlinedButtonV2(
                    text: 'Cancel',
                    onPressed: onDismiss,
                  ),
                ),
              if (onDismiss != null && onRetry != null)
                const SizedBox(width: AppSpacing.s12),
              if (onRetry != null)
                Expanded(
                  child: PrimaryButton(
                    text: 'Try Again',
                    onPressed: onRetry,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
