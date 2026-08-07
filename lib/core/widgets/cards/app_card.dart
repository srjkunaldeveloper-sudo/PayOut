import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final double? borderRadius;
  final bool hasShadow;
  final VoidCallback? onTap;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.color,
    this.borderRadius,
    this.hasShadow = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final double radius = borderRadius ?? AppRadius.xl;
    final Color cardColor = color ?? AppColors.surface;

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: (hasShadow || onTap != null) ? AppShadow.medium : AppShadow.none,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(radius),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(AppSpacing.s16),
            child: child,
          ),
        ),
      ),
    );
  }
}
