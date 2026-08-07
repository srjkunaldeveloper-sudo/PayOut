import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_colors.dart';
import 'package:payout/core/theme/app_typography.dart';
import 'package:payout/core/theme/app_spacing.dart';
import 'package:payout/core/theme/app_radius.dart';
import 'package:payout/core/theme/theme_extensions.dart';

export 'package:payout/core/theme/app_colors.dart';
export 'package:payout/core/theme/app_typography.dart';
export 'package:payout/core/theme/app_spacing.dart';
export 'package:payout/core/theme/app_radius.dart';
export 'package:payout/core/theme/app_shadow.dart';
export 'package:payout/core/theme/app_elevation.dart';
export 'package:payout/core/theme/app_icons.dart';
export 'package:payout/core/theme/app_animation.dart';
export 'package:payout/core/theme/app_breakpoints.dart';
export 'package:payout/core/theme/theme_extensions.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.primary,
        onPrimary: AppColors.background,
        primaryContainer: AppColors.primaryContainer,
        onPrimaryContainer: AppColors.primary,
        secondary: AppColors.secondary,
        onSecondary: AppColors.textPrimary,
        error: AppColors.error,
        onError: AppColors.background,
        surface: AppColors.background,
        onSurface: AppColors.textPrimary,
        surfaceContainerLow: AppColors.surface,
        outline: AppColors.divider,
      ),
      fontFamily: 'Inter',
      scaffoldBackgroundColor: AppColors.background,
      dividerColor: AppColors.divider,
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.xl),
          side: BorderSide.none,
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: AppTypography.displayLarge,
        displayMedium: AppTypography.displayMedium,
        displaySmall: AppTypography.displaySmall,
        headlineLarge: AppTypography.headlineLarge,
        headlineMedium: AppTypography.headlineMedium,
        headlineSmall: AppTypography.headlineSmall,
        titleLarge: AppTypography.titleLarge,
        titleMedium: AppTypography.titleMedium,
        titleSmall: AppTypography.titleSmall,
        bodyLarge: AppTypography.bodyLarge,
        bodyMedium: AppTypography.bodyMedium,
        bodySmall: AppTypography.bodySmall,
        labelLarge: AppTypography.labelLarge,
        labelMedium: AppTypography.labelMedium,
        labelSmall: AppTypography.labelSmall,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
        titleTextStyle: TextStyle(
          fontFamily: 'Inter',
          fontSize: 20.0,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s16,
          vertical: AppSpacing.s16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.error, width: 1.0),
        ),
        labelStyle: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 14.0,
          color: AppColors.textSecondary,
        ),
        hintStyle: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 14.0,
          color: AppColors.textSecondary,
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.xxl),
          ),
        ),
        elevation: 4.0,
      ),
      extensions: const [
        PayoutThemeExtension(
          amountLarge: AppTypography.amountLarge,
          amountMedium: AppTypography.amountMedium,
          amountSmall: AppTypography.amountSmall,
          income: AppColors.income,
          expense: AppColors.expense,
          credit: AppColors.credit,
          debit: AppColors.debit,
          pending: AppColors.pending,
          failed: AppColors.failed,
        ),
      ],
    );
  }
}
