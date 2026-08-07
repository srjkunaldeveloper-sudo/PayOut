class BillValidationResult {
  final bool isValid;
  final String? errorMessage;

  const BillValidationResult({required this.isValid, this.errorMessage});
}

class BillValidator {
  static BillValidationResult validateConsumerNumber(String number) {
    if (number.isEmpty || number.length < 5) {
      return const BillValidationResult(isValid: false, errorMessage: 'Consumer number must contain at least 5 alphanumeric characters.');
    }
    return const BillValidationResult(isValid: true);
  }
}
