import 'package:flutter/material.dart';
import 'package:payout/core/di/app_dependencies.dart';
import 'package:payout/features/auth/presentation/login_screen.dart';
import 'package:payout/features/auth/repositories/auth_repository.dart';
import 'package:payout/features/auth/services/session_manager.dart';
import 'package:payout/features/auth/validators/auth_validator.dart';
import 'package:payout/features/dashboard/presentation/dashboard_shell.dart';
import 'package:payout/features/user/dummy/dummy_user_data.dart';

class ExistingUserLoginScreen extends StatefulWidget {
  final AuthRepository? authRepository;

  const ExistingUserLoginScreen({super.key, this.authRepository});

  @override
  State<ExistingUserLoginScreen> createState() => _ExistingUserLoginScreenState();
}

class _ExistingUserLoginScreenState extends State<ExistingUserLoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  late final AuthRepository _authRepository;

  bool _isPasswordVisible = false;
  bool _isEmailFocused = false;
  bool _isPasswordFocused = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _authRepository = widget.authRepository ?? AppDependencies.instance.authRepository;

    _emailFocusNode.addListener(() {
      setState(() {
        _isEmailFocused = _emailFocusNode.hasFocus;
      });
    });

    _passwordFocusNode.addListener(() {
      setState(() {
        _isPasswordFocused = _passwordFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  bool get _isEmailValid => AuthValidator.validateEmail(_emailController.text).isValid;
  bool get _isPasswordValid => _passwordController.text.trim().isNotEmpty;
  bool get _canSubmit => _isEmailValid && _isPasswordValid && !_isLoading;

  /*
  String _formatNameFromEmail(String email) {
    final namePart = email.split('@').first;
    final parts = namePart.replaceAll(RegExp(r'[\._\-]'), ' ').split(' ');
    final formatted = parts
        .where((p) => p.isNotEmpty)
        .map((p) => p[0].toUpperCase() + (p.length > 1 ? p.substring(1).toLowerCase() : ''))
        .join(' ');
    return formatted.isNotEmpty ? formatted : 'Payout User';
  }
  */

  Future<void> _handleLogin() async {
    if (!_canSubmit) return;

    setState(() {
      _isLoading = true;
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    final result = await _authRepository.signInWithEmailPassword(
      email: email,
      password: password,
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (result.isSuccess && result.data != null) {
      final user = result.data!;
      await SessionManager.instance.initSession(
        'FIREBASE-TOKEN-${user.id}',
        'FIREBASE-REFRESH-${user.id}',
        user,
      );

      // Update active profile data dynamically
      DummyUserData.currentUser = DummyUserData.currentUser.copyWith(
        name: user.name,
        email: user.email ?? email,
        phone: user.phone,
      );

      if (!mounted) return;

      // Navigate directly to Home (DashboardShell)
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const DashboardShell(),
        ),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.message ?? 'Invalid email or password. Please try again.'),
          backgroundColor: const Color(0xFFEF4444),
        ),
      );
    }
  }

  void _handleForgotPassword() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFCBD5E1),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF2563EB).withValues(alpha: 0.1),
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.lock_reset_rounded,
                  color: Color(0xFF2563EB),
                  size: 28,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Reset Password',
                style: TextStyle(
                  fontFamily: 'Geist Sans',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F1F1F),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'A secure password reset link will be sent to ${_emailController.text.isNotEmpty ? _emailController.text.trim() : 'your registered email'}.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Geist Sans',
                  fontSize: 14,
                  color: const Color(0xFF1F1F1F).withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 24),
              PremiumCTAButton(
                text: 'Send Reset Link',
                isLoading: false,
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Password reset instructions sent successfully.'),
                      backgroundColor: Color(0xFF059669),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                        // Back Button
                        if (Navigator.of(context).canPop())
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                border: Border.all(color: const Color(0xFFE2E8F0)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.03),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              alignment: Alignment.center,
                              child: const Icon(
                                Icons.arrow_back_rounded,
                                color: Color(0xFF3F37C9),
                                size: 20,
                              ),
                            ),
                          ),
                        const SizedBox(height: 20),

                        // Title Header
                        FadeUpEntrance(
                          delay: const Duration(milliseconds: 100),
                          child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              const Text(
                                'Welcome ',
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
                                  'Back',
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
                            'Login to continue to your Payout account.',
                            style: TextStyle(
                              fontFamily: 'Geist Sans',
                              fontSize: 14,
                              color: const Color(0xFF1F1F1F).withValues(alpha: 0.5),
                              height: 1.4,
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),

                        // 1. Email Address Field
                        FadeUpEntrance(
                          delay: const Duration(milliseconds: 200),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Email Address',
                                style: TextStyle(
                                  fontFamily: 'Geist Sans',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1E293B),
                                ),
                              ),
                              const SizedBox(height: 8),
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                height: 58,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: _isEmailFocused
                                        ? const Color(0xFF2563EB)
                                        : const Color(0xFFE2E8F0),
                                    width: _isEmailFocused ? 1.5 : 1.0,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: _isEmailFocused
                                          ? const Color(0xFF2563EB).withValues(alpha: 0.08)
                                          : const Color(0xFF002E6E).withValues(alpha: 0.02),
                                      blurRadius: 10,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 38,
                                      height: 38,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF3F37C9).withValues(alpha: 0.06),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      alignment: Alignment.center,
                                      child: const Icon(
                                        Icons.mail_outline_rounded,
                                        color: Color(0xFF3F37C9),
                                        size: 20,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: TextField(
                                        focusNode: _emailFocusNode,
                                        controller: _emailController,
                                        keyboardType: TextInputType.emailAddress,
                                        onChanged: (_) => setState(() {}),
                                        style: const TextStyle(
                                          fontFamily: 'Geist Sans',
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15.5,
                                          color: Color(0xFF0F172A),
                                        ),
                                        decoration: const InputDecoration(
                                          hintText: 'name@example.com',
                                          hintStyle: TextStyle(
                                            fontFamily: 'Geist Sans',
                                            fontWeight: FontWeight.normal,
                                            fontSize: 14.5,
                                            color: Color(0xFF94A3B8),
                                          ),
                                          border: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          disabledBorder: InputBorder.none,
                                          contentPadding: EdgeInsets.symmetric(vertical: 16),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 18),

                        // 2. Password Field
                        FadeUpEntrance(
                          delay: const Duration(milliseconds: 250),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Password',
                                style: TextStyle(
                                  fontFamily: 'Geist Sans',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1E293B),
                                ),
                              ),
                              const SizedBox(height: 8),
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                height: 58,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: _isPasswordFocused
                                        ? const Color(0xFF2563EB)
                                        : const Color(0xFFE2E8F0),
                                    width: _isPasswordFocused ? 1.5 : 1.0,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: _isPasswordFocused
                                          ? const Color(0xFF2563EB).withValues(alpha: 0.08)
                                          : const Color(0xFF002E6E).withValues(alpha: 0.02),
                                      blurRadius: 10,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 38,
                                      height: 38,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF3F37C9).withValues(alpha: 0.06),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      alignment: Alignment.center,
                                      child: const Icon(
                                        Icons.lock_outline_rounded,
                                        color: Color(0xFF3F37C9),
                                        size: 20,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: TextField(
                                        focusNode: _passwordFocusNode,
                                        controller: _passwordController,
                                        obscureText: !_isPasswordVisible,
                                        onChanged: (_) => setState(() {}),
                                        style: const TextStyle(
                                          fontFamily: 'Geist Sans',
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15.5,
                                          color: Color(0xFF0F172A),
                                        ),
                                        decoration: const InputDecoration(
                                          hintText: 'Enter your password',
                                          hintStyle: TextStyle(
                                            fontFamily: 'Geist Sans',
                                            fontWeight: FontWeight.normal,
                                            fontSize: 14.5,
                                            color: Color(0xFF94A3B8),
                                          ),
                                          border: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          disabledBorder: InputBorder.none,
                                          contentPadding: EdgeInsets.symmetric(vertical: 16),
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        _isPasswordVisible
                                            ? Icons.visibility_off_outlined
                                            : Icons.visibility_outlined,
                                        color: const Color(0xFF64748B),
                                        size: 20,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _isPasswordVisible = !_isPasswordVisible;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const Spacer(),
                        const SizedBox(height: 24),

                        // Login Button
                        FadeUpEntrance(
                          delay: const Duration(milliseconds: 300),
                          child: PremiumCTAButton(
                            text: 'Login',
                            isLoading: _isLoading,
                            onPressed: _canSubmit ? _handleLogin : null,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Forgot Password Link
                        FadeUpEntrance(
                          delay: const Duration(milliseconds: 350),
                          child: Center(
                            child: TextButton(
                              onPressed: _handleForgotPassword,
                              child: const Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  fontFamily: 'Geist Sans',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF2563EB),
                                ),
                              ),
                            ),
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
