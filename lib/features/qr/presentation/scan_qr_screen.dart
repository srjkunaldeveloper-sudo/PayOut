import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/widgets.dart';
import 'package:payout/features/payments/presentation/amount_entry_screen.dart';
import 'package:payout/features/qr/dummy/dummy_qr_data.dart';
import 'package:payout/features/qr/models/qr_models.dart';
import 'package:payout/features/qr/repositories/qr_repository.dart';

class ScanQRScreen extends StatefulWidget {
  const ScanQRScreen({super.key});

  @override
  State<ScanQRScreen> createState() => _ScanQRScreenState();
}

class _ScanQRScreenState extends State<ScanQRScreen> with SingleTickerProviderStateMixin {
  final QrRepository _qrRepository = MockQrRepository();
  
  bool _isFlashOn = false;
  late AnimationController _animationController;
  late Animation<double> _scanAnimation;

  QRResolutionResult? _resolutionResult;
  bool _isResolving = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    _scanAnimation = Tween<double>(begin: 0.0, end: 240.0).animate(_animationController);
    
    // Auto-resolve SRJ Foods for seamless initial demo experience
    _resolvePayload(DummyQrData.validMerchantPayload);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // TODO(api/integration): Replace demo scanner with camera/QR scanning implementation.
  Future<void> _resolvePayload(String payload) async {
    setState(() {
      _resolutionResult = null;
      _isResolving = true;
    });

    final result = await _qrRepository.resolveQR(payload);
    if (!mounted) return;

    setState(() {
      _resolutionResult = result;
      _isResolving = false;
    });

    if (result.type == QRType.invalid || result.type == QRType.expired || result.type == QRType.unsupported) {
      _showErrorModal(result);
    }
  }

  void _showErrorModal(QRResolutionResult result) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final isExpired = result.type == QRType.expired;
        final title = isExpired ? 'QR Code Expired' : 'QR Code Not Supported';
        final message = result.errorMessage ?? 'The scanned QR code could not be verified.';

        return Container(
          decoration: const BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(AppSpacing.s24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.error.withOpacity(0.08),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isExpired ? Icons.timer_off_rounded : Icons.error_outline_rounded,
                    color: AppColors.error,
                    size: 40,
                  ),
                ),
                const SizedBox(height: AppSpacing.s16),
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.s8),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.s24),
                SizedBox(
                  width: double.infinity,
                  child: PrimaryButton(
                    text: 'Scan Again',
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() {
                        _resolutionResult = null;
                      });
                    },
                  ),
                ),
                const SizedBox(height: AppSpacing.s8),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDemoScenariosSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(AppSpacing.s24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.divider,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.s16),
                const Text(
                  'Select Demo QR Scenario',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.s16),
                _buildDemoOption(
                  'SRJ Foods (Valid Merchant)',
                  'srjfoods@upi • Food & Dining',
                  () {
                    Navigator.pop(context);
                    _resolvePayload(DummyQrData.validMerchantPayload);
                  },
                  key: const Key('demo_merchant'),
                ),
                _buildDemoOption(
                  'Rahul Sharma (Valid Personal)',
                  'rahul@upi • Personal UPI',
                  () {
                    Navigator.pop(context);
                    _resolvePayload(DummyQrData.validPersonalPayload);
                  },
                  key: const Key('demo_personal'),
                ),
                _buildDemoOption(
                  'Invalid QR Code',
                  'Simulate invalid signature',
                  () {
                    Navigator.pop(context);
                    _resolvePayload(DummyQrData.invalidPayload);
                  },
                  key: const Key('demo_invalid'),
                ),
                _buildDemoOption(
                  'Expired QR Code',
                  'Simulate expired merchant QR',
                  () {
                    Navigator.pop(context);
                    _resolvePayload(DummyQrData.expiredPayload);
                  },
                  key: const Key('demo_expired'),
                ),
                _buildDemoOption(
                  'Unsupported QR Code',
                  'Simulate non-UPI format',
                  () {
                    Navigator.pop(context);
                    _resolvePayload(DummyQrData.unsupportedPayload);
                  },
                  key: const Key('demo_unsupported'),
                ),
                const SizedBox(height: AppSpacing.s12),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDemoOption(String title, String subtitle, VoidCallback onTap, {Key? key}) {
    return Material(
      color: Colors.transparent,
      child: ListTile(
        key: key,
        contentPadding: EdgeInsets.zero,
        title: Text(title, style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Text(subtitle, style: const TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.textSecondary)),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textSecondary),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final result = _resolutionResult;
    final isSuccessResolution = result != null && (result.type == QRType.merchant || result.type == QRType.personal);

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
        actions: [
          TextButton.icon(
            onPressed: _showDemoScenariosSheet,
            icon: const Icon(Icons.tune_rounded, color: Colors.white, size: 16),
            label: const Text('Demo QR', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
          ),
        ],
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

          // 2. Scanner Guides Overlay
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
                  'Align QR code inside the frame to scan',
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

          // 3. Floating action panels (Flash / Scenarios)
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
                  icon: Icons.qr_code_scanner_rounded,
                  onTap: _showDemoScenariosSheet,
                ),
              ],
            ),
          ),

          // 4. Payee Bottom Sheet card
          if (_isResolving)
            const Positioned(
              bottom: AppSpacing.s32,
              left: AppSpacing.s24,
              right: AppSpacing.s24,
              child: Center(
                child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary)),
              ),
            )
          else if (isSuccessResolution)
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
                        CustomAvatar(
                          name: result.name,
                          size: 44,
                          backgroundColor: AppColors.primaryContainer,
                          textColor: AppColors.primary,
                        ),
                        const SizedBox(width: AppSpacing.s12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                result.name,
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.0,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${result.upiId} • ${result.category}',
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 11.0,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (result.isVerified)
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
                            builder: (context) => AmountEntryScreen(
                              recipientName: result.name,
                              recipientDetail: result.upiId,
                              recipientType: result.type == QRType.merchant ? 'Merchant' : 'Personal',
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
