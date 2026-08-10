import 'package:flutter/material.dart';
import 'package:payout/core/error/error_message_mapper.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/widgets.dart';

class EmptyState extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final String? buttonText;
  final VoidCallback? onButtonPressed;

  const EmptyState({
    super.key,
    required this.title,
    required this.description,
    this.icon = Icons.inbox_rounded,
    this.buttonText,
    this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.s24),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.s32),
              decoration: BoxDecoration(
                color: AppColors.primaryContainer,
                shape: BoxShape.circle,
                boxShadow: AppShadow.small,
              ),
              child: Icon(
                icon,
                size: 56,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.s24),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTypography.headlineSmall.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.s8),
            Text(
              description,
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            if (buttonText != null && onButtonPressed != null) ...[
              const SizedBox(height: AppSpacing.s24),
              SizedBox(
                width: 200,
                child: PrimaryButton(
                  text: buttonText!,
                  onPressed: onButtonPressed,
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}

class ErrorState extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback? onRetry;
  final Object? error;

  const ErrorState({
    super.key,
    this.title = 'Something went wrong',
    this.description = 'We encountered an error processing your request. Please try again.',
    this.onRetry,
    this.error,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveDesc = error != null ? ErrorMessageMapper.map(error, fallback: description) : description;

    return EmptyState(
      title: title,
      description: effectiveDesc,
      icon: Icons.error_outline_rounded,
      buttonText: onRetry != null ? 'Try Again' : null,
      onButtonPressed: onRetry,
    );
  }
}

class SuccessState extends StatelessWidget {
  final String title;
  final String description;
  final String buttonText;
  final VoidCallback onButtonPressed;

  const SuccessState({
    super.key,
    required this.title,
    required this.description,
    required this.buttonText,
    required this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.s24),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.s24),
              decoration: const BoxDecoration(
                color: AppColors.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                size: 64,
                color: AppColors.success,
              ),
            ),
            const SizedBox(height: AppSpacing.s24),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTypography.headlineLarge.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.s8),
            Text(
              description,
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.s32),
            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                text: buttonText,
                onPressed: onButtonPressed,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class LoadingState extends StatelessWidget {
  final String? message;

  const LoadingState({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: const TextStyle(fontFamily: 'Geist Sans', fontSize: 13, color: AppColors.textSecondary),
            ),
          ],
        ],
      ),
    );
  }
}

class SkeletonLoader extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const SkeletonLoader({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
      ),
    );
  }
}

// Standardized naming aliases for unified architecture
typedef AppLoadingState = LoadingState;
typedef AppErrorState = ErrorState;
typedef AppEmptyState = EmptyState;
typedef AppSuccessState = SuccessState;
