import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final Color? color;
  final Border? border;
  final bool hasShadow;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.color,
    this.border,
    this.hasShadow = false,
  });

  @override
  Widget build(BuildContext context) {
    final cardWidget = Container(
      padding: padding ?? const EdgeInsets.all(AppSpacing.s16),
      decoration: BoxDecoration(
        color: color ?? AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadii.card),
        border: border ?? Border.all(color: AppColors.divider, width: 1.0),
        boxShadow: hasShadow
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: child,
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadii.card),
          child: cardWidget,
        ),
      );
    }

    return cardWidget;
  }
}
