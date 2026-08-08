class BankModel {
  final String id;
  final String name;
  final String logoCode; // e.g. 'SBI', 'HDFC'

  const BankModel({
    required this.id,
    required this.name,
    required this.logoCode,
  });

  factory BankModel.fromJson(Map<String, dynamic> json) {
    return BankModel(
      id: json['id'] as String,
      name: json['name'] as String,
      logoCode: json['logoCode'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'logoCode': logoCode,
    };
  }
}

class LinkedBankAccountModel {
  final String id;
  final String bankName;
  final String accountHolderName;
  final String accountNumber;
  final String ifsc;
  final bool isVerified;
  final bool isDefault;

  const LinkedBankAccountModel({
    required this.id,
    required this.bankName,
    required this.accountHolderName,
    required this.accountNumber,
    required this.ifsc,
    required this.isVerified,
    required this.isDefault,
  });

  String get maskedAccountNumber {
    if (accountNumber.length <= 4) return accountNumber;
    return '•••• ${accountNumber.substring(accountNumber.length - 4)}';
  }

  LinkedBankAccountModel copyWith({
    String? id,
    String? bankName,
    String? accountHolderName,
    String? accountNumber,
    String? ifsc,
    bool? isVerified,
    bool? isDefault,
  }) {
    return LinkedBankAccountModel(
      id: id ?? this.id,
      bankName: bankName ?? this.bankName,
      accountHolderName: accountHolderName ?? this.accountHolderName,
      accountNumber: accountNumber ?? this.accountNumber,
      ifsc: ifsc ?? this.ifsc,
      isVerified: isVerified ?? this.isVerified,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  factory LinkedBankAccountModel.fromJson(Map<String, dynamic> json) {
    return LinkedBankAccountModel(
      id: json['id'] as String,
      bankName: json['bankName'] as String,
      accountHolderName: json['accountHolderName'] as String,
      accountNumber: json['accountNumber'] as String,
      ifsc: json['ifsc'] as String,
      isVerified: json['isVerified'] as bool,
      isDefault: json['isDefault'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bankName': bankName,
      'accountHolderName': accountHolderName,
      'accountNumber': accountNumber,
      'ifsc': ifsc,
      'isVerified': isVerified,
      'isDefault': isDefault,
    };
  }
}
