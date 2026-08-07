import 'package:payout/features/payments/constants/payments_constants.dart';

class PaymentValidationResult {
  final bool isValid;
  final String? errorMessage;

  const PaymentValidationResult({required this.isValid, this.errorMessage});
}

class PaymentsValidator {
  static PaymentValidationResult validateAmount(double amount) {
    if (amount < PaymentsConstants.minimumTransactionAmount) {
      return const PaymentValidationResult(
        isValid: false,
        errorMessage: 'Amount must be at least ${PaymentsConstants.currencySymbol}${PaymentsConstants.minimumTransactionAmount}.',
      );
    }
    return const PaymentValidationResult(isValid: true);
  }

  static PaymentValidationResult validateUPI(String upi) {
    if (upi.isEmpty) {
      return const PaymentValidationResult(isValid: false, errorMessage: 'UPI ID cannot be empty.');
    }
    final parts = upi.split('@');
    if (parts.length != 2 || parts[0].isEmpty || parts[1].isEmpty) {
      return const PaymentValidationResult(isValid: false, errorMessage: 'Invalid UPI ID format. E.g. user@bank');
    }
    return const PaymentValidationResult(isValid: true);
  }

  static PaymentValidationResult validateIFSC(String ifsc) {
    final cleanIFSC = ifsc.trim().toUpperCase();
    final ifscRegex = RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$');
    if (!ifscRegex.hasMatch(cleanIFSC)) {
      return const PaymentValidationResult(
        isValid: false,
        errorMessage: 'Invalid IFSC format. Must be 11 characters. E.g. HDFC0009821',
      );
    }
    return const PaymentValidationResult(isValid: true);
  }

  static PaymentValidationResult validateRemarks(String remarks) {
    if (remarks.length > PaymentsConstants.maximumRemarksLength) {
      return const PaymentValidationResult(
        isValid: false,
        errorMessage: 'Remarks cannot exceed ${PaymentsConstants.maximumRemarksLength} characters.',
      );
    }
    return const PaymentValidationResult(isValid: true);
  }

  static PaymentValidationResult validateLimit(double todayTotal, double amount) {
    if (todayTotal + amount > PaymentsConstants.dailyPaymentLimit) {
      return const PaymentValidationResult(
        isValid: false,
        errorMessage: 'Transaction exceeds daily payments limit of ${PaymentsConstants.currencySymbol}${PaymentsConstants.dailyPaymentLimit}.',
      );
    }
    return const PaymentValidationResult(isValid: true);
  }
}
