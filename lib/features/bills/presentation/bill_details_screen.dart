import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/app_button.dart';
import 'package:payout/core/widgets/app_card.dart';
import 'package:payout/features/bills/presentation/review_bill_screen.dart';

class BillDetailsScreen extends StatelessWidget {
  final String categoryName;
  final String providerName;
  final String consumerNumber;

  const BillDetailsScreen({
    super.key,
    required this.categoryName,
    required this.providerName,
    required this.consumerNumber,
  });

  @override
  Widget build(BuildContext context) {
    // Generate mock bills based on category
    double amount = 45.80;
    String dueDate = 'Aug 24, 2026';

    if (categoryName == 'Electricity') {
      amount = 84.60;
      dueDate = 'Aug 18, 2026';
    } else if (categoryName == 'Water') {
      amount = 22.00;
      dueDate = 'Aug 20, 2026';
    } else if (categoryName == 'Gas') {
      amount = 32.50;
      dueDate = 'Aug 22, 2026';
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Bill Details'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.s24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Outstanding Balance',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.s16),
              AppCard(
                padding: const EdgeInsets.all(AppSpacing.s24),
                child: Column(
                  children: [
                    Text(
                      '\$${amount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 36.0,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        letterSpacing: -1.0,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.error.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'DUE BY $dueDate',
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppColors.error,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.s32),
              const Text(
                'Account Details',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.s12),
              AppCard(
                padding: const EdgeInsets.all(AppSpacing.s20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Provider',
                          style: TextStyle(fontFamily: 'Inter', color: AppColors.textSecondary, fontSize: 13),
                        ),
                        Text(
                          providerName,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.s12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Consumer ID',
                          style: TextStyle(fontFamily: 'Inter', color: AppColors.textSecondary, fontSize: 13),
                        ),
                        Text(
                          consumerNumber,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.s12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Account Name',
                          style: TextStyle(fontFamily: 'Inter', color: AppColors.textSecondary, fontSize: 13),
                        ),
                        const Text(
                          'Alex Morgan',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  text: 'Proceed to Pay',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReviewBillScreen(
                          categoryName: categoryName,
                          providerName: providerName,
                          consumerNumber: consumerNumber,
                          amount: amount,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.s16),
            ],
          ),
        ),
      ),
    );
  }
}
