import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_button.dart';
import 'package:payout/features/auth/presentation/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _slides = [
    {
      'icon': Icons.account_balance_wallet_rounded,
      'title': 'Minimalist Wallet',
      'description': 'Store, manage, and monitor your cash balance inside an ultra-clean digital ledger.',
    },
    {
      'icon': Icons.swap_horiz_rounded,
      'title': 'Instant Transfers',
      'description': 'Send funds directly to contacts, local banks, or self-accounts with Stripe-like speed.',
    },
    {
      'icon': Icons.workspace_premium_rounded,
      'title': 'Premium Rewards',
      'description': 'Earn cashback, claim coupons, and earn reward points on every transaction.',
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.s16),
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                    );
                  },
                  child: const Text(
                    'Skip',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _slides.length,
                itemBuilder: (context, index) {
                  final slide = _slides[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.s32),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.divider, width: 1.0),
                          ),
                          child: Icon(
                            slide['icon'],
                            size: 64,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.s40),
                        Text(
                          slide['title'],
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: AppSpacing.s16),
                        Text(
                          slide['description'],
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppColors.textSecondary,
                                fontSize: 15.0,
                                height: 1.5,
                              ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s32, vertical: AppSpacing.s24),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _slides.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.symmetric(horizontal: 4.0),
                        height: 6.0,
                        width: _currentPage == index ? 24.0 : 6.0,
                        decoration: BoxDecoration(
                          color: _currentPage == index ? AppColors.primary : AppColors.divider,
                          borderRadius: BorderRadius.circular(3.0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s32),
                  SizedBox(
                    width: double.infinity,
                    child: AppButton(
                      text: _currentPage == _slides.length - 1 ? 'Get Started' : 'Next',
                      onPressed: () {
                        if (_currentPage < _slides.length - 1) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeIn,
                          );
                        } else {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => const LoginScreen()),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
