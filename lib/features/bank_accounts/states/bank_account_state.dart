import 'package:payout/features/bank_accounts/models/bank_account_models.dart';

enum BankAccountStatus { idle, loading, success, failure }

class BankAccountState {
  final BankAccountStatus status;
  final List<LinkedBankAccountModel>? accounts;
  final String? errorMessage;

  const BankAccountState({
    required this.status,
    this.accounts,
    this.errorMessage,
  });

  bool get isLoading => status == BankAccountStatus.loading;
  bool get isSuccess => status == BankAccountStatus.success;
  bool get isFailure => status == BankAccountStatus.failure;
}
