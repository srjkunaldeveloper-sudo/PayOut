import 'package:payout/features/auth/constants/auth_constants.dart';

class ValidationResult {
  final bool isValid;
  final String? errorMessage;

  const ValidationResult({required this.isValid, this.errorMessage});
}

class AuthValidator {
  static ValidationResult validateMobile(String? value) {
    if (value == null || value.isEmpty) {
      return const ValidationResult(isValid: false, errorMessage: 'Mobile number cannot be empty.');
    }
    final digitsOnly = value.replaceAll(RegExp(r'\D'), '');
    if (digitsOnly.length != AuthConstants.mobileLength) {
      return const ValidationResult(
        isValid: false,
        errorMessage: 'Mobile number must be exactly ${AuthConstants.mobileLength} digits.',
      );
    }
    return const ValidationResult(isValid: true);
  }

  static ValidationResult validateOTP(String? value) {
    if (value == null || value.isEmpty) {
      return const ValidationResult(isValid: false, errorMessage: 'OTP cannot be empty.');
    }
    final digitsOnly = value.replaceAll(RegExp(r'\D'), '');
    if (digitsOnly.length != AuthConstants.otpLength) {
      return const ValidationResult(
        isValid: false,
        errorMessage: 'OTP must be exactly ${AuthConstants.otpLength} digits.',
      );
    }
    return const ValidationResult(isValid: true);
  }

  static ValidationResult validateMPIN(String? value) {
    if (value == null || value.isEmpty) {
      return const ValidationResult(isValid: false, errorMessage: 'MPIN cannot be empty.');
    }
    final digitsOnly = value.replaceAll(RegExp(r'\D'), '');
    if (digitsOnly.length != AuthConstants.mpinLength) {
      return const ValidationResult(
        isValid: false,
        errorMessage: 'MPIN must be exactly ${AuthConstants.mpinLength} digits.',
      );
    }
    return const ValidationResult(isValid: true);
  }

  static ValidationResult validateConfirmMPIN(String? pin, String? confirmPin) {
    final pinVal = validateMPIN(pin);
    if (!pinVal.isValid) return pinVal;

    if (confirmPin == null || confirmPin.isEmpty) {
      return const ValidationResult(isValid: false, errorMessage: 'Confirm MPIN cannot be empty.');
    }
    if (pin != confirmPin) {
      return const ValidationResult(isValid: false, errorMessage: 'MPIN and Confirm MPIN do not match.');
    }
    return const ValidationResult(isValid: true);
  }
}
