import 'package:payout/features/bank_accounts/models/bank_account_models.dart';
import 'package:payout/features/bank_accounts/dummy/dummy_bank_account_data.dart';

abstract class BankAccountRepository {
  Future<List<LinkedBankAccountModel>> getLinkedAccounts();
  Future<List<BankModel>> getSupportedBanks();
  Future<bool> sendOTP(String phoneNumber);
  Future<bool> verifyOTP(String otp);
  Future<bool> linkAccount(LinkedBankAccountModel account);
  Future<bool> unlinkAccount(String accountId);
}

class MockBankAccountRepository implements BankAccountRepository {
  @override
  Future<List<LinkedBankAccountModel>> getLinkedAccounts() async {
    // TODO(api): GET /bank-accounts
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(DummyBankAccountData.linkedAccounts);
  }

  @override
  Future<List<BankModel>> getSupportedBanks() async {
    // TODO(api): GET /banks
    await Future.delayed(const Duration(milliseconds: 200));
    return List.from(DummyBankAccountData.allBanks);
  }

  @override
  Future<bool> sendOTP(String phoneNumber) async {
    // TODO(api): POST /bank-accounts/send-otp
    await Future.delayed(const Duration(milliseconds: 450));
    return true; // Mock success
  }

  @override
  Future<bool> verifyOTP(String otp) async {
    // TODO(api): POST /bank-accounts/verify-otp
    await Future.delayed(const Duration(milliseconds: 400));
    // Accepts any valid 6-digit OTP code for demo purposes
    return otp.length == 6 && int.tryParse(otp) != null;
  }

  @override
  Future<bool> linkAccount(LinkedBankAccountModel account) async {
    // TODO(api): POST /bank-accounts/link
    await Future.delayed(const Duration(milliseconds: 600));
    // Append dynamically to mutable dummy list
    DummyBankAccountData.linkedAccounts.add(account);
    return true;
  }

  @override
  Future<bool> unlinkAccount(String accountId) async {
    // TODO(api): DELETE /bank-accounts/{id}
    await Future.delayed(const Duration(milliseconds: 400));
    DummyBankAccountData.linkedAccounts.removeWhere((acc) => acc.id == accountId);
    return true;
  }
}
