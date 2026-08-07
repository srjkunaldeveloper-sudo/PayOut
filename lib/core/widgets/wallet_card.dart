import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_card.dart';

class WalletCard extends StatefulWidget {
  final double balance;
  final VoidCallback? onAddMoney;
  final VoidCallback? onSendMoney;
  final VoidCallback? onWithdraw;

  const WalletCard({
    super.key,
    required this.balance,
    this.onAddMoney,
    this.onSendMoney,
    this.onWithdraw,
  });

  @override
  State<WalletCard> createState() => _WalletCardState();
}

class _WalletCardState extends State<WalletCard> {
  bool _isHidden = false;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: AppColors.surface,
      padding: const EdgeInsets.all(AppSpacing.s20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.s8),
                  const Text(
                    'Wallet Balance',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: Icon(
                  _isHidden ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
                onPressed: () {
                  setState(() {
                    _isHidden = !_isHidden;
                  });
                },
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s8),
          Text(
            _isHidden ? '••••••' : '\$${widget.balance.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: _isHidden ? 2.0 : -0.5,
                ),
          ),
          const SizedBox(height: AppSpacing.s20),
          Row(
            children: [
              Expanded(
                child: TextButton.icon(
                  onPressed: widget.onAddMoney,
                  icon: const Icon(Icons.add_rounded, size: 18, color: AppColors.primary),
                  label: const Text(
                    'Add Money',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      fontSize: 13.0,
                      color: AppColors.primary,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: AppColors.primaryLight,
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.s12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.s12),
              Expanded(
                child: TextButton.icon(
                  onPressed: widget.onSendMoney ?? widget.onWithdraw,
                  icon: Icon(
                    widget.onSendMoney != null ? Icons.arrow_outward_rounded : Icons.arrow_downward_rounded,
                    size: 18,
                    color: AppColors.textPrimary,
                  ),
                  label: Text(
                    widget.onSendMoney != null ? 'Send Money' : 'Withdraw',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      fontSize: 13.0,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: AppColors.background,
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.s12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: const BorderSide(color: AppColors.divider, width: 1.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
