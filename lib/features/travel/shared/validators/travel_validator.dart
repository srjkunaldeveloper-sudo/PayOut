class TravelValidationResult {
  final bool isValid;
  final String? errorMessage;

  const TravelValidationResult({required this.isValid, this.errorMessage});
}

class TravelValidator {
  static TravelValidationResult validatePassengerCount(int count) {
    if (count <= 0) {
      return const TravelValidationResult(isValid: false, errorMessage: 'You must add at least 1 passenger.');
    }
    if (count > 9) {
      return const TravelValidationResult(isValid: false, errorMessage: 'Maximum of 9 passengers allowed per booking.');
    }
    return const TravelValidationResult(isValid: true);
  }

  static TravelValidationResult validateTravelDate(DateTime date) {
    if (date.isBefore(DateTime.now().subtract(const Duration(days: 1)))) {
      return const TravelValidationResult(isValid: false, errorMessage: 'Travel date cannot be in the past.');
    }
    return const TravelValidationResult(isValid: true);
  }
}
