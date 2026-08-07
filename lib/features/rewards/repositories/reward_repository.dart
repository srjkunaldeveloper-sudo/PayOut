import 'package:payout/features/rewards/models/reward_models.dart';
import 'package:payout/features/rewards/dummy/dummy_reward_data.dart';
import 'package:payout/features/rewards/services/reward_logger.dart';

abstract class RewardRepository {
  Future<List<CashbackModel>> getCashbacks();
  Future<List<CouponModel>> getCoupons();
  Future<List<ScratchCardModel>> getScratchCards();
  Future<bool> scratchCard(String id);
}

class MockRewardRepository implements RewardRepository {
  @override
  Future<List<CashbackModel>> getCashbacks() async {
    // TODO: Connect cashbacks tracking database api endpoint
    await Future.delayed(const Duration(milliseconds: 400));
    return List.from(DummyRewardData.dummyCashbacks);
  }

  @override
  Future<List<CouponModel>> getCoupons() async {
    // TODO: Connect commercial coupons partner API
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(DummyRewardData.dummyCoupons);
  }

  @override
  Future<List<ScratchCardModel>> getScratchCards() async {
    // TODO: Connect scratch cards collection endpoint
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(DummyRewardData.dummyScratchCards);
  }

  @override
  Future<bool> scratchCard(String id) async {
    // TODO: Connect scratch cards trigger update API
    await Future.delayed(const Duration(milliseconds: 600));
    final index = DummyRewardData.dummyScratchCards.indexWhere((c) => c.id == id);
    if (index != -1) {
      final card = DummyRewardData.dummyScratchCards[index];
      DummyRewardData.dummyScratchCards[index] = card.copyWith(isScratched: true);
      RewardLogger.logScratchCardOpened(id, card.amount);
      return true;
    }
    return false;
  }
}
