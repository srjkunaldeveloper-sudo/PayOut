import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/widgets.dart';
import 'package:payout/features/payments/presentation/amount_entry_screen.dart';

class ScanQRScreen extends StatefulWidget {
  const ScanQRScreen({super.key});

  @override
  State<ScanQRScreen> createState() => _ScanQRScreenState();
}

class _ScanQRScreenState extends State<ScanQRScreen> with SingleTickerProviderStateMixin {
  bool _isFlashOn = false;
  late AnimationController _animationController;
  late Animation<double> _scanAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    _scanAnimation = Tween<double>(begin: 0.0, end: 240.0).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(AppSpacing.s8),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 16,
                color: Colors.white,
              ),
              onPressed: () => Navigator.of(context).pop(),
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
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // 1. Dark Simulated Viewport
          Positioned.fill(
            child: Container(
              color: Colors.grey[950],
              child: const Center(
                child: Icon(
                  Icons.camera_alt_rounded,
                  color: Colors.white10,
                  size: 80,
                ),
              ),
            ),
          ),

          // 2. Translucent guides overlay
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 250,
                      height: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppRadius.xxl),
                        border: Border.all(color: Colors.white38, width: 2.0),
                      ),
                    ),
                    // Animated laser scanning line
                    AnimatedBuilder(
                      animation: _scanAnimation,
                      builder: (context, child) {
                        return Positioned(
                          top: 5 + _scanAnimation.value,
                          child: Container(
                            height: 2.0,
                            width: 220,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withOpacity(0.5),
                                  blurRadius: 8.0,
                                  spreadRadius: 2.0,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.s24),
                const Text(
                  'Align QR code inside the box to scan',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13.0,
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // 3. Floating action panels (Flash / Gallery / My QR)
          Positioned(
            top: 100,
            right: AppSpacing.s24,
            child: Column(
              children: [
                _buildFloatingButton(
                  icon: _isFlashOn ? Icons.flash_on_rounded : Icons.flash_off_rounded,
                  onTap: () {
                    setState(() {
                      _isFlashOn = !_isFlashOn;
                    });
                  },
                ),
                const SizedBox(height: AppSpacing.s16),
                _buildFloatingButton(
                  icon: Icons.photo_library_rounded,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Opening Gallery...')),
                    );
                  },
                ),
              ],
            ),
          ),

          // 4. Merchant Bottom Sheet card
          Positioned(
            bottom: AppSpacing.s32,
            left: AppSpacing.s24,
            right: AppSpacing.s24,
            child: AppCard(
              color: Colors.white,
              borderRadius: AppRadius.xxl,
              padding: const EdgeInsets.all(AppSpacing.s20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      const CustomAvatar(
                        name: 'Starbucks Coffee',
                        size: 44,
                        backgroundColor: AppColors.primaryContainer,
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
                                fontSize: 15.0,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'UPI ID: starbucks@okhdfc',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 11.0,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.success.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(AppRadius.xs),
                        ),
                        child: const Text(
                          'Verified',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: AppColors.success,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.s20),
                  PrimaryButton(
                    text: 'Continue to Pay',
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AmountEntryScreen(
                            recipientName: 'Starbucks Coffee',
                            recipientDetail: 'starbucks@okhdfc',
                            recipientType: 'Merchant',
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingButton({required IconData icon, required VoidCallback onTap}) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: Colors.black45,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white24, width: 1.0),
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white, size: 20),
        onPressed: onTap,
      ),
    );
  }
}
