import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/widgets.dart';
import 'package:payout/features/auth/presentation/biometric_screen.dart';

class MPINScreen extends StatefulWidget {
  const MPINScreen({super.key});

  @override
  State<MPINScreen> createState() => _MPINScreenState();
}

class _MPINScreenState extends State<MPINScreen> {
  String _pin = '';
  bool _isConfirmStage = false;
  String _firstPin = '';
  String? _errorMessage;

  void _onKeyPress(String val) {
    if (_pin.length < 6) {
      setState(() {
        _errorMessage = null;
        _pin += val;
      });

      if (_pin.length == 6) {
        Future.delayed(const Duration(milliseconds: 300), () {
          if (!mounted) return;

          if (!_isConfirmStage) {
            // Move to confirm stage
            setState(() {
              _firstPin = _pin;
              _pin = '';
              _isConfirmStage = true;
            });
          } else {
            // Verify match
            if (_pin == _firstPin) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const BiometricScreen()),
              );
            } else {
              setState(() {
                _pin = '';
                _errorMessage = 'PINs do not match. Please try again.';
              });
            }
          }
        });
      }
    }
  }

  void _onBackspace() {
    if (_pin.isNotEmpty) {
      setState(() {
        _errorMessage = null;
        _pin = _pin.substring(0, _pin.length - 1);
      });
    }
  }

  Widget _buildKey(String value) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(AppSpacing.s4),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _onKeyPress(value),
            borderRadius: BorderRadius.circular(AppRadius.md),
            child: Container(
              height: 56,
              alignment: Alignment.center,
              child: Text(
                value,
                style: AppTypography.titleLarge.copyWith(
                  fontWeight: FontWeight.bold,
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
      appBar: const CustomAppBar(title: ''),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24, vertical: AppSpacing.s12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
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
                    Icons.lock_outline_rounded,
                    color: AppColors.primary,
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.s24),
              Text(
                _isConfirmStage ? 'Confirm security MPIN' : 'Set security MPIN',
                style: AppTypography.displaySmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  fontSize: 24.0,
                ),
              ),
              const SizedBox(height: AppSpacing.s8),
              Text(
                _isConfirmStage 
                    ? 'Re-enter your 6-digit PIN to confirm.'
                    : 'Create a secure 6-digit PIN for instant access.',
                textAlign: TextAlign.center,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.s40),
              
              // 6-digit indicators
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(6, (index) {
                  final isFilled = index < _pin.length;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    margin: const EdgeInsets.symmetric(horizontal: AppSpacing.s8),
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: isFilled ? AppColors.primary : Colors.transparent,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isFilled ? AppColors.primary : AppColors.divider,
                        width: 2.0,
                      ),
                    ),
                  );
                }),
              ),
              
              if (_errorMessage != null) ...[
                const SizedBox(height: AppSpacing.s24),
                Text(
                  _errorMessage!,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    color: AppColors.error,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
              
              const Spacer(),
              
              // Keypad
              Column(
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
                        child: Container(
                          margin: const EdgeInsets.all(AppSpacing.s4),
                          child: InkWell(
                            onTap: _onBackspace,
                            borderRadius: BorderRadius.circular(AppRadius.md),
                            child: Container(
                              height: 56,
                              alignment: Alignment.center,
                              child: const Icon(
                                Icons.backspace_outlined,
                                color: AppColors.textSecondary,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.s16),
            ],
          ),
        ),
      ),
    );
  }
}
