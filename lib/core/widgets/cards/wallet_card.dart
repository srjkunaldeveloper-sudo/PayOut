import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/cards/app_card.dart';

class WalletCard extends StatefulWidget {
  final double balance;
  final VoidCallback? onAddMoney;
  final VoidCallback? onSendMoney;
  final VoidCallback? onWithdraw;
  final String? linkedBankName;
  final double? cashbackEarned;
  final String? lastUpdated;

  const WalletCard({
    super.key,
    required this.balance,
    this.onAddMoney,
    this.onSendMoney,
    this.onWithdraw,
    this.linkedBankName,
    this.cashbackEarned,
    this.lastUpdated,
  });

  @override
  State<WalletCard> createState() => _WalletCardState();
}

class _WalletCardState extends State<WalletCard> {
  bool _isHidden = false;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: AppColors.primary,
      borderRadius: AppRadius.xxl,
      padding: const EdgeInsets.all(AppSpacing.s24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryContainer,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.s8),
                  const Text(
                    'Available Balance',
                    style: TextStyle(
                      fontFamily: 'Geist Sans',
                      fontSize: 13.0,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryContainer,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: Icon(
                  _isHidden ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                  color: AppColors.primaryContainer.withValues(alpha: 0.8),
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                _isHidden ? '••••••' : '₹${widget.balance.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontFamily: 'Geist Sans',
                  fontSize: 34.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
              if (!_isHidden) ...[
                const SizedBox(width: AppSpacing.s4),
                const Text(
                  '.75',
                  style: TextStyle(
                    fontFamily: 'Geist Sans',
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white70,
                  ),
                ),
              ],
            ],
          ),
          
          // Custom indicators row (Bank, Cashback, Last updated)
          if (widget.linkedBankName != null || widget.cashbackEarned != null || widget.lastUpdated != null) ...[
            const SizedBox(height: AppSpacing.s16),
            const Divider(color: Colors.white24, height: 1),
            const SizedBox(height: AppSpacing.s12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (widget.linkedBankName != null)
                  Flexible(
                    flex: 2,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.account_balance_rounded, color: Colors.white70, size: 12),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            widget.linkedBankName!,
                            style: const TextStyle(
                              fontFamily: 'Geist Sans',
                              fontSize: 10.0,
                              color: Colors.white70,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                if (widget.cashbackEarned != null) ...[
                  const SizedBox(width: 8),
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white12,
                        borderRadius: BorderRadius.circular(AppRadius.xs),
                      ),
                      child: Text(
                        '₹${widget.cashbackEarned!.toStringAsFixed(0)} Cashback',
                        style: const TextStyle(
                          fontFamily: 'Geist Sans',
                          fontSize: 9.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
                if (widget.lastUpdated != null) ...[
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      widget.lastUpdated!,
                      style: const TextStyle(
                        fontFamily: 'Geist Sans',
                        fontSize: 10.0,
                        color: Colors.white60,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ],
            ),
          ],
          
          const SizedBox(height: AppSpacing.s24),
          Row(
            children: [
              Expanded(
                child: TextButton.icon(
                  onPressed: widget.onAddMoney,
                  icon: const Icon(Icons.add_rounded, size: 18, color: AppColors.primary),
                  label: const Text(
                    'Add Money',
                    style: TextStyle(
                      fontFamily: 'Geist Sans',
                      fontWeight: FontWeight.bold,
                      fontSize: 13.0,
                      color: AppColors.primary,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.s12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.circle),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.s12),
              Expanded(
                child: TextButton.icon(
                  onPressed: widget.onSendMoney ?? widget.onWithdraw,
                  icon: const Icon(
                    Icons.arrow_outward_rounded,
                    size: 18,
                    color: Colors.white,
                  ),
                  label: Text(
                    widget.onSendMoney != null ? 'Send Money' : 'Withdraw',
                    style: const TextStyle(
                      fontFamily: 'Geist Sans',
                      fontWeight: FontWeight.bold,
                      fontSize: 13.0,
                      color: Colors.white,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white.withValues(alpha: 0.15),
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.s12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.circle),
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
