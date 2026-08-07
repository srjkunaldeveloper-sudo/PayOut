class QrConstants {
  static const int scanTimeoutSeconds = 15;
  static const int cameraDelayMilliseconds = 500;
  static const double maxPayloadLength = 512.0;

  static const List<String> supportedQrFormats = ['UPI_QR', 'PAYOUT_QR', 'STATIC_URL'];
  
  static const List<String> merchantCategories = [
    'Grocery',
    'Food & Beverage',
    'Pharmacy',
    'Fuel',
    'Shopping',
    'Electronics'
  ];

  static const double dummyCashbackPercentage = 5.0;
  static const int retryDelaySeconds = 2;
}
