import 'package:flutter/material.dart';
import 'package:payout/core/widgets/widgets.dart';
import 'package:payout/features/auth/presentation/login_screen.dart';
import 'package:payout/features/auth/services/session_manager.dart';
import 'package:payout/features/bank_accounts/presentation/bank_accounts_screen.dart';
import 'package:payout/features/rewards/presentation/rewards_screen.dart';
import 'package:payout/features/support/presentation/support_screen.dart';
import 'package:payout/features/qr/presentation/my_qr_screen.dart';
import 'package:payout/core/di/app_dependencies.dart';
import 'package:payout/features/user/models/user_models.dart';
import 'package:payout/features/user/repositories/user_repository.dart';
import 'package:payout/features/user/presentation/edit_profile_screen.dart';
import 'package:payout/features/user/presentation/kyc_status_screen.dart';
import 'package:payout/features/user/presentation/settings_screen.dart';
import 'package:payout/features/user/presentation/about_screen.dart';

class ProfileScreen extends StatefulWidget {
  final UserRepository? userRepository;

  const ProfileScreen({super.key, this.userRepository});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final UserRepository _userRepository;
  
  UserProfileModel? _profile;
  KYCModel? _kyc;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _userRepository = widget.userRepository ?? AppDependencies.instance.userRepository;
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
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFFF8FAFC),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(20),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFCBD5E1),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  'Confirm Logout',
                  style: TextStyle(
                    fontFamily: 'Geist Sans',
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Color(0xFF1F1F1F),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Are you sure you want to log out of your Payout account?',
                  style: TextStyle(
                    fontFamily: 'Geist Sans',
                    color: Color(0xFF64748B),
                    fontSize: 13,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButtonV2(
                        text: 'Cancel',
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    const SizedBox(width: 14),
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
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.of(context).canPop();

    if (_isLoading || _profile == null) {
      return Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Center(
                child: Text(
                  'My Profile',
                  style: const TextStyle(
                    fontFamily: 'Geist Sans',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F1F1F),
                  ),
                ),
              ),
            ),
          ),
        ),
        body: const Center(
          child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF3F37C9))),
        ),
      );
    }

    final profile = _profile!;
    final isKycVerified = _kyc?.status.toUpperCase() == 'VERIFIED' || profile.isKycVerified;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                if (canPop)
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.arrow_back_rounded,
                        color: Color(0xFF3F37C9),
                        size: 20,
                      ),
                    ),
                  )
                else
                  const SizedBox(width: 38),
                const Expanded(
                  child: Center(
                    child: Text(
                      'My Profile',
                      style: TextStyle(
                        fontFamily: 'Geist Sans',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F1F1F),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    final updated = await Navigator.push<bool>(
                      context,
                      MaterialPageRoute(builder: (context) => EditProfileScreen(profile: profile)),
                    );
                    if (updated == true) {
                      _loadUserData();
                    }
                  },
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.edit_outlined,
                      color: Color(0xFF3F37C9),
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _loadUserData,
        color: const Color(0xFF3F37C9),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Profile Identity Card
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF002E6E).withValues(alpha: 0.025),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF3F37C9),
                            Color(0xFF4895EF),
                            Color(0xFF4CC9F0),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF3F37C9).withValues(alpha: 0.25),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        _getInitials(profile.name),
                        style: const TextStyle(
                          fontFamily: 'Geist Sans',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            profile.name,
                            style: const TextStyle(
                              fontFamily: 'Geist Sans',
                              fontWeight: FontWeight.bold,
                              fontSize: 16.5,
                              color: Color(0xFF1F1F1F),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '+91 ${profile.phone}',
                            style: const TextStyle(
                              fontFamily: 'Geist Sans',
                              fontSize: 12.0,
                              color: Color(0xFF64748B),
                            ),
                          ),
                          Text(
                            profile.email,
                            style: const TextStyle(
                              fontFamily: 'Geist Sans',
                              fontSize: 11.5,
                              color: Color(0xFF64748B),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: (isKycVerified ? const Color(0xFF10B981) : Colors.orange).withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  isKycVerified ? Icons.check_circle_rounded : Icons.pending_rounded,
                                  size: 12,
                                  color: isKycVerified ? const Color(0xFF059669) : Colors.orange,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  isKycVerified ? 'KYC Verified' : 'KYC Pending',
                                  style: TextStyle(
                                    fontFamily: 'Geist Sans',
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: isKycVerified ? const Color(0xFF059669) : Colors.orange,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // 2. Overview Stats (Member Since / Linked Banks)
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF002E6E).withValues(alpha: 0.02),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Member Since', style: TextStyle(fontFamily: 'Geist Sans', fontSize: 11, color: Color(0xFF64748B))),
                          const SizedBox(height: 4),
                          Text(profile.memberSince, style: const TextStyle(fontFamily: 'Geist Sans', fontWeight: FontWeight.bold, fontSize: 13.5, color: Color(0xFF1F1F1F))),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const BankAccountsScreen()));
                      },
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF002E6E).withValues(alpha: 0.02),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Linked Banks', style: TextStyle(fontFamily: 'Geist Sans', fontSize: 11, color: Color(0xFF64748B))),
                            const SizedBox(height: 4),
                            Text('${profile.linkedBankCount} Accounts', style: const TextStyle(fontFamily: 'Geist Sans', fontWeight: FontWeight.bold, fontSize: 13.5, color: Color(0xFF3F37C9))),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 3. Account Section
              const Text('Account & Identity', style: TextStyle(fontFamily: 'Geist Sans', fontWeight: FontWeight.bold, fontSize: 14.5, color: Color(0xFF1F1F1F))),
              const SizedBox(height: 10),
              Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                clipBehavior: Clip.antiAlias,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
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
                      const Divider(height: 1, color: Color(0xFFE2E8F0)),
                      _buildNavTile(
                        icon: Icons.verified_user_outlined,
                        title: 'KYC Verification Center',
                        subtitle: isKycVerified ? 'Verified Level 2' : 'Action Required',
                        trailingText: isKycVerified ? 'Verified' : 'Pending',
                        trailingColor: isKycVerified ? const Color(0xFF059669) : Colors.orange,
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const KYCStatusScreen()),
                          );
                          _loadUserData();
                        },
                      ),
                      const Divider(height: 1, color: Color(0xFFE2E8F0)),
                      _buildNavTile(
                        icon: Icons.account_balance_outlined,
                        title: 'Bank Accounts',
                        subtitle: 'Manage linked bank accounts',
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const BankAccountsScreen()));
                        },
                      ),
                      const Divider(height: 1, color: Color(0xFFE2E8F0)),
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
              ),
              const SizedBox(height: 20),

              // 4. Preferences & Security Section
              const Text('Preferences & Security', style: TextStyle(fontFamily: 'Geist Sans', fontWeight: FontWeight.bold, fontSize: 14.5, color: Color(0xFF1F1F1F))),
              const SizedBox(height: 10),
              Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                clipBehavior: Clip.antiAlias,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
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
                      const Divider(height: 1, color: Color(0xFFE2E8F0)),
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
              ),
              const SizedBox(height: 20),

              // 5. Support & Legal Section
              const Text('Support & Legal', style: TextStyle(fontFamily: 'Geist Sans', fontWeight: FontWeight.bold, fontSize: 14.5, color: Color(0xFF1F1F1F))),
              const SizedBox(height: 10),
              Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                clipBehavior: Clip.antiAlias,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
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
                      const Divider(height: 1, color: Color(0xFFE2E8F0)),
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
              ),
              const SizedBox(height: 20),

              // 6. Logout Button
              Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: _showLogoutSheet,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFFEF4444).withValues(alpha: 0.2)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEF4444).withValues(alpha: 0.08),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.logout_rounded, color: Color(0xFFEF4444), size: 18),
                        ),
                        const SizedBox(width: 14),
                        const Expanded(
                          child: Text(
                            'Logout',
                            style: TextStyle(
                              fontFamily: 'Geist Sans',
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Color(0xFFEF4444),
                            ),
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Color(0xFFEF4444)),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    } else if (parts.isNotEmpty && parts[0].isNotEmpty) {
      return parts[0][0].toUpperCase();
    }
    return 'U';
  }

  Widget _buildNavTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    String? trailingText,
    Color? trailingColor,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: const Color(0xFF3F37C9).withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: const Color(0xFF3F37C9), size: 18),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'Geist Sans',
                      fontWeight: FontWeight.w600,
                      fontSize: 13.5,
                      color: Color(0xFF1F1F1F),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontFamily: 'Geist Sans',
                      fontSize: 11,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
            if (trailingText != null)
              Container(
                margin: const EdgeInsets.only(right: 8.0),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: (trailingColor ?? const Color(0xFF64748B)).withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  trailingText,
                  style: TextStyle(
                    fontFamily: 'Geist Sans',
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                    color: trailingColor ?? const Color(0xFF64748B),
                  ),
                ),
              ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 13, color: Color(0xFF64748B)),
          ],
        ),
      ),
    );
  }
}
