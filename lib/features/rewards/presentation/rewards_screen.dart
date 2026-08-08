import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/app_card.dart';
import 'package:payout/features/rewards/constants/reward_constants.dart';
import 'package:payout/features/rewards/models/reward_models.dart';
import 'package:payout/features/rewards/repositories/reward_repository.dart';
import 'package:payout/features/rewards/services/reward_service.dart';
import 'package:payout/features/rewards/presentation/scratch_card_screen.dart';
import 'package:payout/features/rewards/presentation/coupon_details_screen.dart';
import 'package:payout/features/rewards/presentation/cashback_history_screen.dart';

class RewardsScreen extends StatefulWidget {
  final RewardRepository? rewardRepository;

  const RewardsScreen({
    super.key,
    this.rewardRepository,
  });

  @override
  State<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen> {
  late final RewardRepository _rewardRepo;
  RewardSummaryModel? _summary;
  List<ScratchCardModel> _scratchCards = [];
  List<CouponModel> _coupons = [];
  List<CashbackModel> _recentCashbacks = [];
  bool _isLoading = true;
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    _rewardRepo = widget.rewardRepository ?? MockRewardRepository();
    _loadRewards();
  }

  Future<void> _loadRewards() async {
    final summary = await _rewardRepo.getRewardSummary();
    final scratchCards = await _rewardRepo.getScratchCards();
    final coupons = await _rewardRepo.getCoupons();
    final cashbacks = await _rewardRepo.getCashbackHistory();

    if (mounted) {
      setState(() {
        _summary = summary;
        _scratchCards = scratchCards;
        _coupons = coupons;
        _recentCashbacks = cashbacks.take(3).toList();
        _isLoading = false;
      });
    }
  }

