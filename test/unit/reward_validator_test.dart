import 'package:flutter_test/flutter_test.dart';
import 'package:payout/features/rewards/models/reward_models.dart';
import 'package:payout/features/rewards/validators/reward_validator.dart';

void main() {
  group('RewardValidator Tests', () {
    test('validateCouponCode checks length and alphanumeric pattern', () {
      expect(RewardValidator.validateCouponCode('').isValid, isFalse);
      expect(RewardValidator.validateCouponCode('SW').isValid, isFalse);
      expect(RewardValidator.validateCouponCode('SWIGGY100').isValid, isTrue);
    });

    test('validateCouponEligibility checks active status, usage limit, and cart amount', () {
      const activeCoupon = CouponModel(
        id: 'CPN-1',
        code: 'SAVE100',
        title: 'Save 100',
        description: 'Desc',
        discountValue: 100.0,
        minimumSpend: 500.0,
        validUntil: '31 Aug 2026',
        usageLimit: 2,
        usedCount: 0,
        isActive: true,
      );

      // Active and minimum spend satisfied
      expect(RewardValidator.validateCouponEligibility(activeCoupon, currentCartAmount: 600.0).isValid, isTrue);

      // Below minimum spend
      expect(RewardValidator.validateCouponEligibility(activeCoupon, currentCartAmount: 400.0).isValid, isFalse);

      // Inactive coupon
      final inactiveCoupon = activeCoupon.copyWith(isActive: false);
      expect(RewardValidator.validateCouponEligibility(inactiveCoupon, currentCartAmount: 600.0).isValid, isFalse);

      // Exhausted usage limit
      final exhaustedCoupon = activeCoupon.copyWith(usedCount: 2);
      expect(RewardValidator.validateCouponEligibility(exhaustedCoupon, currentCartAmount: 600.0).isValid, isFalse);
    });

    test('validateMinimumSpend checks threshold', () {
      expect(RewardValidator.validateMinimumSpend(300.0, 500.0).isValid, isFalse);
      expect(RewardValidator.validateMinimumSpend(500.0, 500.0).isValid, isTrue);
      expect(RewardValidator.validateMinimumSpend(800.0, 500.0).isValid, isTrue);
    });

    test('validateRewardAmount checks scratch card reward boundaries', () {
      expect(RewardValidator.validateRewardAmount(null).isValid, isFalse);
      expect(RewardValidator.validateRewardAmount(0.0).isValid, isFalse);
      expect(RewardValidator.validateRewardAmount(2.0).isValid, isFalse); // < 5
      expect(RewardValidator.validateRewardAmount(1500.0).isValid, isFalse); // > 1000
      expect(RewardValidator.validateRewardAmount(50.0).isValid, isTrue);
    });
  });
}
