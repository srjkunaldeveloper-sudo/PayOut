import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/mpin/mpin_widgets.dart';
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
  final VoidCallback? onSuccess;

  const PaymentMPINVerificationScreen({
    super.key,
    required this.recipientName,
    required this.recipientDetail,
    required this.recipientType,
    required this.amount,
    required this.note,
    required this.methodId,
    this.onSuccess,
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
      if (widget.onSuccess != null) {
        widget.onSuccess!();
        return;
      }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: MpinBackground(
        child: SafeArea(
          child: _isLoadingMpin
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    // Header with back button
                    const PremiumMpinHeader(
                      title: 'Security MPIN',
                    ),
                    const SizedBox(height: 6),

                    // Centered Security Lock Visual
                    Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFF00B9F1).withValues(alpha: 0.08),
                                width: 1.0,
                              ),
                            ),
                          ),
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFF3F37C9).withValues(alpha: 0.06),
                                width: 1.0,
                              ),
                            ),
                          ),
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFF3F37C9),
                                  Color(0xFF4895EF),
                                  Color(0xFF4CC9F0),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF3F37C9).withValues(alpha: 0.24),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.lock_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Title with gradient MPIN
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [
                          Color(0xFF1F1F1F),
                          Color(0xFF1F1F1F),
                          Color(0xFF3F37C9),
                          Color(0xFF4895EF),
                        ],
                        stops: [0.0, 0.68, 0.72, 1.0],
                      ).createShader(Offset.zero & bounds.size),
                      child: const Text(
                        'Enter 6-Digit MPIN',
                        style: TextStyle(
                          fontFamily: 'Geist Sans',
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Dynamic payment description
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: Text(
                        'Confirm transfer of ₹${widget.amount.toStringAsFixed(2)} to ${widget.recipientName}.',
                        style: TextStyle(
                          fontFamily: 'Geist Sans',
                          fontSize: 13.0,
                          color: const Color(0xFF1F1F1F).withValues(alpha: 0.6),
                          height: 1.3,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 14),

                    // MPIN Dots
                    PremiumMpinIndicator(
                      pinLength: _pin.length,
                      maxLength: AuthConstants.mpinLength,
                    ),

                    const Spacer(),

                    // Keypad
                    PremiumMpinKeypad(
                      onKeyPress: _onKeyPress,
                      onBackspace: _onBackspace,
                    ),

                    const Spacer(),

                    // Footer
                    const MpinSecurityFooter(),
                  ],
                ),
        ),
      ),
    );
  }
}
