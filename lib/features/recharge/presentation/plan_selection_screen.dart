import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/app_card.dart';
import 'package:payout/features/recharge/presentation/review_recharge_screen.dart';

class PlanSelectionScreen extends StatelessWidget {
  final String mobileNumber;
  final String operatorName;

  const PlanSelectionScreen({
    super.key,
    required this.mobileNumber,
    required this.operatorName,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> plans = [
      {
        'price': 15.00,
        'desc': 'Talk & Text + 2GB High Speed Data. 30 Days.',
        'tag': 'Best Value'
      },
      {
        'price': 35.00,
        'desc': 'Unlimited Talk, Text & 15GB Data + Hotspot. 30 Days.',
        'tag': 'Recommended'
      },
      {
        'price': 55.00,
        'desc': 'Premium Unlimited Data + 50GB Hotspot + Roaming. 30 Days.',
        'tag': 'Super Saver'
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Select Plan'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.s24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Selected Details Card
            AppCard(
              padding: const EdgeInsets.all(AppSpacing.s16),
              child: Row(
                children: [
                  const Icon(Icons.phone_android_rounded, color: AppColors.primary),
                  const SizedBox(width: AppSpacing.s12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        mobileNumber,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        operatorName,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.s32),
            const Text(
              'Recommended Plans',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.s16),
            ...plans.map((plan) {
              final double price = plan['price'];
              final String desc = plan['desc'];
              final String tag = plan['tag'];

              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.s16),
                child: AppCard(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReviewRechargeScreen(
                          mobileNumber: mobileNumber,
                          operatorName: operatorName,
                          amount: price,
                          planDesc: desc,
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
                            '\$${price.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primaryLight,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              tag,
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
                      const SizedBox(height: AppSpacing.s12),
                      Text(
                        desc,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13.0,
                          color: AppColors.textSecondary,
                          height: 1.4,
                        ),
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
