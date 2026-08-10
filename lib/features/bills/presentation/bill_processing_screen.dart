import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/di/app_dependencies.dart';
import 'package:payout/features/bills/models/bill_models.dart';
import 'package:payout/features/bills/repositories/bill_repository.dart';
import 'package:payout/features/bills/presentation/bill_success_screen.dart';
import 'package:payout/features/bills/presentation/bill_pending_screen.dart';
import 'package:payout/features/bills/presentation/bill_failed_screen.dart';

class BillProcessingScreen extends StatefulWidget {
  final BillModel bill;
  final String methodId;
  final BillRepository? billRepository;

  const BillProcessingScreen({
    super.key,
    required this.bill,
    required this.methodId,
    this.billRepository,
  });

  @override
  State<BillProcessingScreen> createState() => _BillProcessingScreenState();
}

class _BillProcessingScreenState extends State<BillProcessingScreen> {
  late final BillRepository _billRepository;

  @override
  void initState() {
    super.initState();
    _billRepository = widget.billRepository ?? AppDependencies.instance.billRepository;
    _startBillPayment();
  }

  void _startBillPayment() async {
    try {
      final response = await _billRepository.payBill(
        billId: widget.bill.id,
        amount: widget.bill.amount + widget.bill.lateFee,
        methodId: widget.methodId,
      );

      if (!mounted) return;

      if (response.status == 'SUCCESS') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BillSuccessScreen(
              bill: widget.bill,
              transactionId: response.transactionId,
              paymentMethod: widget.methodId,
            ),
          ),
        );
      } else if (response.status == 'PENDING') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BillPendingScreen(
              bill: widget.bill,
              transactionId: response.transactionId,
            ),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BillFailedScreen(
              bill: widget.bill,
              errorMessage: 'Utility operator system unavailable or payment declined.',
              onRetry: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BillProcessingScreen(
                      bill: widget.bill,
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
          builder: (context) => BillFailedScreen(
            bill: widget.bill,
            errorMessage: 'An unexpected error occurred during processing.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalAmount = widget.bill.amount + widget.bill.lateFee;

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
                      'Processing Bill Payment...',
                      style: TextStyle(
                        fontFamily: 'Geist Sans',
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s8),
                    Text(
                      'Please do not close the app. Paying ${widget.bill.billerName}',
                      style: const TextStyle(
                        fontFamily: 'Geist Sans',
                        fontSize: 14.0,
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
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
              const Spacer(),
              const Text(
                'Secured by Payout BBPS utility gateway',
                style: TextStyle(
                  fontFamily: 'Geist Sans',
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
