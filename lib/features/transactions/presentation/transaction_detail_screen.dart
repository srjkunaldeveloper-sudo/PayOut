import 'dart:math';
import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/widgets.dart';
import 'package:payout/features/payments/models/payments_models.dart';
import 'package:payout/features/payments/presentation/receipt_screen.dart';
import 'package:payout/features/transactions/models/transaction_models.dart' show TransactionModel;

class TransactionDetailScreen extends StatelessWidget {
  final TransactionModel transaction;

  const TransactionDetailScreen({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    final isSuccess = transaction.status == 'SUCCESS';
    final isPending = transaction.status == 'PENDING';

    final Color statusColor = isSuccess
        ? AppColors.success
        : (isPending ? AppColors.warning : AppColors.error);
    final IconData statusIcon = isSuccess
        ? Icons.check_circle_rounded
        : (isPending ? Icons.hourglass_empty_rounded : Icons.error_outline_rounded);
    final String statusTitle = isSuccess
        ? 'Payment Successful'
        : (isPending ? 'Payment Pending' : 'Payment Failed');

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Transaction Details'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.s24),
          child: Column(
            children: [
              Center(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.s16),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.08),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        statusIcon,
                        size: 48,
                        color: statusColor,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s16),
                    Text(
                      statusTitle,
                      style: const TextStyle(
                        fontFamily: 'Geist Sans',
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s8),
                    Text(
                      '₹${transaction.amount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontFamily: 'Geist Sans',
                        fontSize: 32.0,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.s24),
              AppCard(
                padding: const EdgeInsets.all(AppSpacing.s20),
                child: Column(
                  children: [
                    _buildDetailRow('To / Payee', transaction.title),
                    const Divider(color: AppColors.divider),
                    _buildDetailRow('UPI ID', transaction.upiId),
                    const Divider(color: AppColors.divider),
                    _buildDetailRow('Category', transaction.category),
                    const Divider(color: AppColors.divider),
                    _buildDetailRow('Payment Source', transaction.paymentMethod),
                    const Divider(color: AppColors.divider),
                    _buildDetailRow('Transaction ID', transaction.id),
                    const Divider(color: AppColors.divider),
                    _buildDetailRow('UTR Number', transaction.utr.isNotEmpty ? transaction.utr : 'N/A'),
                    const Divider(color: AppColors.divider),
                    _buildDetailRow('Reference ID', transaction.referenceNumber.isNotEmpty ? transaction.referenceNumber : 'N/A'),
                    const Divider(color: AppColors.divider),
                    _buildDetailRow('Date & Time', transaction.date),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.s32),
              if (isSuccess) ...[
                SizedBox(
                  width: double.infinity,
                  child: PrimaryButton(
                    text: 'View Receipt',
                    onPressed: () {
                      final receipt = ReceiptModel(
                        txnId: transaction.id,
                        utrNumber: transaction.utr.isNotEmpty ? transaction.utr : 'UTR${Random().nextInt(900000) + 100000}',
                        refNumber: transaction.referenceNumber.isNotEmpty ? transaction.referenceNumber : 'REF${Random().nextInt(900000) + 100000}',
                        amount: transaction.amount,
                        date: transaction.date,
                        method: transaction.paymentMethod,
                        receiverName: transaction.title,
                        receiverUpi: transaction.upiId,
                        status: transaction.status,
                        notes: 'Transfer completed successfully.',
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
              ],
              SizedBox(
                width: double.infinity,
                child: SecondaryButton(
                  text: 'Done',
                  onPressed: () {
                    Navigator.pop(context);
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
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontFamily: 'Geist Sans', fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
