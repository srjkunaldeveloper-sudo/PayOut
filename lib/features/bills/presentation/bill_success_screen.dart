import 'dart:math';
import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/widgets.dart';
import 'package:payout/features/bills/models/bill_models.dart';
import 'package:payout/features/payments/models/payments_models.dart';
import 'package:payout/features/payments/presentation/receipt_screen.dart';

class BillSuccessScreen extends StatelessWidget {
  final BillModel bill;
  final String transactionId;
  final String paymentMethod;

  const BillSuccessScreen({
    super.key,
    required this.bill,
    required this.transactionId,
    required this.paymentMethod,
  });

  @override
  Widget build(BuildContext context) {
    final totalAmount = bill.amount + bill.lateFee;
    final now = DateTime.now();
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final month = months[now.month - 1];
    final day = now.day.toString().padLeft(2, '0');
    final year = now.year;
    final hourInt = now.hour > 12 ? now.hour - 12 : (now.hour == 0 ? 12 : now.hour);
    final ampm = now.hour >= 12 ? 'PM' : 'AM';
    final minute = now.minute.toString().padLeft(2, '0');
    final formattedDate = '$month $day, $year • $hourInt:$minute $ampm';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Receipt', showLeading: false),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.s24),
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.s24),
              Center(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.s24),
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.08),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_circle_rounded,
                        size: 72,
                        color: AppColors.success,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s24),
                    const Text(
                      'Bill Payment Successful!',
                      style: TextStyle(
                        fontFamily: 'Geist Sans',
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s8),
                    Text(
                      bill.billerName,
                      style: const TextStyle(
                        fontFamily: 'Geist Sans',
                        fontSize: 14.0,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s24),
                    Text(
                      '₹${totalAmount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontFamily: 'Geist Sans',
                        fontSize: 38.0,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.s32),
              AppCard(
                padding: const EdgeInsets.all(AppSpacing.s20),
                child: Column(
                  children: [
                    _buildDetailRow('Consumer Name', bill.consumerName),
                    const Divider(color: AppColors.divider),
                    _buildDetailRow('Consumer ID', bill.consumerNumber),
                    const Divider(color: AppColors.divider),
                    _buildDetailRow('Bill Number', bill.billNumber),
                    const Divider(color: AppColors.divider),
                    _buildDetailRow('Transaction ID', transactionId),
                    const Divider(color: AppColors.divider),
                    _buildDetailRow('Date & Time', formattedDate),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.s40),
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  text: 'View Receipt',
                  onPressed: () {
                    final receipt = ReceiptModel(
                      txnId: transactionId,
                      utrNumber: 'UTR${DateTime.now().millisecondsSinceEpoch}',
                      refNumber: 'REF${Random().nextInt(900000) + 100000}',
                      amount: totalAmount,
                      date: formattedDate,
                      method: paymentMethod == 'wallet' ? 'Payout Wallet' : 'Bank Account',
                      receiverName: bill.billerName,
                      receiverUpi: '${bill.consumerNumber}@utility',
                      status: 'SUCCESS',
                      notes: 'Electricity bill paid for consumer ${bill.consumerName}',
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReceiptScreen(receipt: receipt),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.s12),
              SizedBox(
                width: double.infinity,
                child: SecondaryButton(
                  text: 'Done',
                  onPressed: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                ),
              ),
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
          Text(label, style: const TextStyle(fontFamily: 'Geist Sans', color: AppColors.textSecondary, fontSize: 13)),
          Text(value, style: const TextStyle(fontFamily: 'Geist Sans', fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary)),
        ],
      ),
    );
  }
}
