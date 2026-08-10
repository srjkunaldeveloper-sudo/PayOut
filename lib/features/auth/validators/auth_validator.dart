import 'package:payout/features/auth/constants/auth_constants.dart';

class ValidationResult {
  final bool isValid;
  final String? errorMessage;

  const ValidationResult({required this.isValid, this.errorMessage});
}

class AuthValidator {
  static ValidationResult validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return const ValidationResult(isValid: false, errorMessage: 'Email address cannot be empty.');
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return const ValidationResult(isValid: false, errorMessage: 'Enter a valid email address.');
    }
    return const ValidationResult(isValid: true);
  }

  static bool hasMinLength(String password) => password.length >= 8;
  static bool hasUppercase(String password) => RegExp(r'[A-Z]').hasMatch(password);
  static bool hasNumber(String password) => RegExp(r'[0-9]').hasMatch(password);

  static ValidationResult validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return const ValidationResult(isValid: false, errorMessage: 'Password cannot be empty.');
    }
    if (!hasMinLength(value)) {
      return const ValidationResult(isValid: false, errorMessage: 'Password must be at least 8 characters.');
    }
    if (!hasUppercase(value)) {
      return const ValidationResult(isValid: false, errorMessage: 'Password must contain at least one uppercase letter.');
    }
    if (!hasNumber(value)) {
      return const ValidationResult(isValid: false, errorMessage: 'Password must contain at least one number.');
    }
    return const ValidationResult(isValid: true);
  }

  static ValidationResult validateConfirmPassword(String? password, String? confirmPassword) {
    final passVal = validatePassword(password);
    if (!passVal.isValid) return passVal;
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return const ValidationResult(isValid: false, errorMessage: 'Confirm password cannot be empty.');
    }
    if (password != confirmPassword) {
      return const ValidationResult(isValid: false, errorMessage: 'Passwords do not match');
    }
    return const ValidationResult(isValid: true);
  }

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
