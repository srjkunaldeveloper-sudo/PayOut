import 'package:payout/features/user/models/user_models.dart';

class UserService {
  static bool isPremiumUser(RewardSummaryModel rewards) {
    return rewards.cashbackEarned >= 200.0 && rewards.pointsEarned >= 1000;
  }
}
