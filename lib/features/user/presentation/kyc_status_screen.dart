import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/widgets.dart';
import 'package:payout/core/di/app_dependencies.dart';
import 'package:payout/features/user/models/user_models.dart';
import 'package:payout/features/user/repositories/user_repository.dart';
import 'package:payout/features/user/presentation/kyc_flow_screen.dart';

class KYCStatusScreen extends StatefulWidget {
  final UserRepository? userRepository;

  const KYCStatusScreen({super.key, this.userRepository});

  @override
  State<KYCStatusScreen> createState() => _KYCStatusScreenState();
}

class _KYCStatusScreenState extends State<KYCStatusScreen> {
  late final UserRepository _userRepository;

  KYCModel? _kyc;
  bool _isLoading = true;
  bool _isChecking = false;

  @override
  void initState() {
    super.initState();
    _userRepository = widget.userRepository ?? AppDependencies.instance.userRepository;
    _loadKYCStatus();
  }

  Future<void> _loadKYCStatus() async {
    setState(() {
      _isLoading = true;
    });
    final kycData = await _userRepository.getKYC();
    if (mounted) {
      setState(() {
        _kyc = kycData;
        _isLoading = false;
      });
    }
  }

  Future<void> _checkStatus() async {
    setState(() {
      _isChecking = true;
    });
    final status = await _userRepository.checkKYCStatus();
    if (mounted) {
      setState(() {
        _kyc = status;
        _isChecking = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('KYC Status: ${status.status}'),
          backgroundColor: status.status == 'VERIFIED' ? AppColors.success : AppColors.primary,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _kyc == null) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        appBar: CustomAppBar(title: 'KYC Verification Center'),
        body: Center(
          child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary)),
        ),
      );
    }

    final kyc = _kyc!;
    final isVerified = kyc.status.toUpperCase() == 'VERIFIED';
    final isPending = kyc.status.toUpperCase() == 'PENDING';
    final isRejected = kyc.status.toUpperCase() == 'REJECTED' || kyc.status.toUpperCase() == 'NEEDS_ACTION';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'KYC Verification Center'),
      body: RefreshIndicator(
        onRefresh: _loadKYCStatus,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppSpacing.s24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Status Banner Card
              AppCard(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: (isVerified ? AppColors.success : (isPending ? Colors.orange : AppColors.error)).withValues(alpha: 0.08),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isVerified ? Icons.verified_rounded : (isPending ? Icons.hourglass_empty_rounded : Icons.error_outline_rounded),
                            color: isVerified ? AppColors.success : (isPending ? Colors.orange : AppColors.error),
                            size: 32,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.s16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isVerified ? 'KYC Verified' : (isPending ? 'Verification Under Review' : 'Action Required'),
                                style: const TextStyle(
                                  fontFamily: 'Geist Sans',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                isVerified
                                    ? 'Verified on ${kyc.verifiedDate ?? '12 March 2024'}'
                                    : (isPending ? 'Estimated completion: 2 hours' : 'Please submit valid documentation.'),
                                style: const TextStyle(
                                  fontFamily: 'Geist Sans',
                                  fontSize: 11.0,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (isRejected && kyc.rejectionReason != null) ...[
                      const SizedBox(height: AppSpacing.s12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.error.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(AppRadius.md),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.info_outline_rounded, color: AppColors.error, size: 18),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                kyc.rejectionReason!,
                                style: const TextStyle(fontFamily: 'Geist Sans', fontSize: 12, color: AppColors.error),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.s24),

              // 2. Verification Checklist
              const Text('Verification Stages', style: TextStyle(fontFamily: 'Geist Sans', fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: AppSpacing.s12),
              AppCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    _buildChecklistTile(
                      title: '1. Personal Information',
                      subtitle: 'Name, DOB, Address verified',
                      isCompleted: isVerified || kyc.personalDetailsSubmitted,
                    ),
                    const Divider(height: 1, color: AppColors.divider),
                    _buildChecklistTile(
                      title: '2. PAN Authentication',
                      subtitle: kyc.panNumber != null ? 'PAN: ${kyc.panNumber}' : 'Tax ID verified',
                      isCompleted: isVerified || kyc.panVerified,
                    ),
                    const Divider(height: 1, color: AppColors.divider),
                    _buildChecklistTile(
                      title: '3. Identity Proof',
                      subtitle: '${kyc.documentType} uploaded',
                      isCompleted: isVerified || kyc.documentUploaded,
                    ),
                    const Divider(height: 1, color: AppColors.divider),
                    _buildChecklistTile(
                      title: '4. Bank Account Verification',
                      subtitle: 'Penny drop check completed',
                      isCompleted: isVerified || kyc.bankVerified,
                    ),
                    const Divider(height: 1, color: AppColors.divider),
                    _buildChecklistTile(
                      title: '5. Regulatory Compliance',
                      subtitle: isVerified ? 'All checks approved' : 'Review in progress',
                      isCompleted: isVerified,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.s24),

              // 3. Unlocked Benefits
              const Text('Unlocked Account Benefits', style: TextStyle(fontFamily: 'Geist Sans', fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: AppSpacing.s12),
              AppCard(
                child: Column(
                  children: [
                    _buildBenefitRow(Icons.account_balance_wallet_outlined, 'Monthly Wallet Limit', '₹1,00,000 / month'),
                    const Divider(color: AppColors.divider),
                    _buildBenefitRow(Icons.swap_horiz_rounded, 'Daily P2P Transfers', 'Unlimited'),
                    const Divider(color: AppColors.divider),
                    _buildBenefitRow(Icons.arrow_circle_down_rounded, 'Direct Bank Withdrawal', 'Enabled ✓'),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.s32),

              // 4. Primary Actions
              if (!isVerified) ...[
                if (isPending) ...[
                  SizedBox(
                    width: double.infinity,
                    child: PrimaryButton(
                      text: _isChecking ? 'Checking...' : 'Check Status',
                      isLoading: _isChecking,
                      onPressed: _isChecking ? null : _checkStatus,
                    ),
                  ),
                ] else ...[
                  SizedBox(
                    width: double.infinity,
                    child: PrimaryButton(
                      text: 'Complete KYC',
                      onPressed: () async {
                        final updated = await Navigator.push<bool>(
                          context,
                          MaterialPageRoute(builder: (context) => const KYCFlowScreen()),
                        );
                        if (updated == true) {
                          _loadKYCStatus();
                        }
                      },
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacing.s12),
              ],
              SizedBox(
                width: double.infinity,
                child: SecondaryButton(
                  text: 'Back to Profile',
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const SizedBox(height: AppSpacing.s16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChecklistTile({
    required String title,
    required String subtitle,
    required bool isCompleted,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: isCompleted ? AppColors.success.withValues(alpha: 0.1) : AppColors.divider.withValues(alpha: 0.5),
          shape: BoxShape.circle,
        ),
        child: Icon(
          isCompleted ? Icons.check_rounded : Icons.radio_button_unchecked_rounded,
          color: isCompleted ? AppColors.success : AppColors.textSecondary,
          size: 18,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontFamily: 'Geist Sans',
          fontWeight: FontWeight.w600,
          fontSize: 13,
          color: isCompleted ? AppColors.textPrimary : AppColors.textSecondary,
        ),
      ),
      subtitle: Text(subtitle, style: const TextStyle(fontFamily: 'Geist Sans', fontSize: 11, color: AppColors.textSecondary)),
    );
  }

  Widget _buildBenefitRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: const TextStyle(fontFamily: 'Geist Sans', fontSize: 12, color: AppColors.textSecondary))),
          Text(value, style: const TextStyle(fontFamily: 'Geist Sans', fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.textPrimary)),
        ],
      ),
    );
  }
}
