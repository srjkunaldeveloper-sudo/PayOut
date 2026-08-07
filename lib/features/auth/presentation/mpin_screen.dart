import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/features/dashboard/presentation/dashboard_shell.dart';

class MPINScreen extends StatefulWidget {
  const MPINScreen({super.key});

  @override
  State<MPINScreen> createState() => _MPINScreenState();
}

class _MPINScreenState extends State<MPINScreen> {
  String _pin = '';

  void _onKeyPress(String val) {
    if (_pin.length < 4) {
      setState(() {
        _pin += val;
      });
      if (_pin.length == 4) {
        // Auto-navigate to home dashboard
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const DashboardShell()),
              (route) => false,
            );
          }
        });
      }
    }
  }

  void _onBackspace() {
    if (_pin.isNotEmpty) {
      setState(() {
        _pin = _pin.substring(0, _pin.length - 1);
      });
    }
  }

  Widget _buildKey(String value) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(AppSpacing.s8),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _onKeyPress(value),
            borderRadius: BorderRadius.circular(16.0),
            child: Container(
              height: 60,
              alignment: Alignment.center,
              child: Text(
                value,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 24.0,
                  fontWeight: FontWeight.w600,
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
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: AppSpacing.s16),
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Icon(
                    Icons.fingerprint_rounded,
                    color: AppColors.primary,
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.s24),
              Text(
                'Set security MPIN',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontSize: 26.0,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: AppSpacing.s8),
              const Text(
                'Create a 4-digit PIN for quick and secure logins.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14.0,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.s40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (index) {
                  final isFilled = index < _pin.length;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    margin: const EdgeInsets.symmetric(horizontal: AppSpacing.s12),
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
              const Spacer(),
              // Custom Numeric Keypad
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
                          margin: const EdgeInsets.all(AppSpacing.s8),
                          child: InkWell(
                            onTap: _onBackspace,
                            borderRadius: BorderRadius.circular(16.0),
                            child: Container(
                              height: 60,
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
