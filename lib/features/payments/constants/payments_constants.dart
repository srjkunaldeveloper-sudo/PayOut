class PaymentsConstants {
  static const String currencyCode = 'INR';
  static const String currencySymbol = '₹';

  static const double minimumTransactionAmount = 1.0;
  static const double maximumUPILimit = 100000.0;
  static const double maximumIMPSLimit = 500000.0;
  static const double dailyPaymentLimit = 100000.0;
  static const double monthlyPaymentLimit = 1000000.0;

  static const int maximumRemarksLength = 50;
  
  static const List<String> supportedUPIExtensions = ['@upi', '@oksbi', '@okhdfcbank', '@okaxis', '@okicici'];
}
