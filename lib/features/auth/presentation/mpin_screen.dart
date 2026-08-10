import 'package:flutter/material.dart';
import 'package:payout/core/di/app_dependencies.dart';
import 'package:payout/core/widgets/mpin/mpin_widgets.dart';
import 'package:payout/features/auth/constants/auth_constants.dart';
import 'package:payout/features/auth/validators/auth_validator.dart';
import 'package:payout/features/auth/repositories/auth_repository.dart';
import 'package:payout/features/auth/states/auth_state.dart';
import 'package:payout/features/auth/presentation/widgets/auth_error_widget.dart';
import 'package:payout/features/auth/presentation/biometric_screen.dart';

class MPINScreen extends StatefulWidget {
  final AuthRepository? authRepository;

  const MPINScreen({super.key, this.authRepository});

  @override
  State<MPINScreen> createState() => _MPINScreenState();
}

class _MPINScreenState extends State<MPINScreen> {
  late final AuthRepository _authRepository;

  String _pin = '';
  bool _isConfirmStage = false;
  String _firstPin = '';
  
  AuthState _state = const AuthState(status: AuthStatus.idle);

  @override
  void initState() {
    super.initState();
    _authRepository = widget.authRepository ?? AppDependencies.instance.authRepository;
  }

  void _onKeyPress(String val) {
    if (_pin.length < AuthConstants.mpinLength) {
      setState(() {
        _state = const AuthState(status: AuthStatus.typing);
        _pin += val;
      });

      if (_pin.length == AuthConstants.mpinLength) {
        Future.delayed(const Duration(milliseconds: 300), () async {
          if (!mounted) return;

          if (!_isConfirmStage) {
            // First stage validation
            final validationResult = AuthValidator.validateMPIN(_pin);
            if (validationResult.isValid) {
              setState(() {
                _firstPin = _pin;
                _pin = '';
                _isConfirmStage = true;
              });
            } else {
              setState(() {
                _pin = '';
                _state = AuthState(
                  status: AuthStatus.failure,
                  errorMessage: validationResult.errorMessage ?? 'Invalid MPIN.',
                );
              });
            }
          } else {
            // Confirm stage validation
            final confirmResult = AuthValidator.validateConfirmMPIN(_firstPin, _pin);
            if (confirmResult.isValid) {
              setState(() {
                _state = const AuthState(status: AuthStatus.loading);
              });

              // Create MPIN in repo stub
              final success = await _authRepository.createMPIN(_pin);

              if (!mounted) return;

              if (success) {
                setState(() {
                  _state = const AuthState(status: AuthStatus.success);
                });

                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const BiometricScreen()),
                );
              } else {
                setState(() {
                  _pin = '';
                  _state = const AuthState(
                    status: AuthStatus.failure,
                    errorMessage: 'Failed to create MPIN. Please try again.',
                  );
                });
              }
            } else {
              setState(() {
                _pin = '';
                _state = AuthState(
                  status: AuthStatus.failure,
                  errorMessage: confirmResult.errorMessage ?? 'MPINs do not match.',
                );
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
        _state = const AuthState(status: AuthStatus.typing);
        _pin = _pin.substring(0, _pin.length - 1);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final showLoading = _state.status == AuthStatus.loading;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: MpinBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 8),
                // Top navigation back button
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFFE2E8F0),
                            width: 1.0,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Color(0xFF1F1F1F),
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                
                // Centered concentric security/lock visual
                Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Concentric Orbit 1 (large outer)
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF00B9F1).withValues(alpha: 0.08),
                            width: 1.0,
                          ),
                        ),
                      ),
                      // Concentric Orbit 2 (middle)
                      Container(
                        width: 96,
                        height: 96,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF3F37C9).withValues(alpha: 0.06),
                            width: 1.0,
                          ),
                        ),
                      ),
                      // Tiny Orbit dots
                      Positioned(
                        top: 20,
                        left: 15,
                        child: Container(
                          width: 4,
                          height: 4,
                          decoration: const BoxDecoration(
                            color: Color(0xFF4CC9F0),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 15,
                        right: 12,
                        child: Container(
                          width: 5,
                          height: 5,
                          decoration: const BoxDecoration(
                            color: Color(0xFF3F37C9),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 50,
                        right: 4,
                        child: Container(
                          width: 3.5,
                          height: 3.5,
                          decoration: const BoxDecoration(
                            color: Color(0xFF4895EF),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      // Central Gradient Circle with Lock Icon
                      Container(
                        width: 64,
                        height: 64,
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
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.lock_rounded,
                          color: Colors.white,
                          size: 26,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Title with dynamic confirm/set stage and gradient word highlight
                Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      _isConfirmStage ? 'Confirm security ' : 'Set security ',
                      style: const TextStyle(
                        fontFamily: 'Geist Sans',
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1F1F1F),
                      ),
                    ),
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [
                          Color(0xFF3F37C9),
                          Color(0xFF4895EF),
                        ],
                      ).createShader(Offset.zero & bounds.size),
                      child: const Text(
                        'MPIN',
                        style: TextStyle(
                          fontFamily: 'Geist Sans',
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),

                // Subtitle
                Text(
                  _isConfirmStage 
                      ? 'Re-enter your ${AuthConstants.mpinLength}-digit PIN to confirm.'
                      : 'Create a secure ${AuthConstants.mpinLength}-digit PIN for instant access.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Geist Sans',
                    fontSize: 14,
                    color: const Color(0xFF1F1F1F).withValues(alpha: 0.5),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 18),

                // Auth Error widget if creation failed
                if (_state.status == AuthStatus.failure && _state.errorMessage != null) ...[
                  AuthErrorWidget(
                    title: 'PIN Match Error',
                    description: _state.errorMessage!,
                    onDismiss: () {
                      setState(() {
                        _state = const AuthState(status: AuthStatus.idle);
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                ],

                // MPIN Indicators
                PremiumMpinIndicator(
                  pinLength: _pin.length,
                  maxLength: AuthConstants.mpinLength,
                  isLoading: showLoading,
                ),
                
                const Spacer(),

                // Numeric Keypad
                PremiumMpinKeypad(
                  onKeyPress: _onKeyPress,
                  onBackspace: _onBackspace,
                ),

                const Spacer(),

                // Security Footer
                const MpinSecurityFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
