import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/widgets.dart';
import 'package:payout/features/auth/constants/auth_constants.dart';
import 'package:payout/features/auth/validators/auth_validator.dart';
import 'package:payout/features/auth/models/auth_models.dart';
import 'package:payout/features/auth/repositories/auth_repository.dart';
import 'package:payout/features/auth/states/auth_state.dart';
import 'package:payout/features/auth/presentation/widgets/auth_error_widget.dart';
import 'package:payout/features/auth/presentation/otp_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final AuthRepository _authRepository = MockAuthRepository();

  AuthState _state = const AuthState(status: AuthStatus.idle);
  bool _isValid = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _checkValidation(String value) {
    final result = AuthValidator.validateMobile(value);
    setState(() {
      _isValid = result.isValid;
      _state = const AuthState(status: AuthStatus.typing);
    });
  }

  Future<void> _requestOTP() async {
    setState(() {
      _state = const AuthState(status: AuthStatus.loading);
    });

    final phone = _phoneController.text;
    final request = LoginRequest(
      mobile: phone,
      countryCode: AuthConstants.countryCode,
    );

    final response = await _authRepository.login(request);

    if (!mounted) return;

    if (response.success && response.sessionId != null) {
      setState(() {
        _state = const AuthState(status: AuthStatus.success);
      });

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => OTPScreen(
            phoneNumber: '${AuthConstants.countryCode} $phone',
            sessionId: response.sessionId!,
          ),
        ),
      );
    } else {
      setState(() {
        _state = AuthState(
          status: AuthStatus.failure,
          errorMessage: response.message ?? 'Authentication failed.',
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final showLoading = _state.status == AuthStatus.loading;

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
              const SizedBox(height: AppSpacing.s32),

              if (_state.status == AuthStatus.failure && _state.errorMessage != null) ...[
                AuthErrorWidget(
                  title: 'Blocked Account',
                  description: _state.errorMessage!,
                  onDismiss: () {
                    setState(() {
                      _state = const AuthState(status: AuthStatus.idle);
                    });
                  },
                ),
                const SizedBox(height: AppSpacing.s24),
              ],

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
                      AuthConstants.countryCode,
                      style: AppTypography.bodyLarge.copyWith(
                        fontWeight: FontWeight.bold,
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
                        enabled: !showLoading,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(AuthConstants.mobileLength),
                        ],
                        style: AppTypography.bodyLarge.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Enter ${AuthConstants.mobileLength}-digit number',
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
                          disabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: AppColors.divider),
                            borderRadius: BorderRadius.circular(AppRadius.md),
                          ),
                        ),
                      ),
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
                isLoading: showLoading,
                onPressed: _isValid && !showLoading ? _requestOTP : null,
              ),
              const SizedBox(height: AppSpacing.s24),
            ],
          ),
        ),
      ),
    );
  }
}
