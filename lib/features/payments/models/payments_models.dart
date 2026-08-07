class PaymentModel {
  final String id;
  final double amount;
  final String method;
  final String status;
  final String date;
  final String remarks;

  const PaymentModel({
    required this.id,
    required this.amount,
    required this.method,
    required this.status,
    required this.date,
    required this.remarks,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'method': method,
      'status': status,
      'date': date,
      'remarks': remarks,
    };
  }

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'] as String,
      amount: (json['amount'] as num).toDouble(),
      method: json['method'] as String,
      status: json['status'] as String,
      date: json['date'] as String,
      remarks: json['remarks'] as String,
    );
  }
}

class TransferRequestModel {
  final String recipientName;
  final String upiId;
  final double amount;
  final String remarks;
  final String methodId;

  const TransferRequestModel({
    required this.recipientName,
    required this.upiId,
    required this.amount,
    required this.remarks,
    required this.methodId,
  });
}

class TransferResponseModel {
  final bool success;
  final String transactionId;
  final String utrNumber;
  final String status;
  final String date;

  const TransferResponseModel({
    required this.success,
    required this.transactionId,
    required this.utrNumber,
    required this.status,
    required this.date,
  });
}

class BeneficiaryModel {
  final String id;
  final String name;
  final String upiId;
  final String? accountNumber;
  final String? ifsc;
  final String phone;
  final bool isFavourite;
  final bool isVerified;

  const BeneficiaryModel({
    required this.id,
    required this.name,
    required this.upiId,
    this.accountNumber,
    this.ifsc,
    required this.phone,
    required this.isFavourite,
    required this.isVerified,
  });

  BeneficiaryModel copyWith({
    String? id,
    String? name,
    String? upiId,
    String? accountNumber,
    String? ifsc,
    String? phone,
    bool? isFavourite,
    bool? isVerified,
  }) {
    return BeneficiaryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      upiId: upiId ?? this.upiId,
      accountNumber: accountNumber ?? this.accountNumber,
      ifsc: ifsc ?? this.ifsc,
      phone: phone ?? this.phone,
      isFavourite: isFavourite ?? this.isFavourite,
      isVerified: isVerified ?? this.isVerified,
    );
  }
}

class UPIModel {
  final String id;
  final String upiId;
  final bool isVerified;

  const UPIModel({required this.id, required this.upiId, required this.isVerified});
}

class BankAccountModel {
  final String id;
  final String bankName;
  final String accountSuffix;
  final String ifsc;
  final bool isDefault;

  const BankAccountModel({
    required this.id,
    required this.bankName,
    required this.accountSuffix,
    required this.ifsc,
    required this.isDefault,
  });
}

class RecentPaymentModel {
  final String id;
  final String recipientName;
  final String upiId;
  final double amount;
  final String status;
  final String date;

  const RecentPaymentModel({
    required this.id,
    required this.recipientName,
    required this.upiId,
    required this.amount,
    required this.status,
    required this.date,
  });
}

class PaymentMethodModel {
  final String id;
  final String type; // UPI, Wallet, Bank Account, Card
  final String label;
  final bool lastUsed;
  final bool isDefault;
  final bool isVerified;
  final String logoPath;

  const PaymentMethodModel({
    required this.id,
    required this.type,
    required this.label,
    required this.lastUsed,
    required this.isDefault,
    required this.isVerified,
    required this.logoPath,
  });
}

class PaymentLimitModel {
  final double dailyLimit;
  final double dailyRemaining;
  final double monthlyLimit;
  final double monthlyRemaining;

  const PaymentLimitModel({
    required this.dailyLimit,
    required this.dailyRemaining,
    required this.monthlyLimit,
    required this.monthlyRemaining,
  });
}

class ReceiptModel {
  final String txnId;
  final String utrNumber;
  final String refNumber;
  final double amount;
  final String date;
  final String method;
  final String receiverName;
  final String receiverUpi;
  final String status;
  final String notes;

  const ReceiptModel({
    required this.txnId,
    required this.utrNumber,
    required this.refNumber,
    required this.amount,
    required this.date,
    required this.method,
    required this.receiverName,
    required this.receiverUpi,
    required this.status,
    required this.notes,
  });
}
