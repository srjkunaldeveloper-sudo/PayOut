import 'package:flutter/material.dart';
import 'package:payout/core/error/error_message_mapper.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/widgets.dart';
import 'package:payout/features/bank_accounts/models/bank_account_models.dart';
import 'package:payout/features/bank_accounts/services/bank_account_service.dart';
import 'package:payout/features/bank_accounts/presentation/link_bank_flow.dart';
import 'package:payout/features/payments/presentation/amount_entry_screen.dart';

class BankAccountsScreen extends StatefulWidget {
  final BankAccountService? bankAccountService;

  const BankAccountsScreen({super.key, this.bankAccountService});

  @override
  State<BankAccountsScreen> createState() => _BankAccountsScreenState();
}

class _BankAccountsScreenState extends State<BankAccountsScreen> {
  late final BankAccountService _bankAccountService;
  List<LinkedBankAccountModel> _linkedAccounts = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _bankAccountService = widget.bankAccountService ?? BankAccountService();
    _loadLinkedAccounts();
  }

  Future<void> _loadLinkedAccounts() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final accounts = await _bankAccountService.getLinkedAccounts();
      if (mounted) {
        setState(() {
          _linkedAccounts = accounts;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = ErrorMessageMapper.map(e, fallback: 'Unable to load linked bank accounts.');
          _isLoading = false;
        });
      }
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
      MaterialPageRoute(builder: (context) => LinkBankFlow(bankAccountService: _bankAccountService)),
    );

    if (result == true) {
      _loadLinkedAccounts();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        appBar: CustomAppBar(title: 'Bank Accounts'),
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        ),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: const CustomAppBar(title: 'Bank Accounts'),
        body: SafeArea(
          child: ErrorState(
            description: _errorMessage!,
            onRetry: _loadLinkedAccounts,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Bank Accounts'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24, vertical: AppSpacing.s12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Linked Bank Accounts',
              style: TextStyle(
                fontFamily: 'Geist Sans',
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.s16),
            if (_linkedAccounts.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24.0),
                child: EmptyState(
                  title: 'No Linked Accounts',
                  description: 'Add a bank account to enable direct payouts and transfers.',
                  icon: Icons.account_balance_rounded,
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
                            bank.bankName.isNotEmpty ? bank.bankName.substring(0, 1) : 'B',
                            style: const TextStyle(
                              fontFamily: 'Geist Sans',
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
                                      fontFamily: 'Geist Sans',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                  if (bank.isDefault) ...[
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: AppColors.success.withValues(alpha: 0.08),
                                        borderRadius: BorderRadius.circular(AppRadius.xs),
                                      ),
                                      child: const Text(
                                        'PRIMARY',
                                        style: TextStyle(
                                          fontFamily: 'Geist Sans',
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
                                  fontFamily: 'Geist Sans',
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
              }),
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
