import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:payout/core/di/app_dependencies.dart';
import 'package:payout/features/auth/constants/auth_constants.dart';
import 'package:payout/features/auth/validators/auth_validator.dart';
import 'package:payout/features/auth/models/auth_models.dart';
import 'package:payout/features/auth/repositories/auth_repository.dart';
import 'package:payout/features/auth/states/auth_state.dart';
import 'package:payout/features/auth/presentation/widgets/auth_error_widget.dart';
import 'package:payout/features/auth/presentation/otp_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginScreen extends StatefulWidget {
  final AuthRepository? authRepository;

  const LoginScreen({super.key, this.authRepository});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final TextEditingController _phoneController = TextEditingController();
  final FocusNode _phoneFocusNode = FocusNode();
  late final AuthRepository _authRepository;

  AuthState _state = const AuthState(status: AuthStatus.idle);
  bool _isValid = false;
  bool _isEmailFocused = false;
  bool _isPhoneFocused = false;

  @override
  void initState() {
    super.initState();
    _authRepository = widget.authRepository ?? AppDependencies.instance.authRepository;
    _emailFocusNode.addListener(() {
      setState(() {
        _isEmailFocused = _emailFocusNode.hasFocus;
      });
    });
    _phoneFocusNode.addListener(() {
      setState(() {
        _isPhoneFocused = _phoneFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _emailFocusNode.dispose();
    _phoneController.dispose();
    _phoneFocusNode.dispose();
    super.dispose();
  }

  Future<void> _launchURL(String urlString) async {
    final uri = Uri.parse(urlString);
    try {
      final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!launched && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open link: $urlString')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open link: $urlString')),
        );
      }
    }
  }

  void _checkValidation([String? _]) {
    final emailResult = AuthValidator.validateEmail(_emailController.text);
    final phoneResult = AuthValidator.validateMobile(_phoneController.text);
    setState(() {
      _isValid = emailResult.isValid && phoneResult.isValid;
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
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Subtle Premium Background
          const Positioned.fill(
            child: CustomPaint(
              painter: LoginBackgroundPainter(),
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
                        // Brand Banner Header (using login_banner.jpeg exactly)
                        FadeUpEntrance(
                          delay: Duration.zero,
                          child: AspectRatio(
                            aspectRatio: 2.8,
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFF05021A), // Matches the dark background of the login banner exactly
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
                                fit: BoxFit.contain, // Guarantees no stretching or cropping occurs
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),
                        
                        // Welcome Header
                        FadeUpEntrance(
                          delay: const Duration(milliseconds: 100),
                          child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              const Text(
                                'Welcome to ',
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
                                  'payout',
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
                        
                        // Subtitle
                        FadeUpEntrance(
                          delay: const Duration(milliseconds: 150),
                          child: Text(
                            'Enter your email and phone number to create your account.',
                            style: TextStyle(
                              fontFamily: 'Geist Sans',
                              fontSize: 14,
                              color: const Color(0xFF1F1F1F).withOpacity(0.5),
                              height: 1.4,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Auth Error Panel if failed
                        if (_state.status == AuthStatus.failure && _state.errorMessage != null) ...[
                          FadeUpEntrance(
                            delay: Duration.zero,
                            child: AuthErrorWidget(
                              title: 'Blocked Account',
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

                        // 1. Email Input
                        FadeUpEntrance(
                          delay: const Duration(milliseconds: 180),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            height: 56,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: _isEmailFocused ? const Color(0xFF00B9F1) : const Color(0xFFE2E8F0),
                                width: _isEmailFocused ? 1.5 : 1.0,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: _isEmailFocused
                                      ? const Color(0xFF00B9F1).withOpacity(0.06)
                                      : const Color(0xFF002E6E).withOpacity(0.01),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                const SizedBox(width: 12),
                                Icon(
                                  Icons.mail_outline_rounded,
                                  color: const Color(0xFF1F1F1F).withOpacity(0.35),
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: TextField(
                                    focusNode: _emailFocusNode,
                                    controller: _emailController,
                                    onChanged: _checkValidation,
                                    keyboardType: TextInputType.emailAddress,
                                    enabled: !showLoading,
                                    style: const TextStyle(
                                      fontFamily: 'Geist Sans',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: Color(0xFF1F1F1F),
                                    ),
                                    decoration: InputDecoration(
                                      hintText: 'Enter your email',
                                      hintStyle: TextStyle(
                                        fontFamily: 'Geist Sans',
                                        fontWeight: FontWeight.normal,
                                        fontSize: 14,
                                        color: const Color(0xFF1F1F1F).withOpacity(0.35),
                                      ),
                                      border: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),

                        // 2. Separated Phone Inputs
                        FadeUpEntrance(
                          delay: const Duration(milliseconds: 200),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Left country code block
                              Container(
                                height: 56,
                                width: 72,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: const Color(0xFFE2E8F0),
                                    width: 1.0,
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  AuthConstants.countryCode,
                                  style: const TextStyle(
                                    fontFamily: 'Geist Sans',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Color(0xFF1F1F1F),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Right phone text field block
                              Expanded(
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  height: 56,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: _isPhoneFocused ? const Color(0xFF00B9F1) : const Color(0xFFE2E8F0),
                                      width: _isPhoneFocused ? 1.5 : 1.0,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: _isPhoneFocused
                                            ? const Color(0xFF00B9F1).withOpacity(0.06)
                                            : const Color(0xFF002E6E).withOpacity(0.01),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      const SizedBox(width: 12),
                                      Icon(
                                        Icons.phone_outlined,
                                        color: const Color(0xFF1F1F1F).withOpacity(0.35),
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: TextField(
                                          focusNode: _phoneFocusNode,
                                          controller: _phoneController,
                                          onChanged: _checkValidation,
                                          keyboardType: TextInputType.phone,
                                          enabled: !showLoading,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.digitsOnly,
                                            LengthLimitingTextInputFormatter(AuthConstants.mobileLength),
                                          ],
                                          style: const TextStyle(
                                            fontFamily: 'Geist Sans',
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                            color: Color(0xFF1F1F1F),
                                            letterSpacing: 1.0,
                                          ),
                                          decoration: InputDecoration(
                                            hintText: 'Enter ${AuthConstants.mobileLength}-digit number',
                                            hintStyle: TextStyle(
                                              fontFamily: 'Geist Sans',
                                              fontWeight: FontWeight.normal,
                                              fontSize: 14,
                                              color: const Color(0xFF1F1F1F).withOpacity(0.35),
                                              letterSpacing: 0,
                                            ),
                                            border: InputBorder.none,
                                            enabledBorder: InputBorder.none,
                                            focusedBorder: InputBorder.none,
                                            disabledBorder: InputBorder.none,
                                            contentPadding: const EdgeInsets.symmetric(vertical: 16),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        const Spacer(),
                        
                        // Legal details
                        FadeUpEntrance(
                          delay: const Duration(milliseconds: 250),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: Center(
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  text: 'By continuing, you agree to our ',
                                  style: TextStyle(
                                    fontFamily: 'Geist Sans',
                                    fontSize: 12.0,
                                    color: const Color(0xFF1F1F1F).withOpacity(0.5),
                                  ),
                                  children: [
                                    TextSpan(
                                      text: 'Privacy Policy',
                                      style: const TextStyle(
                                        color: Color(0xFF2563EB),
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () => _launchURL('https://www.srjupipaymentsnbfcbank.com/privacy-policy.html'),
                                    ),
                                    const TextSpan(text: ' and '),
                                    TextSpan(
                                      text: 'Terms & Conditions',
                                      style: const TextStyle(
                                        color: Color(0xFF2563EB),
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () => _launchURL('https://www.srjupipaymentsnbfcbank.com/terms-conditions.html'),
                                    ),
                                    const TextSpan(text: '.'),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        
                        // Send Verification Code Button
                        FadeUpEntrance(
                          delay: const Duration(milliseconds: 300),
                          child: PremiumCTAButton(
                            text: 'Send Verification Code',
                            isLoading: showLoading,
                            onPressed: _isValid && !showLoading ? _requestOTP : null,
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

// Background painter for radial highlights and soft waves at bottom
class LoginBackgroundPainter extends CustomPainter {
  const LoginBackgroundPainter();

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
