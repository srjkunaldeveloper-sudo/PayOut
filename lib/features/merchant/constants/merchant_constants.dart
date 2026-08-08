class MerchantConstants {
  static const double minimumSettlementAmount = 100.0;
  static const double maximumSettlementAmount = 500000.0;

  static const List<String> supportedBusinessTypes = [
    'Individual / Proprietorship',
    'Partnership',
    'Private Limited',
    'Public Limited',
    'LLP',
  ];

  static const List<String> merchantCategories = [
    'Retail & Grocery',
    'Restaurant & Cafe',
    'Electronics & Gadgets',
    'Healthcare & Pharmacy',
    'Fashion & Apparel',
    'Professional Services',
  ];

  static const List<String> settlementStatuses = [
    'SUCCESS',
    'PENDING',
    'FAILED',
    'PROCESSING',
  ];

  static const List<String> transactionStatuses = [
    'SUCCESS',
    'PENDING',
    'FAILED',
  ];

  static const List<String> settlementFrequencies = [
    'Instant',
    'Daily (06:00 AM)',
    'Weekly',
  ];
}
