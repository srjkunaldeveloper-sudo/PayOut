import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/app_button.dart';
import 'package:payout/core/widgets/app_card.dart';
import 'package:payout/features/financial/loans/presentation/financial_success_screen.dart';
import 'package:payout/features/financial/shared/models/financial_models.dart';
import 'package:payout/features/financial/shared/repositories/financial_repository.dart';
import 'package:payout/features/financial/shared/services/financial_service.dart';

// 1. LOANS LANDING / CATEGORIES PAGE
class LoansScreen extends StatefulWidget {
  const LoansScreen({super.key});

  @override
  State<LoansScreen> createState() => _LoansScreenState();
}

class _LoansScreenState extends State<LoansScreen> {
  final FinancialRepository _financialRepository = MockFinancialRepository();
  List<LoanModel> _loans = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLoans();
  }

  Future<void> _loadLoans() async {
    final list = await _financialRepository.getLoans();
    if (mounted) {
      setState(() {
        _loans = list;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        appBar: CustomAppBar(title: 'Loans & Credit'),
        body: Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary))),
      );
    }

    final List<Map<String, dynamic>> loanUIMap = [
      {'category': 'Personal', 'desc': 'Instant credit for medical, travel or shopping', 'icon': Icons.person_rounded, 'color': AppColors.primary},
      {'category': 'Business', 'desc': 'Expand operations, buy inventory or hire staff', 'icon': Icons.business_center_rounded, 'color': Colors.indigo},
      {'category': 'Home', 'desc': 'Low interest rates for purchasing new houses', 'icon': Icons.home_rounded, 'color': Colors.orange},
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
            ..._loans.map((loan) {
              final ui = loanUIMap.firstWhere(
                (u) => u['category'] == loan.category,
                orElse: () => {'desc': 'Tailored financing alternatives', 'icon': Icons.credit_card_rounded, 'color': Colors.teal},
              );

              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.s16),
                child: AppCard(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoanEligibilityScreen(loan: loan),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.s12),
                        decoration: BoxDecoration(
                          color: (ui['color'] as Color).withOpacity(0.08),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(ui['icon'] as IconData, color: ui['color'] as Color, size: 24),
                      ),
                      const SizedBox(width: AppSpacing.s16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              loan.title,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              ui['desc'] as String,
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
  final LoanModel loan;

  const LoanEligibilityScreen({super.key, required this.loan});

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

        double limit = 500000.0;
        if (widget.loan.category == 'Business') {
          limit = 800000.0;
        } else if (widget.loan.category == 'Home') {
          limit = 2500000.0;
        }

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoanDetailsScreen(
              loan: widget.loan,
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
      appBar: CustomAppBar(title: '${widget.loan.category} Loan Eligibility'),
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
  final LoanModel loan;
  final double approvedLimit;
  final String name;

  const LoanDetailsScreen({
    super.key,
    required this.loan,
    required this.approvedLimit,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    final emi = FinancialService.calculateEMI(approvedLimit, loan.interestRate, loan.tenureMonths);

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
                        Text('${loan.interestRate.toStringAsFixed(1)}% p.a.', style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 13)),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.s12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Tenure', style: TextStyle(fontFamily: 'Inter', color: AppColors.textSecondary, fontSize: 13)),
                        Text('${loan.tenureMonths} Months', style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 13)),
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
                          loan: loan,
                          approvedLimit: approvedLimit,
                          name: name,
                          emi: emi,
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
  final LoanModel loan;
  final double approvedLimit;
  final String name;
  final double emi;

  const LoanReviewScreen({
    super.key,
    required this.loan,
    required this.approvedLimit,
    required this.name,
    required this.emi,
  });

  @override
  State<LoanReviewScreen> createState() => _LoanReviewScreenState();
}

class _LoanReviewScreenState extends State<LoanReviewScreen> {
  final FinancialRepository _financialRepository = MockFinancialRepository();
  bool _isProcessing = false;

  void _submitApplication() async {
    setState(() {
      _isProcessing = true;
    });

    final success = await _financialRepository.applyLoan(widget.loan.id, widget.approvedLimit);

    if (mounted) {
      setState(() {
        _isProcessing = false;
      });

      if (success) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => FinancialSuccessScreen(
              title: 'Application Submitted!',
              subtitle: 'Your loan application is under bank review.',
              referenceLabel: 'Application ID',
              details: '${widget.loan.title} • Approved: ₹${widget.approvedLimit.toStringAsFixed(0)} • EMI: ₹${widget.emi.toStringAsFixed(0)}/mo',
              amount: widget.approvedLimit,
            ),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );
      }
    }
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
                          widget.loan.title,
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
                        Text('${widget.loan.tenureMonths} Months', style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 12)),
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
