import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/app_button.dart';
import 'package:payout/core/widgets/app_card.dart';

class BillsScreen extends StatefulWidget {
  const BillsScreen({super.key});

  @override
  State<BillsScreen> createState() => _BillsScreenState();
}

class _BillsScreenState extends State<BillsScreen> {
  final List<Map<String, dynamic>> _categories = [
    {'name': 'Electricity', 'icon': Icons.lightbulb_rounded, 'color': AppColors.warning},
    {'name': 'Water Bills', 'icon': Icons.water_drop_rounded, 'color': AppColors.primary},
    {'name': 'Piped Gas', 'icon': Icons.local_fire_department_rounded, 'color': AppColors.error},
    {'name': 'Broadband', 'icon': Icons.wifi_rounded, 'color': AppColors.success},
    {'name': 'DTH Cable', 'icon': Icons.tv_rounded, 'color': Colors.purple},
    {'name': 'Credit Card', 'icon': Icons.credit_card_rounded, 'color': AppColors.textPrimary},
  ];

  final List<Map<String, dynamic>> _dueBills = [
    {'provider': 'PowerGrid Corp', 'type': 'Electricity', 'due': 'Aug 15, 2026', 'amount': 84.60},
    {'provider': 'Aqua Aqua water', 'type': 'Water Bills', 'due': 'Aug 20, 2026', 'amount': 22.00},
  ];

  void _payBill(String provider, double amount) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadii.bottomSheet)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(AppSpacing.s24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Confirm bill payment',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 20.0),
              ),
              const SizedBox(height: AppSpacing.s16),
              AppCard(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          provider,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Payment processed via Wallet',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '\$${amount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.s24),
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  text: 'Pay Now',
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Payment of \$${amount.toStringAsFixed(2)} to $provider successful.'),
                        backgroundColor: AppColors.success,
                      ),
                    );
                    setState(() {
                      _dueBills.removeWhere((bill) => bill['provider'] == provider);
                    });
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.s16),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Pay Bills'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.s24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Due bills section
            if (_dueBills.isNotEmpty) ...[
              const Text(
                'Due Bills',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.s12),
              ..._dueBills.map((bill) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.s12),
                  child: AppCard(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              bill['provider'],
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0,
                              ),
                            ),
                            Text(
                              'Due by ${bill['due']}',
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12.0,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              '\$${bill['amount'].toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                                color: AppColors.error,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.s12),
                            TextButton(
                              onPressed: () => _payBill(bill['provider'], bill['amount']),
                              style: TextButton.styleFrom(
                                backgroundColor: AppColors.primaryLight,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Pay',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
              const SizedBox(height: AppSpacing.s24),
            ],
            const Text(
              'Select Bill Utility',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.s16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _categories.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.9,
              ),
              itemBuilder: (context, index) {
                final cat = _categories[index];
                return AppCard(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  onTap: () {
                    // Navigate / search provider
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Opening providers for ${cat['name']}.'),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(cat['icon'], color: cat['color'], size: 28),
                      const SizedBox(height: AppSpacing.s8),
                      Text(
                        cat['name'],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12.0,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: AppSpacing.s40),
          ],
        ),
      ),
    );
  }
}
