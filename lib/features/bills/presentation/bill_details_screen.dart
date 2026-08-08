import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/widgets.dart';
import 'package:payout/features/bills/models/bill_models.dart';
import 'package:payout/features/bills/presentation/review_bill_screen.dart';

class BillDetailsScreen extends StatelessWidget {
  final BillModel bill;

  const BillDetailsScreen({
    super.key,
    required this.bill,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Bill Details'),
      body: SafeArea(
        child: SingleChildScrollView(
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
                      '₹${bill.amount.toStringAsFixed(2)}',
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
                        'DUE BY ${bill.dueDate}',
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
                    _buildDetailRow('Provider / Biller', bill.billerName),
                    const Divider(color: AppColors.divider),
                    _buildDetailRow('Consumer ID', bill.consumerNumber),
                    const Divider(color: AppColors.divider),
                    _buildDetailRow('Consumer Name', bill.consumerName),
                    const Divider(color: AppColors.divider),
                    _buildDetailRow('Bill Number', bill.billNumber),
                    const Divider(color: AppColors.divider),
                    _buildDetailRow('Bill Date', bill.billDate),
                    const Divider(color: AppColors.divider),
                    _buildDetailRow('Late Fee', '₹${bill.lateFee.toStringAsFixed(2)}'),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.s40),
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  text: 'Continue to Pay',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReviewBillScreen(
                          bill: bill,
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

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontFamily: 'Inter', color: AppColors.textSecondary, fontSize: 13)),
          Text(value, style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary)),
        ],
      ),
    );
  }
}
