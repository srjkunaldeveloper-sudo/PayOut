import 'package:flutter_test/flutter_test.dart';
import 'package:payout/features/rewards/models/reward_models.dart';
import 'package:payout/features/rewards/services/reward_service.dart';

void main() {
  group('RewardService Tests', () {
    test('calculateTotalCashback sums only AVAILABLE cashbacks', () {
      final cashbacks = [
        const CashbackModel(id: '1', amount: 50.0, status: 'AVAILABLE', earnedAt: 'Today'),
        const CashbackModel(id: '2', amount: 75.0, status: 'PENDING', earnedAt: 'Today'),
        const CashbackModel(id: '3', amount: 25.0, status: 'AVAILABLE', earnedAt: 'Today'),
      ];

      final total = RewardService.calculateTotalCashback(cashbacks);
      expect(total, equals(75.0));
    });

    test('calculateRewardSummary computes available, pending, and total coupons', () {
      final cashbacks = [
        const CashbackModel(id: '1', amount: 100.0, status: 'AVAILABLE', earnedAt: 'Today'),
        const CashbackModel(id: '2', amount: 50.0, status: 'PENDING', earnedAt: 'Today'),
      ];
      final coupons = [
        const CouponModel(id: '1', code: 'C1', title: 'T1', description: 'D1', discountValue: 10.0, validUntil: '31 Aug 2026', isActive: true),
        const CouponModel(id: '2', code: 'C2', title: 'T2', description: 'D2', discountValue: 20.0, validUntil: '31 Aug 2026', isActive: false),
      ];

      final summary = RewardService.calculateRewardSummary(cashbacks, coupons);
      expect(summary.availableCashback, equals(100.0));
      expect(summary.pendingCashback, equals(50.0));
      expect(summary.totalCashback, equals(150.0));
      expect(summary.totalCoupons, equals(1));
    });

    test('filterCoupons filters by category and active flag', () {
      final coupons = [
        const CouponModel(id: '1', code: 'C1', title: 'Food Deal', description: 'D1', category: 'Food & Dining', discountValue: 10.0, validUntil: '31 Aug 2026', isActive: true),
        const CouponModel(id: '2', code: 'C2', title: 'Shopping Deal', description: 'D2', category: 'Shopping', discountValue: 20.0, validUntil: '31 Aug 2026', isActive: true),
        const CouponModel(id: '3', code: 'C3', title: 'Old Deal', description: 'D3', category: 'Shopping', discountValue: 15.0, validUntil: '31 Aug 2026', isActive: false),
      ];

      final foodOnly = RewardService.filterCoupons(coupons, category: 'Food & Dining');
      expect(foodOnly.length, equals(1));
      expect(foodOnly.first.title, equals('Food Deal'));

      final activeShopping = RewardService.filterCoupons(coupons, category: 'Shopping', onlyActive: true);
      expect(activeShopping.length, equals(1));
    });

    test('calculateDiscountAmount handles FLAT and PERCENTAGE discounts with limits', () {
      const flatCoupon = CouponModel(
        id: '1',
        code: 'FLAT50',
        title: 'Flat 50',
        description: 'D',
        discountType: 'FLAT',
        discountValue: 50.0,
        minimumSpend: 200.0,
        maximumDiscount: 50.0,
        validUntil: '31 Aug 2026',
      );

      const percentCoupon = CouponModel(
        id: '2',
        code: 'PERC20',
        title: '20% Off',
        description: 'D',
        discountType: 'PERCENTAGE',
        discountValue: 20.0,
        minimumSpend: 500.0,
        maximumDiscount: 200.0,
        validUntil: '31 Aug 2026',
      );

      // Below minimum spend
      expect(RewardService.calculateDiscountAmount(flatCoupon, 150.0), equals(0.0));

      // Flat discount
      expect(RewardService.calculateDiscountAmount(flatCoupon, 300.0), equals(50.0));

      // Percentage discount capped at max discount
      expect(RewardService.calculateDiscountAmount(percentCoupon, 2000.0), equals(200.0)); // 20% of 2000 = 400 => capped at 200
      expect(RewardService.calculateDiscountAmount(percentCoupon, 600.0), equals(120.0)); // 20% of 600 = 120
    });
  });
}
