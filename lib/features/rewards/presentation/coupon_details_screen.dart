import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/widgets.dart';
import 'package:payout/core/di/app_dependencies.dart';
import 'package:payout/features/rewards/models/reward_models.dart';
import 'package:payout/features/rewards/repositories/reward_repository.dart';

class CouponDetailsScreen extends StatefulWidget {
  final CouponModel coupon;
  final RewardRepository? rewardRepository;

  const CouponDetailsScreen({
    super.key,
    required this.coupon,
    this.rewardRepository,
  });

  @override
  State<CouponDetailsScreen> createState() => _CouponDetailsScreenState();
}

class _CouponDetailsScreenState extends State<CouponDetailsScreen> {
  late final RewardRepository _rewardRepo;
  bool _isRedeeming = false;

  @override
  void initState() {
    super.initState();
    _rewardRepo = widget.rewardRepository ?? AppDependencies.instance.rewardRepository;
  }

  void _copyPromoCode() {
    Clipboard.setData(ClipboardData(text: widget.coupon.code));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Promo Code "${widget.coupon.code}" copied to clipboard!'),
        backgroundColor: AppColors.success,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _redeemCoupon() async {
    setState(() {
      _isRedeeming = true;
    });

    final success = await _rewardRepo.redeemCoupon(widget.coupon.id);

    if (mounted) {
      setState(() {
        _isRedeeming = false;
      });

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Coupon code "${widget.coupon.code}" activated! Ready to use on checkout.'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final coupon = widget.coupon;
    final discountStr = coupon.discountType.toUpperCase() == 'FLAT'
        ? '₹${coupon.discountValue.toInt()} FLAT OFF'
        : '${coupon.discountValue.toInt()}% INSTANT OFF';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Coupon Details'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.s24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Coupon Hero Card
              AppCard(
                color: AppColors.primary,
                borderRadius: AppRadii.cardHero,
                padding: const EdgeInsets.all(AppSpacing.s24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            coupon.category.toUpperCase(),
                            style: const TextStyle(fontFamily: 'Geist Sans', fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                        Text(
                          'Valid till ${coupon.validUntil}',
                          style: const TextStyle(fontFamily: 'Geist Sans', fontSize: 11, color: AppColors.primaryLight),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      discountStr,
                      style: const TextStyle(
                        fontFamily: 'Geist Sans',
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      coupon.title,
                      style: const TextStyle(fontFamily: 'Geist Sans', fontSize: 14, color: AppColors.primaryLight, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 16),
                    const Divider(color: Colors.white24),
                    const SizedBox(height: 12),
                    // Promo Code Box
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('PROMO CODE', style: TextStyle(fontFamily: 'Geist Sans', fontSize: 9, color: AppColors.textSecondary, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 2),
                              Text(coupon.code, style: const TextStyle(fontFamily: 'Geist Sans', fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary, letterSpacing: 1.5)),
                            ],
                          ),
                          TextButton.icon(
                            onPressed: _copyPromoCode,
                            icon: const Icon(Icons.copy_rounded, size: 16, color: AppColors.primary),
                            label: const Text('COPY', style: TextStyle(fontFamily: 'Geist Sans', fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.primary)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.s24),

              // Offer Description & Terms
              const Text(
                'Offer Breakdown',
                style: TextStyle(fontFamily: 'Geist Sans', fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: AppSpacing.s12),
              AppCard(
                padding: const EdgeInsets.all(AppSpacing.s16),
                child: Column(
                  children: [
                    _buildRow('Description', coupon.description),
                    const Divider(color: AppColors.divider),
                    _buildRow('Minimum Transaction', '₹${coupon.minimumSpend.toStringAsFixed(0)}'),
                    const Divider(color: AppColors.divider),
                    _buildRow('Maximum Discount', '₹${coupon.maximumDiscount.toStringAsFixed(0)}'),
                    const Divider(color: AppColors.divider),
                    _buildRow('Validity Period', '${coupon.validFrom} – ${coupon.validUntil}'),
                    const Divider(color: AppColors.divider),
                    _buildRow('Usage Limit', '${coupon.usageLimit} Redemption per customer'),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.s24),

              // How to Redeem
              const Text(
                'How to Redeem',
                style: TextStyle(fontFamily: 'Geist Sans', fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: AppSpacing.s12),
              AppCard(
                padding: const EdgeInsets.all(AppSpacing.s16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('1. Copy the promo code using the COPY button above.', style: TextStyle(fontFamily: 'Geist Sans', fontSize: 12, height: 1.4)),
                    SizedBox(height: 8),
                    Text('2. Make a payment or booking matching the minimum spend criteria.', style: TextStyle(fontFamily: 'Geist Sans', fontSize: 12, height: 1.4)),
                    SizedBox(height: 8),
                    Text('3. Paste the code in the "Apply Coupon" field on the payment checkout screen.', style: TextStyle(fontFamily: 'Geist Sans', fontSize: 12, height: 1.4)),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.s32),

              // Actions
              PrimaryButton(
                text: _isRedeeming ? 'Redeeming...' : 'Redeem Coupon Code',
                isLoading: _isRedeeming,
                onPressed: _isRedeeming ? null : _redeemCoupon,
              ),
              const SizedBox(height: AppSpacing.s16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontFamily: 'Geist Sans', fontSize: 12, color: AppColors.textSecondary)),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontFamily: 'Geist Sans', fontSize: 12, fontWeight: FontWeight.w600),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
