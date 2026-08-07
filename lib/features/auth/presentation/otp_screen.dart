import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/app_button.dart';
import 'package:payout/features/auth/presentation/mpin_screen.dart';

class OTPScreen extends StatefulWidget {
  final String phoneNumber;

  const OTPScreen({super.key, required this.phoneNumber});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final List<TextEditingController> _controllers = List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());
  bool _isValid = false;

  @override
  void dispose() {
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
      if (index < 3) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
      }
    } else {
      if (index > 0) {
        _focusNodes[index - 1].requestFocus();
      }
    }

    // check if all OTP slots are filled
    setState(() {
      _isValid = _controllers.every((controller) => controller.text.isNotEmpty);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: ''),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.s16),
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(12),
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
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: AppSpacing.s8),
              Text(
                'We sent a 4-digit code to +1 ${widget.phoneNumber.isEmpty ? '555 0199' : widget.phoneNumber}.',
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14.0,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.s40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(4, (index) {
                  return SizedBox(
                    width: 64,
                    height: 64,
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      onChanged: (val) => _onChanged(val, index),
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                      decoration: InputDecoration(
                        counterText: '',
                        contentPadding: EdgeInsets.zero,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),
                          borderSide: const BorderSide(color: AppColors.divider, width: 1.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),
                          borderSide: const BorderSide(color: AppColors.primary, width: 2.0),
                        ),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: AppSpacing.s32),
              Center(
                child: TextButton(
                  onPressed: () {
                    // Mock resending code
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('OTP Code resent successfully.'),
                        backgroundColor: AppColors.primary,
                      ),
                    );
                  },
                  child: const Text(
                    'Resend Code',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  text: 'Verify & Proceed',
                  onPressed: _isValid
                      ? () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const MPINScreen(),
                            ),
                          );
                        }
                      : null,
                ),
              ),
              const SizedBox(height: AppSpacing.s24),
            ],
          ),
        ),
      ),
    );
  }
}
