import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/app_button.dart';
import 'package:payout/core/widgets/app_card.dart';

class InvestmentsScreen extends StatefulWidget {
  const InvestmentsScreen({super.key});

  @override
  State<InvestmentsScreen> createState() => _InvestmentsScreenState();
}

class _InvestmentsScreenState extends State<InvestmentsScreen> {
  final List<Map<String, dynamic>> _portfolio = [
    {'name': 'Growth Mutual Fund', 'type': 'Mutual Funds', 'value': '\$4,250.00', 'return': '+14.5%', 'up': true},
    {'name': 'Tesla Inc (TSLA)', 'type': 'US Stocks', 'value': '\$1,850.50', 'return': '+8.2%', 'up': true},
    {'name': '24K Digital Gold', 'type': 'Commodities', 'value': '\$950.00', 'return': '-1.4%', 'up': false},
  ];

  void _showPurchaseSheet(String assetName, String assetType) {
    double? investAmount;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadii.bottomSheet)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: AppSpacing.s24,
            left: AppSpacing.s24,
            right: AppSpacing.s24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Buy $assetName',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 20.0),
              ),
              const SizedBox(height: AppSpacing.s8),
              Text(
                'Invest in $assetType instantly from your wallet balance.',
                style: const TextStyle(fontFamily: 'Inter', color: AppColors.textSecondary, fontSize: 13),
              ),
              const SizedBox(height: AppSpacing.s24),
              TextField(
                keyboardType: TextInputType.number,
                autofocus: true,
                onChanged: (val) {
                  investAmount = double.tryParse(val);
                },
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                decoration: const InputDecoration(
                  prefixText: '\$ ',
                  hintText: '0.00',
                ),
              ),
              const SizedBox(height: AppSpacing.s24),
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  text: 'Invest Now',
                  onPressed: () {
                    if (investAmount != null && investAmount! > 0) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Invested \$${investAmount!.toStringAsFixed(2)} in $assetName successfully.'),
                          backgroundColor: AppColors.success,
                        ),
                      );
                    }
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.s24),
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
      appBar: const CustomAppBar(title: 'Investments'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.s24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Portfolio summary banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.s24),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppRadii.card),
                border: Border.all(color: AppColors.divider, width: 1.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Total Portfolio Value',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13.0,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$7,050.50',
                        style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 28.0),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.success.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          '+11.8%',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.bold,
                            fontSize: 12.0,
                            color: AppColors.success,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.s32),
            const Text(
              'My Portfolio',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.s12),
            ..._portfolio.map((item) {
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.s12),
                child: AppCard(
                  onTap: () => _showPurchaseSheet(item['name'], item['type']),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['name'],
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                            ),
                          ),
                          Text(
                            item['type'],
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12.0,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            item['value'],
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                            ),
                          ),
                          Text(
                            item['return'],
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                              color: item['up'] ? AppColors.success : AppColors.error,
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
            const Text(
              'Explore Funds',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.s12),
            AppCard(
              onTap: () => _showPurchaseSheet('S&P 500 Index Fund', 'Index Funds'),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.s10),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.analytics_rounded, color: AppColors.primary, size: 24),
                  ),
                  const SizedBox(width: AppSpacing.s16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'S&P 500 Index Fund',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0,
                          ),
                        ),
                        Text(
                          'Invest in top 500 companies in the US.',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 11.0,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.s40),
          ],
        ),
      ),
    );
  }
}
