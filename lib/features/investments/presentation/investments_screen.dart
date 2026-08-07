import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/app_button.dart';
import 'package:payout/core/widgets/app_card.dart';
import 'package:payout/features/loans/presentation/financial_success_screen.dart';

// 1. INVESTMENTS LANDING / CATEGORIES PAGE
class InvestmentsScreen extends StatelessWidget {
  const InvestmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> categories = [
      {'name': 'Mutual Funds', 'desc': 'Grow wealth by investing in equities, debt or hybrid indexes', 'icon': Icons.trending_up_rounded, 'color': AppColors.primary},
      {'name': 'Monthly SIP', 'desc': 'Start systematic investment plans with just ₹100/mo', 'icon': Icons.calendar_month_rounded, 'color': AppColors.success},
      {'name': 'Digital Gold', 'desc': 'Buy & sell 24K 99.9% pure digital gold at real-time rates', 'icon': Icons.workspace_premium_rounded, 'color': Colors.amber},
      {'name': 'Fixed Deposit', 'desc': 'Get guaranteed high-returns up to 7.8% interest rates', 'icon': Icons.lock_rounded, 'color': Colors.orange},
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
                children: const [
                  Text(
                    'Invest in your future',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Unlock inflation-beating returns. Start a SIP, buy pure digital gold, or lock in high-yield FDs.',
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
              'Investment Categories',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.s16),
            ...categories.map((cat) {
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.s16),
                child: AppCard(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FundDetailsScreen(
                          categoryName: cat['name'] as String,
                        ),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.s12),
                        decoration: BoxDecoration(
                          color: (cat['color'] as Color).withOpacity(0.08),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(cat['icon'] as IconData, color: cat['color'] as Color, size: 24),
                      ),
                      const SizedBox(width: AppSpacing.s16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cat['name'] as String,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              cat['desc'] as String,
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

// 2. FUND DETAILS SCREEN
class FundDetailsScreen extends StatelessWidget {
  final String categoryName;

  const FundDetailsScreen({super.key, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    // Localized mutual funds & investment assets
    final List<Map<String, dynamic>> funds = [
      {'name': 'HDFC Index Nifty 50 Fund', 'returns': '24.5%', 'rating': '5 ★', 'minInv': 500.0, 'risk': 'High Risk'},
      {'name': 'Parag Parikh Flexi Cap Fund', 'returns': '26.2%', 'rating': '5 ★', 'minInv': 1000.0, 'risk': 'High Risk'},
      {'name': 'SBI Bluechip Direct Fund', 'returns': '21.0%', 'rating': '4 ★', 'minInv': 500.0, 'risk': 'Moderately High'},
      {'name': 'ICICI Prudential Liquid Fund', 'returns': '7.2%', 'rating': '4 ★', 'minInv': 100.0, 'risk': 'Low Risk'},
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: categoryName),
      body: ListView.builder(
        padding: const EdgeInsets.all(AppSpacing.s24),
        itemCount: funds.length,
        itemBuilder: (context, index) {
          final fund = funds[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.s16),
            child: AppCard(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InvestmentSummaryScreen(
                      categoryName: categoryName,
                      fundName: fund['name'] as String,
                      minInv: fund['minInv'] as double,
                      returns: fund['returns'] as String,
                    ),
                  ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          fund['name'],
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.s8),
                      Text(
                        fund['returns'],
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                          color: AppColors.success,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Min Investment: ₹${(fund['minInv'] as double).toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12.0,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        '${fund['risk']} • ${fund['rating']}',
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12.0,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// 3. INVESTMENT SUMMARY SCREEN
class InvestmentSummaryScreen extends StatefulWidget {
  final String categoryName;
  final String fundName;
  final double minInv;
  final String returns;

  const InvestmentSummaryScreen({
    super.key,
    required this.categoryName,
    required this.fundName,
    required this.minInv,
    required this.returns,
  });

  @override
  State<InvestmentSummaryScreen> createState() => _InvestmentSummaryScreenState();
}

class _InvestmentSummaryScreenState extends State<InvestmentSummaryScreen> {
  bool _isProcessing = false;
  final TextEditingController _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _amountController.text = widget.minInv.toStringAsFixed(0);
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _payInvestment() {
    final double amount = double.tryParse(_amountController.text) ?? widget.minInv;
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
              title: 'Investment Successful!',
              subtitle: 'Your units will be allocated shortly.',
              referenceLabel: 'Folio Number',
              details: '${widget.categoryName} • ${widget.fundName} • 3Y Return: ${widget.returns}',
              amount: amount,
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
                            widget.fundName,
                            style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.s8),
                        Text(
                          widget.returns,
                          style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, color: AppColors.success),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.s12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Asset Class', style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.textSecondary)),
                        Text(widget.categoryName, style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.s8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Min SIP Requirement', style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.textSecondary)),
                        Text('₹${widget.minInv.toStringAsFixed(0)}', style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 12)),
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
