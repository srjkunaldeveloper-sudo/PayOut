class TransactionValidationResult {
  final bool isValid;
  final String? errorMessage;

  const TransactionValidationResult({required this.isValid, this.errorMessage});
}

class TransactionValidator {
  static TransactionValidationResult validateSearch(String query) {
    if (query.isNotEmpty && query.length < 2) {
      return const TransactionValidationResult(isValid: false, errorMessage: 'Search query must contain at least 2 characters.');
    }
    return const TransactionValidationResult(isValid: true);
  }

  static TransactionValidationResult validateAmount(double amount) {
    if (amount <= 0.0) {
      return const TransactionValidationResult(isValid: false, errorMessage: 'Amount must be greater than zero.');
    }
    return const TransactionValidationResult(isValid: true);
  }

  static TransactionValidationResult validateDateRange(DateTime start, DateTime end) {
    if (start.isAfter(end)) {
      return const TransactionValidationResult(isValid: false, errorMessage: 'Start date cannot be after end date.');
    }
    return const TransactionValidationResult(isValid: true);
  }
}
