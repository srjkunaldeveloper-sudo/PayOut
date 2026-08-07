import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionText;
  final VoidCallback? onActionPressed;

  const SectionHeader({
    super.key,
    required this.title,
    this.actionText,
    this.onActionPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.s12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
          ),
          if (actionText != null && onActionPressed != null)
            GestureDetector(
              onTap: onActionPressed,
              child: Text(
                actionText!,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14.0,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
