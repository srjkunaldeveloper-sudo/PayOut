import 'package:payout/features/bank_accounts/models/bank_account_models.dart';
import 'package:payout/features/bank_accounts/repositories/bank_account_repository.dart';

class BankAccountService {
  final BankAccountRepository _repository = MockBankAccountRepository();

  Future<List<LinkedBankAccountModel>> getLinkedAccounts() => _repository.getLinkedAccounts();
  Future<List<BankModel>> getSupportedBanks() => _repository.getSupportedBanks();
  Future<bool> sendOTP(String phoneNumber) => _repository.sendOTP(phoneNumber);
  Future<bool> verifyOTP(String otp) => _repository.verifyOTP(otp);
  Future<bool> linkAccount(LinkedBankAccountModel account) => _repository.linkAccount(account);
  Future<bool> unlinkAccount(String accountId) => _repository.unlinkAccount(accountId);
}
