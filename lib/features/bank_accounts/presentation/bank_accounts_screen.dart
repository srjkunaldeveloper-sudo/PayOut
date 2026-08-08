import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/widgets.dart';
import 'package:payout/features/bank_accounts/models/bank_account_models.dart';
import 'package:payout/features/bank_accounts/services/bank_account_service.dart';
import 'package:payout/features/bank_accounts/presentation/link_bank_flow.dart';
import 'package:payout/features/payments/presentation/amount_entry_screen.dart';

class BankAccountsScreen extends StatefulWidget {
  const BankAccountsScreen({super.key});

  @override
  State<BankAccountsScreen> createState() => _BankAccountsScreenState();
}

class _BankAccountsScreenState extends State<BankAccountsScreen> {
  final BankAccountService _bankAccountService = BankAccountService();
  List<LinkedBankAccountModel> _linkedAccounts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLinkedAccounts();
  }

  Future<void> _loadLinkedAccounts() async {
    setState(() {
      _isLoading = true;
    });
    final accounts = await _bankAccountService.getLinkedAccounts();
    if (mounted) {
      setState(() {
        _linkedAccounts = accounts;
        _isLoading = false;
      });
    }
  }

  void _unlinkAccount(String accountId) async {
    final ok = await _bankAccountService.unlinkAccount(accountId);
    if (ok) {
      _loadLinkedAccounts();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bank account unlinked successfully.'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  void _navigateToLinkBank() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LinkBankFlow()),
    );

    if (result == true) {
      _loadLinkedAccounts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Bank Accounts'),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24, vertical: AppSpacing.s12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Linked Bank Accounts',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s16),
                  if (_linkedAccounts.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24.0),
                      child: Center(
                        child: Text(
                          'No linked bank accounts. Click below to add.',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      ),
                    )
                  else
                    ..._linkedAccounts.map((bank) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.s12),
                        child: AppCard(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AmountEntryScreen(
                                  recipientName: bank.bankName,
                                  recipientDetail: bank.maskedAccountNumber,
                                  recipientType: 'Bank',
                                ),
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: const BoxDecoration(
                                  color: AppColors.primaryContainer,
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  bank.bankName.substring(0, 1),
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              const SizedBox(width: AppSpacing.s16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          bank.bankName,
                                          style: const TextStyle(
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.0,
                                          ),
                                        ),
                                        if (bank.isDefault) ...[
                                          const SizedBox(width: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: AppColors.success.withOpacity(0.08),
                                              borderRadius: BorderRadius.circular(AppRadius.xs),
                                            ),
                                            child: const Text(
                                              'PRIMARY',
                                              style: TextStyle(
                                                fontFamily: 'Inter',
                                                fontSize: 8,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.success,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Savings ${bank.maskedAccountNumber}',
                                      style: const TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 12.0,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.remove_circle_outline_rounded, color: AppColors.error, size: 20),
                                onPressed: () => _unlinkAccount(bank.id),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  const SizedBox(height: AppSpacing.s24),
                  OutlinedButtonV2(
                    text: 'Add New Bank Account',
                    iconLeft: Icons.add_rounded,
                    onPressed: _navigateToLinkBank,
                  ),
                ],
              ),
            ),
    );
  }
}
