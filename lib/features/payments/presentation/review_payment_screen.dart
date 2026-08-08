import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/widgets.dart';
import 'package:payout/features/payments/presentation/mpin_verification_screen.dart';

class ReviewPaymentScreen extends StatefulWidget {
  final String recipientName;
  final String recipientDetail;
  final String recipientType;
  final double amount;
  final String note;
  final String methodId;
  final String methodLabel;

  const ReviewPaymentScreen({
    super.key,
    required this.recipientName,
    required this.recipientDetail,
    required this.recipientType,
    required this.amount,
    required this.note,
    required this.methodId,
    required this.methodLabel,
  });

  @override
  State<ReviewPaymentScreen> createState() => _ReviewPaymentScreenState();
}

class _ReviewPaymentScreenState extends State<ReviewPaymentScreen> {
  void _navigateToMPINVerification() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentMPINVerificationScreen(
          recipientName: widget.recipientName,
          recipientDetail: widget.recipientDetail,
          recipientType: widget.recipientType,
          amount: widget.amount,
          note: widget.note,
          methodId: widget.methodId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double fee = 0.0;
    final double total = widget.amount + fee;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Review Payment'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24, vertical: AppSpacing.s12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Review Details',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.s16),
              AppCard(
                padding: const EdgeInsets.all(AppSpacing.s20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CustomAvatar(
                          name: widget.recipientName,
                          size: 48,
                          backgroundColor: AppColors.primaryContainer,
                          textColor: AppColors.primary,
                        ),
                        const SizedBox(width: AppSpacing.s16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.recipientName,
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.0,
                                ),
                              ),
                              Text(
                                widget.recipientDetail,
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 12.0,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: AppSpacing.s16),
                      child: Divider(color: AppColors.divider),
                    ),
                    _buildReviewRow('Amount', '₹${widget.amount.toStringAsFixed(2)}', isBold: true),
                    const SizedBox(height: 8),
                    _buildReviewRow('Transfer Fee', '₹${fee.toStringAsFixed(2)}'),
                    const SizedBox(height: 8),
                    _buildReviewRow('Total Payment', '₹${total.toStringAsFixed(2)}', isBold: true, isPrimary: true),
                    if (widget.note.isNotEmpty) ...[
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: AppSpacing.s12),
                        child: Divider(color: AppColors.divider),
                      ),
                      _buildReviewRow('Note', widget.note),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.s24),
              const Text(
                'Payment Method',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.s16),
              AppCard(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primaryContainer,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        widget.methodId == 'wallet'
                            ? Icons.account_balance_wallet_rounded
                            : Icons.account_balance_rounded,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.s16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.methodLabel,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const Text(
                            'Instant transfer',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.check_circle_rounded, color: AppColors.primary),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  text: 'Pay ₹${total.toStringAsFixed(2)}',
                  onPressed: _navigateToMPINVerification,
                ),
              ),
              const SizedBox(height: AppSpacing.s16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReviewRow(String label, String val, {bool isBold = false, bool isPrimary = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 13.0,
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          val,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: isBold ? 15.0 : 13.0,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: isPrimary ? AppColors.primary : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
