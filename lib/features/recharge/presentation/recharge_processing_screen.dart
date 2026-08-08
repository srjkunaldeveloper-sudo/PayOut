import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/features/recharge/repositories/recharge_repository.dart';
import 'package:payout/features/recharge/presentation/recharge_success_screen.dart';
import 'package:payout/features/recharge/presentation/recharge_pending_screen.dart';
import 'package:payout/features/recharge/presentation/recharge_failed_screen.dart';
import 'package:payout/features/transactions/repositories/transaction_repository.dart';

class RechargeProcessingScreen extends StatefulWidget {
  final String mobileNumber;
  final String operatorName;
  final double amount;
  final String planId;
  final String planData;
  final String planValidity;
  final String methodId;

  const RechargeProcessingScreen({
    super.key,
    required this.mobileNumber,
    required this.operatorName,
    required this.amount,
    required this.planId,
    required this.planData,
    required this.planValidity,
    required this.methodId,
  });

  @override
  State<RechargeProcessingScreen> createState() => _RechargeProcessingScreenState();
}

class _RechargeProcessingScreenState extends State<RechargeProcessingScreen> {
  late final RechargeRepository _rechargeRepository;

  @override
  void initState() {
    super.initState();
    _rechargeRepository = MockRechargeRepository(MockTransactionRepository());
    _startRecharge();
  }

  void _startRecharge() async {
    try {
      final response = await _rechargeRepository.rechargeMobile(
        mobileNumber: widget.mobileNumber,
        operator: widget.operatorName,
        amount: widget.amount,
        planId: widget.planId,
        methodId: widget.methodId,
      );

      if (!mounted) return;

      if (response.status == 'SUCCESS') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => RechargeSuccessScreen(
              mobileNumber: widget.mobileNumber,
              operatorName: widget.operatorName,
              amount: widget.amount,
              planData: widget.planData,
              planValidity: widget.planValidity,
              transactionId: response.transactionId,
              paymentMethod: widget.methodId,
            ),
          ),
        );
      } else if (response.status == 'PENDING') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => RechargePendingScreen(
              mobileNumber: widget.mobileNumber,
              operatorName: widget.operatorName,
              amount: widget.amount,
              transactionId: response.transactionId,
            ),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => RechargeFailedScreen(
              mobileNumber: widget.mobileNumber,
              operatorName: widget.operatorName,
              amount: widget.amount,
              errorMessage: 'Operator unavailable or payment declined.',
              onRetry: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RechargeProcessingScreen(
                      mobileNumber: widget.mobileNumber,
                      operatorName: widget.operatorName,
                      amount: widget.amount,
                      planId: widget.planId,
                      planData: widget.planData,
                      planValidity: widget.planValidity,
                      methodId: widget.methodId,
                    ),
                  ),
                );
              },
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => RechargeFailedScreen(
            mobileNumber: widget.mobileNumber,
            operatorName: widget.operatorName,
            amount: widget.amount,
            errorMessage: 'An unexpected error occurred during processing.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final maskedMobile = widget.mobileNumber.length == 10
        ? '+91 ******${widget.mobileNumber.substring(6)}'
        : widget.mobileNumber;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Processing Request', showLeading: false),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.s24),
          child: Column(
            children: [
              const Spacer(),
              Center(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.s24),
                      decoration: const BoxDecoration(
                        color: AppColors.primaryContainer,
                        shape: BoxShape.circle,
                      ),
                      child: const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                        strokeWidth: 4,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s24),
                    const Text(
                      'Processing Recharge...',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s8),
                    Text(
                      'Please do not close the app. Recharging $maskedMobile',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14.0,
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.s24),
                    Text(
                      '₹${widget.amount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 38.0,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              const Text(
                'Secured by Payout telecom service gateway',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12.0,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
