import 'dart:math';
import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/widgets.dart';
import 'package:payout/features/payments/presentation/receipt_screen.dart';
import 'package:payout/features/payments/repositories/payments_repository.dart';
import 'package:payout/features/transactions/repositories/transaction_repository.dart';
import 'package:payout/features/notifications/repositories/notification_repository.dart';

class PaymentSuccessScreen extends StatelessWidget {
  final String recipientName;
  final double amount;
  final String? transactionId;

  const PaymentSuccessScreen({
    super.key,
    required this.recipientName,
    required this.amount,
    this.transactionId,
  });

  String _generateTxnId() {
    final rand = Random();
    final buffer = StringBuffer('TXN');
    for (int i = 0; i < 10; i++) {
      buffer.write(rand.nextInt(10));
    }
    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    final txnId = transactionId ?? _generateTxnId();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Payment Status', showLeading: false),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24, vertical: AppSpacing.s12),
          child: Column(
            children: [
              const Spacer(),
              // Premium Success State
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.s24),
                      decoration: BoxDecoration(
                        color: AppColors.success.withOpacity(0.08),
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
                      'Payment Successful!',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s8),
                    Text(
                      'Sent to $recipientName',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14.0,
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.s16),
                    Text(
                      '₹${amount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 38.0,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              
              // Transaction Details Card
              AppCard(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Payment Status',
                          style: TextStyle(fontFamily: 'Inter', color: AppColors.textSecondary, fontSize: 13),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.success.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'COMPLETED',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: AppColors.success,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.s12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Transaction ID',
                          style: TextStyle(fontFamily: 'Inter', color: AppColors.textSecondary, fontSize: 13),
                        ),
                        Text(
                          txnId,
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
                          'Method',
                          style: TextStyle(fontFamily: 'Inter', color: AppColors.textSecondary, fontSize: 13),
                        ),
                        const Text(
                          'Payout Wallet Balance',
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
              const SizedBox(height: AppSpacing.s24),
              
              Row(
                children: [
                  Expanded(
                    child: OutlinedButtonV2(
                      text: 'View Receipt',
                      iconLeft: Icons.receipt_long_rounded,
                      onPressed: () async {
                        final repo = MockPaymentsRepository(
                          MockTransactionRepository(),
                          MockNotificationRepository(),
                        );
                        final receipt = await repo.getReceipt(txnId);
                        if (context.mounted) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReceiptScreen(receipt: receipt),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: AppSpacing.s16),
                  Expanded(
                    child: PrimaryButton(
                      text: 'Done',
                      onPressed: () {
                        Navigator.of(context).popUntil((route) => route.isFirst);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.s16),
            ],
          ),
        ),
      ),
    );
  }
}
