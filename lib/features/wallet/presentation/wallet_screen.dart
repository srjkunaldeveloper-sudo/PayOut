import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/app_button.dart';
import 'package:payout/core/widgets/app_card.dart';
import 'package:payout/core/widgets/transaction_tile.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  double _walletBalance = 1250.75;

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
            top: AppSpacing.s24,
            left: AppSpacing.s24,
            right: AppSpacing.s24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add money to wallet',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 20.0),
              ),
              const SizedBox(height: AppSpacing.s8),
              const Text(
                'Enter the amount to add from your linked account.',
                style: TextStyle(fontFamily: 'Inter', color: AppColors.textSecondary, fontSize: 13),
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
                  prefixText: '\$ ',
                  hintText: '0.00',
                ),
              ),
              const SizedBox(height: AppSpacing.s24),
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  text: 'Add Funds',
                  onPressed: () {
                    if (addedAmount != null && addedAmount! > 0) {
                      setState(() {
                        _walletBalance += addedAmount!;
                      });
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('\$${addedAmount!.toStringAsFixed(2)} added to your wallet.'),
                          backgroundColor: AppColors.success,
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
            top: AppSpacing.s24,
            left: AppSpacing.s24,
            right: AppSpacing.s24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Withdraw money to bank',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 20.0),
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
                  prefixText: '\$ ',
                  hintText: '0.00',
                ),
              ),
              const SizedBox(height: AppSpacing.s24),
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  text: 'Withdraw Funds',
                  onPressed: () {
                    if (withdrawAmount != null && withdrawAmount! > 0 && withdrawAmount! <= _walletBalance) {
                      setState(() {
                        _walletBalance -= withdrawAmount!;
                      });
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('\$${withdrawAmount!.toStringAsFixed(2)} transferred to bank account.'),
                          backgroundColor: AppColors.success,
                        ),
                      );
                    } else if (withdrawAmount != null && withdrawAmount! > _walletBalance) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Insufficient balance in your Payout wallet.'),
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
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Wallet Balance'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.s24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.s24),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(AppRadii.card),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Available Cash',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryLight,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s8),
                  Text(
                    '\$${_walletBalance.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold,
                      color: AppColors.background,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s24),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton.icon(
                          onPressed: _showAddMoneyBottomSheet,
                          icon: const Icon(Icons.add_rounded, size: 18, color: AppColors.primary),
                          label: const Text(
                            'Add Funds',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                              color: AppColors.primary,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            backgroundColor: AppColors.background,
                            padding: const EdgeInsets.symmetric(vertical: AppSpacing.s12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.s12),
                      Expanded(
                        child: TextButton.icon(
                          onPressed: _showWithdrawBottomSheet,
                          icon: const Icon(Icons.arrow_downward_rounded, size: 18, color: AppColors.background),
                          label: const Text(
                            'Withdraw',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                              color: AppColors.background,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            backgroundColor: AppColors.background.withOpacity(0.15),
                            padding: const EdgeInsets.symmetric(vertical: AppSpacing.s12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.s32),
            Row(
              children: [
                Expanded(
                  child: AppCard(
                    padding: const EdgeInsets.all(AppSpacing.s16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Icon(Icons.workspace_premium_rounded, color: AppColors.warning, size: 24),
                        SizedBox(height: AppSpacing.s8),
                        Text(
                          'Cashback',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          '\$142.50 earned',
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
            TransactionTile(
              title: 'Added via Bank Account',
              subtitle: 'Wallet Load',
              date: 'Aug 07, 2026',
              amount: 500.00,
              isCredit: true,
            ),
            const Divider(color: AppColors.divider),
            TransactionTile(
              title: 'Transfer to John Doe',
              subtitle: 'Wallet Debit',
              date: 'Aug 05, 2026',
              amount: 45.00,
              isCredit: false,
            ),
            const Divider(color: AppColors.divider),
            TransactionTile(
              title: 'Cashback Received',
              subtitle: 'Promo Reward',
              date: 'Jul 28, 2026',
              amount: 15.00,
              isCredit: true,
            ),
            const SizedBox(height: AppSpacing.s24),
          ],
        ),
      ),
    );
  }
}
