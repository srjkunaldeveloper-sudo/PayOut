import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/app_card.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _faceIdEnabled = true;
  bool _pushNotifications = true;
  bool _emailReports = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'App Settings'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.s24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Security & Access',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.s12),
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text(
                      'Biometric Verification',
                      style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                    subtitle: const Text(
                      'Use FaceID or Fingerprint to unlock.',
                      style: TextStyle(fontFamily: 'Inter', fontSize: 12),
                    ),
                    value: _faceIdEnabled,
                    activeColor: AppColors.primary,
                    onChanged: (val) {
                      setState(() {
                        _faceIdEnabled = val;
                      });
                    },
                  ),
                  const Divider(height: 1, color: AppColors.divider),
                  ListTile(
                    title: const Text(
                      'Change security MPIN',
                      style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                    trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Route to reset MPIN.')),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.s32),
            const Text(
              'Notifications',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.s12),
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text(
                      'Push Notifications',
                      style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                    subtitle: const Text(
                      'Receive alerts for transfers and deposits.',
                      style: TextStyle(fontFamily: 'Inter', fontSize: 12),
                    ),
                    value: _pushNotifications,
                    activeColor: AppColors.primary,
                    onChanged: (val) {
                      setState(() {
                        _pushNotifications = val;
                      });
                    },
                  ),
                  const Divider(height: 1, color: AppColors.divider),
                  SwitchListTile(
                    title: const Text(
                      'Monthly Statements',
                      style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                    subtitle: const Text(
                      'Receive transaction history via email.',
                      style: TextStyle(fontFamily: 'Inter', fontSize: 12),
                    ),
                    value: _emailReports,
                    activeColor: AppColors.primary,
                    onChanged: (val) {
                      setState(() {
                        _emailReports = val;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.s32),
            const Text(
              'General Settings',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.s12),
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  ListTile(
                    title: const Text(
                      'Base Currency',
                      style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                    trailing: const Text(
                      'USD (\$)',
                      style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, color: AppColors.primary),
                    ),
                    onTap: () {},
                  ),
                  const Divider(height: 1, color: AppColors.divider),
                  ListTile(
                    title: const Text(
                      'About Payout App',
                      style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                    trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.s40),
          ],
        ),
      ),
    );
  }
}
