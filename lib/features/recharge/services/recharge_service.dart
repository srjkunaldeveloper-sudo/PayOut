import 'package:payout/features/recharge/models/recharge_models.dart';

class RechargeService {
  static List<RechargePlanModel> filterByCategory(List<RechargePlanModel> list, String category) {
    if (category == 'All') {
      return list;
    }
    return list.where((p) => p.category.toLowerCase() == category.toLowerCase()).toList();
  }
}
