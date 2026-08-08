class UserValidationResult {
  final bool isValid;
  final String? errorMessage;

  const UserValidationResult({required this.isValid, this.errorMessage});
}

class UserValidator {
  static UserValidationResult validateName(String name) {
    if (name.trim().isEmpty || name.trim().length < 3) {
      return const UserValidationResult(isValid: false, errorMessage: 'Full name must contain at least 3 characters.');
    }
    return const UserValidationResult(isValid: true);
  }

  static UserValidationResult validateEmail(String email) {
    if (email.trim().isEmpty) {
      return const UserValidationResult(isValid: false, errorMessage: 'Email address is required.');
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email.trim())) {
      return const UserValidationResult(isValid: false, errorMessage: 'Enter a valid email address.');
    }
    return const UserValidationResult(isValid: true);
  }

  static UserValidationResult validateDOB(String dob) {
    if (dob.trim().isEmpty) {
      return const UserValidationResult(isValid: false, errorMessage: 'Date of birth is required.');
    }
    final dobRegex = RegExp(r'^\d{2}/\d{2}/\d{4}$');
    if (!dobRegex.hasMatch(dob.trim())) {
      return const UserValidationResult(isValid: false, errorMessage: 'Enter date in DD/MM/YYYY format.');
    }
    try {
      final parts = dob.trim().split('/');
      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);
      final date = DateTime(year, month, day);
      final now = DateTime.now();
      final age = now.year - date.year - ((now.month < date.month || (now.month == date.month && now.day < date.day)) ? 1 : 0);
      if (age < 18) {
        return const UserValidationResult(isValid: false, errorMessage: 'You must be at least 18 years old.');
      }
      if (age > 100) {
        return const UserValidationResult(isValid: false, errorMessage: 'Enter a valid date of birth.');
      }
    } catch (_) {
      return const UserValidationResult(isValid: false, errorMessage: 'Enter a valid date of birth.');
    }
    return const UserValidationResult(isValid: true);
  }

  static UserValidationResult validatePhone(String phone) {
    final cleaned = phone.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleaned.length != 10) {
      return const UserValidationResult(isValid: false, errorMessage: 'Enter a valid 10-digit mobile number.');
    }
    return const UserValidationResult(isValid: true);
  }

  static UserValidationResult validateOTP(String otp) {
    if (otp.length != 6 || !RegExp(r'^[0-9]+$').hasMatch(otp)) {
      return const UserValidationResult(isValid: false, errorMessage: 'Enter a valid 6-digit OTP.');
    }
    return const UserValidationResult(isValid: true);
  }

  static UserValidationResult validatePAN(String pan) {
    final panRegex = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$');
    if (!panRegex.hasMatch(pan.toUpperCase().trim())) {
      return const UserValidationResult(isValid: false, errorMessage: 'Invalid PAN format. (Expected: ABCDE1234F)');
    }
    return const UserValidationResult(isValid: true);
  }

  static UserValidationResult validateAadhaar(String aadhaar) {
    final cleaned = aadhaar.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleaned.length != 12) {
      return const UserValidationResult(isValid: false, errorMessage: 'Aadhaar number must be exactly 12 digits.');
    }
    return const UserValidationResult(isValid: true);
  }
}
