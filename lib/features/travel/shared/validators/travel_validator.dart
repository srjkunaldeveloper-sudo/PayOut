class TravelValidationResult {
  final bool isValid;
  final String? errorMessage;

  const TravelValidationResult({required this.isValid, this.errorMessage});
}

class TravelValidator {
  static TravelValidationResult validatePassengerName(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      return const TravelValidationResult(isValid: false, errorMessage: 'Full name is required.');
    }
    if (trimmed.length < 3) {
      return const TravelValidationResult(isValid: false, errorMessage: 'Name must be at least 3 characters.');
    }
    final nameRegex = RegExp(r'^[a-zA-Z\s.]+$');
    if (!nameRegex.hasMatch(trimmed)) {
      return const TravelValidationResult(isValid: false, errorMessage: 'Name should only contain alphabets and spaces.');
    }
    return const TravelValidationResult(isValid: true);
  }

  static TravelValidationResult validateAge(String ageStr) {
    final age = int.tryParse(ageStr.trim());
    if (age == null) {
      return const TravelValidationResult(isValid: false, errorMessage: 'Please enter a valid age in years.');
    }
    if (age <= 0 || age > 120) {
      return const TravelValidationResult(isValid: false, errorMessage: 'Age must be between 1 and 120.');
    }
    return const TravelValidationResult(isValid: true);
  }

  static TravelValidationResult validateMobile(String phone) {
    final trimmed = phone.trim();
    if (trimmed.isEmpty) {
      return const TravelValidationResult(isValid: false, errorMessage: 'Mobile number is required.');
    }
    final phoneRegex = RegExp(r'^[6-9]\d{9}$');
    if (!phoneRegex.hasMatch(trimmed)) {
      return const TravelValidationResult(isValid: false, errorMessage: 'Enter a valid 10-digit Indian mobile number.');
    }
    return const TravelValidationResult(isValid: true);
  }

  static TravelValidationResult validateEmail(String email) {
    final trimmed = email.trim();
    if (trimmed.isEmpty) {
      return const TravelValidationResult(isValid: false, errorMessage: 'Email address is required.');
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(trimmed)) {
      return const TravelValidationResult(isValid: false, errorMessage: 'Please enter a valid email address.');
    }
    return const TravelValidationResult(isValid: true);
  }

  static TravelValidationResult validateSearchCities(String from, String to) {
    final f = from.trim();
    final t = to.trim();
    if (f.isEmpty) {
      return const TravelValidationResult(isValid: false, errorMessage: 'Please select origin location.');
    }
    if (t.isEmpty) {
      return const TravelValidationResult(isValid: false, errorMessage: 'Please select destination location.');
    }
    if (f.toLowerCase() == t.toLowerCase()) {
      return const TravelValidationResult(isValid: false, errorMessage: 'Origin and destination cannot be the same.');
    }
    return const TravelValidationResult(isValid: true);
  }

  static TravelValidationResult validateTravelDates(DateTime departure, DateTime? returnDate) {
    final today = DateTime.now();
    final todayOnly = DateTime(today.year, today.month, today.day);
    final depOnly = DateTime(departure.year, departure.month, departure.day);

    if (depOnly.isBefore(todayOnly)) {
      return const TravelValidationResult(isValid: false, errorMessage: 'Departure date cannot be in the past.');
    }
    if (returnDate != null) {
      final retOnly = DateTime(returnDate.year, returnDate.month, returnDate.day);
      if (retOnly.isBefore(depOnly)) {
        return const TravelValidationResult(isValid: false, errorMessage: 'Return date must be after departure date.');
      }
    }
    return const TravelValidationResult(isValid: true);
  }

  static TravelValidationResult validatePassengerCount(int count) {
    if (count <= 0) {
      return const TravelValidationResult(isValid: false, errorMessage: 'You must add at least 1 passenger.');
    }
    if (count > 9) {
      return const TravelValidationResult(isValid: false, errorMessage: 'Maximum of 9 passengers allowed per booking.');
    }
    return const TravelValidationResult(isValid: true);
  }
}
