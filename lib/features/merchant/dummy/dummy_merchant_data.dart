import 'package:payout/features/merchant/models/merchant_models.dart';

class DummyMerchantData {
  static const MerchantProfileModel dummyProfile = MerchantProfileModel(
    id: 'MER-402',
    businessName: 'SRJ Global Technologies',
    ownerName: 'Kunal Kumar',
    gstNumber: '22AAAAA1111A1Z1',
  );

  static final List<SettlementModel> dummySettlements = [
    const SettlementModel(id: 'SET-901', amount: 15420.00, date: 'Today, 10:00 AM', status: 'SUCCESS'),
    const SettlementModel(id: 'SET-902', amount: 8900.00, date: 'Yesterday', status: 'SUCCESS'),
    const SettlementModel(id: 'SET-903', amount: 12500.00, date: '05 Aug', status: 'SUCCESS'),
  ];

  static final List<BusinessInsightModel> dummyInsights = [
    const BusinessInsightModel(title: 'Net Profit Margin', value: '₹42,500', changePercentage: 12.5),
    const BusinessInsightModel(title: 'Average Order Value', value: '₹1,240', changePercentage: -3.2),
  ];
}
