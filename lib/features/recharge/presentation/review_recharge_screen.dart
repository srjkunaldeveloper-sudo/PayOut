import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/widgets.dart';
import 'package:payout/features/recharge/presentation/recharge_success_screen.dart';

class ReviewRechargeScreen extends StatefulWidget {
  final String mobileNumber;
  final String operatorName;
  final double planPrice;
  final String planDescription;

  const ReviewRechargeScreen({
    super.key,
    required this.mobileNumber,
    required this.operatorName,
    required this.planPrice,
    required this.planDescription,
  });

  @override
  State<ReviewRechargeScreen> createState() => _ReviewRechargeScreenState();
}

class _ReviewRechargeScreenState extends State<ReviewRechargeScreen> {
  bool _isProcessing = false;

  void _payRecharge() {
    setState(() {
      _isProcessing = true;
    });

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => RechargeSuccessScreen(
              serviceName: 'Mobile Recharge - ${widget.operatorName}',
              consumerNumber: widget.mobileNumber,
              amount: widget.planPrice,
            ),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const double convenienceFee = 0.00;
    const double couponDiscount = 10.00;
    final double totalPayable = widget.planPrice + convenienceFee - couponDiscount;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Review Recharge'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24, vertical: AppSpacing.s12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Recharge Details',
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
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            color: AppColors.primaryContainer,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.phone_iphone_rounded, color: AppColors.primary),
                        ),
                        const SizedBox(width: AppSpacing.s16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.mobileNumber,
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.0,
                                ),
                              ),
                              Text(
                                widget.operatorName,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Selected Plan',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13.0,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.s24),
                        Expanded(
                          child: Text(
                            widget.planDescription,
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13.0,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textPrimary,
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
                          'Plan Price',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13.0,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          '₹${widget.planPrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.s12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'Convenience Fee',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13.0,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          '₹0.00',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            color: AppColors.success,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.s12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'Coupon Discount',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13.0,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          '-₹10.00',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            color: AppColors.success,
                          ),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: AppSpacing.s12),
                      child: Divider(color: AppColors.divider),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Payable',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          '₹${totalPayable.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
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
                      decoration: const BoxDecoration(
                        color: AppColors.primaryContainer,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.account_balance_wallet_rounded, color: AppColors.primary),
                    ),
                    const SizedBox(width: AppSpacing.s16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Payout Wallet Balance',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Text(
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
              PrimaryButton(
                text: 'Pay ₹${totalPayable.toStringAsFixed(2)}',
                isLoading: _isProcessing,
                onPressed: _isProcessing ? null : _payRecharge,
              ),
              const SizedBox(height: AppSpacing.s16),
            ],
          ),
        ),
      ),
    );
  }
}
