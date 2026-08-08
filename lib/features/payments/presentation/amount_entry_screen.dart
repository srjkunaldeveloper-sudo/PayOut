import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/widgets.dart';
import 'package:payout/features/bank_accounts/services/bank_account_service.dart';
import 'package:payout/features/bank_accounts/models/bank_account_models.dart';
import 'package:payout/features/payments/presentation/review_payment_screen.dart';
import 'package:payout/features/payments/validators/payments_validator.dart';

class AmountEntryScreen extends StatefulWidget {
  final String recipientName;
  final String recipientDetail;
  final String recipientType;

  const AmountEntryScreen({
    super.key,
    required this.recipientName,
    required this.recipientDetail,
    required this.recipientType,
  });

  @override
  State<AmountEntryScreen> createState() => _AmountEntryScreenState();
}

class _AmountEntryScreenState extends State<AmountEntryScreen> {
  final BankAccountService _bankAccountService = BankAccountService();

  String _amountStr = '';
  final TextEditingController _noteController = TextEditingController();

  // Payment Method Selection State
  String _methodId = 'wallet';
  String _methodLabel = 'Payout Wallet';
  List<LinkedBankAccountModel> _linkedBanks = [];
  bool _isLoadingBanks = true;

  @override
  void initState() {
    super.initState();
    _loadBanks();
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _loadBanks() async {
    final banks = await _bankAccountService.getLinkedAccounts();
    setState(() {
      _linkedBanks = banks;
      _isLoadingBanks = false;
    });
  }

  void _onKeyPress(String val) {
    if (val == '.') {
      if (_amountStr.contains('.')) return;
      if (_amountStr.isEmpty) {
        setState(() {
          _amountStr = '0.';
        });
        return;
      }
    }
    // limit decimal digits to 2
    if (_amountStr.contains('.')) {
      final decPart = _amountStr.split('.')[1];
      if (decPart.length >= 2) return;
    }
    // limit total characters
    if (_amountStr.length >= 8) return;

    setState(() {
      _amountStr += val;
    });
  }

  void _onBackspace() {
    if (_amountStr.isNotEmpty) {
      setState(() {
        _amountStr = _amountStr.substring(0, _amountStr.length - 1);
      });
    }
  }

  void _showPaymentMethodSelector() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xxl)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: AppSpacing.s24,
            left: AppSpacing.s24,
            right: AppSpacing.s24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Choose Payment Method',
                style: TextStyle(fontFamily: 'Inter', fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              const SizedBox(height: AppSpacing.s8),
              const Text(
                'Select the source account for this transaction.',
                style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.textSecondary),
              ),
              const SizedBox(height: AppSpacing.s20),
              // Payout Wallet option
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: AppColors.primaryContainer, borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.account_balance_wallet_rounded, color: AppColors.primary),
                ),
                title: const Text('Payout Wallet', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 14)),
                subtitle: const Text('Instant, direct balance transfer', style: TextStyle(fontFamily: 'Inter', fontSize: 11, color: AppColors.textSecondary)),
                trailing: _methodId == 'wallet' ? const Icon(Icons.check_circle_rounded, color: AppColors.primary) : null,
                onTap: () {
                  setState(() {
                    _methodId = 'wallet';
                    _methodLabel = 'Payout Wallet';
                  });
                  Navigator.pop(context);
                },
              ),
              const Divider(color: AppColors.divider),
              // Linked Bank options
              ..._linkedBanks.map((bank) {
                final isSelected = _methodId == bank.id;
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: AppColors.primaryContainer, borderRadius: BorderRadius.circular(8)),
                    child: const Icon(Icons.account_balance_rounded, color: AppColors.primary),
                  ),
                  title: Text(bank.bankName, style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 14)),
                  subtitle: Text('Savings ${bank.maskedAccountNumber}', style: const TextStyle(fontFamily: 'Inter', fontSize: 11, color: AppColors.textSecondary)),
                  trailing: isSelected ? const Icon(Icons.check_circle_rounded, color: AppColors.primary) : null,
                  onTap: () {
                    setState(() {
                      _methodId = bank.id;
                      _methodLabel = '${bank.bankName} ${bank.maskedAccountNumber}';
                    });
                    Navigator.pop(context);
                  },
                );
              }).toList(),
              const SizedBox(height: AppSpacing.s24),
            ],
          ),
        );
      },
    );
  }

  Widget _buildKey(String value) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(AppSpacing.s4),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _onKeyPress(value),
            borderRadius: BorderRadius.circular(16.0),
            child: Container(
              height: 54,
              alignment: Alignment.center,
              child: Text(
                value,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 22.0,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double parsedAmount = double.tryParse(_amountStr) ?? 0.0;
    final displayAmount = _amountStr.isEmpty ? '0.00' : _amountStr;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Enter Amount'),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24),
                child: Column(
                  children: [
                    const SizedBox(height: AppSpacing.s12),
                    // Recipient details header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomAvatar(
                          name: widget.recipientName,
                          size: 40,
                          backgroundColor: AppColors.primaryLight,
                          textColor: AppColors.primary,
                        ),
                        const SizedBox(width: AppSpacing.s12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.recipientName,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                              ),
                            ),
                            Text(
                              widget.recipientDetail,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 11.0,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.s32),
                    // Big Amount text
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 4.0),
                          child: Text(
                            '₹',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 28.0,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          displayAmount,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 48.0,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                            letterSpacing: -1.0,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.s24),
                    // Note Input field
                    SizedBox(
                      width: 260,
                      child: TextField(
                        controller: _noteController,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Add a payment note',
                          filled: true,
                          fillColor: AppColors.surface,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s20),
                    // Payment Method selector pill
                    GestureDetector(
                      onTap: _showPaymentMethodSelector,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.account_balance_wallet_rounded, size: 14, color: AppColors.primary),
                            const SizedBox(width: 8),
                            Text(
                              _methodLabel,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(Icons.keyboard_arrow_down_rounded, size: 16, color: AppColors.primary),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Custom Numeric Keypad & Proceed Button
            Container(
              padding: const EdgeInsets.all(AppSpacing.s16),
              decoration: const BoxDecoration(
                color: AppColors.background,
                border: Border(
                  top: BorderSide(color: AppColors.divider, width: 1.0),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [_buildKey('1'), _buildKey('2'), _buildKey('3')],
                  ),
                  Row(
                    children: [_buildKey('4'), _buildKey('5'), _buildKey('6')],
                  ),
                  Row(
                    children: [_buildKey('7'), _buildKey('8'), _buildKey('9')],
                  ),
                  Row(
                    children: [
                      _buildKey('.'),
                      _buildKey('0'),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.all(AppSpacing.s4),
                          child: InkWell(
                            onTap: _onBackspace,
                            borderRadius: BorderRadius.circular(16.0),
                            child: Container(
                              height: 54,
                              alignment: Alignment.center,
                              child: const Icon(
                                Icons.backspace_outlined,
                                color: AppColors.textSecondary,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.s12),
                  SizedBox(
                    width: double.infinity,
                    child: PrimaryButton(
                      text: 'Continue',
                      onPressed: parsedAmount > 0.0
                          ? () {
                              final validation = PaymentsValidator.validateAmount(parsedAmount);
                              if (!validation.isValid) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(validation.errorMessage ?? 'Invalid amount.'),
                                    backgroundColor: AppColors.error,
                                  ),
                                );
                                return;
                              }
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ReviewPaymentScreen(
                                    recipientName: widget.recipientName,
                                    recipientDetail: widget.recipientDetail,
                                    recipientType: widget.recipientType,
                                    amount: parsedAmount,
                                    note: _noteController.text,
                                    methodId: _methodId,
                                    methodLabel: _methodLabel,
                                  ),
                                ),
                              );
                            }
                          : null,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
