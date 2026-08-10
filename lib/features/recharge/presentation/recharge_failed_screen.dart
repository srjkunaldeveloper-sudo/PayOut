import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/widgets.dart';

class RechargeFailedScreen extends StatelessWidget {
  final String mobileNumber;
  final String operatorName;
  final double amount;
  final String errorMessage;
  final VoidCallback? onRetry;

  const RechargeFailedScreen({
    super.key,
    required this.mobileNumber,
    required this.operatorName,
    required this.amount,
    required this.errorMessage,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final maskedMobile = mobileNumber.length == 10
        ? '+91 ******${mobileNumber.substring(6)}'
        : mobileNumber;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Payment Status', showLeading: false),
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
                        color: AppColors.error.withOpacity(0.08),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.error_outline_rounded,
                        size: 72,
                        color: AppColors.error,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s24),
                    const Text(
                      'Recharge Failed',
                      style: TextStyle(
                        fontFamily: 'Geist Sans',
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s8),
                    Text(
                      errorMessage,
                      style: const TextStyle(
                        fontFamily: 'Geist Sans',
                        fontSize: 14.0,
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.s12),
                    Text(
                      'To: $maskedMobile ($operatorName)',
                      style: const TextStyle(
                        fontFamily: 'Geist Sans',
                        fontSize: 12.0,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s24),
                    Text(
                      '₹${amount.toStringAsFixed(2)}',
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
              const SizedBox(height: AppSpacing.s40),
              if (onRetry != null) ...[
                SizedBox(
                  width: double.infinity,
                  child: PrimaryButton(
                    text: 'Retry Recharge',
                    onPressed: onRetry!,
                  ),
                ),
                const SizedBox(height: AppSpacing.s12),
              ],
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Change Payment Method',
                    style: TextStyle(fontFamily: 'Geist Sans', fontWeight: FontWeight.bold, color: AppColors.primary),
                  ),
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
}
