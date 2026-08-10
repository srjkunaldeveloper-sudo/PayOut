import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/widgets.dart';
import 'package:payout/core/di/app_dependencies.dart';
import 'package:payout/features/merchant/models/merchant_models.dart';
import 'package:payout/features/merchant/repositories/merchant_repository.dart';

class MerchantProfileScreen extends StatefulWidget {
  final MerchantProfileModel? profile;
  final MerchantRepository? merchantRepository;

  const MerchantProfileScreen({
    super.key,
    this.profile,
    this.merchantRepository,
  });

  @override
  State<MerchantProfileScreen> createState() => _MerchantProfileScreenState();
}

class _MerchantProfileScreenState extends State<MerchantProfileScreen> {
  late final MerchantRepository _merchantRepo;
  MerchantProfileModel? _profile;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _merchantRepo = widget.merchantRepository ?? AppDependencies.instance.merchantRepository;
    if (widget.profile != null) {
      _profile = widget.profile;
      _isLoading = false;
    } else {
      _loadProfile();
    }
  }

  Future<void> _loadProfile() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final prof = await _merchantRepo.getMerchantProfile();
      if (mounted) {
        setState(() {
          _profile = prof;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to load business profile. Please try again.';
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildInfoRow(String label, String value, {bool isVerified = false, Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.s8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Geist Sans',
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    value,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontFamily: 'Geist Sans',
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: valueColor ?? AppColors.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (isVerified) ...[
                  const SizedBox(width: 4),
                  const Icon(Icons.verified_rounded, color: AppColors.success, size: 16),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        appBar: CustomAppBar(title: 'Business Profile'),
        body: Center(
          child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary)),
        ),
      );
    }

    if (_errorMessage != null || _profile == null) {
      return Scaffold(
        appBar: const CustomAppBar(title: 'Business Profile'),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.s24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline_rounded, size: 48, color: AppColors.error),
                const SizedBox(height: 16),
                Text(
                  _errorMessage ?? 'Business profile unavailable',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontFamily: 'Geist Sans', fontSize: 14, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),
                PrimaryButton(
                  text: 'Retry',
                  onPressed: _loadProfile,
                ),
              ],
            ),
          ),
        ),
      );
    }

    final profile = _profile!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Business Profile'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.s24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Business Identity Card
            AppCard(
              color: AppColors.primary,
              borderRadius: AppRadii.cardHero,
              padding: const EdgeInsets.all(AppSpacing.s20),
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      profile.storeName.isNotEmpty ? profile.storeName[0] : 'S',
                      style: const TextStyle(
                        fontFamily: 'Geist Sans',
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          profile.storeName,
                          style: const TextStyle(
                            fontFamily: 'Geist Sans',
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Merchant ID: ${profile.id}',
                          style: const TextStyle(
                            fontFamily: 'Geist Sans',
                            fontSize: 11.0,
                            color: AppColors.primaryLight,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            profile.businessType,
                            style: const TextStyle(
                              fontFamily: 'Geist Sans',
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.s24),

            // Store Details Section
            const Text(
              'Store Information',
              style: TextStyle(
                fontFamily: 'Geist Sans',
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.s12),
            AppCard(
              padding: const EdgeInsets.all(AppSpacing.s16),
              child: Column(
                children: [
                  _buildInfoRow('Owner Name', profile.ownerName),
                  const Divider(color: AppColors.divider),
                  _buildInfoRow('Category', profile.businessCategory),
                  const Divider(color: AppColors.divider),
                  _buildInfoRow('Store UPI ID', profile.upiId),
                  const Divider(color: AppColors.divider),
                  _buildInfoRow('Contact Mobile', profile.phoneNumber),
                  const Divider(color: AppColors.divider),
                  _buildInfoRow('Email Address', profile.email),
                  const Divider(color: AppColors.divider),
                  _buildInfoRow('Store Address', '${profile.address}, ${profile.city}, ${profile.pincode}'),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.s24),

            // Legal & Compliance Section
            const Text(
              'Tax & KYC Compliance',
              style: TextStyle(
                fontFamily: 'Geist Sans',
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.s12),
            AppCard(
              padding: const EdgeInsets.all(AppSpacing.s16),
              child: Column(
                children: [
                  _buildInfoRow('GSTIN', profile.gstNumber, isVerified: true),
                  const Divider(color: AppColors.divider),
                  _buildInfoRow('PAN Number', profile.panNumber, isVerified: true),
                  const Divider(color: AppColors.divider),
                  _buildInfoRow('KYC Verification', profile.kycStatus.toUpperCase(), isVerified: true, valueColor: AppColors.success),
                  const Divider(color: AppColors.divider),
                  _buildInfoRow('Linked Bank A/c', profile.bankAccountMasked, isVerified: true),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.s32),
          ],
        ),
      ),
    );
  }
}
