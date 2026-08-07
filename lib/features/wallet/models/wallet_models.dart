class WalletModel {
  final String id;
  final String status;
  final double balance;
  final String lastUpdated;
  final String linkedBank;
  final double cashbackEarned;

  const WalletModel({
    required this.id,
    required this.status,
    required this.balance,
    required this.lastUpdated,
    required this.linkedBank,
    required this.cashbackEarned,
  });

  WalletModel copyWith({
    String? id,
    String? status,
    double? balance,
    String? lastUpdated,
    String? linkedBank,
    double? cashbackEarned,
  }) {
    return WalletModel(
      id: id ?? this.id,
      status: status ?? this.status,
      balance: balance ?? this.balance,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      linkedBank: linkedBank ?? this.linkedBank,
      cashbackEarned: cashbackEarned ?? this.cashbackEarned,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'balance': balance,
      'lastUpdated': lastUpdated,
      'linkedBank': linkedBank,
      'cashbackEarned': cashbackEarned,
    };
  }

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      id: json['id'] as String,
      status: json['status'] as String,
      balance: (json['balance'] as num).toDouble(),
      lastUpdated: json['lastUpdated'] as String,
      linkedBank: json['linkedBank'] as String,
      cashbackEarned: (json['cashbackEarned'] as num).toDouble(),
    );
  }
}

class WalletBalanceModel {
  final double amount;
  final String currency;

  const WalletBalanceModel({required this.amount, required this.currency});

  Map<String, dynamic> toJson() => {'amount': amount, 'currency': currency};
  factory WalletBalanceModel.fromJson(Map<String, dynamic> json) {
    return WalletBalanceModel(
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String,
    );
  }
}

class WalletTransactionModel {
  final String id;
  final String title;
  final String subtitle;
  final String date;
  final double amount;
  final bool isCredit;

  const WalletTransactionModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.date,
    required this.amount,
    required this.isCredit,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'date': date,
      'amount': amount,
      'isCredit': isCredit,
    };
  }

  factory WalletTransactionModel.fromJson(Map<String, dynamic> json) {
    return WalletTransactionModel(
      id: json['id'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      date: json['date'] as String,
      amount: (json['amount'] as num).toDouble(),
      isCredit: json['isCredit'] as bool,
    );
  }
}

class WalletSummaryModel {
  final double totalAdded;
  final double totalWithdrawn;
  final int rewardsClaimed;

  const WalletSummaryModel({
    required this.totalAdded,
    required this.totalWithdrawn,
    required this.rewardsClaimed,
  });

  Map<String, dynamic> toJson() {
    return {
      'totalAdded': totalAdded,
      'totalWithdrawn': totalWithdrawn,
      'rewardsClaimed': rewardsClaimed,
    };
  }

  factory WalletSummaryModel.fromJson(Map<String, dynamic> json) {
    return WalletSummaryModel(
      totalAdded: (json['totalAdded'] as num).toDouble(),
      totalWithdrawn: (json['totalWithdrawn'] as num).toDouble(),
      rewardsClaimed: json['rewardsClaimed'] as int,
    );
  }
}

class LinkedBankModel {
  final String id;
  final String bankName;
  final String accountNumberSuffix;
  final bool isDefault;

  const LinkedBankModel({
    required this.id,
    required this.bankName,
    required this.accountNumberSuffix,
    required this.isDefault,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bankName': bankName,
      'accountNumberSuffix': accountNumberSuffix,
      'isDefault': isDefault,
    };
  }

  factory LinkedBankModel.fromJson(Map<String, dynamic> json) {
    return LinkedBankModel(
      id: json['id'] as String,
      bankName: json['bankName'] as String,
      accountNumberSuffix: json['accountNumberSuffix'] as String,
      isDefault: json['isDefault'] as bool,
    );
  }
}

class LinkedCardModel {
  final String id;
  final String cardBrand;
  final String cardSuffix;
  final String expiry;

  const LinkedCardModel({
    required this.id,
    required this.cardBrand,
    required this.cardSuffix,
    required this.expiry,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cardBrand': cardBrand,
      'cardSuffix': cardSuffix,
      'expiry': expiry,
    };
  }

  factory LinkedCardModel.fromJson(Map<String, dynamic> json) {
    return LinkedCardModel(
      id: json['id'] as String,
      cardBrand: json['cardBrand'] as String,
      cardSuffix: json['cardSuffix'] as String,
      expiry: json['expiry'] as String,
    );
  }
}

class RewardPointModel {
  final int points;
  final double valueInRupees;

  const RewardPointModel({required this.points, required this.valueInRupees});

  Map<String, dynamic> toJson() => {'points': points, 'valueInRupees': valueInRupees};
  factory RewardPointModel.fromJson(Map<String, dynamic> json) {
    return RewardPointModel(
      points: json['points'] as int,
      valueInRupees: (json['valueInRupees'] as num).toDouble(),
    );
  }
}

class CashbackModel {
  final double totalCashback;
  final double pendingCashback;

  const CashbackModel({required this.totalCashback, required this.pendingCashback});

  Map<String, dynamic> toJson() => {
        'totalCashback': totalCashback,
        'pendingCashback': pendingCashback,
      };

  factory CashbackModel.fromJson(Map<String, dynamic> json) {
    return CashbackModel(
      totalCashback: (json['totalCashback'] as num).toDouble(),
      pendingCashback: (json['pendingCashback'] as num).toDouble(),
    );
  }
}

class WalletLimitModel {
  final double dailyLimit;
  final double dailyUsed;
  final double monthlyLimit;
  final double monthlyUsed;

  const WalletLimitModel({
    required this.dailyLimit,
    required this.dailyUsed,
    required this.monthlyLimit,
    required this.monthlyUsed,
  });

  Map<String, dynamic> toJson() {
    return {
      'dailyLimit': dailyLimit,
      'dailyUsed': dailyUsed,
      'monthlyLimit': monthlyLimit,
      'monthlyUsed': monthlyUsed,
    };
  }

  factory WalletLimitModel.fromJson(Map<String, dynamic> json) {
    return WalletLimitModel(
      dailyLimit: (json['dailyLimit'] as num).toDouble(),
      dailyUsed: (json['dailyUsed'] as num).toDouble(),
      monthlyLimit: (json['monthlyLimit'] as num).toDouble(),
      monthlyUsed: (json['monthlyUsed'] as num).toDouble(),
    );
  }
}

class SettlementModel {
  final String id;
  final String date;
  final double amount;
  final String bankAccountSuffix;

  const SettlementModel({
    required this.id,
    required this.date,
    required this.amount,
    required this.bankAccountSuffix,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'amount': amount,
      'bankAccountSuffix': bankAccountSuffix,
    };
  }

  factory SettlementModel.fromJson(Map<String, dynamic> json) {
    return SettlementModel(
      id: json['id'] as String,
      date: json['date'] as String,
      amount: (json['amount'] as num).toDouble(),
      bankAccountSuffix: json['bankAccountSuffix'] as String,
    );
  }
}
