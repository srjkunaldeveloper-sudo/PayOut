import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/widgets.dart';
import 'package:payout/features/auth/presentation/login_screen.dart';
import 'package:payout/features/bank_accounts/presentation/bank_accounts_screen.dart';
import 'package:payout/features/rewards/presentation/rewards_screen.dart';
import 'package:payout/features/support/presentation/support_screen.dart';
import 'package:payout/features/qr/presentation/my_qr_screen.dart';
import 'package:payout/features/user/models/user_models.dart';
import 'package:payout/features/user/repositories/user_repository.dart';
import 'package:payout/features/user/dummy/dummy_user_data.dart';
import 'package:payout/features/user/presentation/kyc_status_screen.dart';
import 'package:payout/features/user/presentation/settings_screen.dart';
import 'package:payout/features/auth/services/session_manager.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserRepository _userRepository = MockUserRepository();
  
  UserProfileModel? _profile;
  KYCModel? _kyc;
  bool _isLoading = true;
  double _paymentLimit = 50000.0;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
    });
    final profileData = await _userRepository.getProfile();
    final kycData = await _userRepository.getKYC();
    if (mounted) {
      setState(() {
        _profile = profileData;
        _kyc = kycData;
        _isLoading = false;
      });
    }
  }

  void _showLogoutSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadii.bottomSheet)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.s24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.textSecondary.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: AppSpacing.s24),
                const Text(
                  'Confirm Logout',
                  style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: AppSpacing.s12),
                const Text(
                  'Are you sure you want to log out of your Payout account?',
                  style: TextStyle(fontFamily: 'Inter', color: AppColors.textSecondary, fontSize: 13),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.s24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButtonV2(
                        text: 'Cancel',
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.s16),
                    Expanded(
                      child: DangerButton(
                        text: 'Logout',
                        onPressed: () async {
                          await SessionManager.instance.logout();
                          if (!mounted) return;
                          Navigator.pop(context);
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => const LoginScreen()),
                            (route) => false,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading && _profile == null) {
      return const Scaffold(
        appBar: CustomAppBar(title: 'My Profile', showLeading: false),
        body: Center(
          child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary)),
        ),
      );
    }

    final user = _profile ?? DummyUserData.currentUser;
    final kycVal = _kyc ?? DummyUserData.currentKYC;

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
                      CustomAvatar(
                        name: user.name,
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
                    children: [
                      Text(
                        user.name,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(
                        Icons.verified_rounded,
                        color: AppColors.success,
                        size: 18,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '+91 ${user.phone} • ${user.email}',
                    style: const TextStyle(
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
                    trailing: Text(
                      kycVal.status,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: kycVal.status == 'VERIFIED' ? AppColors.success : Colors.orange,
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

            // 3. Saved Cards
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
                  ...DummyUserData.savedCards.map((card) {
                    return ListTile(
                      leading: const Icon(Icons.credit_card_rounded, color: AppColors.primary),
                      title: Text(card.cardHolderName, style: const TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w600)),
                      subtitle: Text(card.cardNumber, style: const TextStyle(fontFamily: 'Inter', fontSize: 11, color: AppColors.textSecondary)),
                      trailing: const Icon(Icons.more_vert_rounded),
                    );
                  }).toList(),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.s24),

            // 4. App Shortcuts & Preferences
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
              onPressed: _showLogoutSheet,
            ),
            const SizedBox(height: AppSpacing.s40),
          ],
        ),
      ),
    );
  }
}
