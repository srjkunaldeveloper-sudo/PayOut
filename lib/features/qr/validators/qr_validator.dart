class QrValidationResult {
  final bool isValid;
  final String? errorMessage;

  const QrValidationResult({required this.isValid, this.errorMessage});
}

class QrValidator {
  static QrValidationResult validateQR(String payload) {
    if (payload.isEmpty) {
      return const QrValidationResult(isValid: false, errorMessage: 'QR payload cannot be empty.');
    }
    // Verify standard UPI link scheme: upi://pay?...
    if (!payload.startsWith('upi://pay') && !payload.startsWith('payout://qr')) {
      return const QrValidationResult(
        isValid: false,
        errorMessage: 'Unsupported or invalid QR format. Please scan a valid merchant UPI QR.',
      );
    }
    return const QrValidationResult(isValid: true);
  }

  static QrValidationResult validateUPI(String upi) {
    if (upi.isEmpty || !upi.contains('@')) {
      return const QrValidationResult(isValid: false, errorMessage: 'Invalid UPI address format.');
    }
    return const QrValidationResult(isValid: true);
  }

  static QrValidationResult validateAmount(double amount) {
    if (amount <= 0.0) {
      return const QrValidationResult(isValid: false, errorMessage: 'Amount must be greater than zero.');
    }
    return const QrValidationResult(isValid: true);
  }
}
