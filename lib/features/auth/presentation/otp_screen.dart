import 'dart:async';
import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/widgets.dart';
import 'package:payout/features/auth/constants/auth_constants.dart';
import 'package:payout/features/auth/validators/auth_validator.dart';
import 'package:payout/features/auth/models/auth_models.dart';
import 'package:payout/features/auth/repositories/auth_repository.dart';
import 'package:payout/features/auth/states/auth_state.dart';
import 'package:payout/features/auth/services/session_manager.dart';
import 'package:payout/features/auth/presentation/widgets/auth_error_widget.dart';
import 'package:payout/features/auth/presentation/mpin_screen.dart';

class OTPScreen extends StatefulWidget {
  final String phoneNumber;
  final String sessionId;

  const OTPScreen({
    super.key,
    required this.phoneNumber,
    required this.sessionId,
  });

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final List<TextEditingController> _controllers = List.generate(AuthConstants.otpLength, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(AuthConstants.otpLength, (_) => FocusNode());
  final AuthRepository _authRepository = MockAuthRepository();

  AuthState _state = const AuthState(status: AuthStatus.idle);
  bool _isValid = false;
  int _secondsRemaining = AuthConstants.timerDuration;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _secondsRemaining = AuthConstants.timerDuration;
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
      if (index < AuthConstants.otpLength - 1) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
      }
    } else {
      if (index > 0) {
        _focusNodes[index - 1].requestFocus();
      }
    }

    final enteredCode = _controllers.map((c) => c.text).join();
    final result = AuthValidator.validateOTP(enteredCode);
    setState(() {
      _isValid = result.isValid;
      _state = const AuthState(status: AuthStatus.typing);
    });
  }

  Future<void> _verifyOTP() async {
    setState(() {
      _state = const AuthState(status: AuthStatus.loading);
    });

    final enteredCode = _controllers.map((c) => c.text).join();
    final request = OTPRequest(
      sessionId: widget.sessionId,
      code: enteredCode,
    );

    final response = await _authRepository.verifyOTP(request);

    if (!mounted) return;

    if (response.success && response.accessToken != null && response.refreshToken != null && response.user != null) {
      // Initialize active session
      await SessionManager.instance.initSession(
        response.accessToken!,
        response.refreshToken!,
        response.user!,
      );

      setState(() {
        _state = const AuthState(status: AuthStatus.success);
      });

      // Show success checkmark for exactly 1 second before moving
      await Future.delayed(const Duration(seconds: 1));

      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const MPINScreen(),
        ),
      );
    } else {
      setState(() {
        _state = AuthState(
          status: AuthStatus.failure,
          errorMessage: response.message ?? 'OTP verification failed.',
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final showLoading = _state.status == AuthStatus.loading;
    final isSuccess = _state.status == AuthStatus.success;

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
                'We sent a ${AuthConstants.otpLength}-digit code to ${widget.phoneNumber}.',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.s32),

              if (_state.status == AuthStatus.failure && _state.errorMessage != null) ...[
                AuthErrorWidget(
                  title: 'Verification Failed',
                  description: _state.errorMessage!,
                  onDismiss: () {
                    setState(() {
                      _state = const AuthState(status: AuthStatus.idle);
                    });
                  },
                ),
                const SizedBox(height: AppSpacing.s24),
              ],

              // OTP input grid
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(AuthConstants.otpLength, (index) {
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
                      enabled: !showLoading && !isSuccess,
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
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                          borderSide: const BorderSide(color: AppColors.divider, width: 1.0),
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
                        onPressed: () async {
                          _startTimer();
                          await _authRepository.resendOTP(widget.phoneNumber);
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

              if (isSuccess)
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
                  isLoading: showLoading,
                  onPressed: _isValid && !showLoading ? _verifyOTP : null,
                ),
              const SizedBox(height: AppSpacing.s24),
            ],
          ),
        ),
      ),
    );
  }
}
