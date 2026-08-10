import 'package:flutter/material.dart';
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
            color: Color(0xFFF8FAFC),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(color: const Color(0xFFCBD5E1), borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Select Payment Source',
                style: TextStyle(fontFamily: 'Geist Sans', fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1F1F1F)),
              ),
              const SizedBox(height: 14),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(color: const Color(0xFF3F37C9).withValues(alpha: 0.08), shape: BoxShape.circle),
                  child: const Icon(Icons.account_balance_wallet_rounded, color: Color(0xFF3F37C9), size: 20),
                ),
                title: const Text('Payout Wallet', style: TextStyle(fontFamily: 'Geist Sans', fontSize: 14, fontWeight: FontWeight.bold)),
                subtitle: const Text('Available Balance: ₹5,000.00', style: TextStyle(fontFamily: 'Geist Sans', fontSize: 12, color: Color(0xFF64748B))),
                trailing: _selectedMethodId == 'wallet' ? const Icon(Icons.check_circle_rounded, color: Color(0xFF3F37C9)) : null,
                onTap: () {
                  setState(() {
                    _selectedMethodId = 'wallet';
                    _selectedMethodLabel = 'Payout Wallet';
                  });
                  Navigator.pop(context);
                },
              ),
              const Divider(color: Color(0xFFE2E8F0)),
              if (_isLoadingBanks)
                const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF3F37C9))))
              else
                ..._linkedBanks.map((bank) {
                  final isSelected = _selectedMethodId == bank.id;
                  final suffix = bank.accountNumber.length >= 4
                      ? bank.accountNumber.substring(bank.accountNumber.length - 4)
                      : '9999';
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(color: const Color(0xFF3F37C9).withValues(alpha: 0.08), shape: BoxShape.circle),
                      child: const Icon(Icons.account_balance_rounded, color: Color(0xFF3F37C9), size: 20),
                    ),
                    title: Text(bank.bankName, style: const TextStyle(fontFamily: 'Geist Sans', fontSize: 14, fontWeight: FontWeight.bold)),
                    subtitle: Text('Checking •••• $suffix', style: const TextStyle(fontFamily: 'Geist Sans', fontSize: 12, color: Color(0xFF64748B))),
                    trailing: isSelected ? const Icon(Icons.check_circle_rounded, color: Color(0xFF3F37C9)) : null,
                    onTap: () {
                      setState(() {
                        _selectedMethodId = bank.id;
                        _selectedMethodLabel = '${bank.bankName} •••• $suffix';
                      });
                      Navigator.pop(context);
                    },
                  );
                }),
              const SizedBox(height: 18),
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
    final canPop = Navigator.of(context).canPop();
    const double convenienceFee = 0.00;
    const double couponDiscount = 0.00;
    final double totalPayable = widget.plan.amount + convenienceFee - couponDiscount;

    final maskedMobile = widget.mobileNumber.length == 10
        ? '+91 ******${widget.mobileNumber.substring(6)}'
        : widget.mobileNumber;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                if (canPop)
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.arrow_back_rounded,
                        color: Color(0xFF3F37C9),
                        size: 20,
                      ),
                    ),
                  ),
                const Expanded(
                  child: Center(
                    child: Text(
                      'Review Recharge',
                      style: TextStyle(
                        fontFamily: 'Geist Sans',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F1F1F),
                      ),
                    ),
                  ),
                ),
                if (canPop)
                  const SizedBox(width: 38)
                else
                  const SizedBox(width: 16),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Recharge Details',
                style: TextStyle(
                  fontFamily: 'Geist Sans',
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F1F1F),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF002E6E).withValues(alpha: 0.02),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFF3F37C9).withValues(alpha: 0.08),
                          ),
                          child: const Icon(Icons.phone_iphone_rounded, color: Color(0xFF3F37C9), size: 22),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                maskedMobile,
                                style: const TextStyle(
                                  fontFamily: 'Geist Sans',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.0,
                                  color: Color(0xFF1F1F1F),
                                ),
                              ),
                              Text(
                                widget.operatorName,
                                style: const TextStyle(
                                  fontFamily: 'Geist Sans',
                                  fontSize: 12.0,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      child: Divider(color: Color(0xFFE2E8F0)),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Selected Plan',
                          style: TextStyle(
                            fontFamily: 'Geist Sans',
                            fontSize: 13.0,
                            color: Color(0xFF64748B),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Text(
                            widget.plan.description,
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              fontFamily: 'Geist Sans',
                              fontSize: 13.0,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF1F1F1F),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Plan Price',
                          style: TextStyle(
                            fontFamily: 'Geist Sans',
                            fontSize: 13.0,
                            color: Color(0xFF64748B),
                          ),
                        ),
                        Text(
                          '₹${widget.plan.amount.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontFamily: 'Geist Sans',
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1F1F1F),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'Convenience Fee',
                          style: TextStyle(
                            fontFamily: 'Geist Sans',
                            fontSize: 13.0,
                            color: Color(0xFF64748B),
                          ),
                        ),
                        Text(
                          '₹0.00',
                          style: TextStyle(
                            fontFamily: 'Geist Sans',
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF059669),
                          ),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Divider(color: Color(0xFFE2E8F0)),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Payable',
                          style: TextStyle(
                            fontFamily: 'Geist Sans',
                            fontSize: 14.5,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1F1F1F),
                          ),
                        ),
                        Text(
                          '₹${totalPayable.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontFamily: 'Geist Sans',
                            fontSize: 19.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF3F37C9),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              const Text(
                'Payment Method',
                style: TextStyle(
                  fontFamily: 'Geist Sans',
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F1F1F),
                ),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: _showMethodSelector,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF002E6E).withValues(alpha: 0.02),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFF3F37C9).withValues(alpha: 0.08),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _selectedMethodId == 'wallet' ? Icons.account_balance_wallet_rounded : Icons.account_balance_rounded,
                          color: const Color(0xFF3F37C9),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _selectedMethodLabel,
                              style: const TextStyle(
                                fontFamily: 'Geist Sans',
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Color(0xFF1F1F1F),
                              ),
                            ),
                            const Text(
                              'Tap to change source',
                              style: TextStyle(
                                fontFamily: 'Geist Sans',
                                fontSize: 11,
                                color: Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF64748B)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 28),

              PrimaryButton(
                text: 'Pay ₹${totalPayable.toStringAsFixed(2)}',
                height: 52,
                onPressed: _proceedToPay,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
