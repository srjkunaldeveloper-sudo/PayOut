import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/app_button.dart';
import 'package:payout/core/widgets/app_card.dart';

class InsuranceScreen extends StatelessWidget {
  const InsuranceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> products = [
      {
        'title': 'Premium Health Secure',
        'desc': 'Complete health protection with up to \$1M coverage limit.',
        'tag': 'Best Seller',
        'price': '\$28/mo',
        'icon': Icons.favorite_rounded,
        'color': AppColors.error,
      },
      {
        'title': 'Auto Platinum Guard',
        'desc': 'Zero-deductible roadside assistance and comprehensive theft guard.',
        'tag': 'Premium',
        'price': '\$42/mo',
        'icon': Icons.directions_car_rounded,
        'color': AppColors.primary,
      },
      {
        'title': 'Life Wealth shield',
        'desc': 'Secure your family\'s financial future with guaranteed payouts.',
        'tag': 'Critical',
        'price': '\$19/mo',
        'icon': Icons.family_restroom_rounded,
        'color': AppColors.success,
      },
    ];

    void _purchaseInsurance(String title, String price) {
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
                  'Review Coverage Plan',
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
                            title,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Instantly active after payment',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        price,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.s24),
                SizedBox(
                  width: double.infinity,
                  child: AppButton(
                    text: 'Confirm & Purchase',
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Subscribed to $title successfully.'),
                          backgroundColor: AppColors.success,
                        ),
                      );
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

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Insurance Plans'),
      body: ListView.builder(
        padding: const EdgeInsets.all(AppSpacing.s24),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final prod = products[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.s16),
            child: AppCard(
              onTap: () => _purchaseInsurance(prod['title'], prod['price']),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.s10),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.divider, width: 1.0),
                        ),
                        child: Icon(prod['icon'], color: prod['color'], size: 24),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          prod['tag'],
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 10.0,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.s16),
                  Text(
                    prod['title'],
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s4),
                  Text(
                    prod['desc'],
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12.0,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s16),
                  const Divider(color: AppColors.divider),
                  const SizedBox(height: AppSpacing.s8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Starting from',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12.0,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        prod['price'],
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
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
