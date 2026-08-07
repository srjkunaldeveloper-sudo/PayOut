import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/widgets.dart';
import 'package:payout/features/auth/presentation/otp_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  bool _isValid = false;
  bool _isProcessing = false;
  String? _errorMessage;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _checkValidation(String value) {
    setState(() {
      _errorMessage = null;
      _isValid = value.length == 10;
    });
  }

  Future<void> _requestOTP() async {
    setState(() {
      _isProcessing = true;
      _errorMessage = null;
    });

    // Simulate dummy API request latency
    await Future.delayed(const Duration(milliseconds: 1200));

    if (!mounted) return;

    setState(() {
      _isProcessing = false;
    });

    final phone = _phoneController.text;
    // Simulate invalid mobile validation failure block
    if (phone == '9999999999') {
      setState(() {
        _errorMessage = 'This mobile number is blocked or invalid.';
      });
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => OTPScreen(phoneNumber: '+91 $phone'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: '', showLeading: false),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24, vertical: AppSpacing.s12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.s16),
              // Brand Logo
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(AppRadius.md)),
                child: Image.asset(
                  'assets/logo/brand_logo.jpeg',
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: AppSpacing.s24),
              Text(
                'Welcome to payout',
                style: AppTypography.displaySmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.s8),
              Text(
                'Enter your phone number to receive a secure OTP code.',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.s40),

              // Mobile number input row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 54,
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: const BorderRadius.all(Radius.circular(AppRadius.md)),
                      border: Border.all(color: AppColors.divider, width: 1.0),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '+91',
                      style: AppTypography.bodyLarge.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.s12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 54,
                          child: TextField(
                            controller: _phoneController,
                            onChanged: _checkValidation,
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(10),
                            ],
                            style: AppTypography.bodyLarge.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Enter 10-digit number',
                              counterText: '',
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: AppColors.divider),
                                borderRadius: BorderRadius.circular(AppRadius.md),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                                borderRadius: BorderRadius.circular(AppRadius.md),
                              ),
                            ),
                          ),
                        ),
                        if (_errorMessage != null) ...[
                          const SizedBox(height: 6),
                          Text(
                            _errorMessage!,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              color: AppColors.error,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Center(
                child: Text(
                  'By proceeding, you agree to Payout\'s Terms & Privacy Policy.',
                  textAlign: TextAlign.center,
                  style: AppTypography.bodyMedium.copyWith(
                    fontSize: 11.0,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.s16),
              PrimaryButton(
                text: 'Send Verification Code',
                isLoading: _isProcessing,
                onPressed: _isValid && !_isProcessing ? _requestOTP : null,
              ),
              const SizedBox(height: AppSpacing.s24),
            ],
          ),
        ),
      ),
    );
  }
}
