import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';

class DangerButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isDisabled;
  final IconData? iconLeft;
  final IconData? iconRight;
  final double? width;
  final double height;

  const DangerButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.iconLeft,
    this.iconRight,
    this.width,
    this.height = 48.0,
  });

  @override
  Widget build(BuildContext context) {
    final bool isButtonEnabled = onPressed != null && !isDisabled && !isLoading;

    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: isButtonEnabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.error,
          foregroundColor: AppColors.background,
          disabledBackgroundColor: AppColors.textDisabled,
          disabledForegroundColor: AppColors.textHint,
          elevation: AppElevation.level0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.circle),
          ),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24),
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.background),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (iconLeft != null) ...[
                    Icon(iconLeft, size: 18),
                    const SizedBox(width: AppSpacing.s8),
                  ],
                  Text(
                    text,
                    style: AppTypography.labelLarge.copyWith(
                      color: isButtonEnabled ? AppColors.background : AppColors.textHint,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (iconRight != null) ...[
                    const SizedBox(width: AppSpacing.s8),
                    Icon(iconRight, size: 18),
                  ],
                ],
              ),
      ),
    );
  }
}
