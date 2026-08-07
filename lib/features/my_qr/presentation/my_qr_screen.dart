import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/app_card.dart';
import 'package:payout/core/widgets/avatar.dart';

class MyQRScreen extends StatelessWidget {
  const MyQRScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const upiId = 'alexmorgan@payout';

    void _copyUPI() {
      Clipboard.setData(const ClipboardData(text: upiId));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('UPI ID "$upiId" copied to clipboard!'),
          backgroundColor: AppColors.success,
          duration: Duration(seconds: 1),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'My Payment QR'),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.s24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppCard(
                color: AppColors.surface,
                padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
                child: Column(
                  children: [
                    const CustomAvatar(
                      name: 'Alex Morgan',
                      size: 56,
                      backgroundColor: AppColors.primaryLight,
                      textColor: AppColors.primary,
                    ),
                    const SizedBox(height: AppSpacing.s12),
                    const Text(
                      'Alex Morgan',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    // UPI ID with Copy button
                    GestureDetector(
                      onTap: _copyUPI,
                      child: Container(
                        margin: const EdgeInsets.only(top: 4.0),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Text(
                              'UPI ID: $upiId',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                            SizedBox(width: 6),
                            Icon(Icons.copy_rounded, size: 12, color: AppColors.primary),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s32),
                    // Visual Mock QR code
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.s16),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.divider, width: 1.5),
                      ),
                      child: const Icon(
                        Icons.qr_code_2_rounded,
                        size: 200,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s32),
                    const Text(
                      'Scan this code to instantly transfer funds to Alex\'s wallet.',
                      textAlign: TextAlign.center,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Downloading QR Image...')),
                      );
                    },
                    icon: const Icon(Icons.download_rounded, color: AppColors.primary),
                    label: const Text(
                      'Save Image',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: AppColors.primaryLight,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.s16),
                  TextButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Sharing QR Link...')),
                      );
                    },
                    icon: const Icon(Icons.share_rounded, color: AppColors.textPrimary),
                    label: const Text(
                      'Share Code',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: AppColors.surface,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: AppColors.divider),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
