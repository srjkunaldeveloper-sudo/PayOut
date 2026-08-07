class FinancialValidationResult {
  final bool isValid;
  final String? errorMessage;

  const FinancialValidationResult({required this.isValid, this.errorMessage});
}

class FinancialValidator {
  static FinancialValidationResult validatePAN(String pan) {
    final panRegex = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$');
    if (!panRegex.hasMatch(pan.toUpperCase())) {
      return const FinancialValidationResult(isValid: false, errorMessage: 'Invalid PAN card format. (Expected: ABCDE1234F)');
    }
    return const FinancialValidationResult(isValid: true);
  }

  static FinancialValidationResult validateLoanAmount(double amount) {
    if (amount < 10000.0) {
      return const FinancialValidationResult(isValid: false, errorMessage: 'Loan amount must be at least ₹10,000.');
    }
    return const FinancialValidationResult(isValid: true);
  }

  static FinancialValidationResult validateInvestmentAmount(double amount) {
    if (amount < 500.0) {
      return const FinancialValidationResult(isValid: false, errorMessage: 'Investment amount must be at least ₹500.');
    }
    return const FinancialValidationResult(isValid: true);
  }
}
