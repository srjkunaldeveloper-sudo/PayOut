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
      color: AppColors.primary,
      borderRadius: AppRadii.cardHero,
      padding: const EdgeInsets.all(AppSpacing.s24),
      hasShadow: true,
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
                      color: AppColors.primaryLight,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.s8),
                  const Text(
                    'Available Balance',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13.0,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryLight,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: Icon(
                  _isHidden ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                  color: AppColors.primaryLight.withOpacity(0.8),
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
            _isHidden ? '••••••' : '₹${widget.balance.toStringAsFixed(0)}', // Muted clean Rupee integer
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 34.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
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
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.bold,
                      fontSize: 13.0,
                      color: AppColors.primary,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.s12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0), // Rounded pill M3 buttons
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
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.bold,
                      fontSize: 13.0,
                      color: Colors.white,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.15),
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.s12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0), // Rounded pill M3 buttons
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
