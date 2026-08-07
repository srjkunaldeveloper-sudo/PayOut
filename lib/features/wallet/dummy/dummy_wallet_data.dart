import 'package:payout/features/wallet/models/wallet_models.dart';

class DummyWalletData {
  static double walletBalance = 1250.75;
  static double cashbackEarned = 1425.0;

  static const WalletModel dummyWallet = WalletModel(
    id: 'WLT-100203',
    status: 'ACTIVE',
    balance: 1250.75,
    lastUpdated: 'Updated just now',
    linkedBank: 'HDFC Bank •••• 9821',
    cashbackEarned: 1425.0,
  );

  static const List<LinkedBankModel> dummyBanks = [
    LinkedBankModel(
      id: 'BNK-001',
      bankName: 'HDFC Bank',
      accountNumberSuffix: '9821',
      isDefault: true,
    ),
    LinkedBankModel(
      id: 'BNK-002',
      bankName: 'ICICI Bank',
      accountNumberSuffix: '4412',
      isDefault: false,
    ),
  ];

  static const List<LinkedCardModel> dummyCards = [
    LinkedCardModel(
      id: 'CRD-001',
      cardBrand: 'Visa',
      cardSuffix: '5561',
      expiry: '12/28',
    ),
  ];

  static final List<WalletTransactionModel> dummyTransactions = [
    const WalletTransactionModel(
      id: 'TXN-901',
      title: 'Added via Bank Account',
      subtitle: 'Wallet Load',
      date: 'Aug 07, 2026',
      amount: 500.00,
      isCredit: true,
    ),
    const WalletTransactionModel(
      id: 'TXN-902',
      title: 'Transfer to John Doe',
      subtitle: 'Wallet Debit',
      date: 'Aug 05, 2026',
      amount: 45.00,
      isCredit: false,
    ),
    const WalletTransactionModel(
      id: 'TXN-903',
      title: 'Cashback Received',
      subtitle: 'Promo Reward',
      date: 'Jul 28, 2026',
      amount: 15.00,
      isCredit: true,
    ),
  ];

  static const WalletLimitModel dummyLimits = WalletLimitModel(
    dailyLimit: 20000.0,
    dailyUsed: 45.0,
    monthlyLimit: 200000.0,
    monthlyUsed: 1480.0,
  );
}
