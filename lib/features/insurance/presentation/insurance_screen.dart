import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/app_button.dart';
import 'package:payout/core/widgets/app_card.dart';
import 'package:payout/features/loans/presentation/financial_success_screen.dart';

// 1. INSURANCE LANDING / CATEGORIES PAGE
class InsuranceScreen extends StatelessWidget {
  const InsuranceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> categories = [
      {'name': 'Health Insurance', 'desc': 'Cashless hospitalization at 10,000+ network hospitals', 'icon': Icons.medical_services_rounded, 'color': Colors.red},
      {'name': 'Life Insurance', 'desc': 'Protect your family\'s financial future with term covers', 'icon': Icons.favorite_rounded, 'color': Colors.pink},
      {'name': 'Motor Insurance', 'desc': 'Instant third party & comprehensive car/bike cover', 'icon': Icons.directions_car_rounded, 'color': Colors.blue},
      {'name': 'Travel Insurance', 'desc': 'Cover flight delays, medical emergency & baggage loss', 'icon': Icons.flight_takeoff_rounded, 'color': Colors.teal},
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
            ...categories.map((cat) {
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.s16),
                child: AppCard(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InsurancePolicyDetailsScreen(
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

// 2. POLICY DETAILS SCREEN
class InsurancePolicyDetailsScreen extends StatelessWidget {
  final String categoryName;

  const InsurancePolicyDetailsScreen({super.key, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    // Localized insurance provider offers
    final List<Map<String, dynamic>> offers = [
      {'provider': 'HDFC Ergo Protection', 'sumInsured': 500000.0, 'basePremium': 3500.0, 'coverDesc': 'Cashless ICU, Daycare treatments & organ donor cover'},
      {'provider': 'ICICI Lombard Guard', 'sumInsured': 1000000.0, 'basePremium': 5800.0, 'coverDesc': 'No room rent limit, COVID-19 cover & free health checkup'},
      {'provider': 'TATA AIG Active Health', 'sumInsured': 500000.0, 'basePremium': 3200.0, 'coverDesc': 'Restore benefits, AYUSH treatment & maternity cover'},
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: categoryName),
      body: ListView.builder(
        padding: const EdgeInsets.all(AppSpacing.s24),
        itemCount: offers.length,
        itemBuilder: (context, index) {
          final policy = offers[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.s16),
            child: AppCard(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InsurancePremiumSummaryScreen(
                      categoryName: categoryName,
                      providerName: policy['provider'] as String,
                      sumInsured: policy['sumInsured'] as double,
                      basePremium: policy['basePremium'] as double,
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
                      Text(
                        policy['provider'],
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                        ),
                      ),
                      Text(
                        '₹${(policy['basePremium'] as double).toStringAsFixed(0)}/yr',
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Sum Insured: ₹${(policy['sumInsured'] as double).toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12.0,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    policy['coverDesc'],
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12.0,
                      color: AppColors.textSecondary,
                    ),
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

// 3. PREMIUM SUMMARY SCREEN
class InsurancePremiumSummaryScreen extends StatefulWidget {
  final String categoryName;
  final String providerName;
  final double sumInsured;
  final double basePremium;

  const InsurancePremiumSummaryScreen({
    super.key,
    required this.categoryName,
    required this.providerName,
    required this.sumInsured,
    required this.basePremium,
  });

  @override
  State<InsurancePremiumSummaryScreen> createState() => _InsurancePremiumSummaryScreenState();
}

class _InsurancePremiumSummaryScreenState extends State<InsurancePremiumSummaryScreen> {
  bool _isProcessing = false;

  void _payPremium() {
    setState(() {
      _isProcessing = true;
    });

    final gst = widget.basePremium * 0.18;
    final total = widget.basePremium + gst;

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => FinancialSuccessScreen(
              title: 'Policy Issued!',
              subtitle: 'Your insurance cover is active instantly.',
              referenceLabel: 'Policy Number',
              details: '${widget.categoryName} • ${widget.providerName} • Cover: ₹${widget.sumInsured.toStringAsFixed(0)}',
              amount: total,
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
    final gst = widget.basePremium * 0.18;
    final total = widget.basePremium + gst;

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
                          widget.providerName,
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
                        Text('₹${widget.basePremium.toStringAsFixed(0)}', style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 12)),
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
                        Text('₹${widget.sumInsured.toStringAsFixed(0)}', style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 12)),
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
