import 'package:payout/features/rewards/models/reward_models.dart';

class DummyRewardData {
  static final List<CouponModel> dummyCoupons = [
    const CouponModel(
      id: 'CPN-101',
      code: 'SWIGGY100',
      title: 'Swiggy Gourmet Dining',
      description: 'Get flat ₹100 discount on gourmet restaurant orders above ₹499.',
      discountType: 'FLAT',
      discountValue: 100.0,
      minimumSpend: 499.0,
      maximumDiscount: 100.0,
      validFrom: '01 Aug 2026',
      validUntil: '31 Aug 2026',
      category: 'Food & Dining',
      usageLimit: 2,
      usedCount: 0,
      isActive: true,
    ),
    const CouponModel(
      id: 'CPN-102',
      code: 'MYNTRA20',
      title: 'Myntra Fashion Festive',
      description: 'Get 20% instant off on latest fashion collections and apparel.',
      discountType: 'PERCENTAGE',
      discountValue: 20.0,
      minimumSpend: 1499.0,
      maximumDiscount: 500.0,
      validFrom: '01 Aug 2026',
      validUntil: '15 Sep 2026',
      category: 'Shopping',
      usageLimit: 1,
      usedCount: 0,
      isActive: true,
    ),
    const CouponModel(
      id: 'CPN-103',
      code: 'PAYOUTFLY',
      title: 'Payout Travel Flights',
      description: 'Flat 12% OFF on all domestic flight bookings with zero fee.',
      discountType: 'PERCENTAGE',
      discountValue: 12.0,
      minimumSpend: 3000.0,
      maximumDiscount: 1200.0,
      validFrom: '01 Aug 2026',
      validUntil: '31 Dec 2026',
      category: 'Travel & Flights',
      usageLimit: 3,
      usedCount: 0,
      isActive: true,
    ),
    const CouponModel(
      id: 'CPN-104',
      code: 'CINEMA50',
      title: 'PVR INOX Multiplex',
      description: 'Buy 1 Ticket and get ₹50 flat off on the second ticket on weekends.',
      discountType: 'FLAT',
      discountValue: 50.0,
      minimumSpend: 400.0,
      maximumDiscount: 50.0,
      validFrom: '01 Aug 2026',
      validUntil: '30 Sep 2026',
      category: 'Entertainment & Movies',
      usageLimit: 1,
      usedCount: 0,
      isActive: true,
    ),
  ];

  static final List<ScratchCardModel> dummyScratchCards = [
    const ScratchCardModel(
      id: 'SCR-201',
      title: 'Weekend Mystery Scratch',
      description: 'Earned on merchant store payment above ₹500',
      rewardType: 'CASHBACK',
      rewardValue: 75.0,
      status: 'UNSCRATCHED',
      expiresAt: '25 Aug 2026',
    ),
    const ScratchCardModel(
      id: 'SCR-202',
      title: 'Electricity Bill Cashback',
      description: 'Earned on paying utility bill via Payout',
      rewardType: 'CASHBACK',
      rewardValue: 40.0,
      status: 'UNSCRATCHED',
      expiresAt: '28 Aug 2026',
    ),
    const ScratchCardModel(
      id: 'SCR-203',
      title: 'Flight Booking Bonanza',
      description: 'Earned on Indigo flight reservation',
      rewardType: 'CASHBACK',
      rewardValue: 150.0,
      status: 'SCRATCHED',
      expiresAt: '10 Aug 2026',
      claimedAt: '05 Aug 2026',
    ),
    const ScratchCardModel(
      id: 'SCR-204',
      title: 'Mobile Recharge Surprise',
      description: 'Earned on ₹799 Jio Unlimited recharge',
      rewardType: 'CASHBACK',
      rewardValue: 25.0,
      status: 'SCRATCHED',
      expiresAt: '01 Aug 2026',
      claimedAt: '28 Jul 2026',
    ),
  ];

  static final List<CashbackModel> dummyCashbacks = [
    const CashbackModel(
      id: 'CSH-301',
      source: 'Merchant QR Payment at SRJ Foods',
      amount: 50.00,
      status: 'AVAILABLE',
      earnedAt: 'Today, 02:30 PM',
      expiresAt: '31 Dec 2026',
      transactionId: 'TXN-UPI-883921',
    ),
    const CashbackModel(
      id: 'CSH-302',
      source: 'Electricity Bill Payment',
      amount: 75.00,
      status: 'AVAILABLE',
      earnedAt: 'Yesterday, 11:15 AM',
      expiresAt: '31 Dec 2026',
      transactionId: 'TXN-BIL-482910',
    ),
    const CashbackModel(
      id: 'CSH-303',
      source: 'Mobile Recharge Bonus',
      amount: 25.00,
      status: 'AVAILABLE',
      earnedAt: '04 Aug 2026',
      expiresAt: '31 Dec 2026',
      transactionId: 'TXN-RCH-391820',
    ),
    const CashbackModel(
      id: 'CSH-304',
      source: 'Travel Flight Cashback Bonus',
      amount: 150.00,
      status: 'AVAILABLE',
      earnedAt: '01 Aug 2026',
      expiresAt: '31 Dec 2026',
      transactionId: 'TXN-TRV-281903',
    ),
    const CashbackModel(
      id: 'CSH-305',
      source: 'Friend Referral Reward',
      amount: 150.00,
      status: 'PENDING',
      earnedAt: 'Just now',
      expiresAt: '31 Dec 2026',
      transactionId: 'TXN-REF-109283',
    ),
  ];

  static RewardSummaryModel get dummySummary {
    final available = dummyCashbacks
        .where((c) => c.status.toUpperCase() == 'AVAILABLE')
        .fold(0.0, (sum, c) => sum + c.amount);
    final pending = dummyCashbacks
        .where((c) => c.status.toUpperCase() == 'PENDING')
        .fold(0.0, (sum, c) => sum + c.amount);
    final expired = dummyCashbacks
        .where((c) => c.status.toUpperCase() == 'EXPIRED')
        .fold(0.0, (sum, c) => sum + c.amount);
    final total = available + pending;

    return RewardSummaryModel(
      totalCashback: total,
      availableCashback: available,
      pendingCashback: pending,
      expiredCashback: expired,
      totalCoupons: dummyCoupons.where((c) => c.isActive).length,
    );
  }
}
