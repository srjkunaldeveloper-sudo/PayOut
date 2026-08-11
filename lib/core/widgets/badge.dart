import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';

enum BadgeType { success, warning, error, primary }

class CustomBadge extends StatelessWidget {
  final String label;
  final BadgeType type;

  const CustomBadge({
    super.key,
    required this.label,
    this.type = BadgeType.primary,
  });

  @override
  Widget build(BuildContext context) {
    Color getBgColor() {
      switch (type) {
        case BadgeType.success:
          return AppColors.success.withValues(alpha: 0.1);
        case BadgeType.warning:
          return AppColors.warning.withValues(alpha: 0.1);
        case BadgeType.error:
          return AppColors.error.withValues(alpha: 0.1);
        case BadgeType.primary:
          return AppColors.primaryLight;
      }
    }

    Color getTextColor() {
      switch (type) {
        case BadgeType.success:
          return AppColors.success;
        case BadgeType.warning:
          return AppColors.warning;
        case BadgeType.error:
          return AppColors.error;
        case BadgeType.primary:
          return AppColors.primary;
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s8, vertical: AppSpacing.s4),
      decoration: BoxDecoration(
        color: getBgColor(),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          fontFamily: 'Geist Sans',
          fontSize: 10.0,
          fontWeight: FontWeight.w700,
          color: getTextColor(),
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
