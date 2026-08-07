import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_button.dart';
import 'package:payout/core/widgets/app_card.dart';
import 'package:payout/core/widgets/avatar.dart';
import 'package:payout/features/payments/presentation/amount_entry_screen.dart';

class ScanQRScreen extends StatefulWidget {
  const ScanQRScreen({super.key});

  @override
  State<ScanQRScreen> createState() => _ScanQRScreenState();
}

class _ScanQRScreenState extends State<ScanQRScreen> {
  bool _isFlashOn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: AppSpacing.s12, top: 4, bottom: 4),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 16,
                color: Colors.white,
              ),
              onPressed: () => Navigator.of(context).pop(),
              padding: EdgeInsets.zero,
            ),
          ),
        ),
        title: const Text(
          'Scan QR Code',
          style: TextStyle(
            fontFamily: 'Inter',
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: AppSpacing.s16, top: 4, bottom: 4),
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: IconButton(
              icon: Icon(
                _isFlashOn ? Icons.flash_on_rounded : Icons.flash_off_rounded,
                size: 18,
                color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  _isFlashOn = !_isFlashOn;
                });
              },
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Simulated camera viewport
          Positioned.fill(
            child: Container(
              color: Colors.grey[900],
              child: const Center(
                child: Icon(
                  Icons.camera_alt_rounded,
                  color: Colors.white24,
                  size: 80,
                ),
              ),
            ),
          ),
          // Viewport scanner focus bracket
          Center(
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: Colors.white, width: 2.5),
              ),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: 2.0,
                      width: 200,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Merchant Card & Gallery Button Floating at Bottom
          Positioned(
            bottom: AppSpacing.s32,
            left: AppSpacing.s24,
            right: AppSpacing.s24,
            child: Column(
              children: [
                TextButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Opening Gallery...')),
                    );
                  },
                  icon: const Icon(Icons.image_rounded, color: Colors.white, size: 16),
                  label: const Text(
                    'Upload from Gallery',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      color: Colors.white,
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white12,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: AppSpacing.s20),
                // Merchant Details Card
                AppCard(
                  color: AppColors.background,
                  borderRadius: AppRadii.cardHero,
                  hasShadow: true,
                  padding: const EdgeInsets.all(AppSpacing.s16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const CustomAvatar(
                            name: 'Starbucks Coffee',
                            size: 40,
                            backgroundColor: AppColors.primaryLight,
                            textColor: AppColors.primary,
                          ),
                          const SizedBox(width: AppSpacing.s12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Starbucks Coffee',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.0,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'Merchant ID: starbucks@payout',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 11.0,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.s16),
                      SizedBox(
                        width: double.infinity,
                        child: AppButton(
                          text: 'Continue to Pay',
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AmountEntryScreen(
                                  recipientName: 'Starbucks Coffee',
                                  recipientDetail: 'starbucks@payout',
                                  recipientType: 'Merchant',
                                ),
                              ),
                            );
                          },
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
    );
  }
}
