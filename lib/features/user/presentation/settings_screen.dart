import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/widgets.dart';
import 'package:payout/features/auth/presentation/login_screen.dart';
import 'package:payout/features/auth/services/session_manager.dart';
import 'package:payout/features/bank_accounts/presentation/bank_accounts_screen.dart';
import 'package:payout/features/payments/presentation/mpin_verification_screen.dart';
import 'package:payout/features/support/presentation/support_screen.dart';
import 'package:payout/core/di/app_dependencies.dart';
import 'package:payout/features/user/models/user_models.dart';
import 'package:payout/features/user/repositories/user_repository.dart';
import 'package:payout/features/user/presentation/about_screen.dart';
import 'package:payout/features/user/presentation/edit_profile_screen.dart';
import 'package:payout/features/user/presentation/kyc_status_screen.dart';

class SettingsScreen extends StatefulWidget {
  final UserRepository? userRepository;

  const SettingsScreen({super.key, this.userRepository});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final UserRepository _userRepository;

  PreferenceModel? _prefs;
  UserProfileModel? _profile;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _userRepository = widget.userRepository ?? AppDependencies.instance.userRepository;
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });
    final prefs = await _userRepository.getPreferences();
    final profile = await _userRepository.getProfile();
    if (mounted) {
      setState(() {
        _prefs = prefs;
        _profile = profile;
        _isLoading = false;
      });
    }
  }

  Future<void> _updatePrefs(PreferenceModel newPrefs) async {
    setState(() {
      _prefs = newPrefs;
    });
    await _userRepository.updatePreferences(newPrefs);
  }

  void _showLogoutDialog() {
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
                  style: TextStyle(fontFamily: 'Geist Sans', fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: AppSpacing.s12),
                const Text(
                  'Are you sure you want to log out of your Payout account?',
                  style: TextStyle(fontFamily: 'Geist Sans', color: AppColors.textSecondary, fontSize: 13),
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

  void _showDeleteAccountDialog() {
    final passwordController = TextEditingController();
    bool isDeleting = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SafeArea(
              child: Padding(
                padding: EdgeInsets.only(
                  left: AppSpacing.s24,
                  right: AppSpacing.s24,
                  top: AppSpacing.s24,
                  bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.s24,
                ),
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
                    const SizedBox(height: AppSpacing.s20),
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: AppColors.error.withValues(alpha: 0.08),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: const Icon(Icons.delete_forever_rounded, color: AppColors.error, size: 28),
                    ),
                    const SizedBox(height: AppSpacing.s16),
                    const Text(
                      'Delete Account Permanently',
                      style: TextStyle(fontFamily: 'Geist Sans', fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(height: AppSpacing.s12),
                    const Text(
                      'This action is irreversible. All your profile data, transaction history, KYC records, and linked credentials will be permanently erased.',
                      style: TextStyle(fontFamily: 'Geist Sans', color: AppColors.textSecondary, fontSize: 13, height: 1.4),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.s20),
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Enter password to confirm (optional)',
                        hintStyle: const TextStyle(fontFamily: 'Geist Sans', fontSize: 13, color: AppColors.textSecondary),
                        prefixIcon: const Icon(Icons.lock_outline_rounded, size: 18, color: AppColors.textSecondary),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.divider),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.divider),
                        ),
                      ),
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
                            text: isDeleting ? 'Deleting...' : 'Delete Account',
                            onPressed: isDeleting
                                ? () {}
                                : () async {
                                    setModalState(() {
                                      isDeleting = true;
                                    });

                                    final navigator = Navigator.of(context);
                                    final messenger = ScaffoldMessenger.of(context);

                                    final authRepo = AppDependencies.instance.authRepository;
                                    final pwd = passwordController.text.trim();
                                    final result = await authRepo.deleteAccount(
                                      currentPassword: pwd.isNotEmpty ? pwd : null,
                                    );

                                    if (result.isSuccess) {
                                      await SessionManager.instance.logout();
                                      if (mounted) {
                                        navigator.pop(); // Close bottom sheet
                                        navigator.pushAndRemoveUntil(
                                          MaterialPageRoute(builder: (context) => const LoginScreen()),
                                          (route) => false,
                                        );
                                        messenger.showSnackBar(
                                          const SnackBar(
                                            content: Text('Account permanently deleted.'),
                                            backgroundColor: AppColors.error,
                                          ),
                                        );
                                      }
                                    } else {
                                      if (mounted) {
                                        setModalState(() {
                                          isDeleting = false;
                                        });
                                        messenger.showSnackBar(
                                          SnackBar(
                                            content: Text(result.message ?? 'Failed to delete account. Please try again.'),
                                            backgroundColor: AppColors.error,
                                          ),
                                        );
                                      }
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _prefs == null) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        appBar: CustomAppBar(title: 'Settings & Security'),
        body: Center(
          child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary)),
        ),
      );
    }

    final prefs = _prefs!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Settings & Security'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.s24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Account Settings
            const Text('Account', style: TextStyle(fontFamily: 'Geist Sans', fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: AppSpacing.s12),
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _buildNavTile(
                    icon: Icons.person_outline_rounded,
                    title: 'Personal Details',
                    subtitle: 'Name, email, date of birth',
                    onTap: () {
                      if (_profile != null) {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfileScreen(profile: _profile!)));
                      }
                    },
                  ),
                  const Divider(height: 1, color: AppColors.divider),
                  _buildNavTile(
                    icon: Icons.verified_user_outlined,
                    title: 'KYC Verification',
                    subtitle: 'Status and identity proofs',
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const KYCStatusScreen()));
                    },
                  ),
                  const Divider(height: 1, color: AppColors.divider),
                  _buildNavTile(
                    icon: Icons.account_balance_outlined,
                    title: 'Linked Bank Accounts',
                    subtitle: 'Manage primary and payout banks',
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const BankAccountsScreen()));
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.s24),

            // 2. Security Settings
            const Text('Security & Access', style: TextStyle(fontFamily: 'Geist Sans', fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: AppSpacing.s12),
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _buildNavTile(
                    icon: Icons.pin_outlined,
                    title: 'Change 6-Digit MPIN',
                    subtitle: 'Used to authorize payments and transfers',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaymentMPINVerificationScreen(
                            recipientName: 'Security Update',
                            recipientDetail: 'Change 6-Digit MPIN',
                            recipientType: 'Security',
                            amount: 0.0,
                            note: 'Change MPIN',
                            methodId: 'security',
                            onSuccess: () {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('MPIN updated successfully!'), backgroundColor: AppColors.success),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1, color: AppColors.divider),
                  SwitchListTile(
                    secondary: const Icon(Icons.fingerprint_rounded, color: AppColors.primary),
                    title: const Text('Biometric Authentication', style: TextStyle(fontFamily: 'Geist Sans', fontWeight: FontWeight.w600, fontSize: 13)),
                    subtitle: const Text('Use FaceID / Fingerprint to log in', style: TextStyle(fontFamily: 'Geist Sans', fontSize: 11, color: AppColors.textSecondary)),
                    value: prefs.biometricEnabled,
                    activeColor: AppColors.primary,
                    onChanged: (val) {
                      _updatePrefs(prefs.copyWith(biometricEnabled: val));
                    },
                  ),
                  const Divider(height: 1, color: AppColors.divider),
                  SwitchListTile(
                    secondary: const Icon(Icons.lock_outline_rounded, color: AppColors.primary),
                    title: const Text('App Lock on Background', style: TextStyle(fontFamily: 'Geist Sans', fontWeight: FontWeight.w600, fontSize: 13)),
                    subtitle: const Text('Require MPIN when returning to app', style: TextStyle(fontFamily: 'Geist Sans', fontSize: 11, color: AppColors.textSecondary)),
                    value: prefs.appLockEnabled,
                    activeColor: AppColors.primary,
                    onChanged: (val) {
                      _updatePrefs(prefs.copyWith(appLockEnabled: val));
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.s24),

            // 3. Notification Preferences
            const Text('Notifications & Alerts', style: TextStyle(fontFamily: 'Geist Sans', fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: AppSpacing.s12),
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  SwitchListTile(
                    secondary: const Icon(Icons.notifications_active_outlined, color: AppColors.primary),
                    title: const Text('Payment Alerts', style: TextStyle(fontFamily: 'Geist Sans', fontWeight: FontWeight.w600, fontSize: 13)),
                    subtitle: const Text('Instant alerts for sent & received money', style: TextStyle(fontFamily: 'Geist Sans', fontSize: 11, color: AppColors.textSecondary)),
                    value: prefs.paymentNotif,
                    activeColor: AppColors.primary,
                    onChanged: (val) => _updatePrefs(prefs.copyWith(paymentNotif: val)),
                  ),
                  const Divider(height: 1, color: AppColors.divider),
                  SwitchListTile(
                    secondary: const Icon(Icons.bolt_outlined, color: AppColors.primary),
                    title: const Text('Recharge & Bill Reminders', style: TextStyle(fontFamily: 'Geist Sans', fontWeight: FontWeight.w600, fontSize: 13)),
                    subtitle: const Text('Due date alerts for bills & mobile packs', style: TextStyle(fontFamily: 'Geist Sans', fontSize: 11, color: AppColors.textSecondary)),
                    value: prefs.billsNotif,
                    activeColor: AppColors.primary,
                    onChanged: (val) => _updatePrefs(prefs.copyWith(billsNotif: val)),
                  ),
                  const Divider(height: 1, color: AppColors.divider),
                  SwitchListTile(
                    secondary: const Icon(Icons.local_offer_outlined, color: AppColors.primary),
                    title: const Text('Promotions & Cashback', style: TextStyle(fontFamily: 'Geist Sans', fontWeight: FontWeight.w600, fontSize: 13)),
                    subtitle: const Text('Weekly deals, scratch cards and discounts', style: TextStyle(fontFamily: 'Geist Sans', fontSize: 11, color: AppColors.textSecondary)),
                    value: prefs.offersNotif,
                    activeColor: AppColors.primary,
                    onChanged: (val) => _updatePrefs(prefs.copyWith(offersNotif: val)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.s24),

            // 4. Preferences (Language & Theme)
            const Text('App Preferences', style: TextStyle(fontFamily: 'Geist Sans', fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: AppSpacing.s12),
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.language_rounded, color: AppColors.primary),
                    title: const Text('App Language', style: TextStyle(fontFamily: 'Geist Sans', fontSize: 13, fontWeight: FontWeight.w600)),
                    trailing: DropdownButton<String>(
                      value: prefs.language,
                      underline: const SizedBox(),
                      items: const [
                        DropdownMenuItem(value: 'English', child: Text('English', style: TextStyle(fontFamily: 'Geist Sans', fontSize: 12))),
                        DropdownMenuItem(value: 'Hindi', child: Text('हिन्दी (Hindi)', style: TextStyle(fontFamily: 'Geist Sans', fontSize: 12))),
                      ],
                      onChanged: (val) {
                        if (val != null) {
                          _updatePrefs(prefs.copyWith(language: val));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Language set to $val')),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.s24),

            // 5. Support & Legal
            const Text('Support & Legal', style: TextStyle(fontFamily: 'Geist Sans', fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: AppSpacing.s12),
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _buildNavTile(
                    icon: Icons.help_outline_rounded,
                    title: 'Help & Customer Support',
                    subtitle: 'FAQs, ticket status, contact info',
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const SupportScreen()));
                    },
                  ),
                  const Divider(height: 1, color: AppColors.divider),
                  _buildNavTile(
                    icon: Icons.info_outline_rounded,
                    title: 'About Payout',
                    subtitle: 'Version, licenses, legal',
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const AboutScreen()));
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.s24),

            // 6. Danger Zone: Delete Account & Logout
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.delete_outline_rounded, color: AppColors.error),
                    title: const Text('Delete Account', style: TextStyle(fontFamily: 'Geist Sans', fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.error)),
                    subtitle: const Text('Permanently erase account and all data', style: TextStyle(fontFamily: 'Geist Sans', fontSize: 11, color: AppColors.textSecondary)),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.error),
                    onTap: _showDeleteAccountDialog,
                  ),
                  const Divider(height: 1, color: AppColors.divider),
                  ListTile(
                    leading: const Icon(Icons.logout_rounded, color: AppColors.error),
                    title: const Text('Logout', style: TextStyle(fontFamily: 'Geist Sans', fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.error)),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.error),
                    onTap: _showLogoutDialog,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.s32),
          ],
        ),
      ),
    );
  }

  Widget _buildNavTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title, style: const TextStyle(fontFamily: 'Geist Sans', fontWeight: FontWeight.w600, fontSize: 13)),
      subtitle: Text(subtitle, style: const TextStyle(fontFamily: 'Geist Sans', fontSize: 11, color: AppColors.textSecondary)),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 13, color: AppColors.textSecondary),
      onTap: onTap,
    );
  }
}
