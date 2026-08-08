import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/widgets.dart';
import 'package:payout/features/rewards/models/reward_models.dart';
import 'package:payout/features/rewards/repositories/reward_repository.dart';

class ScratchCardScreen extends StatefulWidget {
  final ScratchCardModel card;
  final RewardRepository? rewardRepository;

  const ScratchCardScreen({
    super.key,
    required this.card,
    this.rewardRepository,
  });

  @override
  State<ScratchCardScreen> createState() => _ScratchCardScreenState();
}

class _ScratchCardScreenState extends State<ScratchCardScreen> with SingleTickerProviderStateMixin {
  late final RewardRepository _rewardRepo;
  late bool _isScratched;
  bool _isClaiming = false;
  bool _isClaimed = false;
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _rewardRepo = widget.rewardRepository ?? MockRewardRepository();
    _isScratched = widget.card.status.toUpperCase() == 'SCRATCHED';
    _isClaimed = _isScratched;

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.elasticOut,
    );

    if (_isScratched) {
      _animController.value = 1.0;
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _revealAndClaim() async {
    if (_isClaiming || _isClaimed) return;

    setState(() {
      _isClaiming = true;
    });

    final updated = await _rewardRepo.openScratchCard(widget.card.id);

    if (mounted) {
      setState(() {
        _isScratched = true;
        _isClaimed = true;
        _isClaiming = false;
      });
      _animController.forward(from: 0.0);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('🎉 Congratulations! ₹${(updated?.rewardValue ?? widget.card.rewardValue).toStringAsFixed(2)} credited to Rewards Wallet!'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Mystery Scratch Card'),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.s24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.card.title,
                style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
                widget.card.description,
                style: const TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.s32),

              // Interactive Card Container
              GestureDetector(
                onTap: _isClaimed ? null : _revealAndClaim,
                child: AnimatedBuilder(
                  animation: _scaleAnimation,
                  builder: (context, child) {
                    return Container(
                      width: 260,
                      height: 260,
                      decoration: BoxDecoration(
                        gradient: _isScratched
                            ? const LinearGradient(
                                colors: [Color(0xFFFFF9E6), Color(0xFFFFEDBA)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                            : const LinearGradient(
                                colors: [Color(0xFF2A5298), Color(0xFF1E3C72)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: (_isScratched ? Colors.amber : AppColors.primary).withValues(alpha: 0.25),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                        border: Border.all(
                          color: _isScratched ? Colors.amber : Colors.white24,
                          width: 2,
                        ),
                      ),
                      child: _isScratched
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.stars_rounded, color: Colors.amber, size: 48),
                                const SizedBox(height: 12),
                                const Text(
                                  'YOU WON CASHBACK',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: Color(0xFF8A6D00),
                                    letterSpacing: 1.2,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  '₹${widget.card.rewardValue.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 42,
                                    color: Color(0xFF5A4400),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.success.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Text(
                                    'CREDITED TO WALLET',
                                    style: TextStyle(fontFamily: 'Inter', fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.success),
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.touch_app_rounded, color: Colors.white, size: 48),
                                const SizedBox(height: 16),
                                const Text(
                                  'TAP TO SCRATCH',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.white,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Expires ${widget.card.expiresAt}',
                                  style: const TextStyle(fontFamily: 'Inter', fontSize: 11, color: Colors.white70),
                                ),
                              ],
                            ),
                    );
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.s32),

              // Action Buttons
              if (!_isClaimed)
                PrimaryButton(
                  text: _isClaiming ? 'Unlocking Reward...' : 'Scratch & Claim Reward',
                  isLoading: _isClaiming,
                  onPressed: _isClaiming ? null : _revealAndClaim,
                )
              else
                PrimaryButton(
                  text: 'Done & Back to Rewards',
                  onPressed: () => Navigator.pop(context, true),
                ),
              const SizedBox(height: AppSpacing.s16),
              AppCard(
                padding: const EdgeInsets.all(AppSpacing.s12),
                child: Row(
                  children: const [
                    Icon(Icons.info_outline_rounded, color: AppColors.primary, size: 20),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Cashback is credited instantly to your Rewards wallet balance.',
                        style: TextStyle(fontFamily: 'Inter', fontSize: 11, color: AppColors.textSecondary),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
