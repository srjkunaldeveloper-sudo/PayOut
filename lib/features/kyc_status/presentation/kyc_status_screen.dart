import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/app_card.dart';
import 'package:payout/core/widgets/badge.dart';

class KYCStatusScreen extends StatefulWidget {
  const KYCStatusScreen({super.key});

  @override
  State<KYCStatusScreen> createState() => _KYCStatusScreenState();
}

class _KYCStatusScreenState extends State<KYCStatusScreen> {
  String _kycStatus = 'Pending';
  bool _isUploading = false;

  void _submitDocument() {
    setState(() {
      _isUploading = true;
    });
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _isUploading = false;
          _kycStatus = 'In Review';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('ID verification documents submitted successfully.'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Identity Verification'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.s24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Card
            AppCard(
              padding: const EdgeInsets.all(AppSpacing.s20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Verification Status',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _kycStatus == 'Pending'
                          ? 'Action Required'
                          : _kycStatus == 'In Review'
                              ? 'Documents Under Review'
                              : 'Verified',
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  CustomBadge(
                    label: _kycStatus,
                    type: _kycStatus == 'Pending'
                        ? BadgeType.warning
                        : _kycStatus == 'In Review'
                            ? BadgeType.primary
                            : BadgeType.success,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.s32),
            const Text(
              'Upload Identification Document',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.s12),
            if (_kycStatus == 'Pending') ...[
              GestureDetector(
                onTap: _submitDocument,
                child: Container(
                  width: double.infinity,
                  height: 180,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppRadii.card),
                    border: Border.all(color: AppColors.divider, style: BorderStyle.solid),
                  ),
                  child: Center(
                    child: _isUploading
                        ? const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(AppColors.primary))
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.cloud_upload_rounded, color: AppColors.primary, size: 36),
                              SizedBox(height: 8),
                              Text(
                                'Tap to upload Passport or Driver\'s License',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'PNG, JPG, or PDF up to 5MB',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 10,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.s24),
              const Text(
                'Why verify my identity?',
                style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 13),
              ),
              const SizedBox(height: 4),
              const Text(
                'To comply with financial regulations and raise daily wallet cash transfer thresholds, Payout requires standard identity documentation check.',
                style: TextStyle(fontFamily: 'Inter', color: AppColors.textSecondary, fontSize: 11, height: 1.4),
              ),
            ] else ...[
              AppCard(
                color: AppColors.primaryLight.withOpacity(0.3),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline_rounded, color: AppColors.primary),
                    const SizedBox(width: AppSpacing.s12),
                    Expanded(
                      child: Text(
                        _kycStatus == 'In Review'
                            ? 'Our verification team is reviewing your documents. This process generally takes up to 2 hours.'
                            : 'Identity checks verified successfully. All transfer restrictions removed.',
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
