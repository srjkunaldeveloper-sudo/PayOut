import 'package:payout/features/wallet/models/wallet_models.dart';

class WalletService {
  static double calculateTotalCredit(List<WalletTransactionModel> transactions) {
    return transactions
        .where((t) => t.isCredit)
        .fold(0.0, (sum, item) => sum + item.amount);
  }

  static double calculateTotalDebit(List<WalletTransactionModel> transactions) {
    return transactions
        .where((t) => !t.isCredit)
        .fold(0.0, (sum, item) => sum + item.amount);
  }
}
