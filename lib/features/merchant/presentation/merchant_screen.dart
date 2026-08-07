import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/app_card.dart';
import 'package:payout/core/widgets/search_bar.dart';
import 'package:payout/core/widgets/avatar.dart';

class MerchantScreen extends StatelessWidget {
  const MerchantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> merchants = [
      {'name': 'Starbucks Coffee', 'cat': 'Food & Dining', 'dist': '0.4 mi', 'initials': 'SB'},
      {'name': 'Walmart Supercenter', 'cat': 'Groceries', 'dist': '1.2 mi', 'initials': 'WM'},
      {'name': 'Chevron Gas Station', 'cat': 'Automotive', 'dist': '0.8 mi', 'initials': 'CV'},
      {'name': 'Target Stores', 'cat': 'Shopping', 'dist': '1.5 mi', 'initials': 'TG'},
      {'name': 'CVS Pharmacy', 'cat': 'Health & Wellness', 'dist': '0.3 mi', 'initials': 'CVS'},
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Pay Merchants'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.s24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomSearchBar(hintText: 'Search nearby merchants...'),
            const SizedBox(height: AppSpacing.s24),
            const Text(
              'Nearby Merchants',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.s16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: merchants.length,
              itemBuilder: (context, index) {
                final mer = merchants[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.s12),
                  child: AppCard(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Starting merchant checkout for ${mer['name']}')),
                      );
                    },
                    child: Row(
                      children: [
                        CustomAvatar(
                          name: mer['name'],
                          size: 44,
                          backgroundColor: AppColors.primaryLight,
                          textColor: AppColors.primary,
                        ),
                        const SizedBox(width: AppSpacing.s12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                mer['name'],
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${mer['cat']} • ${mer['dist']}',
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 12.0,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 14,
                          color: AppColors.textSecondary,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
