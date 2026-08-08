import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/widgets.dart';
import 'package:payout/features/recharge/models/recharge_models.dart';
import 'package:payout/features/recharge/presentation/recharge_processing_screen.dart';
import 'package:payout/features/payments/presentation/mpin_verification_screen.dart';
import 'package:payout/features/bank_accounts/services/bank_account_service.dart';
import 'package:payout/features/bank_accounts/models/bank_account_models.dart';

class ReviewRechargeScreen extends StatefulWidget {
  final String mobileNumber;
  final String operatorName;
  final RechargePlanModel plan;

  const ReviewRechargeScreen({
    super.key,
    required this.mobileNumber,
    required this.operatorName,
    required this.plan,
  });

  @override
  State<ReviewRechargeScreen> createState() => _ReviewRechargeScreenState();
}

class _ReviewRechargeScreenState extends State<ReviewRechargeScreen> {
  final BankAccountService _bankAccountService = BankAccountService();

  List<LinkedBankAccountModel> _linkedBanks = [];
  bool _isLoadingBanks = true;

  // Selected method ID: 'wallet' or bank account ID
  String _selectedMethodId = 'wallet';
  String _selectedMethodLabel = 'Payout Wallet';

  @override
  void initState() {
    super.initState();
    _loadBanks();
  }

  Future<void> _loadBanks() async {
    final list = await _bankAccountService.getLinkedAccounts();
    if (mounted) {
      setState(() {
        _linkedBanks = list;
        _isLoadingBanks = false;
      });
    }
  }

  void _showMethodSelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(AppSpacing.s24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(color: AppColors.divider, borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: AppSpacing.s24),
              const Text(
                'Select Payment Source',
                style: TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              const SizedBox(height: AppSpacing.s16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(color: AppColors.primaryContainer, shape: BoxShape.circle),
                  child: const Icon(Icons.account_balance_wallet_rounded, color: AppColors.primary, size: 20),
                ),
                title: const Text('Payout Wallet', style: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.bold)),
                subtitle: const Text('Available Balance: ₹5,000.00', style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.textSecondary)),
                trailing: _selectedMethodId == 'wallet' ? const Icon(Icons.check_circle_rounded, color: AppColors.primary) : null,
                onTap: () {
                  setState(() {
                    _selectedMethodId = 'wallet';
                    _selectedMethodLabel = 'Payout Wallet';
                  });
                  Navigator.pop(context);
                },
              ),
              const Divider(color: AppColors.divider),
              if (_isLoadingBanks)
                const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary)))
              else
                ..._linkedBanks.map((bank) {
                  final isSelected = _selectedMethodId == bank.id;
                  final suffix = bank.accountNumber.length >= 4
                      ? bank.accountNumber.substring(bank.accountNumber.length - 4)
                      : '9999';
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(color: AppColors.surface, shape: BoxShape.circle),
                      child: const Icon(Icons.account_balance_rounded, color: AppColors.primary, size: 20),
                    ),
                    title: Text(bank.bankName, style: const TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.bold)),
                    subtitle: Text('Checking •••• $suffix', style: const TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.textSecondary)),
                    trailing: isSelected ? const Icon(Icons.check_circle_rounded, color: AppColors.primary) : null,
                    onTap: () {
                      setState(() {
                        _selectedMethodId = bank.id;
                        _selectedMethodLabel = '${bank.bankName} •••• $suffix';
                      });
                      Navigator.pop(context);
                    },
                  );
                }),
              const SizedBox(height: AppSpacing.s24),
            ],
          ),
        );
      },
    );
  }

  void _proceedToPay() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentMPINVerificationScreen(
          recipientName: '${widget.operatorName} Recharge',
          recipientDetail: widget.mobileNumber,
          recipientType: 'Mobile',
          amount: widget.plan.amount,
          note: 'Recharge for ${widget.mobileNumber}',
          methodId: _selectedMethodId,
          onSuccess: () {
            // Push to processing screen
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => RechargeProcessingScreen(
                  mobileNumber: widget.mobileNumber,
                  operatorName: widget.operatorName,
                  amount: widget.plan.amount,
                  planId: widget.plan.id,
                  planData: widget.plan.data,
                  planValidity: widget.plan.validity,
                  methodId: _selectedMethodId,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double convenienceFee = 0.00;
    final double couponDiscount = 0.00;
    final double totalPayable = widget.plan.amount + convenienceFee - couponDiscount;

    final maskedMobile = widget.mobileNumber.length == 10
        ? '+91 ******${widget.mobileNumber.substring(6)}'
        : widget.mobileNumber;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Review Recharge'),
      body: SafeArea(
        child: SingleChildScrollView(
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
                                maskedMobile,
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
                            widget.plan.description,
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
                          '₹${widget.plan.amount.toStringAsFixed(2)}',
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
                onTap: _showMethodSelector,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: AppColors.primaryContainer,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _selectedMethodId == 'wallet' ? Icons.account_balance_wallet_rounded : Icons.account_balance_rounded,
                        color: AppColors.primary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.s16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _selectedMethodLabel,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const Text(
                            'Tap to change source',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textSecondary),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.s40),
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  text: 'Pay ₹${totalPayable.toStringAsFixed(2)}',
                  onPressed: _proceedToPay,
                ),
              ),
              const SizedBox(height: AppSpacing.s16),
            ],
          ),
        ),
      ),
    );
  }
}
