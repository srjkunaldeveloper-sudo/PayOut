import 'package:payout/features/wallet/models/wallet_models.dart';
import 'package:payout/features/wallet/dummy/dummy_wallet_data.dart';
import 'package:payout/features/wallet/services/wallet_logger.dart';

abstract class WalletRepository {
  Future<WalletModel> getWallet();
  Future<double> getBalance();
  Future<List<WalletTransactionModel>> getTransactions();
  Future<bool> addMoney(double amount);
  Future<bool> withdrawMoney(double amount);
}

class MockWalletRepository implements WalletRepository {
  @override
  Future<WalletModel> getWallet() async {
    // TODO: Connect wallet details API endpoint
    await Future.delayed(const Duration(milliseconds: 600));
    return WalletModel(
      id: DummyWalletData.dummyWallet.id,
      status: DummyWalletData.dummyWallet.status,
      balance: DummyWalletData.walletBalance,
      lastUpdated: 'Updated just now',
      linkedBank: DummyWalletData.dummyWallet.linkedBank,
      cashbackEarned: DummyWalletData.cashbackEarned,
    );
  }

  @override
  Future<double> getBalance() async {
    // TODO: Connect wallet balance status API endpoint
    await Future.delayed(const Duration(milliseconds: 400));
    return DummyWalletData.walletBalance;
  }

  @override
  Future<List<WalletTransactionModel>> getTransactions() async {
    // TODO: Connect wallet transaction history ledger API endpoint
    await Future.delayed(const Duration(milliseconds: 600));
    return List.from(DummyWalletData.dummyTransactions);
  }

  @override
  Future<bool> addMoney(double amount) async {
    // TODO: Connect wallet loading payment gateway API endpoint
    await Future.delayed(const Duration(milliseconds: 1000));
    DummyWalletData.walletBalance += amount;
    
    // Prepend to transaction stack
    DummyWalletData.dummyTransactions.insert(
      0,
      WalletTransactionModel(
        id: 'TXN-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
        title: 'Added via Bank Account',
        subtitle: 'Wallet Load',
        date: 'Today',
        amount: amount,
        isCredit: true,
      ),
    );

    WalletLogger.logMoneyAdded(amount);
    return true;
  }

  @override
  Future<bool> withdrawMoney(double amount) async {
    // TODO: Connect wallet payout checking account API endpoint
    await Future.delayed(const Duration(milliseconds: 1000));
    if (DummyWalletData.walletBalance >= amount) {
      DummyWalletData.walletBalance -= amount;
      
      // Prepend to transaction stack
      DummyWalletData.dummyTransactions.insert(
        0,
        WalletTransactionModel(
          id: 'TXN-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
          title: 'Withdrawal to Bank',
          subtitle: 'Wallet Debit',
          date: 'Today',
          amount: amount,
          isCredit: false,
        ),
      );

      WalletLogger.logMoneyWithdrawn(amount);
      return true;
    }
    return false;
  }
}
