import 'dart:async';
import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/widgets.dart';
import 'package:payout/features/auth/presentation/mpin_screen.dart';

class OTPScreen extends StatefulWidget {
  final String phoneNumber;

  const OTPScreen({super.key, required this.phoneNumber});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  bool _isValid = false;
  bool _isProcessing = false;
  bool _isSuccess = false;
  
  int _secondsRemaining = 30;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _secondsRemaining = 30;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onChanged(String value, int index) {
    if (value.isNotEmpty) {
      if (index < 5) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
      }
    } else {
      if (index > 0) {
        _focusNodes[index - 1].requestFocus();
      }
    }

    setState(() {
      _isValid = _controllers.every((controller) => controller.text.isNotEmpty);
    });
  }

  Future<void> _verifyOTP() async {
    setState(() {
      _isProcessing = true;
    });

    // Simulate backend verification check latency
    await Future.delayed(const Duration(milliseconds: 1000));

    final enteredCode = _controllers.map((c) => c.text).join();

    if (enteredCode == '123456') {
      setState(() {
        _isProcessing = false;
        _isSuccess = true;
      });

      // Show success validation state for exactly 1 second before navigating
      await Future.delayed(const Duration(seconds: 1));

      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const MPINScreen(),
        ),
      );
    } else {
      setState(() {
        _isProcessing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid OTP. Please enter 123456.'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: ''),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24, vertical: AppSpacing.s12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.s16),
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: AppColors.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.security_rounded,
                    color: AppColors.primary,
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.s24),
              Text(
                'Enter OTP code',
                style: AppTypography.displaySmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.s8),
              Text(
                'We sent a 6-digit code to ${widget.phoneNumber}.',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.s40),
              
              // 6-digit OTP input grid
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: 45,
                    height: 54,
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      onChanged: (val) => _onChanged(val, index),
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      style: AppTypography.headlineMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                      decoration: InputDecoration(
                        counterText: '',
                        contentPadding: EdgeInsets.zero,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                          borderSide: const BorderSide(color: AppColors.divider, width: 1.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                          borderSide: const BorderSide(color: AppColors.primary, width: 2.0),
                        ),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: AppSpacing.s32),
              
              Center(
                child: _secondsRemaining > 0
                    ? Text(
                        'Resend OTP in ${_secondsRemaining}s',
                        style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                      )
                    : TextButton(
                        onPressed: () {
                          _startTimer();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('OTP Code resent successfully.'),
                              backgroundColor: AppColors.primary,
                            ),
                          );
                        },
                        child: Text(
                          'Resend Code',
                          style: AppTypography.bodyMedium.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
              ),
              const Spacer(),
              
              if (_isSuccess)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.success,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.check_circle_rounded, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        'OTP Verified Successfully!',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                )
              else
                PrimaryButton(
                  text: 'Verify & Proceed',
                  isLoading: _isProcessing,
                  onPressed: _isValid && !_isProcessing ? _verifyOTP : null,
                ),
              const SizedBox(height: AppSpacing.s24),
            ],
          ),
        ),
      ),
    );
  }
}
