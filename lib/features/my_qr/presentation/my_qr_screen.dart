import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/widgets.dart';

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
      appBar: CustomAppBar(
        title: 'My QR Code',
        actions: [
          IconButton(
            icon: const Icon(Icons.print_rounded, color: AppColors.textPrimary),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Preparing document print...')),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24, vertical: AppSpacing.s12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // QR identity card container
              AppCard(
                color: Colors.white,
                borderRadius: AppRadius.xxl,
                padding: const EdgeInsets.symmetric(vertical: 40, horizontal: AppSpacing.s24),
                child: Column(
                  children: [
                    const CustomAvatar(
                      name: 'Alex Morgan',
                      size: 64,
                      backgroundColor: AppColors.primaryContainer,
                      textColor: AppColors.primary,
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
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(width: 6),
                        Icon(Icons.verified_rounded, color: AppColors.success, size: 18),
                      ],
                    ),
                    const SizedBox(height: 6),
                    
                    // Copyable UPI Badge
                    GestureDetector(
                      onTap: _copyUPI,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.primaryContainer,
                          borderRadius: BorderRadius.circular(AppRadius.circle),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Text(
                              upiId,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.copy_rounded, size: 12, color: AppColors.primary),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s32),
                    
                    // QR Code Frame with logo at center
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.s16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(AppRadius.xl),
                            border: Border.all(color: AppColors.divider, width: 1.5),
                          ),
                          child: const Icon(
                            Icons.qr_code_2_rounded,
                            size: 200,
                            color: Colors.black,
                          ),
                        ),
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(AppRadius.md),
                            boxShadow: AppShadow.small,
                            border: Border.all(color: AppColors.divider, width: 1.0),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(AppRadius.md),
                            child: Image.asset(
                              'assets/logo/brand_logo.jpeg',
                              errorBuilder: (c, e, s) => const Icon(Icons.payment_rounded, color: AppColors.primary),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.s32),
                    const Text(
                      'Scan this code to pay securely using any UPI app.',
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
              
              // Share and Download controls
              Row(
                children: [
                  Expanded(
                    child: OutlinedButtonV2(
                      text: 'Share Code',
                      iconLeft: Icons.share_rounded,
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Sharing QR Link...')),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: AppSpacing.s16),
                  Expanded(
                    child: PrimaryButton(
                      text: 'Save Image',
                      iconLeft: Icons.download_rounded,
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Downloading QR Image...')),
                        );
                      },
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
