import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/app_button.dart';
import 'package:payout/features/auth/presentation/otp_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  bool _isValid = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _checkValidation(String value) {
    setState(() {
      _isValid = value.length >= 8;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: '', showLeading: false),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.s16),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'assets/logo/brand_logo.jpeg',
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: AppSpacing.s24),
              Text(
                'Welcome to payout',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: AppSpacing.s8),
              const Text(
                'Enter your phone number to receive a secure login code.',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14.0,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.s40),
              Row(
                children: [
                  Container(
                    height: 54,
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppRadii.button),
                      border: Border.all(color: AppColors.divider, width: 1.0),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      '+1',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.s12),
                  Expanded(
                    child: SizedBox(
                      height: 54,
                      child: TextField(
                        controller: _phoneController,
                        onChanged: _checkValidation,
                        keyboardType: TextInputType.phone,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                        decoration: const InputDecoration(
                          hintText: '000 000 0000',
                          counterText: '',
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              const Center(
                child: Text(
                  'By proceeding, you agree to Payout\'s Terms & Privacy Policy.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12.0,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.s16),
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  text: 'Send Verification Code',
                  onPressed: _isValid
                      ? () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => OTPScreen(phoneNumber: _phoneController.text),
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
