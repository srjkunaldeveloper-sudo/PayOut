import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/widgets.dart';
import 'package:payout/features/bank_accounts/models/bank_account_models.dart';
import 'package:payout/features/bank_accounts/repositories/bank_account_repository.dart';
import 'package:payout/features/merchant/repositories/merchant_repository.dart';
import 'package:payout/features/merchant/validators/merchant_validator.dart';
import 'package:payout/features/payments/presentation/mpin_verification_screen.dart';

class MerchantSettlementScreen extends StatefulWidget {
  final MerchantRepository? merchantRepository;
  final BankAccountRepository? bankAccountRepository;

  const MerchantSettlementScreen({
    super.key,
    this.merchantRepository,
    this.bankAccountRepository,
  });

  @override
  State<MerchantSettlementScreen> createState() => _MerchantSettlementScreenState();
}

class _MerchantSettlementScreenState extends State<MerchantSettlementScreen> {
  late final MerchantRepository _merchantRepo;
  late final BankAccountRepository _bankAccountRepo;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  List<LinkedBankAccountModel> _bankAccounts = [];
  LinkedBankAccountModel? _selectedBank;
  double _availableBalance = 0.0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _merchantRepo = widget.merchantRepository ?? MockMerchantRepository();
    _bankAccountRepo = widget.bankAccountRepository ?? MockBankAccountRepository();
    _loadSettlementData();
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _loadSettlementData() async {
    try {
      final list = await _bankAccountRepo.getLinkedAccounts();
      final balance = await _merchantRepo.getAvailableSettlementBalance();
      if (mounted) {
        setState(() {
          _bankAccounts = list;
          _availableBalance = balance;
          if (list.isNotEmpty) {
            _selectedBank = list.firstWhere((b) => b.isDefault, orElse: () => list.first);
          }
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _onQuickAmountSelected(double val) {
    setState(() {
      _amountController.text = val.toInt().toString();
    });
  }

  void _showReviewBottomSheet() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedBank == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a linked bank account for settlement deposit.')),
      );
      return;
    }

    final amount = double.parse(_amountController.text.trim());
    final bankInfo = '${_selectedBank!.bankName} (${_selectedBank!.maskedAccountNumber})';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(AppSpacing.s24),
          child: SingleChildScrollView(
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
                const SizedBox(height: AppSpacing.s16),
                const Text('Review Settlement Request', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                const Text('Transfer outstanding merchant sales to your bank account.', style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.textSecondary)),
                const SizedBox(height: AppSpacing.s16),
                AppCard(
                  padding: const EdgeInsets.all(AppSpacing.s16),
                  child: Column(
                    children: [
                      _buildReviewRow('Settlement Amount', '₹${amount.toStringAsFixed(2)}', isTotal: true),
                      const Divider(color: AppColors.divider),
                      _buildReviewRow('Destination Bank', bankInfo),
                      const Divider(color: AppColors.divider),
                      _buildReviewRow('Processing Mode', 'IMPS Instant Sweep'),
                      const Divider(color: AppColors.divider),
                      _buildReviewRow('Processing Fee', 'FREE (₹0.00)'),
                      const Divider(color: AppColors.divider),
                      _buildReviewRow('Net Amount to Receive', '₹${amount.toStringAsFixed(2)}'),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.s20),
                PrimaryButton(
                  text: 'Authorize Settlement via MPIN',
                  onPressed: () {
                    Navigator.pop(modalContext);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) => PaymentMPINVerificationScreen(
                          recipientName: 'Merchant Bank Settlement',
                          recipientDetail: bankInfo,
                          recipientType: 'Settlement',
                          amount: amount,
                          note: 'Merchant Settlement Sweep',
                          methodId: 'bank_settlement',
                          onSuccess: () async {
                            final success = await _merchantRepo.requestSettlement(
                              amount: amount,
                              bankAccountId: bankInfo,
                            );

                            if (mounted) {
                              if (success) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Settlement of ₹${amount.toStringAsFixed(2)} initiated successfully to $bankInfo!'),
                                    backgroundColor: AppColors.success,
                                  ),
                                );
                                Navigator.pop(context, true);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Settlement request failed. Please check balance and try again.'),
                                    backgroundColor: AppColors.error,
                                  ),
                                );
                              }
                            }
                          },
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildReviewRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontFamily: 'Inter', fontSize: isTotal ? 13 : 12, fontWeight: isTotal ? FontWeight.bold : FontWeight.normal, color: isTotal ? AppColors.textPrimary : AppColors.textSecondary)),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(fontFamily: 'Inter', fontSize: isTotal ? 15 : 12, fontWeight: isTotal ? FontWeight.bold : FontWeight.w600, color: isTotal ? AppColors.primary : AppColors.textPrimary),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final balance = _availableBalance;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Settlement & Instant Sweep'),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary)))
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.s24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Available Balance Card
                      AppCard(
                        color: AppColors.primary,
                        borderRadius: AppRadii.cardHero,
                        padding: const EdgeInsets.all(AppSpacing.s20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Available Settlement Balance',
                              style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.primaryLight),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '₹${balance.toStringAsFixed(2)}',
                              style: const TextStyle(fontFamily: 'Inter', fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Funds collected via Store QR & Customer Payments ready for transfer.',
                              style: TextStyle(fontFamily: 'Inter', fontSize: 11, color: AppColors.primaryLight),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.s24),

                      // Destination Bank Account
                      const Text(
                        'Destination Bank Account',
                        style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      const SizedBox(height: AppSpacing.s12),
                      if (_bankAccounts.isEmpty)
                        AppCard(
                          child: Row(
                            children: const [
                              Icon(Icons.account_balance_rounded, color: AppColors.primary),
                              SizedBox(width: 12),
                              Expanded(
                                child: Text('No linked bank account found. Link an account to settle.', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 13)),
                              ),
                            ],
                          ),
                        )
                      else
                        ..._bankAccounts.map(
                          (bank) {
                            final isSelected = _selectedBank?.id == bank.id;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: AppSpacing.s8),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    _selectedBank = bank;
                                  });
                                },
                                borderRadius: BorderRadius.circular(AppRadius.md),
                                child: AppCard(
                                  color: isSelected ? AppColors.primaryLight.withValues(alpha: 0.3) : AppColors.surface,
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: AppColors.primary.withValues(alpha: 0.1),
                                          shape: BoxShape.circle,
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          bank.bankName.isNotEmpty ? bank.bankName[0] : 'B',
                                          style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, color: AppColors.primary),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(bank.bankName, style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 13)),
                                            const SizedBox(height: 2),
                                            Text('IFSC: ${bank.ifsc} • ${bank.maskedAccountNumber}', style: const TextStyle(fontFamily: 'Inter', fontSize: 11, color: AppColors.textSecondary)),
                                          ],
                                        ),
                                      ),
                                      Icon(
                                        isSelected ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                                        color: isSelected ? AppColors.primary : AppColors.textSecondary,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      const SizedBox(height: AppSpacing.s24),

                      // Settlement Amount
                      const Text(
                        'Settlement Amount',
                        style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      const SizedBox(height: AppSpacing.s12),
                      TextFormField(
                        controller: _amountController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Enter amount (Min ₹100)',
                          prefixIcon: const Icon(Icons.currency_rupee_rounded, color: AppColors.primary),
                          filled: true,
                          fillColor: AppColors.surface,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppRadius.md),
                            borderSide: const BorderSide(color: AppColors.divider),
                          ),
                        ),
                        validator: (val) {
                          final parsed = double.tryParse(val ?? '');
                          final result = MerchantValidator.validateSettlementAmount(parsed, availableBalance: balance);
                          return result.isValid ? null : result.errorMessage;
                        },
                      ),
                      const SizedBox(height: AppSpacing.s12),

                      // Quick Amount Chips
                      Wrap(
                        spacing: 8,
                        children: [
                          _buildQuickAmountChip('₹5,000', 5000.0),
                          _buildQuickAmountChip('₹10,000', 10000.0),
                          _buildQuickAmountChip('₹25,000', 25000.0),
                          if (balance > 0) _buildQuickAmountChip('All Balance', balance),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.s32),

                      // Proceed Button
                      PrimaryButton(
                        text: 'Review Settlement',
                        onPressed: _showReviewBottomSheet,
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildQuickAmountChip(String label, double amount) {
    return ActionChip(
      label: Text(label, style: const TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary)),
      backgroundColor: AppColors.primaryLight.withValues(alpha: 0.5),
      onPressed: () => _onQuickAmountSelected(amount),
    );
  }
}
