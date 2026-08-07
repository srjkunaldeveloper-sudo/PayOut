class UserValidationResult {
  final bool isValid;
  final String? errorMessage;

  const UserValidationResult({required this.isValid, this.errorMessage});
}

class UserValidator {
  static UserValidationResult validateName(String name) {
    if (name.isEmpty || name.length < 3) {
      return const UserValidationResult(isValid: false, errorMessage: 'Full name must contain at least 3 characters.');
    }
    return const UserValidationResult(isValid: true);
  }

  static UserValidationResult validatePAN(String pan) {
    final panRegex = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$');
    if (!panRegex.hasMatch(pan.toUpperCase())) {
      return const UserValidationResult(isValid: false, errorMessage: 'Invalid PAN Card format. (Expected: ABCDE1234F)');
    }
    return const UserValidationResult(isValid: true);
  }

  static UserValidationResult validateAadhaar(String aadhaar) {
    if (aadhaar.length != 12 || !RegExp(r'^[0-9]+$').hasMatch(aadhaar)) {
      return const UserValidationResult(isValid: false, errorMessage: 'Aadhaar Card number must be exactly 12 digits.');
    }
    return const UserValidationResult(isValid: true);
  }
}
