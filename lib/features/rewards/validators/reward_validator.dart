class RewardValidationResult {
  final bool isValid;
  final String? errorMessage;

  const RewardValidationResult({required this.isValid, this.errorMessage});
}

class RewardValidator {
  static RewardValidationResult validateCouponCode(String code) {
    if (code.isEmpty || code.length < 4) {
      return const RewardValidationResult(isValid: false, errorMessage: 'Coupon code must be at least 4 alphanumeric characters.');
    }
    return const RewardValidationResult(isValid: true);
  }
}
