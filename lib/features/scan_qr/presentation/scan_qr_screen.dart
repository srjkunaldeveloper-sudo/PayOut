import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';

class ScanQRScreen extends StatelessWidget {
  const ScanQRScreen({super.key});

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
          style: TextStyle(fontFamily: 'Inter', color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
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
            child: GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Simulated scan completed successfully.'),
                    backgroundColor: AppColors.success,
                  ),
                );
                Navigator.pop(context);
              },
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
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 140.0),
                        child: Text(
                          'Tap to scan mockup',
                          style: TextStyle(fontFamily: 'Inter', color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Instructions text bottom
          Positioned(
            bottom: AppSpacing.s64,
            left: 0,
            right: 0,
            child: Center(
              child: Column(
                children: [
                  const Text(
                    'Align QR code inside the box to pay',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      color: Colors.white,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s16),
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.image_rounded, color: Colors.white),
                    label: const Text(
                      'Upload from Gallery',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white10,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
