import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/widgets.dart';
import 'package:payout/core/di/app_dependencies.dart';
import 'package:payout/features/qr/models/qr_models.dart';
import 'package:payout/features/qr/repositories/qr_repository.dart';
import 'package:payout/features/qr/services/qr_logger.dart';

class MyQRScreen extends StatefulWidget {
  final QrRepository? qrRepository;

  const MyQRScreen({super.key, this.qrRepository});

  @override
  State<MyQRScreen> createState() => _MyQRScreenState();
}

class _MyQRScreenState extends State<MyQRScreen> {
  late final QrRepository _qrRepository;
  
  PersonalQRModel? _qrModel;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _qrRepository = widget.qrRepository ?? AppDependencies.instance.qrRepository;
    _loadQRData();
  }

  Future<void> _loadQRData() async {
    setState(() {
      _isLoading = true;
    });
    final model = await _qrRepository.getMyQR();
    if (mounted) {
      setState(() {
        _qrModel = model;
        _isLoading = false;
      });
    }
  }

  void _copyUPI() {
    final upi = _qrModel?.upiId ?? 'rahulsharma@okaxis';
    Clipboard.setData(ClipboardData(text: upi));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('UPI ID "$upi" copied to clipboard!'),
        backgroundColor: AppColors.success,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading && _qrModel == null) {
      return const Scaffold(
        appBar: CustomAppBar(title: 'My QR Code'),
        body: Center(
          child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary)),
        ),
      );
    }

    final model = _qrModel ?? const PersonalQRModel(
      upiId: 'rahulsharma@okaxis',
      qrCodeUrl: '',
      userName: 'Rahul Sharma',
    );

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
                    CustomAvatar(
                      name: model.userName,
                      size: 64,
                      backgroundColor: AppColors.primaryContainer,
                      textColor: AppColors.primary,
                    ),
                    const SizedBox(height: AppSpacing.s16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          model.userName,
                          style: const TextStyle(
                            fontFamily: 'Geist Sans',
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(Icons.verified_rounded, color: AppColors.success, size: 18),
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
                          children: [
                            Text(
                              model.upiId,
                              style: const TextStyle(
                                fontFamily: 'Geist Sans',
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.copy_rounded, size: 12, color: AppColors.primary),
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
                            child: const Icon(Icons.payment_rounded, color: AppColors.primary),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.s32),
                    const Text(
                      'Scan this code to pay securely using any UPI app.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Geist Sans',
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
                        QrLogger.logShareQR();
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
                        QrLogger.logDownloadQR();
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
