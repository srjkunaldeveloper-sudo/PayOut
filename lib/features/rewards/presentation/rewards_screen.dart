import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/app_card.dart';

class RewardsScreen extends StatelessWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> coupons = [
      {'store': 'Amazon Perks', 'code': 'AMZN25', 'desc': 'Get 25% cashback on purchases.', 'expiry': 'Expires Aug 31'},
      {'store': 'Starbucks Cafe', 'code': 'COFFEEFREE', 'desc': 'Buy 1 Get 1 Free Espresso drink.', 'expiry': 'Expires Aug 25'},
      {'store': 'Uber Rides', 'code': 'UBERRIDE10', 'desc': '\$10 discount on next 3 rides.', 'expiry': 'Expires Sep 10'},
    ];

    void _copyCode(String code) {
      Clipboard.setData(ClipboardData(text: code));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Promo Code "$code" copied to clipboard!'),
          backgroundColor: AppColors.success,
          duration: const Duration(seconds: 1),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Rewards', showLeading: false),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.s24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cashback Summary Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.s24),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(AppRadii.card),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Lifetime Cashback Earned',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13.0,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryLight,
                    ),
                  ),
                  SizedBox(height: AppSpacing.s8),
                  Text(
                    '\$245.80',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold,
                      color: AppColors.background,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.s32),
            // Referral Card
            AppCard(
              color: AppColors.surface,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Invite Friends, Get \$15',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Receive \$15 cashback reward after their first bank transfer.',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.s12),
                  IconButton(
                    icon: const Icon(Icons.share_rounded, color: AppColors.primary),
                    onPressed: () {
                      _copyCode('https://payout.app/invite/user123');
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.s32),
            const Text(
              'My Active Coupons',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.s12),
            ...coupons.map((coupon) {
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.s12),
                child: AppCard(
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.s12),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.percent_rounded, color: AppColors.primary, size: 24),
                      ),
                      const SizedBox(width: AppSpacing.s16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              coupon['store']!,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                              ),
                            ),
                            Text(
                              coupon['desc']!,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 11.0,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              coupon['expiry']!,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 10.0,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.s8),
                      TextButton(
                        onPressed: () => _copyCode(coupon['code']!),
                        style: TextButton.styleFrom(
                          backgroundColor: AppColors.primaryLight,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: Text(
                          coupon['code']!,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
            const SizedBox(height: AppSpacing.s32),
            const Text(
              'Reward History',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.s12),
            ...[
              {'title': 'Referral Bonus', 'date': 'Aug 01, 2026', 'amount': '+\$15.00'},
              {'title': 'Starbucks Cashback perk', 'date': 'Jul 24, 2026', 'amount': '+\$2.40'},
              {'title': 'Amazon Prime signup promo', 'date': 'Jul 10, 2026', 'amount': '+\$10.00'},
            ].map((rew) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.s10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          rew['title']!,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          rew['date']!,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      rew['amount']!,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: AppColors.success,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
            const SizedBox(height: AppSpacing.s40),
          ],
        ),
      ),
    );
  }
}
