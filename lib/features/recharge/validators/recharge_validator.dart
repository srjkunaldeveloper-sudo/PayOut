class RechargeValidationResult {
  final bool isValid;
  final String? errorMessage;

  const RechargeValidationResult({required this.isValid, this.errorMessage});
}

class RechargeValidator {
  static RechargeValidationResult validateMobile(String mobile) {
    if (mobile.length != 10 || !RegExp(r'^[0-9]+$').hasMatch(mobile)) {
      return const RechargeValidationResult(isValid: false, errorMessage: 'Mobile number must be a valid 10-digit number.');
    }
    return const RechargeValidationResult(isValid: true);
  }

  static RechargeValidationResult validateAmount(double amount) {
    if (amount <= 0.0) {
      return const RechargeValidationResult(isValid: false, errorMessage: 'Amount must be greater than zero.');
    }
    return const RechargeValidationResult(isValid: true);
  }
}