  void _copyCode(String code) {
    Clipboard.setData(ClipboardData(text: code));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Promo Code "$code" copied to clipboard!'),
        backgroundColor: AppColors.success,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        appBar: CustomAppBar(title: 'Rewards & Cashback', showLeading: false),
        body: Center(
          child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary)),
        ),
      );
    }

    final summary = _summary ?? RewardService.calculateRewardSummary(_recentCashbacks, _coupons);
    final filteredCoupons = RewardService.filterCoupons(_coupons, category: _selectedCategory);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Rewards & Cashback', showLeading: false),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.s24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cashback Summary Hero Card
            AppCard(
              color: AppColors.primary,
              borderRadius: AppRadii.cardHero,
              padding: const EdgeInsets.all(AppSpacing.s20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Lifetime Cashback Earned',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12.0,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primaryLight,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CashbackHistoryScreen(rewardRepository: _rewardRepo),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Text(
                                'History',
                                style: TextStyle(fontFamily: 'Inter', fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                              SizedBox(width: 4),
                              Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 10),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '₹${summary.totalCashback.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                      color: AppColors.background,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Divider(color: Colors.white24, height: 1),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Available Balance', style: TextStyle(fontFamily: 'Inter', fontSize: 10, color: AppColors.primaryLight)),
                          const SizedBox(height: 2),
                          Text('₹${summary.availableCashback.toStringAsFixed(2)}', style: const TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Pending Clearance', style: TextStyle(fontFamily: 'Inter', fontSize: 10, color: AppColors.primaryLight)),
                          const SizedBox(height: 2),
                          Text('₹${summary.pendingCashback.toStringAsFixed(2)}', style: const TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text('Active Coupons', style: TextStyle(fontFamily: 'Inter', fontSize: 10, color: AppColors.primaryLight)),
                          const SizedBox(height: 2),
                          Text('${summary.totalCoupons} Coupons', style: const TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.s24),

            // Mystery Scratch Cards Carousel
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Mystery Scratch Cards',
                  style: TextStyle(fontFamily: 'Inter', fontSize: 15.0, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                Text(
                  '${_scratchCards.where((c) => c.status.toUpperCase() == 'UNSCRATCHED').length} Unopened',
                  style: const TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.s12),
            SizedBox(
              height: 140,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _scratchCards.length,
                itemBuilder: (context, index) {
                  final card = _scratchCards[index];
                  final isUnscratched = card.status.toUpperCase() == 'UNSCRATCHED';

                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: InkWell(
                      onTap: () async {
                        final updated = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ScratchCardScreen(
                              card: card,
                              rewardRepository: _rewardRepo,
                            ),
                          ),
                        );
                        if (updated == true) {
                          _loadRewards();
                        }
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        width: 130,
                        padding: const EdgeInsets.all(AppSpacing.s12),
                        decoration: BoxDecoration(
                          gradient: isUnscratched
                              ? const LinearGradient(
                                  colors: [Color(0xFF2A5298), Color(0xFF1E3C72)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )
                              : const LinearGradient(
                                  colors: [Color(0xFFFFF9E6), Color(0xFFFFEDBA)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isUnscratched ? Colors.white24 : Colors.amber,
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: (isUnscratched ? AppColors.primary : Colors.amber).withValues(alpha: 0.15),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              isUnscratched ? Icons.touch_app_rounded : Icons.stars_rounded,
                              color: isUnscratched ? Colors.white : Colors.amber,
                              size: 28,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              isUnscratched ? 'SCRATCH' : '₹${card.rewardValue.toInt()}',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.bold,
                                fontSize: isUnscratched ? 12 : 16,
                                color: isUnscratched ? Colors.white : const Color(0xFF5A4400),
                                letterSpacing: isUnscratched ? 1.0 : 0.0,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              isUnscratched ? 'Mystery Prize' : 'Cashback Won',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 9,
                                color: isUnscratched ? Colors.white70 : const Color(0xFF8A6D00),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: AppSpacing.s24),

            // Referral Card
            AppCard(
              color: AppColors.surface,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Invite Friends, Get ₹150',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Receive ₹150 cashback reward after their first bank transfer.',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.s12),
                  IconButton(
                    icon: const Icon(Icons.share_rounded, color: AppColors.primary),
                    onPressed: () {
                      _copyCode('https://payout.app/invite/user123');
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.s24),

            // Category Filter Chips for Coupons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'My Active Coupons',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.s8),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: RewardConstants.couponCategories.map((cat) {
                  final isSelected = _selectedCategory == cat;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(cat, style: TextStyle(fontFamily: 'Inter', fontSize: 11, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                      selected: isSelected,
                      selectedColor: AppColors.primary,
                      labelStyle: TextStyle(color: isSelected ? Colors.white : AppColors.textPrimary),
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _selectedCategory = cat;
                          });
                        }
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: AppSpacing.s12),

            // Filtered Coupons List
            if (filteredCoupons.isEmpty)
              AppCard(
                padding: const EdgeInsets.all(AppSpacing.s16),
                child: Center(
                  child: Text('No coupons available in $_selectedCategory category.', style: const TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.textSecondary)),
                ),
              )
            else
              ...filteredCoupons.map((coupon) {
                final discountLabel = coupon.discountType.toUpperCase() == 'FLAT'
                    ? '₹${coupon.discountValue.toInt()} OFF'
                    : '${coupon.discountValue.toInt()}% OFF';

                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.s12),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CouponDetailsScreen(
                            coupon: coupon,
                            rewardRepository: _rewardRepo,
                          ),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    child: AppCard(
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(AppSpacing.s10),
                            decoration: BoxDecoration(
                              color: AppColors.primaryLight,
                              borderRadius: BorderRadius.circular(AppRadii.cardSmall),
                            ),
                            child: const Icon(Icons.percent_rounded, color: AppColors.primary, size: 22),
                          ),
                          const SizedBox(width: AppSpacing.s12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        coupon.title,
                                        style: const TextStyle(
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13.0,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: AppColors.success.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        discountLabel,
                                        style: const TextStyle(fontFamily: 'Inter', fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.success),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Code: ${coupon.code}',
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 11.0,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Expires ${coupon.validUntil}',
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 10.0,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: AppSpacing.s8),
                          TextButton(
                            onPressed: () => _copyCode(coupon.code),
                            style: TextButton.styleFrom(
                              backgroundColor: AppColors.primaryLight,
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadii.button)),
                            ),
                            child: const Text(
                              'COPY',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            const SizedBox(height: AppSpacing.s24),

            // Reward History Preview
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent Cashback History',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CashbackHistoryScreen(rewardRepository: _rewardRepo),
                      ),
                    );
                  },
                  child: const Text('View All', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.primary)),
                ),
              ],
            ),
            const SizedBox(height: 4),

            ..._recentCashbacks.map((rew) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.s8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            rew.source,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            rew.earnedAt,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '+₹${rew.amount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: AppColors.success,
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: AppSpacing.s32),
          ],
        ),
      ),
    );
  }
}
