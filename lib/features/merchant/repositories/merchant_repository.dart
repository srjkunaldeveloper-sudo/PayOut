import 'package:payout/features/merchant/models/merchant_models.dart';
import 'package:payout/features/merchant/dummy/dummy_merchant_data.dart';
import 'package:payout/features/merchant/services/merchant_logger.dart';

abstract class MerchantRepository {
  Future<MerchantProfileModel> getMerchantProfile();
  Future<List<SettlementModel>> getSettlementHistory();
  Future<List<BusinessInsightModel>> getBusinessInsights();
}

class MockMerchantRepository implements MerchantRepository {
  @override
  Future<MerchantProfileModel> getMerchantProfile() async {
    // TODO: Connect merchant dashboard profile info endpoint
    await Future.delayed(const Duration(milliseconds: 400));
    MerchantLogger.logProfileLoaded(DummyMerchantData.dummyProfile.id);
    return DummyMerchantData.dummyProfile;
  }

  @override
  Future<List<SettlementModel>> getSettlementHistory() async {
    // TODO: Connect ledger settlements history API endpoint
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(DummyMerchantData.dummySettlements);
  }

  @override
  Future<List<BusinessInsightModel>> getBusinessInsights() async {
    // TODO: Connect statistics and insights calculations engine
    await Future.delayed(const Duration(milliseconds: 450));
    return List.from(DummyMerchantData.dummyInsights);
  }
}
