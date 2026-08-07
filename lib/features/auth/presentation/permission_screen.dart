import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/widgets.dart';
import 'package:payout/features/dashboard/presentation/dashboard_shell.dart';

class PermissionScreen extends StatelessWidget {
  const PermissionScreen({super.key});

  Widget _buildPermissionItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.s16),
      margin: const EdgeInsets.only(bottom: AppSpacing.s16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.s12),
            decoration: const BoxDecoration(
              color: AppColors.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: AppSpacing.s16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.bodyLarge.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: '', showLeading: false),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24, vertical: AppSpacing.s12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.s16),
              Text(
                'Help us secure your account',
                style: AppTypography.displaySmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  fontSize: 24.0,
                ),
              ),
              const SizedBox(height: AppSpacing.s8),
              Text(
                'We require the following permissions to ensure secure transactions and prevent fraud on your device.',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.s32),
              
              Expanded(
                child: ListView(
                  children: [
                    _buildPermissionItem(
                      icon: Icons.notifications_active_rounded,
                      title: 'Notifications',
                      description: 'Get real-time transaction updates, fraud alerts, and rewards.',
                    ),
                    _buildPermissionItem(
                      icon: Icons.location_on_rounded,
                      title: 'Location',
                      description: 'Prevent fraud by verifying merchant locations and payment details.',
                    ),
                    _buildPermissionItem(
                      icon: Icons.contacts_rounded,
                      title: 'Contacts',
                      description: 'Easily send money to your friends and family from your contact list.',
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: AppSpacing.s16),
              
              // Action buttons
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  text: 'Allow & Continue',
                  onPressed: () {
                    // Navigate to final dashboard shell
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => const DashboardShell()),
                      (route) => false,
                    );
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.s12),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => const DashboardShell()),
                      (route) => false,
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
              const SizedBox(height: AppSpacing.s8),
            ],
          ),
        ),
      ),
    );
  }
}
