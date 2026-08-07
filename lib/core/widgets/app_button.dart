import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';

enum AppButtonType { primary, secondary, outline }

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonType type;
  final bool isLoading;
  final IconData? icon;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = AppButtonType.primary,
    this.isLoading = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = onPressed != null && !isLoading;

    Color getBgColor() {
      if (!isEnabled) return AppColors.surface;
      switch (type) {
        case AppButtonType.primary:
          return AppColors.primary;
        case AppButtonType.secondary:
          return AppColors.primaryLight;
        case AppButtonType.outline:
          return Colors.transparent;
      }
    }

    Color getTextColor() {
      if (!isEnabled) return AppColors.textSecondary;
      switch (type) {
        case AppButtonType.primary:
          return AppColors.background;
        case AppButtonType.secondary:
        case AppButtonType.outline:
          return AppColors.primary;
      }
    }

    Border? getBorder() {
      if (type == AppButtonType.outline) {
        return Border.all(
          color: isEnabled ? AppColors.primary : AppColors.divider,
          width: 1.5,
        );
      }
      return null;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      height: 52,
      decoration: BoxDecoration(
        color: getBgColor(),
        borderRadius: BorderRadius.circular(AppRadii.button),
        border: getBorder(),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isEnabled ? onPressed : null,
          borderRadius: BorderRadius.circular(AppRadii.button),
          child: Center(
            child: isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.0,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (icon != null) ...[
                        Icon(icon, size: 20, color: getTextColor()),
                        const SizedBox(width: AppSpacing.s8),
                      ],
                      Text(
                        text,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                          color: getTextColor(),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
