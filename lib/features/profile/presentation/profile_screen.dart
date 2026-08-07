import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/app_button.dart';
import 'package:payout/core/widgets/app_card.dart';
import 'package:payout/core/widgets/avatar.dart';
import 'package:payout/features/bank_accounts/presentation/bank_accounts_screen.dart';
import 'package:payout/features/kyc_status/presentation/kyc_status_screen.dart';
import 'package:payout/features/my_qr/presentation/my_qr_screen.dart';
import 'package:payout/features/splash/presentation/splash_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  double _dailyLimit = 5000.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Account Settings', showLeading: false),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.s24),
        child: Column(
          children: [
            // Profile Card
            Center(
              child: Column(
                children: [
                  const CustomAvatar(
                    name: 'Alex Morgan',
                    size: 80,
                    backgroundColor: AppColors.primaryLight,
                    textColor: AppColors.primary,
                  ),
                  const SizedBox(height: AppSpacing.s16),
                  const Text(
                    'Alex Morgan',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Text(
                    'alex.morgan@payout.app',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13.0,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.s32),
            // Subpages links
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.qr_code_2_rounded, color: AppColors.primary),
                    title: const Text(
                      'My Payment QR',
                      style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                    trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const MyQRScreen()),
                      );
                    },
                  ),
                  const Divider(height: 1, color: AppColors.divider),
                  ListTile(
                    leading: const Icon(Icons.account_balance_rounded, color: AppColors.primary),
                    title: const Text(
                      'Linked Bank Accounts',
                      style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                    trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const BankAccountsScreen()),
                      );
                    },
                  ),
                  const Divider(height: 1, color: AppColors.divider),
                  ListTile(
                    leading: const Icon(Icons.verified_user_rounded, color: AppColors.primary),
                    title: const Text(
                      'Identity KYC Status',
                      style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                    trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const KYCStatusScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.s32),
            // Limit controller card
            AppCard(
              padding: const EdgeInsets.all(AppSpacing.s20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Daily Transfer Limit',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        '\$${_dailyLimit.toInt()}',
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.s8),
                  Slider(
                    value: _dailyLimit,
                    min: 1000.0,
                    max: 10000.0,
                    divisions: 9,
                    activeColor: AppColors.primary,
                    inactiveColor: AppColors.primaryLight,
                    onChanged: (val) {
                      setState(() {
                        _dailyLimit = val;
                      });
                    },
                  ),
                  const Text(
                    'Limits prevent unauthorised large transfers out of your wallet.',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.s32),
            // Log out CTA
            SizedBox(
              width: double.infinity,
              child: AppButton(
                text: 'Sign Out',
                type: AppButtonType.outline,
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const SplashScreen()),
                    (route) => false,
                  );
                },
              ),
            ),
            const SizedBox(height: AppSpacing.s40),
          ],
        ),
      ),
    );
  }
}
