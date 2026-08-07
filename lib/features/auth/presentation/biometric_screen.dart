import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/widgets.dart';
import 'package:payout/features/auth/presentation/permission_screen.dart';

class BiometricScreen extends StatelessWidget {
  const BiometricScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: '', showLeading: false),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24, vertical: AppSpacing.s12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              
              // Fingerprint and Face ID premium vector icon frame
              Container(
                padding: const EdgeInsets.all(AppSpacing.s32),
                decoration: const BoxDecoration(
                  color: AppColors.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.fingerprint_rounded,
                  size: 80,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: AppSpacing.s40),
              
              Text(
                'Enable Biometric Login',
                style: AppTypography.displaySmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  fontSize: 26.0,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.s12),
              Text(
                'Unlock your account instantly using Fingerprint or Face ID. This ensures maximum security for your transactions.',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              
              const Spacer(),
              
              // Action buttons
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  text: 'Enable Now',
                  onPressed: () {
                    // Simulate permission request & navigate
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const PermissionScreen()),
                    );
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.s12),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const PermissionScreen()),
                    );
                  },
                  child: Text(
                    'Skip for now',
                    style: AppTypography.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.s16),
            ],
          ),
        ),
      ),
    );
  }
}
