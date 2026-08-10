import 'package:flutter/material.dart';
import 'package:payout/core/di/app_dependencies.dart';
import 'package:payout/features/auth/presentation/login_screen.dart';
import 'package:payout/features/auth/presentation/mpin_screen.dart';
import 'package:payout/features/auth/repositories/auth_repository.dart';
import 'package:payout/features/auth/validators/auth_validator.dart';

class CreatePasswordScreen extends StatefulWidget {
  final AuthRepository? authRepository;

  const CreatePasswordScreen({super.key, this.authRepository});

  @override
  State<CreatePasswordScreen> createState() => _CreatePasswordScreenState();
}

class _CreatePasswordScreenState extends State<CreatePasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();

  late final AuthRepository _authRepository;

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isPasswordFocused = false;
  bool _isConfirmPasswordFocused = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _authRepository = widget.authRepository ?? AppDependencies.instance.authRepository;

    _passwordFocusNode.addListener(() {
      setState(() {
        _isPasswordFocused = _passwordFocusNode.hasFocus;
      });
    });

    _confirmPasswordFocusNode.addListener(() {
      setState(() {
        _isConfirmPasswordFocused = _confirmPasswordFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  bool get _hasMinLength => AuthValidator.hasMinLength(_passwordController.text);
  bool get _hasUppercase => AuthValidator.hasUppercase(_passwordController.text);
  bool get _hasNumber => AuthValidator.hasNumber(_passwordController.text);

  bool get _isPasswordValid => _hasMinLength && _hasUppercase && _hasNumber;
  bool get _passwordsMatch =>
      _passwordController.text.isNotEmpty &&
      _passwordController.text == _confirmPasswordController.text;

  bool get _canSubmit => _isPasswordValid && _passwordsMatch && !_isLoading;

  Future<void> _handleContinue() async {
    if (!_canSubmit) return;

    setState(() {
      _isLoading = true;
    });

    // Simulate secure credential setup via auth architecture
    await Future.delayed(const Duration(milliseconds: 400));

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => MPINScreen(authRepository: _authRepository),
      ),
    );
  }

  Widget _buildRequirementItem(String text, bool isSatisfied) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        children: [
          Icon(
            isSatisfied ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
            color: isSatisfied ? const Color(0xFF059669) : const Color(0xFF94A3B8),
            size: 16,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontFamily: 'Geist Sans',
              fontSize: 12.5,
              fontWeight: isSatisfied ? FontWeight.w600 : FontWeight.normal,
              color: isSatisfied ? const Color(0xFF059669) : const Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final showMismatchError = _confirmPasswordController.text.isNotEmpty &&
        _passwordController.text != _confirmPasswordController.text;

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

                        // Header Title
                        FadeUpEntrance(
                          delay: const Duration(milliseconds: 100),
                          child: const Text(
                            'Create Password',
                            style: TextStyle(
                              fontFamily: 'Geist Sans',
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1F1F1F),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Subtitle
                        FadeUpEntrance(
                          delay: const Duration(milliseconds: 150),
                          child: Text(
                            'Create a strong password to secure your account.',
                            style: TextStyle(
                              fontFamily: 'Geist Sans',
                              fontSize: 14,
                              color: const Color(0xFF1F1F1F).withValues(alpha: 0.5),
                              height: 1.4,
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),

                        // 1. Password Field
                        FadeUpEntrance(
                          delay: const Duration(milliseconds: 200),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Password',
                                style: TextStyle(
                                  fontFamily: 'Geist Sans',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1F1F1F),
                                ),
                              ),
                              const SizedBox(height: 8),
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                height: 56,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: _isPasswordFocused
                                        ? const Color(0xFF00B9F1)
                                        : const Color(0xFFE2E8F0),
                                    width: _isPasswordFocused ? 1.5 : 1.0,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: _isPasswordFocused
                                          ? const Color(0xFF00B9F1).withValues(alpha: 0.06)
                                          : const Color(0xFF002E6E).withValues(alpha: 0.01),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    const SizedBox(width: 12),
                                    Icon(
                                      Icons.lock_outline_rounded,
                                      color: const Color(0xFF1F1F1F).withValues(alpha: 0.35),
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: TextField(
                                        focusNode: _passwordFocusNode,
                                        controller: _passwordController,
                                        obscureText: !_isPasswordVisible,
                                        onChanged: (_) => setState(() {}),
                                        style: const TextStyle(
                                          fontFamily: 'Geist Sans',
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                          color: Color(0xFF1F1F1F),
                                        ),
                                        decoration: InputDecoration(
                                          hintText: 'Enter your password',
                                          hintStyle: TextStyle(
                                            fontFamily: 'Geist Sans',
                                            fontWeight: FontWeight.normal,
                                            fontSize: 14,
                                            color: const Color(0xFF1F1F1F).withValues(alpha: 0.35),
                                          ),
                                          border: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          disabledBorder: InputBorder.none,
                                          contentPadding: const EdgeInsets.symmetric(vertical: 16),
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
                                    const SizedBox(width: 4),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Password Requirements Checklist
                        FadeUpEntrance(
                          delay: const Duration(milliseconds: 220),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFFE2E8F0)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Password must contain:',
                                  style: TextStyle(
                                    fontFamily: 'Geist Sans',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                _buildRequirementItem('8+ characters', _hasMinLength),
                                _buildRequirementItem('One uppercase letter', _hasUppercase),
                                _buildRequirementItem('One number', _hasNumber),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),

                        // 2. Confirm Password Field
                        FadeUpEntrance(
                          delay: const Duration(milliseconds: 250),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Confirm Password',
                                style: TextStyle(
                                  fontFamily: 'Geist Sans',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1F1F1F),
                                ),
                              ),
                              const SizedBox(height: 8),
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                height: 56,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: showMismatchError
                                        ? const Color(0xFFEF4444)
                                        : _isConfirmPasswordFocused
                                            ? const Color(0xFF00B9F1)
                                            : const Color(0xFFE2E8F0),
                                    width: (_isConfirmPasswordFocused || showMismatchError) ? 1.5 : 1.0,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: showMismatchError
                                          ? const Color(0xFFEF4444).withValues(alpha: 0.06)
                                          : _isConfirmPasswordFocused
                                              ? const Color(0xFF00B9F1).withValues(alpha: 0.06)
                                              : const Color(0xFF002E6E).withValues(alpha: 0.01),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    const SizedBox(width: 12),
                                    Icon(
                                      Icons.lock_outline_rounded,
                                      color: const Color(0xFF1F1F1F).withValues(alpha: 0.35),
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: TextField(
                                        focusNode: _confirmPasswordFocusNode,
                                        controller: _confirmPasswordController,
                                        obscureText: !_isConfirmPasswordVisible,
                                        onChanged: (_) => setState(() {}),
                                        style: const TextStyle(
                                          fontFamily: 'Geist Sans',
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                          color: Color(0xFF1F1F1F),
                                        ),
                                        decoration: InputDecoration(
                                          hintText: 'Re-enter your password',
                                          hintStyle: TextStyle(
                                            fontFamily: 'Geist Sans',
                                            fontWeight: FontWeight.normal,
                                            fontSize: 14,
                                            color: const Color(0xFF1F1F1F).withValues(alpha: 0.35),
                                          ),
                                          border: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          disabledBorder: InputBorder.none,
                                          contentPadding: const EdgeInsets.symmetric(vertical: 16),
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        _isConfirmPasswordVisible
                                            ? Icons.visibility_off_outlined
                                            : Icons.visibility_outlined,
                                        color: const Color(0xFF64748B),
                                        size: 20,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                                        });
                                      },
                                    ),
                                    const SizedBox(width: 4),
                                  ],
                                ),
                              ),
                              if (showMismatchError) ...[
                                const SizedBox(height: 6),
                                const Text(
                                  'Passwords do not match',
                                  style: TextStyle(
                                    fontFamily: 'Geist Sans',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFFEF4444),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),

                        const Spacer(),
                        const SizedBox(height: 24),

                        // Continue Button
                        FadeUpEntrance(
                          delay: const Duration(milliseconds: 300),
                          child: PremiumCTAButton(
                            text: 'Continue',
                            isLoading: _isLoading,
                            onPressed: _canSubmit ? _handleContinue : null,
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
