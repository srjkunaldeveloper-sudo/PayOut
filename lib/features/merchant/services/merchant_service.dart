import 'package:payout/features/merchant/models/merchant_models.dart';

class MerchantService {
  static double calculateTotalSettled(List<SettlementModel> list) {
    return list
        .where((s) => s.status.toUpperCase() == 'SUCCESS')
        .map((s) => s.amount)
        .fold(0.0, (sum, val) => sum + val);
  }
}
