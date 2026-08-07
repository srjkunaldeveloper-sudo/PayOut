import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/app_button.dart';
import 'package:payout/core/widgets/app_card.dart';
import 'package:payout/features/loans/presentation/loan_success_screen.dart';

class LoansScreen extends StatefulWidget {
  const LoansScreen({super.key});

  @override
  State<LoansScreen> createState() => _LoansScreenState();
}

class _LoansScreenState extends State<LoansScreen> {
  String? _selectedCategory = 'Personal Loan';
  bool _eligibilityChecked = false;
  bool _isChecking = false;

  final List<Map<String, dynamic>> _loanCategories = [
    {'name': 'Personal Loan', 'icon': Icons.person_rounded, 'limit': '\$50,000'},
    {'name': 'Business Loan', 'icon': Icons.business_center_rounded, 'limit': '\$250,000'},
    {'name': 'Home Loan', 'icon': Icons.home_rounded, 'limit': '\$500,000'},
    {'name': 'Student Loan', 'icon': Icons.school_rounded, 'limit': '\$35,000'},
  ];

  void _checkEligibility() {
    setState(() {
      _isChecking = true;
    });
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _isChecking = false;
          _eligibilityChecked = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Loans & Credit'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.s24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Loan Category',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.s12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _loanCategories.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.3,
              ),
              itemBuilder: (context, index) {
                final cat = _loanCategories[index];
                final isSel = _selectedCategory == cat['name'];
                return AppCard(
                  onTap: () {
                    setState(() {
                      _selectedCategory = cat['name'];
                      _eligibilityChecked = false; // Reset eligibility check
                    });
                  },
                  color: isSel ? AppColors.primaryLight.withOpacity(0.3) : AppColors.surface,
                  border: Border.all(
                    color: isSel ? AppColors.primary : AppColors.divider,
                    width: isSel ? 1.5 : 1.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(cat['icon'], color: isSel ? AppColors.primary : AppColors.textSecondary, size: 24),
                      const SizedBox(height: AppSpacing.s12),
                      Text(
                        cat['name'],
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        'Up to ${cat['limit']}',
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 11.0,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: AppSpacing.s32),
            const Text(
              'Loan Eligibility Checker',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.s12),
            AppCard(
              padding: const EdgeInsets.all(AppSpacing.s20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Estimate your credit availability instantly.',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13.0,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s20),
                  if (!_eligibilityChecked) ...[
                    SizedBox(
                      width: double.infinity,
                      child: AppButton(
                        text: _isChecking ? 'Calculating...' : 'Check My Eligibility',
                        onPressed: _isChecking ? null : _checkEligibility,
                      ),
                    ),
                  ] else ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Approved Limit',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12.0,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            Text(
                              _selectedCategory == 'Personal Loan'
                                  ? '\$25,000.00'
                                  : _selectedCategory == 'Business Loan'
                                      ? '\$120,000.00'
                                      : _selectedCategory == 'Home Loan'
                                          ? '\$300,000.00'
                                          : '\$15,000.00',
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                                color: AppColors.success,
                              ),
                            ),
                          ],
                        ),
                        const Icon(Icons.verified_user_rounded, color: AppColors.success, size: 36),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.s20),
                    SizedBox(
                      width: double.infinity,
                      child: AppButton(
                        text: 'Apply for Loan',
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoanSuccessScreen(
                                category: _selectedCategory!,
                                amount: _selectedCategory == 'Personal Loan'
                                    ? '\$25,000'
                                    : _selectedCategory == 'Business Loan'
                                        ? '\$120,000'
                                        : _selectedCategory == 'Home Loan'
                                            ? '\$300,000'
                                            : '\$15,000',
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.s40),
          ],
        ),
      ),
    );
  }
}
