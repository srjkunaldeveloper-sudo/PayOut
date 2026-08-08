import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/widgets.dart';
import 'package:payout/features/auth/constants/auth_constants.dart';
import 'package:payout/features/auth/services/secure_storage_service.dart';
import 'package:payout/features/payments/presentation/payment_processing_screen.dart';

class PaymentMPINVerificationScreen extends StatefulWidget {
  final String recipientName;
  final String recipientDetail;
  final String recipientType;
  final double amount;
  final String note;
  final String methodId;

  const PaymentMPINVerificationScreen({
    super.key,
    required this.recipientName,
    required this.recipientDetail,
    required this.recipientType,
    required this.amount,
    required this.note,
    required this.methodId,
  });

  @override
  State<PaymentMPINVerificationScreen> createState() => _PaymentMPINVerificationScreenState();
}

class _PaymentMPINVerificationScreenState extends State<PaymentMPINVerificationScreen> {
  String _pin = '';
  String _correctMpin = '123456'; // Default fallback
  bool _isLoadingMpin = true;

  @override
  void initState() {
    super.initState();
    _loadMpin();
  }

  Future<void> _loadMpin() async {
    final savedMpin = await SecureStorageService.readMPIN();
    if (savedMpin != null && savedMpin.isNotEmpty) {
      _correctMpin = savedMpin;
    }
    setState(() {
      _isLoadingMpin = false;
    });
  }

  void _onKeyPress(String val) {
    if (_pin.length < AuthConstants.mpinLength) {
      setState(() {
        _pin += val;
      });

      if (_pin.length == AuthConstants.mpinLength) {
        Future.delayed(const Duration(milliseconds: 300), _verifyAndProceed);
      }
    }
  }

  void _onBackspace() {
    if (_pin.isNotEmpty) {
      setState(() {
        _pin = _pin.substring(0, _pin.length - 1);
      });
    }
  }

  void _verifyAndProceed() {
    if (_pin == _correctMpin) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentProcessingScreen(
            recipientName: widget.recipientName,
            recipientDetail: widget.recipientDetail,
            recipientType: widget.recipientType,
            amount: widget.amount,
            note: widget.note,
            methodId: widget.methodId,
          ),
        ),
      );
    } else {
      setState(() {
        _pin = '';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Incorrect MPIN. Please try again.'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Widget _buildKey(String val) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(AppSpacing.s8),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _onKeyPress(val),
            borderRadius: BorderRadius.circular(32),
            child: Container(
              height: 64,
              alignment: Alignment.center,
              child: Text(
                val,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 24.0,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Security MPIN'),
      body: SafeArea(
        child: _isLoadingMpin
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  const SizedBox(height: AppSpacing.s24),
                  const Text(
                    'Enter 6-Digit MPIN',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s32),
                    child: Text(
                      'Confirm transfer of ₹${widget.amount.toStringAsFixed(2)} to ${widget.recipientName}.',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13.0,
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s40),
                  // PIN Dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(AuthConstants.mpinLength, (index) {
                      final isEntered = index < _pin.length;
                      return Container(
                        width: 16,
                        height: 16,
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isEntered ? AppColors.primary : AppColors.divider,
                        ),
                      );
                    }),
                  ),
                  const Spacer(),
                  // Keyboard
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.s16),
                    decoration: const BoxDecoration(
                      color: AppColors.background,
                      border: Border(
                        top: BorderSide(color: AppColors.divider, width: 1.0),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [_buildKey('1'), _buildKey('2'), _buildKey('3')],
                        ),
                        Row(
                          children: [_buildKey('4'), _buildKey('5'), _buildKey('6')],
                        ),
                        Row(
                          children: [_buildKey('7'), _buildKey('8'), _buildKey('9')],
                        ),
                        Row(
                          children: [
                            const Expanded(child: SizedBox()),
                            _buildKey('0'),
                            Expanded(
                              child: InkWell(
                                onTap: _onBackspace,
                                borderRadius: BorderRadius.circular(32),
                                child: Container(
                                  height: 64,
                                  alignment: Alignment.center,
                                  child: const Icon(
                                    Icons.backspace_outlined,
                                    color: AppColors.textSecondary,
                                    size: 22,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
