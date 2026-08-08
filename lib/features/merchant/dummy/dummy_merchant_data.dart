import 'package:payout/features/merchant/models/merchant_models.dart';

class DummyMerchantData {
  static const MerchantProfileModel dummyProfile = MerchantProfileModel(
    id: 'MER-402',
    businessName: 'SRJ Global Retail & Supermarket',
    ownerName: 'Kunal Kumar',
    businessType: 'Private Limited',
    category: 'Retail & Grocery',
    mobile: '9876543210',
    email: 'contact@srjglobal.com',
    gstNumber: '22AAAAA1111A1Z1',
    panNumber: 'AABCP8832K',
    address: 'Shop 42, Commercial Complex, Sector 18',
    city: 'Noida',
    state: 'Uttar Pradesh',
    pincode: '201301',
    isVerified: true,
    verificationStatus: 'VERIFIED',
    joinedDate: '15 Jan 2024',
    settlementAccountMasked: 'HDFC Bank •••• 9832',
  );

  static const MerchantSalesSummaryModel dummySalesSummary = MerchantSalesSummaryModel(
    todaySales: 42560.80,
    weeklySales: 284120.50,
    monthlySales: 1145900.00,
    transactionCount: 38,
    successfulTransactions: 36,
    failedTransactions: 2,
    averageTransactionValue: 1182.24,
  );

  static final List<MerchantTransactionModel> dummyTransactions = [
    const MerchantTransactionModel(
      id: 'MTX-101',
      transactionId: 'TXN-UPI-883921',
      customerName: 'Aarav Sharma',
      amount: 1450.00,
      paymentMethod: 'UPI',
      status: 'SUCCESS',
      dateTime: 'Today, 04:32 PM',
      utr: 'UTR983210982341',
    ),
    const MerchantTransactionModel(
      id: 'MTX-102',
      transactionId: 'TXN-CRD-772910',
      customerName: 'Priya Patel',
      amount: 3299.50,
      paymentMethod: 'CARD',
      status: 'SUCCESS',
      dateTime: 'Today, 03:15 PM',
      utr: 'UTR983210982342',
    ),
    const MerchantTransactionModel(
      id: 'MTX-103',
      transactionId: 'TXN-WLT-661829',
      customerName: 'Rohit Verma',
      amount: 450.00,
      paymentMethod: 'WALLET',
      status: 'SUCCESS',
      dateTime: 'Today, 01:45 PM',
      utr: 'UTR983210982343',
    ),
    const MerchantTransactionModel(
      id: 'MTX-104',
      transactionId: 'TXN-UPI-552718',
      customerName: 'Neha Gupta',
      amount: 2100.00,
      paymentMethod: 'UPI',
      status: 'PENDING',
      dateTime: 'Today, 11:20 AM',
      utr: 'UTR983210982344',
    ),
    const MerchantTransactionModel(
      id: 'MTX-105',
      transactionId: 'TXN-UPI-441607',
      customerName: 'Vikram Malhotra',
      amount: 850.00,
      paymentMethod: 'UPI',
      status: 'SUCCESS',
      dateTime: 'Today, 10:05 AM',
      utr: 'UTR983210982345',
    ),
    const MerchantTransactionModel(
      id: 'MTX-106',
      transactionId: 'TXN-CRD-330596',
      customerName: 'Sunita Rao',
      amount: 5200.00,
      paymentMethod: 'CARD',
      status: 'FAILED',
      dateTime: 'Yesterday, 07:40 PM',
      utr: 'UTR983210982346',
    ),
  ];

  static final List<SettlementModel> dummySettlements = [
    const SettlementModel(
      id: 'SET-901',
      settlementId: 'SET-901',
      amount: 15420.00,
      settlementDate: 'Today, 06:00 AM',
      status: 'SUCCESS',
      bankAccountMasked: 'HDFC Bank •••• 9832',
      utr: 'UTR782910394851',
    ),
    const SettlementModel(
      id: 'SET-902',
      settlementId: 'SET-902',
      amount: 8900.00,
      settlementDate: 'Yesterday, 06:00 AM',
      status: 'SUCCESS',
      bankAccountMasked: 'HDFC Bank •••• 9832',
      utr: 'UTR782910394852',
    ),
    const SettlementModel(
      id: 'SET-903',
      settlementId: 'SET-903',
      amount: 12500.00,
      settlementDate: '05 Aug, 06:00 AM',
      status: 'SUCCESS',
      bankAccountMasked: 'HDFC Bank •••• 9832',
      utr: 'UTR782910394853',
    ),
  ];

  static final List<MerchantOfferModel> dummyOffers = [
    const MerchantOfferModel(
      id: 'MOF-01',
      title: 'Flat 10% OFF on Grocery Purchases',
      description: 'Get 10% instant discount on orders above ₹999 paid via UPI QR.',
      discount: 10.0,
      validFrom: '01 Aug 2026',
      validUntil: '31 Aug 2026',
      minimumTransactionAmount: 999.0,
      usageLimit: 250,
      isActive: true,
    ),
    const MerchantOfferModel(
      id: 'MOF-02',
      title: 'Weekend Cashback Bonanza',
      description: 'Flat ₹50 cashback for customers paying via Payout Wallet.',
      discount: 50.0,
      validFrom: '01 Aug 2026',
      validUntil: '15 Aug 2026',
      minimumTransactionAmount: 500.0,
      usageLimit: 100,
      isActive: true,
    ),
    const MerchantOfferModel(
      id: 'MOF-03',
      title: 'RuPay Card Special Discount',
      description: 'Up to ₹150 off on RuPay debit and credit card transactions.',
      discount: 15.0,
      validFrom: '10 Aug 2026',
      validUntil: '25 Aug 2026',
      minimumTransactionAmount: 1500.0,
      usageLimit: 50,
      isActive: true,
    ),
  ];

  static final List<BusinessInsightModel> dummyInsights = [
    const BusinessInsightModel(title: 'Net Profit Margin', value: '₹42,500', changePercentage: 12.5),
    const BusinessInsightModel(title: 'Average Order Value', value: '₹1,182', changePercentage: 8.4),
    const BusinessInsightModel(title: 'Customer Retention', value: '78%', changePercentage: 4.2),
  ];

  static double availableSettlementBalance = 42560.80;
}
