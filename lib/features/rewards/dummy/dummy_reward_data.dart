import 'package:payout/features/rewards/models/reward_models.dart';

class DummyRewardData {
  static final List<CashbackModel> dummyCashbacks = [
    const CashbackModel(id: 'CSH-101', amount: 50.00, date: 'Today, 2:30 PM'),
    const CashbackModel(id: 'CSH-102', amount: 15.00, date: 'Yesterday'),
    const CashbackModel(id: 'CSH-103', amount: 100.00, date: '04 Aug'),
  ];

  static final List<CouponModel> dummyCoupons = [
    const CouponModel(id: 'CPN-301', merchantName: 'Swiggy Food Delivery', discountCode: 'SWIGGY50', expiryDate: '31 Aug 2026'),
    const CouponModel(id: 'CPN-302', merchantName: 'Myntra Fashion', discountCode: 'MYNTRA200', expiryDate: '15 Sep 2026'),
  ];

  static final List<ScratchCardModel> dummyScratchCards = [
    const ScratchCardModel(id: 'SCR-801', amount: 25.00, isScratched: false),
    const ScratchCardModel(id: 'SCR-802', amount: 10.00, isScratched: true),
    const ScratchCardModel(id: 'SCR-803', amount: 150.00, isScratched: false),
  ];
}
