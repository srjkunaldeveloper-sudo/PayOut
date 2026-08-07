import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/app_button.dart';
import 'package:payout/core/widgets/app_card.dart';
import 'package:payout/features/financial/loans/presentation/financial_success_screen.dart';
import 'package:payout/features/financial/shared/models/financial_models.dart';
import 'package:payout/features/financial/shared/repositories/financial_repository.dart';

// 1. INSURANCE LANDING / CATEGORIES PAGE
class InsuranceScreen extends StatefulWidget {
  const InsuranceScreen({super.key});

  @override
  State<InsuranceScreen> createState() => _InsuranceScreenState();
}

class _InsuranceScreenState extends State<InsuranceScreen> {
  final FinancialRepository _financialRepository = MockFinancialRepository();
  List<InsurancePolicyModel> _policies = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPolicies();
  }

  Future<void> _loadPolicies() async {
    final list = await _financialRepository.getPolicies();
    if (mounted) {
      setState(() {
        _policies = list;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        appBar: CustomAppBar(title: 'Insurance Hub'),
        body: Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary))),
      );
    }

    final List<Map<String, dynamic>> categoryUIMap = [
      {'type': 'Health', 'desc': 'Cashless hospitalization at 10,000+ network hospitals', 'icon': Icons.medical_services_rounded, 'color': Colors.red},
      {'type': 'Life', 'desc': 'Protect your family\'s financial future with term covers', 'icon': Icons.favorite_rounded, 'color': Colors.pink},
      {'type': 'Motor', 'desc': 'Instant third party & comprehensive car/bike cover', 'icon': Icons.directions_car_rounded, 'color': Colors.blue},
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Insurance Hub'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.s24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Promos Banner
            AppCard(
              color: AppColors.surface,
              padding: const EdgeInsets.all(AppSpacing.s20),
              child: Row(
                children: [
                  const Icon(Icons.security_rounded, color: AppColors.primary, size: 36),
                  const SizedBox(width: AppSpacing.s16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Complete Protection Plans',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Term covers starting at just ₹499/year. Fast checkouts, zero paperwork.',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 11.0,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.s32),
            const Text(
              'Insurance Categories',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.s16),
            ..._policies.map((policy) {
              final ui = categoryUIMap.firstWhere(
                (c) => c['type'] == policy.type,
                orElse: () => {'desc': 'Protect what matters most to you', 'icon': Icons.shield_rounded, 'color': Colors.teal},
              );

              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.s16),
                child: AppCard(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InsurancePremiumSummaryScreen(policy: policy),
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
                              policy.name,
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

// 2. PREMIUM SUMMARY SCREEN
class InsurancePremiumSummaryScreen extends StatefulWidget {
  final InsurancePolicyModel policy;

  const InsurancePremiumSummaryScreen({
    super.key,
    required this.policy,
  });

  @override
  State<InsurancePremiumSummaryScreen> createState() => _InsurancePremiumSummaryScreenState();
}

class _InsurancePremiumSummaryScreenState extends State<InsurancePremiumSummaryScreen> {
  final FinancialRepository _financialRepository = MockFinancialRepository();
  bool _isProcessing = false;

  void _payPremium() async {
    setState(() {
      _isProcessing = true;
    });

    final success = await _financialRepository.buyPolicy(widget.policy.id);

    if (mounted) {
      setState(() {
        _isProcessing = false;
      });

      if (success) {
        final gst = widget.policy.premium * 0.18;
        final total = widget.policy.premium + gst;

        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => FinancialSuccessScreen(
              title: 'Policy Issued!',
              subtitle: 'Your insurance cover is active instantly.',
              referenceLabel: 'Policy Number',
              details: '${widget.policy.name} • Cover: ₹${widget.policy.coverage.toStringAsFixed(0)}',
              amount: total,
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
    final gst = widget.policy.premium * 0.18;
    final total = widget.policy.premium + gst;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Premium Summary'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.s24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Verify Premium Details',
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
                          widget.policy.name,
                          style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '₹${total.toStringAsFixed(0)}',
                          style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, color: AppColors.primary),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.s12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Base Premium', style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.textSecondary)),
                        Text('₹${widget.policy.premium.toStringAsFixed(0)}', style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.s8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('GST (18%)', style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.textSecondary)),
                        Text('₹${gst.toStringAsFixed(0)}', style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.s8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Cover Plan', style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.textSecondary)),
                        Text('₹${widget.policy.coverage.toStringAsFixed(0)}', style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  text: 'Pay Premium ₹${total.toStringAsFixed(0)}',
                  isLoading: _isProcessing,
                  onPressed: _isProcessing ? null : _payPremium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
