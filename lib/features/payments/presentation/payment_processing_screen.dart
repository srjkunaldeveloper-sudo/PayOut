import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/di/app_dependencies.dart';
import 'package:payout/features/payments/models/payments_models.dart';
import 'package:payout/features/payments/repositories/payments_repository.dart';
import 'package:payout/features/payments/presentation/payment_success_screen.dart';
import 'package:payout/features/payments/presentation/payment_pending_screen.dart';
import 'package:payout/features/payments/presentation/payment_failed_screen.dart';

class PaymentProcessingScreen extends StatefulWidget {
  final String recipientName;
  final String recipientDetail;
  final String recipientType;
  final double amount;
  final String note;
  final String methodId;
  final PaymentsRepository? paymentsRepository;

  const PaymentProcessingScreen({
    super.key,
    required this.recipientName,
    required this.recipientDetail,
    required this.recipientType,
    required this.amount,
    required this.note,
    required this.methodId,
    this.paymentsRepository,
  });

  @override
  State<PaymentProcessingScreen> createState() => _PaymentProcessingScreenState();
}

class _PaymentProcessingScreenState extends State<PaymentProcessingScreen> {
  late final PaymentsRepository _paymentsRepository;

  @override
  void initState() {
    super.initState();
    _paymentsRepository = widget.paymentsRepository ?? AppDependencies.instance.paymentsRepository;
    _executePayment();
  }

  Future<void> _executePayment() async {
    final request = TransferRequestModel(
      recipientName: widget.recipientName,
      upiId: widget.recipientDetail,
      amount: widget.amount,
      remarks: widget.note,
      methodId: widget.methodId,
    );

    try {
      final response = await _paymentsRepository.sendMoney(request);
      if (!mounted) return;

      if (response.status == 'SUCCESS') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentSuccessScreen(
              recipientName: widget.recipientName,
              amount: widget.amount,
              transactionId: response.transactionId,
            ),
          ),
        );
      } else if (response.status == 'PENDING') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentPendingScreen(
              recipientName: widget.recipientName,
              recipientDetail: widget.recipientDetail,
              amount: widget.amount,
              transactionId: response.transactionId,
              note: widget.note,
            ),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentFailedScreen(
              recipientName: widget.recipientName,
              recipientDetail: widget.recipientDetail,
              amount: widget.amount,
              errorMessage: 'Transaction declined. Demo rule: amount == 100.',
              onRetry: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaymentProcessingScreen(
                      recipientName: widget.recipientName,
                      recipientDetail: widget.recipientDetail,
                      recipientType: widget.recipientType,
                      amount: widget.amount,
                      note: widget.note,
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
          builder: (context) => PaymentFailedScreen(
            recipientName: widget.recipientName,
            recipientDetail: widget.recipientDetail,
            amount: widget.amount,
            errorMessage: e.toString(),
            onRetry: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => PaymentProcessingScreen(
                    recipientName: widget.recipientName,
                    recipientDetail: widget.recipientDetail,
                    recipientType: widget.recipientType,
                    amount: widget.amount,
                    note: widget.note,
                    methodId: widget.methodId,
                  ),
                ),
              );
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 56,
                  height: 56,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                    strokeWidth: 4,
                  ),
                ),
                const SizedBox(height: AppSpacing.s32),
                const Text(
                  'Processing Payment',
                  style: TextStyle(
                    fontFamily: 'Geist Sans',
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.s12),
                Text(
                  'Paying ₹${widget.amount.toStringAsFixed(2)} to ${widget.recipientName}...',
                  style: const TextStyle(
                    fontFamily: 'Geist Sans',
                    fontSize: 13.0,
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.s8),
                const Text(
                  'Please do not close the app or navigate away.',
                  style: TextStyle(
                    fontFamily: 'Geist Sans',
                    fontSize: 11.0,
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
