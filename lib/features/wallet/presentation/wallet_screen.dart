import 'package:flutter/material.dart';
import 'package:payout/core/di/app_dependencies.dart';
import 'package:payout/core/error/error_message_mapper.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/widgets.dart';
import 'package:payout/features/wallet/constants/wallet_constants.dart';
import 'package:payout/features/wallet/validators/wallet_validator.dart';
import 'package:payout/features/wallet/models/wallet_models.dart';
import 'package:payout/features/wallet/repositories/wallet_repository.dart';
import 'package:payout/features/wallet/services/wallet_logger.dart';

class WalletScreen extends StatefulWidget {
  final WalletRepository? walletRepository;

  const WalletScreen({super.key, this.walletRepository});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  late final WalletRepository _walletRepository;

  WalletModel? _walletModel;
  List<WalletTransactionModel> _transactions = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _walletRepository = widget.walletRepository ?? AppDependencies.instance.walletRepository;
    _loadWalletData();
    WalletLogger.logWalletOpened();
  }

  Future<void> _loadWalletData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final wallet = await _walletRepository.getWallet();
      final txns = await _walletRepository.getTransactions();
      if (mounted) {
        setState(() {
          _walletModel = wallet;
          _transactions = txns;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = ErrorMessageMapper.map(e, fallback: 'Unable to load wallet details.');
          _isLoading = false;
        });
      }
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
                'Top-up Wallet',
                style: AppTypography.headlineSmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.s8),
              Text(
                'Select or enter amount to add to your Payout Wallet.',
                style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: AppSpacing.s24),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Amount (₹)',
                  hintText: 'e.g. 500',
                  prefixIcon: Icon(Icons.currency_rupee, color: AppColors.primary),
                ),
                onChanged: (val) {
                  addedAmount = double.tryParse(val);
                },
              ),
              const SizedBox(height: AppSpacing.s16),
              Wrap(
                spacing: AppSpacing.s8,
                children: WalletConstants.defaultQuickAmounts.map((amt) {
                  return ActionChip(
                    label: Text('+₹$amt'),
                    backgroundColor: AppColors.surface,
                    onPressed: () {
                      addedAmount = amt.toDouble();
                      Navigator.pop(context);
                      _executeTopUp(amt.toDouble());
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: AppSpacing.s24),
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  text: 'Proceed to Pay',
                  onPressed: () {
                    if (addedAmount != null) {
                      Navigator.pop(context);
                      _executeTopUp(addedAmount!);
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

  void _executeTopUp(double amount) async {
    final validation = WalletValidator.validateAddMoney(amount);
    final messenger = ScaffoldMessenger.of(context);

    if (validation.isValid) {
      final success = await _walletRepository.addMoney(amount);
      if (mounted && success) {
        _loadWalletData();
        messenger.showSnackBar(
          SnackBar(
            content: Text('Successfully added ₹${amount.toStringAsFixed(0)} to Wallet!'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } else {
      messenger.showSnackBar(
        SnackBar(
          content: Text(validation.errorMessage ?? 'Invalid top-up amount.'),
          backgroundColor: AppColors.error,
        ),
      );
    }
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
                'Withdraw to Bank',
                style: AppTypography.headlineSmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.s8),
              Text(
                'Transfer balance securely to your primary linked bank account.',
                style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: AppSpacing.s24),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Withdraw Amount (₹)',
                  hintText: 'e.g. 1000',
                  prefixIcon: Icon(Icons.account_balance, color: AppColors.primary),
                ),
                onChanged: (val) {
                  withdrawAmount = double.tryParse(val);
                },
              ),
              const SizedBox(height: AppSpacing.s24),
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  text: 'Withdraw Now',
                  onPressed: () async {
                    final messenger = ScaffoldMessenger.of(context);
                    final validation = WalletValidator.validateWithdraw(
                      withdrawAmount ?? 0,
                      _walletModel?.balance ?? 0,
                    );

                    if (validation.isValid) {
                      final success = await _walletRepository.withdrawMoney(withdrawAmount!);
                      if (!context.mounted) return;
                      if (success) {
                        Navigator.pop(context);
                        _loadWalletData();
                        messenger.showSnackBar(
                          SnackBar(
                            content: Text('Transferred ₹${withdrawAmount!.toStringAsFixed(0)} to Bank!'),
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

    if (_errorMessage != null || _walletModel == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: const CustomAppBar(title: 'Wallet Balance'),
        body: SafeArea(
          child: ErrorState(
            description: _errorMessage ?? 'Unable to load wallet balance.',
            onRetry: _loadWalletData,
          ),
        ),
      );
    }

    final wallet = _walletModel!;

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
                              fontFamily: 'Geist Sans',
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            '₹${wallet.cashbackEarned.toStringAsFixed(0)} earned',
                            style: const TextStyle(
                              fontFamily: 'Geist Sans',
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
                              fontFamily: 'Geist Sans',
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            '8 perks nearby',
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
                ],
              ),
              const SizedBox(height: AppSpacing.s32),
              const Text(
                'Wallet History',
                style: TextStyle(
                  fontFamily: 'Geist Sans',
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.s16),
              if (_transactions.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24.0),
                  child: EmptyState(
                    title: 'No Transactions',
                    description: 'Your recent wallet top-up and withdrawal activity will appear here.',
                    icon: Icons.receipt_long_rounded,
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
