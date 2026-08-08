import 'package:payout/features/rewards/models/reward_models.dart';
import 'package:payout/features/rewards/constants/reward_constants.dart';

class RewardValidationResult {
  final bool isValid;
  final String? errorMessage;

  const RewardValidationResult({required this.isValid, this.errorMessage});
}

class RewardValidator {
  static RewardValidationResult validateCouponCode(String code) {
    final trimmed = code.trim().toUpperCase();
    if (trimmed.isEmpty) {
      return const RewardValidationResult(isValid: false, errorMessage: 'Coupon code is required.');
    }
    if (trimmed.length < 4) {
      return const RewardValidationResult(isValid: false, errorMessage: 'Coupon code must be at least 4 characters.');
    }
    final codeRegex = RegExp(r'^[A-Z0-9_-]+$');
    if (!codeRegex.hasMatch(trimmed)) {
      return const RewardValidationResult(isValid: false, errorMessage: 'Coupon code can only contain alphanumeric characters.');
    }
    return const RewardValidationResult(isValid: true);
  }

  static RewardValidationResult validateCouponEligibility(CouponModel coupon, {double currentCartAmount = 0}) {
    if (!coupon.isActive) {
      return const RewardValidationResult(isValid: false, errorMessage: 'This coupon is no longer active.');
    }
    if (coupon.usedCount >= coupon.usageLimit) {
      return const RewardValidationResult(isValid: false, errorMessage: 'You have already reached the maximum usage limit for this coupon.');
    }
    if (currentCartAmount > 0 && currentCartAmount < coupon.minimumSpend) {
      return RewardValidationResult(
        isValid: false,
        errorMessage: 'Minimum transaction spend of ₹${coupon.minimumSpend.toInt()} is required to apply this coupon.',
      );
    }
    return const RewardValidationResult(isValid: true);
  }

  static RewardValidationResult validateMinimumSpend(double amount, double minimumSpend) {
    if (amount < minimumSpend) {
      return RewardValidationResult(
        isValid: false,
        errorMessage: 'Minimum spend of ₹${minimumSpend.toInt()} required (Current: ₹${amount.toInt()}).',
      );
    }
    return const RewardValidationResult(isValid: true);
  }

  static RewardValidationResult validateRewardAmount(double? amount) {
    if (amount == null || amount <= 0) {
      return const RewardValidationResult(isValid: false, errorMessage: 'Invalid reward amount.');
    }
    if (amount < RewardConstants.minimumScratchReward) {
      return RewardValidationResult(
        isValid: false,
        errorMessage: 'Reward amount cannot be less than ₹${RewardConstants.minimumScratchReward.toInt()}.',
      );
    }
    if (amount > RewardConstants.maximumScratchReward) {
      return RewardValidationResult(
        isValid: false,
        errorMessage: 'Reward amount exceeds maximum limit of ₹${RewardConstants.maximumScratchReward.toInt()}.',
      );
    }
    return const RewardValidationResult(isValid: true);
  }
}
