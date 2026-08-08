import 'package:payout/features/merchant/constants/merchant_constants.dart';

class MerchantValidationResult {
  final bool isValid;
  final String? errorMessage;

  const MerchantValidationResult({required this.isValid, this.errorMessage});
}

class MerchantValidator {
  static MerchantValidationResult validateBusinessName(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      return const MerchantValidationResult(isValid: false, errorMessage: 'Business name is required.');
    }
    if (trimmed.length < 3) {
      return const MerchantValidationResult(isValid: false, errorMessage: 'Business name must contain at least 3 characters.');
    }
    return const MerchantValidationResult(isValid: true);
  }

  static MerchantValidationResult validateGST(String gst) {
    final trimmed = gst.trim().toUpperCase();
    if (trimmed.isEmpty) {
      return const MerchantValidationResult(isValid: false, errorMessage: 'GSTIN number is required.');
    }
    final gstRegex = RegExp(r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$');
    if (!gstRegex.hasMatch(trimmed)) {
      return const MerchantValidationResult(isValid: false, errorMessage: 'Invalid GSTIN format. (e.g. 22AAAAA1111A1Z1)');
    }
    return const MerchantValidationResult(isValid: true);
  }

  static MerchantValidationResult validatePAN(String pan) {
    final trimmed = pan.trim().toUpperCase();
    if (trimmed.isEmpty) {
      return const MerchantValidationResult(isValid: false, errorMessage: 'PAN number is required.');
    }
    final panRegex = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$');
    if (!panRegex.hasMatch(trimmed)) {
      return const MerchantValidationResult(isValid: false, errorMessage: 'Invalid PAN format. (e.g. AABCP8832K)');
    }
    return const MerchantValidationResult(isValid: true);
  }

  static MerchantValidationResult validateMobile(String mobile) {
    final trimmed = mobile.trim();
    if (trimmed.isEmpty) {
      return const MerchantValidationResult(isValid: false, errorMessage: 'Mobile number is required.');
    }
    final mobileRegex = RegExp(r'^[6-9]\d{9}$');
    if (!mobileRegex.hasMatch(trimmed)) {
      return const MerchantValidationResult(isValid: false, errorMessage: 'Enter a valid 10-digit mobile number.');
    }
    return const MerchantValidationResult(isValid: true);
  }

  static MerchantValidationResult validateEmail(String email) {
    final trimmed = email.trim();
    if (trimmed.isEmpty) {
      return const MerchantValidationResult(isValid: false, errorMessage: 'Email address is required.');
    }
    final emailRegex = RegExp(r'^[\w\.-]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(trimmed)) {
      return const MerchantValidationResult(isValid: false, errorMessage: 'Enter a valid email address.');
    }
    return const MerchantValidationResult(isValid: true);
  }

  static MerchantValidationResult validatePincode(String pincode) {
    final trimmed = pincode.trim();
    if (trimmed.isEmpty) {
      return const MerchantValidationResult(isValid: false, errorMessage: 'Pincode is required.');
    }
    final pinRegex = RegExp(r'^\d{6}$');
    if (!pinRegex.hasMatch(trimmed)) {
      return const MerchantValidationResult(isValid: false, errorMessage: 'Enter a valid 6-digit postal pincode.');
    }
    return const MerchantValidationResult(isValid: true);
  }

  static MerchantValidationResult validateSettlementAmount(double? amount, {double availableBalance = double.infinity}) {
    if (amount == null || amount <= 0) {
      return const MerchantValidationResult(isValid: false, errorMessage: 'Please enter a valid settlement amount.');
    }
    if (amount < MerchantConstants.minimumSettlementAmount) {
      return MerchantValidationResult(
        isValid: false,
        errorMessage: 'Minimum settlement amount is ₹${MerchantConstants.minimumSettlementAmount.toInt()}.',
      );
    }
    if (amount > MerchantConstants.maximumSettlementAmount) {
      return MerchantValidationResult(
        isValid: false,
        errorMessage: 'Maximum settlement amount per transaction is ₹${MerchantConstants.maximumSettlementAmount.toInt()}.',
      );
    }
    if (amount > availableBalance) {
      return MerchantValidationResult(
        isValid: false,
        errorMessage: 'Amount exceeds available settlement balance of ₹${availableBalance.toStringAsFixed(2)}.',
      );
    }
    return const MerchantValidationResult(isValid: true);
  }
}
