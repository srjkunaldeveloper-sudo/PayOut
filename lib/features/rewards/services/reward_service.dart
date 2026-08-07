import 'package:payout/features/rewards/models/reward_models.dart';

class RewardService {
  static double calculateTotalCashback(List<CashbackModel> list) {
    return list.map((c) => c.amount).fold(0.0, (sum, val) => sum + val);
  }
}
