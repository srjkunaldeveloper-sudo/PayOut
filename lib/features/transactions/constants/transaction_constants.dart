class TransactionConstants {
  static const int searchDelayMilliseconds = 300;
  static const int paginationPageSize = 20;

  static const List<String> transactionTypes = ['CREDIT', 'DEBIT'];

  static const List<String> transactionCategories = [
    'UPI Transfer',
    'Wallet Topup',
    'Mobile Recharge',
    'Electricity Bill',
    'Water Bill',
    'FASTag Recharge',
    'Hotel Booking',
    'Flight Booking',
    'Shopping',
    'Refund',
    'Cashback'
  ];

  static const List<String> paymentMethods = [
    'UPI VPA',
    'Payout Wallet',
    'Bank Account',
    'Debit Card',
    'Credit Card'
  ];

  static const List<String> exportFormats = ['PDF', 'CSV', 'EXCEL'];
}
