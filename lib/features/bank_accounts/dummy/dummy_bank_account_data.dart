import 'package:payout/features/bank_accounts/models/bank_account_models.dart';

class DummyBankAccountData {
  static final List<BankModel> popularBanks = [
    const BankModel(id: 'SBI', name: 'State Bank of India', logoCode: 'SBI'),
    const BankModel(id: 'HDFC', name: 'HDFC Bank', logoCode: 'HDFC'),
    const BankModel(id: 'ICICI', name: 'ICICI Bank', logoCode: 'ICICI'),
    const BankModel(id: 'AXIS', name: 'Axis Bank', logoCode: 'AXIS'),
  ];

  static final List<BankModel> allBanks = [
    const BankModel(id: 'SBI', name: 'State Bank of India', logoCode: 'SBI'),
    const BankModel(id: 'HDFC', name: 'HDFC Bank', logoCode: 'HDFC'),
    const BankModel(id: 'ICICI', name: 'ICICI Bank', logoCode: 'ICICI'),
    const BankModel(id: 'AXIS', name: 'Axis Bank', logoCode: 'AXIS'),
    const BankModel(id: 'KOTAK', name: 'Kotak Mahindra Bank', logoCode: 'KOTAK'),
    const BankModel(id: 'PNB', name: 'Punjab National Bank', logoCode: 'PNB'),
    const BankModel(id: 'BOB', name: 'Bank of Baroda', logoCode: 'BOB'),
    const BankModel(id: 'INDUSIND', name: 'IndusInd Bank', logoCode: 'INDUSIND'),
  ];

  // Mutable list representing user's linked bank accounts
  static final List<LinkedBankAccountModel> linkedAccounts = [
    const LinkedBankAccountModel(
      id: 'ACC-HDFC-5849',
      bankName: 'HDFC Bank',
      accountHolderName: 'Rahul Sharma',
      accountNumber: '5010024125849',
      ifsc: 'HDFC0000124',
      isVerified: true,
      isDefault: true,
    ),
    const LinkedBankAccountModel(
      id: 'ACC-ICICI-9201',
      bankName: 'ICICI Bank',
      accountHolderName: 'Rahul Sharma',
      accountNumber: '9010294129201',
      ifsc: 'ICIC0000011',
      isVerified: true,
      isDefault: false,
    ),
  ];
}
