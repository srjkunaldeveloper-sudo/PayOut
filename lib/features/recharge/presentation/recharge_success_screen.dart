import 'dart:math';
import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/widgets.dart';

class RechargeSuccessScreen extends StatelessWidget {
  final String serviceName;
  final String consumerNumber;
  final double amount;
  final String? transactionId;

  const RechargeSuccessScreen({
    super.key,
    required this.serviceName,
    required this.consumerNumber,
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24, vertical: AppSpacing.s12),
          child: Column(
            children: [
              const Spacer(),
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
                      'Recharge Successful!',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s8),
                    Text(
                      serviceName,
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
                          'Mobile Number',
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
                          'Date & Time',
                          style: TextStyle(fontFamily: 'Inter', color: AppColors.textSecondary, fontSize: 13),
                        ),
                        Text(
                          formattedDate,
                          style: const TextStyle(
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
              const SizedBox(height: AppSpacing.s32),
              
              // Share and Done Button Actions
              Row(
                children: [
                  Expanded(
                    child: OutlinedButtonV2(
                      text: 'Share Receipt',
                      iconLeft: Icons.share_rounded,
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Sharing recharge receipt...')),
                        );
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
              const SizedBox(height: AppSpacing.s24),
            ],
          ),
        ),
      ),
    );
  }
}
