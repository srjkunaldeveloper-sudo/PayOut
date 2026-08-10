import 'dart:async';
import 'package:flutter/material.dart';
import 'package:payout/core/di/app_dependencies.dart';
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
  final AuthRepository? authRepository;

  const OTPScreen({
    super.key,
    required this.phoneNumber,
    required this.sessionId,
    this.authRepository,
  });

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final List<TextEditingController> _controllers = List.generate(AuthConstants.otpLength, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(AuthConstants.otpLength, (_) => FocusNode());
  late final AuthRepository _authRepository;

  AuthState _state = const AuthState(status: AuthStatus.idle);
  bool _isValid = false;
  int _secondsRemaining = AuthConstants.timerDuration;
  Timer? _timer;
  int _focusedIndex = -1;

  @override
  void initState() {
    super.initState();
    _authRepository = widget.authRepository ?? AppDependencies.instance.authRepository;
    _startTimer();

    // Track active focus node for high-fidelity border highlighting
    for (int i = 0; i < AuthConstants.otpLength; i++) {
      _focusNodes[i].addListener(() {
        if (_focusNodes[i].hasFocus) {
          setState(() {
            _focusedIndex = i;
          });
        }
      });
    }
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
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Subtle Premium Background
          const Positioned.fill(
            child: CustomPaint(
              painter: OTPBackgroundPainter(),
            ),
          ),
          // 2. Main Content
          SafeArea(
            child: CustomScrollView(
              physics: const ClampingScrollPhysics(),
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 12),
                        // Navigation Back Button
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
                        const SizedBox(height: 24),
                        
                        // Brand Banner Header (matching LoginScreen branding)
                        FadeUpEntrance(
                          delay: Duration.zero,
                          child: AspectRatio(
                            aspectRatio: 2.8,
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFF05021A),
                                borderRadius: BorderRadius.circular(18),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF002E6E).withOpacity(0.06),
                                    blurRadius: 16,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              child: Image.asset(
                                'assets/logo/login_banner.jpeg',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),

                        // Security shield icon
                        FadeUpEntrance(
                          delay: const Duration(milliseconds: 50),
                          child: Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: const Color(0xFF00B9F1).withOpacity(0.08),
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.security_rounded,
                                color: Color(0xFF00B9F1),
                                size: 28,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        
                        // OTP Title Header
                        FadeUpEntrance(
                          delay: const Duration(milliseconds: 100),
                          child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              const Text(
                                'Enter ',
                                style: TextStyle(
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
                                  'OTP code',
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
                        ),
                        const SizedBox(height: 8),
                        
                        // Subtitle with dynamic phone number highlighting
                        FadeUpEntrance(
                          delay: const Duration(milliseconds: 150),
                          child: RichText(
                            text: TextSpan(
                              text: 'We sent a 6-digit code to ',
                              style: TextStyle(
                                fontFamily: 'Geist Sans',
                                fontSize: 14,
                                color: const Color(0xFF1F1F1F).withOpacity(0.5),
                                height: 1.4,
                              ),
                              children: [
                                TextSpan(
                                  text: widget.phoneNumber,
                                  style: const TextStyle(
                                    color: Color(0xFF2563EB),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const TextSpan(text: '.'),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),

                        // Auth Error Widget if verification failed
                        if (_state.status == AuthStatus.failure && _state.errorMessage != null) ...[
                          FadeUpEntrance(
                            delay: Duration.zero,
                            child: AuthErrorWidget(
                              title: 'Verification Failed',
                              description: _state.errorMessage!,
                              onDismiss: () {
                                setState(() {
                                  _state = const AuthState(status: AuthStatus.idle);
                                });
                              },
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],

                        // Premium OTP code boxes
                        FadeUpEntrance(
                          delay: const Duration(milliseconds: 200),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(AuthConstants.otpLength, (index) {
                              final isFocused = _focusedIndex == index;

                              return SizedBox(
                                width: 48,
                                height: 56,
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: isFocused ? const Color(0xFF00B9F1) : const Color(0xFFE2E8F0),
                                      width: isFocused ? 1.8 : 1.0,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: isFocused
                                            ? const Color(0xFF00B9F1).withOpacity(0.08)
                                            : const Color(0xFF002E6E).withOpacity(0.01),
                                        blurRadius: isFocused ? 12 : 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  alignment: Alignment.center,
                                  child: TextField(
                                    controller: _controllers[index],
                                    focusNode: _focusNodes[index],
                                    onChanged: (val) => _onChanged(val, index),
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    maxLength: 1,
                                    enabled: !showLoading && !isSuccess,
                                    style: const TextStyle(
                                      fontFamily: 'Geist Sans',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Color(0xFF1F1F1F),
                                    ),
                                    decoration: const InputDecoration(
                                      counterText: '',
                                      contentPadding: EdgeInsets.zero,
                                      border: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                      filled: false,
                                      fillColor: Colors.transparent,
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                        const SizedBox(height: 28),

                        // Countdown resend action
                        FadeUpEntrance(
                          delay: const Duration(milliseconds: 250),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.timer_outlined,
                                size: 16,
                                color: const Color(0xFF1F1F1F).withOpacity(0.4),
                              ),
                              const SizedBox(width: 6),
                              _secondsRemaining > 0
                                  ? RichText(
                                      text: TextSpan(
                                        text: 'Resend OTP in ',
                                        style: TextStyle(
                                          fontFamily: 'Geist Sans',
                                          fontSize: 14,
                                          color: const Color(0xFF1F1F1F).withOpacity(0.5),
                                        ),
                                        children: [
                                          TextSpan(
                                            text: '${_secondsRemaining}s',
                                            style: const TextStyle(
                                              color: Color(0xFF2563EB),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : TextButton(
                                      onPressed: () async {
                                        final messenger = ScaffoldMessenger.of(context);
                                        _startTimer();
                                        await _authRepository.resendOTP(widget.phoneNumber);
                                        if (mounted) {
                                          messenger.showSnackBar(
                                            const SnackBar(
                                              content: Text('OTP Code resent successfully.'),
                                              backgroundColor: Color(0xFF2563EB),
                                            ),
                                          );
                                        }
                                      },
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        minimumSize: Size.zero,
                                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      child: const Text(
                                        'Resend Code',
                                        style: TextStyle(
                                          fontFamily: 'Geist Sans',
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF2563EB),
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                        ),
                        
                        const Spacer(),

                        // Success Indicator or Verify Button
                        FadeUpEntrance(
                          delay: const Duration(milliseconds: 300),
                          child: isSuccess
                              ? Container(
                                  height: 56,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF10B981),
                                    borderRadius: BorderRadius.circular(28),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF10B981).withOpacity(0.18),
                                        blurRadius: 12,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(Icons.check_circle_rounded, color: Colors.white, size: 24),
                                      SizedBox(width: 8),
                                      Text(
                                        'OTP Verified Successfully!',
                                        style: TextStyle(
                                          fontFamily: 'Geist Sans',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : PremiumCTAButton(
                                  text: 'Verify & Proceed',
                                  isLoading: showLoading,
                                  onPressed: _isValid && !showLoading ? _verifyOTP : null,
                                ),
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Fade up stagger entrance animation helper
class FadeUpEntrance extends StatelessWidget {
  final Widget child;
  final Duration delay;

  const FadeUpEntrance({
    super.key,
    required this.child,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
      builder: (context, value, childWidget) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 12),
            child: childWidget,
          ),
        );
      },
      child: child,
    );
  }
}

// Premium CTA rounded button with custom gradient and scale transforms on tap
class PremiumCTAButton extends StatefulWidget {
  final String text;
  final bool isLoading;
  final VoidCallback? onPressed;

  const PremiumCTAButton({
    super.key,
    required this.text,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  State<PremiumCTAButton> createState() => _PremiumCTAButtonState();
}

class _PremiumCTAButtonState extends State<PremiumCTAButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = widget.onPressed != null;

    return GestureDetector(
      onTapDown: isEnabled ? (_) => setState(() => _isPressed = true) : null,
      onTapUp: isEnabled ? (_) => setState(() => _isPressed = false) : null,
      onTapCancel: isEnabled ? () => setState(() => _isPressed = false) : null,
      onTap: widget.onPressed,
      child: AnimatedScale(
        scale: _isPressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: isEnabled
                ? const LinearGradient(
                    colors: [
                      Color(0xFF4338CA),
                      Color(0xFF2563EB),
                      Color(0xFF06B6D4),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  )
                : null,
            color: isEnabled ? null : const Color(0xFFE2E8F0),
            boxShadow: isEnabled
                ? [
                    BoxShadow(
                      color: const Color(0xFF2563EB).withOpacity(0.18),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          alignment: Alignment.center,
          child: widget.isLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.text,
                      style: TextStyle(
                        fontFamily: 'Geist Sans',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: isEnabled ? Colors.white : const Color(0xFF94A3B8),
                      ),
                    ),
                    if (isEnabled) ...[
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ],
                  ],
                ),
        ),
      ),
    );
  }
}

// Background painter matching Splash and Login Screen
class OTPBackgroundPainter extends CustomPainter {
  const OTPBackgroundPainter();

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Base gradient
    final bgPaint = Paint()
      ..shader = const LinearGradient(
        colors: [
          Color(0xFFFFFFFF),
          Color(0xFFFBFBFF),
          Color(0xFFF3F6FD),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // 2. Extremely subtle radial gradient glow highlights (cyan & purple)
    final Paint glowPaint = Paint()..style = PaintingStyle.fill;
    
    // Cyan glow (top right)
    glowPaint.shader = RadialGradient(
      colors: [
        const Color(0xFF00B9F1).withOpacity(0.04),
        Colors.transparent,
      ],
    ).createShader(Rect.fromCircle(center: Offset(size.width * 0.9, size.height * 0.1), radius: 250));
    canvas.drawCircle(Offset(size.width * 0.9, size.height * 0.1), 250, glowPaint);

    // Purple glow (middle left)
    glowPaint.shader = RadialGradient(
      colors: [
        const Color(0xFF1B1464).withOpacity(0.03),
        Colors.transparent,
      ],
    ).createShader(Rect.fromCircle(center: Offset(size.width * 0.1, size.height * 0.5), radius: 300));
    canvas.drawCircle(Offset(size.width * 0.1, size.height * 0.5), 300, glowPaint);

    // 3. Floating circular accents
    final accentPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Accent Circle 1: top left
    accentPaint.color = const Color(0xFF00B9F1).withOpacity(0.06);
    canvas.drawCircle(Offset(size.width * 0.15, size.height * 0.25), 30, accentPaint);
    canvas.drawCircle(
      Offset(size.width * 0.15, size.height * 0.25), 
      3, 
      Paint()..color = const Color(0xFF00B9F1).withOpacity(0.06),
    );

    // Accent Circle 2: bottom right
    accentPaint.color = const Color(0xFF1B1464).withOpacity(0.04);
    canvas.drawCircle(Offset(size.width * 0.85, size.height * 0.75), 50, accentPaint);
    canvas.drawCircle(
      Offset(size.width * 0.82, size.height * 0.68), 
      5.5, 
      Paint()..color = const Color(0xFF00B9F1).withOpacity(0.06),
    );

    // 4. Soft decorative waves near bottom rising on the right
    final double h = size.height;
    final double w = size.width;

    final path1 = Path();
    path1.moveTo(0, h * 0.88);
    path1.quadraticBezierTo(w * 0.45, h * 0.86, w * 0.75, h * 0.78);
    path1.quadraticBezierTo(w * 0.9, h * 0.75, w, h * 0.65);
    path1.lineTo(w, h);
    path1.lineTo(0, h);
    path1.close();

    final paint1 = Paint()
      ..shader = const LinearGradient(
        colors: [
          Color(0x0CCAD3F5),
          Color(0x20CAD3F5),
        ],
      ).createShader(Rect.fromLTWH(0, h * 0.6, w, h * 0.4));
    canvas.drawPath(path1, paint1);

    // Wave 2
    final path2 = Path();
    path2.moveTo(0, h * 0.92);
    path2.quadraticBezierTo(w * 0.4, h * 0.90, w * 0.75, h * 0.83);
    path2.quadraticBezierTo(w * 0.9, h * 0.80, w, h * 0.72);
    path2.lineTo(w, h);
    path2.lineTo(0, h);
    path2.close();

    final paint2 = Paint()
      ..shader = const LinearGradient(
        colors: [
          Color(0x15DBEDFD),
          Color(0x28C2CCF4),
        ],
      ).createShader(Rect.fromLTWH(0, h * 0.7, w, h * 0.3));
    canvas.drawPath(path2, paint2);

    // Subtle dot-grid pattern clipped to bottom area
    canvas.save();
    canvas.clipPath(path2);
    final dotPaint = Paint()..color = const Color(0x12A6B4E5);
    for (double x = 0; x < w * 0.45; x += 15) {
      for (double y = h * 0.7; y < h; y += 15) {
        canvas.drawCircle(Offset(x, y), 1.0, dotPaint);
      }
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
