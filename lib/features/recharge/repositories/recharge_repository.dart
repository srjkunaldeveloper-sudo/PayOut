import 'package:payout/features/recharge/models/recharge_models.dart';
import 'package:payout/features/recharge/dummy/dummy_recharge_data.dart';

abstract class RechargeRepository {
  Future<List<OperatorModel>> getOperators();
  Future<List<RechargePlanModel>> getPlans(String operatorName);
  Future<List<RecentRechargeModel>> getRecentRecharges();
}

class MockRechargeRepository implements RechargeRepository {
  @override
  Future<List<OperatorModel>> getOperators() async {
    // TODO: Connect operators catalog API endpoint
    await Future.delayed(const Duration(milliseconds: 400));
    return List.from(DummyRechargeData.dummyOperators);
  }

  @override
  Future<List<RechargePlanModel>> getPlans(String operatorName) async {
    // TODO: Connect mobile recharge plans catalog API endpoint
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(DummyRechargeData.dummyPlans);
  }

  @override
  Future<List<RecentRechargeModel>> getRecentRecharges() async {
    // TODO: Connect mobile recharge transaction history API endpoint
    await Future.delayed(const Duration(milliseconds: 400));
    return List.from(DummyRechargeData.dummyRecents);
  }
}
