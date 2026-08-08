import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/widgets.dart';
import 'package:payout/features/auth/presentation/login_screen.dart';
import 'package:payout/features/auth/services/session_manager.dart';
import 'package:payout/features/bank_accounts/presentation/bank_accounts_screen.dart';
import 'package:payout/features/rewards/presentation/rewards_screen.dart';
import 'package:payout/features/support/presentation/support_screen.dart';
import 'package:payout/features/qr/presentation/my_qr_screen.dart';
import 'package:payout/features/user/models/user_models.dart';
import 'package:payout/features/user/repositories/user_repository.dart';
import 'package:payout/features/user/presentation/edit_profile_screen.dart';
import 'package:payout/features/user/presentation/kyc_status_screen.dart';
import 'package:payout/features/user/presentation/settings_screen.dart';
import 'package:payout/features/user/presentation/about_screen.dart';

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
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
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
                    color: AppColors.divider,
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
                          if (context.mounted) {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (context) => const LoginScreen()),
                              (route) => false,
                            );
                          }
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
    if (_isLoading || _profile == null) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        appBar: CustomAppBar(title: 'My Profile'),
        body: Center(
          child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary)),
        ),
      );
    }

    final profile = _profile!;
    final isKycVerified = _kyc?.status.toUpperCase() == 'VERIFIED' || profile.isKycVerified;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'My Profile',
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: AppColors.primary),
            onPressed: () async {
              final updated = await Navigator.push<bool>(
                context,
                MaterialPageRoute(builder: (context) => EditProfileScreen(profile: profile)),
              );
              if (updated == true) {
                _loadUserData();
              }
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadUserData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppSpacing.s24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Profile Header
              AppCard(
                child: Row(
                  children: [
                    CustomAvatar(
                      name: profile.name,
                      size: 60,
                      backgroundColor: AppColors.primaryContainer,
                      textColor: AppColors.primary,
                    ),
                    const SizedBox(width: AppSpacing.s16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            profile.name,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '+91 ${profile.phone}',
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12.0,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Text(
                            profile.email,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 11.0,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: (isKycVerified ? AppColors.success : Colors.orange).withOpacity(0.08),
                              borderRadius: BorderRadius.circular(AppRadius.xs),
                            ),
                            child: Text(
                              isKycVerified ? 'KYC Verified' : 'KYC Pending',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: isKycVerified ? AppColors.success : Colors.orange,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.s16),

              // 2. Overview Stats (Member Since / Linked Banks)
              Row(
                children: [
                  Expanded(
                    child: AppCard(
                      padding: const EdgeInsets.all(AppSpacing.s16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Member Since', style: TextStyle(fontFamily: 'Inter', fontSize: 11, color: AppColors.textSecondary)),
                          const SizedBox(height: 4),
                          Text(profile.memberSince, style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 13)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.s12),
                  Expanded(
                    child: AppCard(
                      padding: const EdgeInsets.all(AppSpacing.s16),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const BankAccountsScreen()));
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Linked Banks', style: TextStyle(fontFamily: 'Inter', fontSize: 11, color: AppColors.textSecondary)),
                          const SizedBox(height: 4),
                          Text('${profile.linkedBankCount} Accounts', style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primary)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.s24),

              // 3. Account Section
              const Text('Account & Identity', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: AppSpacing.s12),
              AppCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    _buildNavTile(
                      icon: Icons.person_outline_rounded,
                      title: 'Edit Personal Details',
                      subtitle: 'Update name, email, DOB',
                      onTap: () async {
                        final res = await Navigator.push<bool>(
                          context,
                          MaterialPageRoute(builder: (context) => EditProfileScreen(profile: profile)),
                        );
                        if (res == true) _loadUserData();
                      },
                    ),
                    const Divider(height: 1, color: AppColors.divider),
                    _buildNavTile(
                      icon: Icons.verified_user_outlined,
                      title: 'KYC Verification Center',
                      subtitle: isKycVerified ? 'Verified Level 2' : 'Action Required',
                      trailingText: isKycVerified ? 'Verified' : 'Pending',
                      trailingColor: isKycVerified ? AppColors.success : Colors.orange,
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const KYCStatusScreen()),
                        );
                        _loadUserData();
                      },
                    ),
                    const Divider(height: 1, color: AppColors.divider),
                    _buildNavTile(
                      icon: Icons.account_balance_outlined,
                      title: 'Bank Accounts',
                      subtitle: 'Manage linked bank accounts',
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const BankAccountsScreen()));
                      },
                    ),
                    const Divider(height: 1, color: AppColors.divider),
                    _buildNavTile(
                      icon: Icons.qr_code_rounded,
                      title: 'My UPI QR Code',
                      subtitle: 'Receive money with personal QR',
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const MyQRScreen()));
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.s24),

              // 4. Preferences & Security Section
              const Text('Preferences & Security', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: AppSpacing.s12),
              AppCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    _buildNavTile(
                      icon: Icons.settings_outlined,
                      title: 'App Settings & Security',
                      subtitle: 'MPIN, Biometrics, Language, Alerts',
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen()));
                      },
                    ),
                    const Divider(height: 1, color: AppColors.divider),
                    _buildNavTile(
                      icon: Icons.stars_outlined,
                      title: 'Rewards & Cashback',
                      subtitle: 'Scratch cards, coupons, coins',
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const RewardsScreen()));
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.s24),

              // 5. Support & Legal Section
              const Text('Support & Legal', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: AppSpacing.s12),
              AppCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    _buildNavTile(
                      icon: Icons.help_outline_rounded,
                      title: 'Help & Customer Support',
                      subtitle: '24/7 assistance and FAQs',
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const SupportScreen()));
                      },
                    ),
                    const Divider(height: 1, color: AppColors.divider),
                    _buildNavTile(
                      icon: Icons.info_outline_rounded,
                      title: 'About Payout',
                      subtitle: 'App version, terms, privacy',
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const AboutScreen()));
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.s24),

              // 6. Logout Button
              AppCard(
                padding: EdgeInsets.zero,
                child: ListTile(
                  leading: const Icon(Icons.logout_rounded, color: AppColors.error),
                  title: const Text(
                    'Logout',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: AppColors.error,
                    ),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.error),
                  onTap: _showLogoutSheet,
                ),
              ),
              const SizedBox(height: AppSpacing.s32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    String? trailingText,
    Color? trailingColor,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title, style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w600, fontSize: 13)),
      subtitle: Text(subtitle, style: const TextStyle(fontFamily: 'Inter', fontSize: 11, color: AppColors.textSecondary)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailingText != null)
            Padding(
              padding: const EdgeInsets.only(right: 6.0),
              child: Text(
                trailingText,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                  color: trailingColor ?? AppColors.textSecondary,
                ),
              ),
            ),
          const Icon(Icons.arrow_forward_ios_rounded, size: 13, color: AppColors.textSecondary),
        ],
      ),
      onTap: onTap,
    );
  }
}
