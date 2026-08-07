import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/app_button.dart';
import 'package:payout/core/widgets/app_card.dart';
import 'package:payout/features/loans/presentation/financial_success_screen.dart';

// 1. LOANS LANDING / CATEGORIES PAGE
class LoansScreen extends StatelessWidget {
  const LoansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> loanTypes = [
      {'name': 'Personal Loan', 'desc': 'Instant credit for medical, travel or shopping', 'icon': Icons.person_rounded, 'color': AppColors.primary},
      {'name': 'Business Loan', 'desc': 'Expand operations, buy inventory or hire staff', 'icon': Icons.business_center_rounded, 'color': Colors.indigo},
      {'name': 'Home Loan', 'desc': 'Low interest rates for purchasing new houses', 'icon': Icons.home_rounded, 'color': Colors.orange},
      {'name': 'Education Loan', 'desc': 'Support higher education at top institutes', 'icon': Icons.school_rounded, 'color': Colors.teal},
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Loans & Credit'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.s24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Intro Hero Card
            AppCard(
              color: AppColors.primary,
              borderRadius: AppRadii.cardHero,
              padding: const EdgeInsets.all(AppSpacing.s20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Instant Credit Limit',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Get approved for personal or business credit limits up to ₹10 Lakhs in under 5 minutes.',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12.0,
                      color: AppColors.primaryLight,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.s32),
            const Text(
              'Select Loan Category',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.s16),
            ...loanTypes.map((loan) {
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.s16),
                child: AppCard(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoanEligibilityScreen(
                          loanName: loan['name'] as String,
                        ),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.s12),
                        decoration: BoxDecoration(
                          color: (loan['color'] as Color).withOpacity(0.08),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(loan['icon'] as IconData, color: loan['color'] as Color, size: 24),
                      ),
                      const SizedBox(width: AppSpacing.s16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              loan['name'] as String,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              loan['desc'] as String,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 11.0,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right_rounded,
                        color: AppColors.textSecondary,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}

// 2. ELIGIBILITY SCREEN
class LoanEligibilityScreen extends StatefulWidget {
  final String loanName;

  const LoanEligibilityScreen({super.key, required this.loanName});

  @override
  State<LoanEligibilityScreen> createState() => _LoanEligibilityScreenState();
}

class _LoanEligibilityScreenState extends State<LoanEligibilityScreen> {
  final TextEditingController _nameController = TextEditingController(text: 'Alex Morgan');
  final TextEditingController _incomeController = TextEditingController(text: '75000');
  final TextEditingController _panController = TextEditingController(text: 'ABCDE1234F');
  bool _isChecking = false;

  void _checkEligibility() {
    setState(() {
      _isChecking = true;
    });

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _isChecking = false;
        });

        // Determine approved limit based on category
        double limit = 500000.0;
        if (widget.loanName == 'Business Loan') {
          limit = 800000.0;
        } else if (widget.loanName == 'Home Loan') {
          limit = 2500000.0;
        }

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoanDetailsScreen(
              loanName: widget.loanName,
              approvedLimit: limit,
              name: _nameController.text,
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: '${widget.loanName} Eligibility'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.s24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Enter Details for Credit Check',
                style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: AppSpacing.s16),
              AppCard(
                padding: const EdgeInsets.all(AppSpacing.s20),
                child: Column(
                  children: [
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Full Name (as on PAN)',
                        prefixIcon: Icon(Icons.person_rounded),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s16),
                    TextField(
                      controller: _incomeController,
                      decoration: const InputDecoration(
                        labelText: 'Monthly Take-home Salary (₹)',
                        prefixIcon: Icon(Icons.currency_rupee_rounded),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: AppSpacing.s16),
                    TextField(
                      controller: _panController,
                      decoration: const InputDecoration(
                        labelText: 'PAN Number',
                        prefixIcon: Icon(Icons.badge_rounded),
                      ),
                      textCapitalization: TextCapitalization.characters,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  text: 'Check Credit Eligibility',
                  isLoading: _isChecking,
                  onPressed: _isChecking ? null : _checkEligibility,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 3. LOAN DETAILS SCREEN
class LoanDetailsScreen extends StatelessWidget {
  final String loanName;
  final double approvedLimit;
  final String name;

  const LoanDetailsScreen({
    super.key,
    required this.loanName,
    required this.approvedLimit,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    // Math logic for EMI
    final rate = loanName == 'Home Loan' ? 0.085 : 0.115; // 8.5% or 11.5%
    final months = loanName == 'Home Loan' ? 120 : 36;
    final emi = (approvedLimit * rate / 12) * (1 / (1 - 1 / (1 + rate / 12))); // Simple approx EMI

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Approved Offer'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.s24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Congratulations!',
                style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.success),
              ),
              const SizedBox(height: AppSpacing.s8),
              const Text(
                'Based on your credit assessment, you are eligible for the following loan offer.',
                style: TextStyle(fontFamily: 'Inter', fontSize: 13, color: AppColors.textSecondary),
              ),
              const SizedBox(height: AppSpacing.s24),
              // Approved Limit Display
              AppCard(
                padding: const EdgeInsets.all(AppSpacing.s24),
                child: Column(
                  children: [
                    const Text(
                      'APPROVED CREDIT LIMIT',
                      style: TextStyle(fontFamily: 'Inter', fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '₹${approvedLimit.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 34.0,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.s24),
              // EMI Info Table
              AppCard(
                padding: const EdgeInsets.all(AppSpacing.s20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Monthly EMI', style: TextStyle(fontFamily: 'Inter', color: AppColors.textSecondary, fontSize: 13)),
                        Text('₹${emi.toStringAsFixed(0)}/month', style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 13)),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.s12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Interest Rate', style: TextStyle(fontFamily: 'Inter', color: AppColors.textSecondary, fontSize: 13)),
                        Text('${(rate * 100).toStringAsFixed(1)}% p.a.', style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 13)),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.s12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Tenure', style: TextStyle(fontFamily: 'Inter', color: AppColors.textSecondary, fontSize: 13)),
                        Text('$months Months', style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 13)),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  text: 'Proceed to Review',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoanReviewScreen(
                          loanName: loanName,
                          approvedLimit: approvedLimit,
                          name: name,
                          emi: emi,
                          tenure: months,
                          rate: rate,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 4. REVIEW SCREEN
class LoanReviewScreen extends StatefulWidget {
  final String loanName;
  final double approvedLimit;
  final String name;
  final double emi;
  final int tenure;
  final double rate;

  const LoanReviewScreen({
    super.key,
    required this.loanName,
    required this.approvedLimit,
    required this.name,
    required this.emi,
    required this.tenure,
    required this.rate,
  });

  @override
  State<LoanReviewScreen> createState() => _LoanReviewScreenState();
}

class _LoanReviewScreenState extends State<LoanReviewScreen> {
  bool _isProcessing = false;

  void _submitApplication() {
    setState(() {
      _isProcessing = true;
    });

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => FinancialSuccessScreen(
              title: 'Application Submitted!',
              subtitle: 'Your loan application is under bank review.',
              referenceLabel: 'Application ID',
              details: '${widget.loanName} • Approved: ₹${widget.approvedLimit.toStringAsFixed(0)} • EMI: ₹${widget.emi.toStringAsFixed(0)}/mo',
              amount: widget.approvedLimit,
            ),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Review Application'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.s24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Review Details',
                style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: AppSpacing.s12),
              AppCard(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.loanName,
                          style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '₹${widget.approvedLimit.toStringAsFixed(0)}',
                          style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, color: AppColors.primary),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.s12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Applicant', style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.textSecondary)),
                        Text(widget.name, style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.s8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Monthly EMI', style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.textSecondary)),
                        Text('₹${widget.emi.toStringAsFixed(0)}/month', style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.s8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Tenure Plan', style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.textSecondary)),
                        Text('${widget.tenure} Months', style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  text: 'Submit Loan Application',
                  isLoading: _isProcessing,
                  onPressed: _isProcessing ? null : _submitApplication,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
