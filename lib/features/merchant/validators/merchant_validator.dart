class MerchantValidationResult {
  final bool isValid;
  final String? errorMessage;

  const MerchantValidationResult({required this.isValid, this.errorMessage});
}

class MerchantValidator {
  static MerchantValidationResult validateGST(String gst) {
    final gstRegex = RegExp(r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$');
    if (!gstRegex.hasMatch(gst.toUpperCase())) {
      return const MerchantValidationResult(isValid: false, errorMessage: 'Invalid GSTIN format. (Expected: 22AAAAA1111A1Z1)');
    }
    return const MerchantValidationResult(isValid: true);
  }

  static MerchantValidationResult validateBusinessName(String name) {
    if (name.isEmpty || name.length < 3) {
      return const MerchantValidationResult(isValid: false, errorMessage: 'Business name must contain at least 3 characters.');
    }
    return const MerchantValidationResult(isValid: true);
  }
}
