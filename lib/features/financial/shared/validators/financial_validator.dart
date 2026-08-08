class FinancialValidationResult {
  final bool isValid;
  final String? errorMessage;

  const FinancialValidationResult({required this.isValid, this.errorMessage});
}

class FinancialValidator {
  static FinancialValidationResult validateName(String name) {
    if (name.trim().isEmpty || name.trim().length < 3) {
      return const FinancialValidationResult(isValid: false, errorMessage: 'Full name must contain at least 3 characters.');
    }
    return const FinancialValidationResult(isValid: true);
  }

  static FinancialValidationResult validateDOB(String dob) {
    if (dob.trim().isEmpty) {
      return const FinancialValidationResult(isValid: false, errorMessage: 'Date of birth is required.');
    }
    final regex = RegExp(r'^\d{2}/\d{2}/\d{4}$');
    if (!regex.hasMatch(dob.trim())) {
      return const FinancialValidationResult(isValid: false, errorMessage: 'Enter date in DD/MM/YYYY format.');
    }
    return const FinancialValidationResult(isValid: true);
  }

  static FinancialValidationResult validatePAN(String pan) {
    final panRegex = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$');
    if (!panRegex.hasMatch(pan.toUpperCase().trim())) {
      return const FinancialValidationResult(isValid: false, errorMessage: 'Invalid PAN format. (Expected: ABCDE1234F)');
    }
    return const FinancialValidationResult(isValid: true);
  }

  static FinancialValidationResult validateMonthlyIncome(String incomeStr) {
    final amount = double.tryParse(incomeStr.replaceAll(',', '').trim());
    if (amount == null || amount < 15000.0) {
      return const FinancialValidationResult(isValid: false, errorMessage: 'Minimum monthly income required is ₹15,000.');
    }
    return const FinancialValidationResult(isValid: true);
  }

  static FinancialValidationResult validateLoanAmount(double amount, {double min = 10000.0, double max = 500000.0}) {
    if (amount < min) {
      return FinancialValidationResult(isValid: false, errorMessage: 'Loan amount must be at least ₹${min.toInt()}.');
    }
    if (amount > max) {
      return FinancialValidationResult(isValid: false, errorMessage: 'Loan amount cannot exceed ₹${max.toInt()}.');
    }
    return const FinancialValidationResult(isValid: true);
  }

  static FinancialValidationResult validateInvestmentAmount(double amount, {double min = 500.0}) {
    if (amount < min) {
      return FinancialValidationResult(isValid: false, errorMessage: 'Investment amount must be at least ₹${min.toInt()}.');
    }
    return const FinancialValidationResult(isValid: true);
  }

  static FinancialValidationResult validateAge(String ageStr) {
    final age = int.tryParse(ageStr.trim());
    if (age == null || age < 18 || age > 75) {
      return const FinancialValidationResult(isValid: false, errorMessage: 'Age must be between 18 and 75 years.');
    }
    return const FinancialValidationResult(isValid: true);
  }
}
