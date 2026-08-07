import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/widgets.dart';
import 'package:payout/features/auth/presentation/login_screen.dart';
import 'package:payout/features/bank_accounts/presentation/bank_accounts_screen.dart';
import 'package:payout/features/kyc_status/presentation/kyc_status_screen.dart';
import 'package:payout/features/my_qr/presentation/my_qr_screen.dart';
import 'package:payout/features/rewards/presentation/rewards_screen.dart';
import 'package:payout/features/settings/presentation/settings_screen.dart';
import 'package:payout/features/support/presentation/support_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  double _paymentLimit = 50000.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'My Profile',
        showLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_2_rounded, color: AppColors.textPrimary),
            tooltip: 'My QR Code',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MyQRScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24, vertical: AppSpacing.s16),
        child: Column(
          children: [
            // 1. Profile Header Hero
            Center(
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      const CustomAvatar(
                        name: 'Alex Morgan',
                        size: 88,
                        backgroundColor: AppColors.primaryLight,
                        textColor: AppColors.primary,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const MyQRScreen()),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(AppSpacing.s6),
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.qr_code_2_rounded,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.s16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Alex Morgan',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(width: 6),
                      Icon(
                        Icons.verified_rounded,
                        color: AppColors.success,
                        size: 18,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '+91 98765 43210 • alex.morgan@payout.in',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.s32),

            // 2. Account Status Details
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.verified_user_rounded, color: AppColors.success),
                    title: const Text('KYC Verification', style: TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w600)),
                    trailing: const Text(
                      'VERIFIED',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppColors.success,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const KYCStatusScreen()),
                      );
                    },
                  ),
                  const Divider(height: 1, color: AppColors.divider),
                  ListTile(
                    leading: const Icon(Icons.account_balance_rounded, color: AppColors.primary),
                    title: const Text('Linked Bank Accounts', style: TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w600)),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const BankAccountsScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.s24),

            // 3. Saved Payment Methods
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Saved Cards',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 14.0, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: AppSpacing.s12),
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.credit_card_rounded, color: AppColors.primary),
                    title: const Text('HDFC Regalia Credit Card', style: TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w600)),
                    subtitle: const Text('•••• •••• •••• 9821', style: TextStyle(fontFamily: 'Inter', fontSize: 11, color: AppColors.textSecondary)),
                    trailing: const Icon(Icons.more_vert_rounded),
                  ),
                  const Divider(height: 1, color: AppColors.divider),
                  ListTile(
                    leading: const Icon(Icons.credit_card_outlined, color: AppColors.textSecondary),
                    title: const Text('ICICI Coral Debit Card', style: TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w600)),
                    subtitle: const Text('•••• •••• •••• 1029', style: TextStyle(fontFamily: 'Inter', fontSize: 11, color: AppColors.textSecondary)),
                    trailing: const Icon(Icons.more_vert_rounded),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.s24),

            // 4. App Shortcuts & Settings Group
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Preferences & Help',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 14.0, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: AppSpacing.s12),
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.stars_rounded, color: Colors.orange),
                    title: const Text('My Rewards & Cashback', style: TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w600)),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RewardsScreen()),
                      );
                    },
                  ),
                  const Divider(height: 1, color: AppColors.divider),
                  ListTile(
                    leading: const Icon(Icons.settings_rounded, color: AppColors.textSecondary),
                    title: const Text('App Settings', style: TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w600)),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SettingsScreen()),
                      );
                    },
                  ),
                  const Divider(height: 1, color: AppColors.divider),
                  ListTile(
                    leading: const Icon(Icons.support_agent_rounded, color: Colors.blueGrey),
                    title: const Text('Help & Support', style: TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w600)),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SupportScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.s24),

            // 5. Daily limit slider cap
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Daily Payment Limit',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 14.0, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: AppSpacing.s12),
            AppCard(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Limit Cap',
                        style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.textSecondary),
                      ),
                      Text(
                        '₹${_paymentLimit.toStringAsFixed(0)}',
                        style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textPrimary),
                      ),
                    ],
                  ),
                  Slider(
                    value: _paymentLimit,
                    min: 10000.0,
                    max: 100000.0,
                    divisions: 9,
                    activeColor: AppColors.primary,
                    inactiveColor: AppColors.primaryLight,
                    onChanged: (val) {
                      setState(() {
                        _paymentLimit = val;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.s32),

            DangerButton(
              text: 'Logout',
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              },
            ),
            const SizedBox(height: AppSpacing.s40),
          ],
        ),
      ),
    );
  }
}
