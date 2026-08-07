import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';

class TextButtonV2 extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isDisabled;
  final IconData? iconLeft;
  final IconData? iconRight;
  final double? width;
  final double height;

  const TextButtonV2({
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
      width: width,
      height: height,
      child: TextButton(
        onPressed: isButtonEnabled ? onPressed : null,
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          disabledForegroundColor: AppColors.textHint,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.circle),
          ),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
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
                      color: isButtonEnabled ? AppColors.primary : AppColors.textHint,
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
