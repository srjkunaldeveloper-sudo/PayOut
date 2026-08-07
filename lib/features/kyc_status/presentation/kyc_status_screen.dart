import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/app_card.dart';

class KYCStatusScreen extends StatefulWidget {
  const KYCStatusScreen({super.key});

  @override
  State<KYCStatusScreen> createState() => _KYCStatusScreenState();
}

class _KYCStatusScreenState extends State<KYCStatusScreen> {
  String _kycState = 'Verified'; // Verified, Pending, Rejected
  bool _isUploading = false;
  double _uploadProgress = 0.0;

  void _simulateDocUpload() {
    setState(() {
      _isUploading = true;
      _uploadProgress = 0.0;
    });

    // Simulating file upload progression progress bar
    Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 100));
      if (!mounted) return false;
      setState(() {
        _uploadProgress += 0.1;
      });
      if (_uploadProgress >= 1.0) {
        setState(() {
          _isUploading = false;
          _kycState = 'Pending';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Documents uploaded! Assessment status set to PENDING.'),
            backgroundColor: AppColors.primary,
          ),
        );
        return false;
      }
      return true;
    });
  }

  Widget _buildStateBadge() {
    Color badgeColor = AppColors.success;
    String label = 'VERIFIED';
    IconData icon = Icons.verified_rounded;

    if (_kycState == 'Pending') {
      badgeColor = Colors.orange;
      label = 'UNDER REVIEW';
      icon = Icons.hourglass_top_rounded;
    } else if (_kycState == 'Rejected') {
      badgeColor = AppColors.error;
      label = 'REJECTED';
      icon = Icons.cancel_rounded;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: badgeColor, size: 16),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: badgeColor,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'KYC Compliance'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.s24),
        child: Column(
          children: [
            // Status Showcase Card
            AppCard(
              padding: const EdgeInsets.all(AppSpacing.s24),
              child: Column(
                children: [
                  const Text(
                    'Assessment Status',
                    style: TextStyle(fontFamily: 'Inter', color: AppColors.textSecondary, fontSize: 13),
                  ),
                  const SizedBox(height: AppSpacing.s12),
                  _buildStateBadge(),
                  const SizedBox(height: AppSpacing.s16),
                  const Text(
                    'Complete your KYC verification to raise transaction limits and unlock credit features.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.s24),
            // Simulator Controllers
            AppCard(
              padding: const EdgeInsets.all(AppSpacing.s16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Simulate Status Changes',
                    style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  const SizedBox(height: AppSpacing.s12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OutlinedButton(
                        onPressed: () => setState(() => _kycState = 'Verified'),
                        child: const Text('Verified', style: TextStyle(fontFamily: 'Inter', fontSize: 11)),
                      ),
                      OutlinedButton(
                        onPressed: () => setState(() => _kycState = 'Pending'),
                        child: const Text('Pending', style: TextStyle(fontFamily: 'Inter', fontSize: 11)),
                      ),
                      OutlinedButton(
                        onPressed: () => setState(() => _kycState = 'Rejected'),
                        child: const Text('Rejected', style: TextStyle(fontFamily: 'Inter', fontSize: 11)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.s32),
            // Document upload stubs
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Upload Identification Documents',
                style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
            const SizedBox(height: AppSpacing.s16),
            AppCard(
              onTap: _isUploading ? null : _simulateDocUpload,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: Column(
                  children: [
                    const Icon(Icons.cloud_upload_outlined, color: AppColors.primary, size: 40),
                    const SizedBox(height: AppSpacing.s12),
                    const Text(
                      'Aadhaar & PAN Documents',
                      style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'PDF, JPG or PNG up to 10MB',
                      style: TextStyle(fontFamily: 'Inter', fontSize: 11, color: AppColors.textSecondary),
                    ),
                    if (_isUploading) ...[
                      const SizedBox(height: AppSpacing.s20),
                      SizedBox(
                        width: 200,
                        child: LinearProgressIndicator(
                          value: _uploadProgress,
                          color: AppColors.primary,
                          backgroundColor: AppColors.primaryLight,
                          minHeight: 4,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Uploading: ${(_uploadProgress * 100).toStringAsFixed(0)}%',
                        style: const TextStyle(fontFamily: 'Inter', fontSize: 10, color: AppColors.textSecondary),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.s40),
          ],
        ),
      ),
    );
  }
}
