import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/widgets.dart';

class PaymentPendingScreen extends StatefulWidget {
  final String recipientName;
  final String recipientDetail;
  final double amount;
  final String transactionId;
  final String note;

  const PaymentPendingScreen({
    super.key,
    required this.recipientName,
    required this.recipientDetail,
    required this.amount,
    required this.transactionId,
    required this.note,
  });

  @override
  State<PaymentPendingScreen> createState() => _PaymentPendingScreenState();
}

class _PaymentPendingScreenState extends State<PaymentPendingScreen> {
  bool _isChecking = false;

  void _checkStatus() async {
    setState(() {
      _isChecking = true;
    });

    // Simulate Status Check API Latency
    await Future.delayed(const Duration(milliseconds: 1000));

    if (!mounted) return;
    setState(() {
      _isChecking = false;
    });

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Transaction Status'),
        content: Text(
          'Transaction ID: ${widget.transactionId}\nStatus: PENDING\nRemarks: The bank is verifying the transaction settlement.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final timestamp = DateTime.now().toString().split('.')[0];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Pending Details', showLeading: false),
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
                        color: AppColors.warning.withValues(alpha: 0.08),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.hourglass_empty_rounded,
                        size: 72,
                        color: AppColors.warning,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s24),
                    const Text(
                      'Payment Pending',
                      style: TextStyle(
                        fontFamily: 'Geist Sans',
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s8),
                    const Text(
                      'Your payment is being processed by the bank.',
                      style: TextStyle(
                        fontFamily: 'Geist Sans',
                        fontSize: 14.0,
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.s24),
                    Text(
                      '₹${widget.amount.toStringAsFixed(2)}',
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
                    _buildDetailRow('Transaction ID', widget.transactionId),
                    const Divider(color: AppColors.divider),
                    _buildDetailRow('Recipient', widget.recipientName),
                    const Divider(color: AppColors.divider),
                    _buildDetailRow('UPI ID / Acc', widget.recipientDetail),
                    const Divider(color: AppColors.divider),
                    _buildDetailRow('Timestamp', timestamp),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.s32),
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  text: _isChecking ? 'Checking...' : 'Check Status',
                  onPressed: _isChecking ? null : _checkStatus,
                ),
              ),
              const SizedBox(height: AppSpacing.s12),
              SizedBox(
                width: double.infinity,
                child: SecondaryButton(
                  text: 'Go Home',
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

  Widget _buildDetailRow(String label, String val) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontFamily: 'Geist Sans', color: AppColors.textSecondary, fontSize: 13)),
          Text(val, style: const TextStyle(fontFamily: 'Geist Sans', fontWeight: FontWeight.bold, fontSize: 13)),
        ],
      ),
    );
  }
}
