import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/app_button.dart';
import 'package:payout/core/widgets/app_card.dart';
import 'package:payout/features/financial/loans/presentation/financial_success_screen.dart';
import 'package:payout/features/financial/shared/models/financial_models.dart';
import 'package:payout/features/financial/shared/repositories/financial_repository.dart';

// 1. INVESTMENTS LANDING / CATEGORIES PAGE
class InvestmentsScreen extends StatefulWidget {
  const InvestmentsScreen({super.key});

  @override
  State<InvestmentsScreen> createState() => _InvestmentsScreenState();
}

class _InvestmentsScreenState extends State<InvestmentsScreen> {
  final FinancialRepository _financialRepository = MockFinancialRepository();
  List<InvestmentModel> _investments = [];
  PortfolioModel? _portfolio;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInvestments();
  }

  Future<void> _loadInvestments() async {
    final invList = await _financialRepository.getInvestments();
    final port = await _financialRepository.getPortfolio();
    if (mounted) {
      setState(() {
        _investments = invList;
        _portfolio = port;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        appBar: CustomAppBar(title: 'Investments'),
        body: Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary))),
      );
    }

    final List<Map<String, dynamic>> typeUIMap = [
      {'type': 'Mutual Fund', 'desc': 'Grow wealth by investing in equities, debt or hybrid indexes', 'icon': Icons.trending_up_rounded, 'color': AppColors.primary},
      {'type': 'Gold Fund', 'desc': 'Buy & sell 24K 99.9% pure digital gold at real-time rates', 'icon': Icons.workspace_premium_rounded, 'color': Colors.amber},
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Investments'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.s24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Intro Banner
            AppCard(
              color: AppColors.primary,
              borderRadius: AppRadii.cardHero,
              padding: const EdgeInsets.all(AppSpacing.s20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Invest in your future',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Portfolio Value: ₹${_portfolio?.totalValue.toStringAsFixed(0)} (Returns: +${_portfolio?.returnPercentage}%)',
                    style: const TextStyle(
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
              'Investment Options',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.s16),
            ..._investments.map((inv) {
              final ui = typeUIMap.firstWhere(
                (t) => t['type'] == inv.type,
                orElse: () => {'desc': 'Systematic wealth growth plan', 'icon': Icons.savings_rounded, 'color': Colors.orange},
              );

              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.s16),
                child: AppCard(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InvestmentSummaryScreen(investment: inv),
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
                              inv.fundName,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '3Y returns: +${inv.returnPercentage}% p.a.',
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

// 3. INVESTMENT SUMMARY SCREEN
class InvestmentSummaryScreen extends StatefulWidget {
  final InvestmentModel investment;

  const InvestmentSummaryScreen({
    super.key,
    required this.investment,
  });

  @override
  State<InvestmentSummaryScreen> createState() => _InvestmentSummaryScreenState();
}

class _InvestmentSummaryScreenState extends State<InvestmentSummaryScreen> {
  final FinancialRepository _financialRepository = MockFinancialRepository();
  bool _isProcessing = false;
  final TextEditingController _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _amountController.text = '500';
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _payInvestment() async {
    final double amount = double.tryParse(_amountController.text) ?? 500.0;
    setState(() {
      _isProcessing = true;
    });

    final success = await _financialRepository.investFund(widget.investment.id, amount);

    if (mounted) {
      setState(() {
        _isProcessing = false;
      });

      if (success) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => FinancialSuccessScreen(
              title: 'Investment Successful!',
              subtitle: 'Your units will be allocated shortly.',
              referenceLabel: 'Folio Number',
              details: '${widget.investment.fundName} • NAV: ₹${widget.investment.nav} • return: ${widget.investment.returnPercentage}%',
              amount: amount,
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
      appBar: const CustomAppBar(title: 'Verify Investment'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.s24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Enter Investment Amount',
                style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: AppSpacing.s12),
              // Amount entry
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
                decoration: const InputDecoration(
                  prefixText: '₹ ',
                ),
              ),
              const SizedBox(height: AppSpacing.s24),
              const Text(
                'Asset Summary',
                style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: AppSpacing.s12),
              AppCard(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            widget.investment.fundName,
                            style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.s8),
                        Text(
                          '+${widget.investment.returnPercentage}%',
                          style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, color: AppColors.success),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.s12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Asset Class', style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.textSecondary)),
                        Text(widget.investment.type, style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.s8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Current NAV', style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.textSecondary)),
                        Text('₹${widget.investment.nav.toStringAsFixed(2)}', style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  text: 'Invest Now',
                  isLoading: _isProcessing,
                  onPressed: _isProcessing ? null : _payInvestment,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
