import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/widgets.dart';
import 'package:payout/features/wallet/constants/wallet_constants.dart';
import 'package:payout/features/wallet/validators/wallet_validator.dart';
import 'package:payout/features/wallet/models/wallet_models.dart';
import 'package:payout/features/wallet/repositories/wallet_repository.dart';
import 'package:payout/features/wallet/services/wallet_logger.dart';
import 'package:payout/features/wallet/dummy/dummy_wallet_data.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final WalletRepository _walletRepository = MockWalletRepository();

  WalletModel? _walletModel;
  List<WalletTransactionModel> _transactions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadWalletData();
    WalletLogger.logWalletOpened();
  }

  Future<void> _loadWalletData() async {
    setState(() {
      _isLoading = true;
    });
    final wallet = await _walletRepository.getWallet();
    final txns = await _walletRepository.getTransactions();
    if (mounted) {
      setState(() {
        _walletModel = wallet;
        _transactions = txns;
        _isLoading = false;
      });
    }
  }

  void _showAddMoneyBottomSheet() {
    double? addedAmount;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadii.bottomSheet)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: AppSpacing.s16,
            left: AppSpacing.s24,
            right: AppSpacing.s24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: const BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.all(Radius.circular(AppRadius.circle)),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.s16),
              Text(
                'Add money to wallet',
                style: AppTypography.headlineSmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.s8),
              Text(
                'Enter the amount to add from your linked account. (Limit: ${WalletConstants.currencySymbol}${WalletConstants.minimumAddMoney} - ${WalletConstants.currencySymbol}${WalletConstants.maximumAddMoney})',
                style: const TextStyle(fontFamily: 'Inter', color: AppColors.textSecondary, fontSize: 13),
              ),
              const SizedBox(height: AppSpacing.s24),
              TextField(
                keyboardType: TextInputType.number,
                autofocus: true,
                onChanged: (val) {
                  addedAmount = double.tryParse(val);
                },
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                decoration: const InputDecoration(
                  prefixText: '₹ ',
                  hintText: '0.00',
                ),
              ),
              const SizedBox(height: AppSpacing.s24),
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  text: 'Add Funds',
                  onPressed: () async {
                    final amount = addedAmount ?? 0.0;
                    final validation = WalletValidator.validateAddMoney(amount);
                    final messenger = ScaffoldMessenger.of(context);

                    if (validation.isValid) {
                      Navigator.pop(context);
                      setState(() {
                        _isLoading = true;
                      });
                      
                      final success = await _walletRepository.addMoney(amount);
                      if (success) {
                        await _loadWalletData();
                        messenger.showSnackBar(
                          SnackBar(
                            content: Text('₹${amount.toStringAsFixed(2)} added to your wallet.'),
                            backgroundColor: AppColors.success,
                          ),
                        );
                      }
                    } else {
                      messenger.showSnackBar(
                        SnackBar(
                          content: Text(validation.errorMessage ?? 'Invalid amount entered.'),
                          backgroundColor: AppColors.error,
                        ),
                      );
                    }
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.s24),
            ],
          ),
        );
      },
    );
  }

  void _showWithdrawBottomSheet() {
    double? withdrawAmount;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadii.bottomSheet)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: AppSpacing.s16,
            left: AppSpacing.s24,
            right: AppSpacing.s24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: const BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.all(Radius.circular(AppRadius.circle)),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.s16),
              Text(
                'Withdraw money to bank',
                style: AppTypography.headlineSmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.s8),
              const Text(
                'Transfer wallet funds back to your linked checking account.',
                style: TextStyle(fontFamily: 'Inter', color: AppColors.textSecondary, fontSize: 13),
              ),
              const SizedBox(height: AppSpacing.s24),
              TextField(
                keyboardType: TextInputType.number,
                autofocus: true,
                onChanged: (val) {
                  withdrawAmount = double.tryParse(val);
                },
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                decoration: const InputDecoration(
                  prefixText: '₹ ',
                  hintText: '0.00',
                ),
              ),
              const SizedBox(height: AppSpacing.s24),
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  text: 'Withdraw Funds',
                  onPressed: () async {
                    final amount = withdrawAmount ?? 0.0;
                    final currentBalance = _walletModel?.balance ?? 0.0;
                    final validation = WalletValidator.validateWithdraw(amount, currentBalance);
                    final messenger = ScaffoldMessenger.of(context);

                    if (validation.isValid) {
                      Navigator.pop(context);
                      setState(() {
                        _isLoading = true;
                      });

                      final success = await _walletRepository.withdrawMoney(amount);
                      if (success) {
                        await _loadWalletData();
                        messenger.showSnackBar(
                          SnackBar(
                            content: Text('₹${amount.toStringAsFixed(2)} transferred to bank account.'),
                            backgroundColor: AppColors.success,
                          ),
                        );
                      }
                    } else {
                      messenger.showSnackBar(
                        SnackBar(
                          content: Text(validation.errorMessage ?? 'Invalid withdrawal amount.'),
                          backgroundColor: AppColors.error,
                        ),
                      );
                    }
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.s24),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading && _walletModel == null) {
      return const Scaffold(
        appBar: CustomAppBar(title: 'Wallet Balance'),
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        ),
      );
    }

    final wallet = _walletModel ?? DummyWalletData.dummyWallet;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Wallet Balance'),
      body: RefreshIndicator(
        onRefresh: _loadWalletData,
        color: AppColors.primary,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppSpacing.s24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              WalletCard(
                balance: wallet.balance,
                linkedBankName: wallet.linkedBank,
                cashbackEarned: wallet.cashbackEarned,
                lastUpdated: wallet.lastUpdated,
                onAddMoney: _showAddMoneyBottomSheet,
                onWithdraw: _showWithdrawBottomSheet,
              ),
              const SizedBox(height: AppSpacing.s32),
              Row(
                children: [
                  Expanded(
                    child: AppCard(
                      padding: const EdgeInsets.all(AppSpacing.s16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.workspace_premium_rounded, color: AppColors.warning, size: 24),
                          const SizedBox(height: AppSpacing.s8),
                          const Text(
                            'Cashback',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            '₹${wallet.cashbackEarned.toStringAsFixed(0)} earned',
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12.0,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.s16),
                  Expanded(
                    child: AppCard(
                      padding: const EdgeInsets.all(AppSpacing.s16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Icon(Icons.percent_rounded, color: AppColors.success, size: 24),
                          SizedBox(height: AppSpacing.s8),
                          Text(
                            'Active Offers',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            '8 perks nearby',
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
                ],
              ),
              const SizedBox(height: AppSpacing.s32),
              const Text(
                'Wallet History',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.s16),
              if (_transactions.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 32.0),
                    child: Text(
                      'No transactions yet.',
                      style: TextStyle(fontFamily: 'Inter', color: AppColors.textSecondary),
                    ),
                  ),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _transactions.length,
                  separatorBuilder: (context, index) => const Divider(color: AppColors.divider),
                  itemBuilder: (context, index) {
                    final tx = _transactions[index];
                    return TransactionTile(
                      title: tx.title,
                      subtitle: tx.subtitle,
                      date: tx.date,
                      amount: tx.amount,
                      isCredit: tx.isCredit,
                    );
                  },
                ),
              const SizedBox(height: AppSpacing.s24),
            ],
          ),
        ),
      ),
    );
  }
}
