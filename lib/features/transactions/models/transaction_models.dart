class TransactionModel {
  final String id;
  final String title;
  final String upiId;
  final String type; // CREDIT or DEBIT
  final String category;
  final double amount;
  final String date;
  final String status; // SUCCESS, PENDING, FAILED
  final String paymentMethod;
  final String utr;
  final String referenceNumber;

  const TransactionModel({
    required this.id,
    required this.title,
    required this.upiId,
    required this.type,
    required this.category,
    required this.amount,
    required this.date,
    required this.status,
    required this.paymentMethod,
    required this.utr,
    required this.referenceNumber,
  });

  TransactionModel copyWith({
    String? id,
    String? title,
    String? upiId,
    String? type,
    String? category,
    double? amount,
    String? date,
    String? status,
    String? paymentMethod,
    String? utr,
    String? referenceNumber,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      title: title ?? this.title,
      upiId: upiId ?? this.upiId,
      type: type ?? this.type,
      category: category ?? this.category,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      utr: utr ?? this.utr,
      referenceNumber: referenceNumber ?? this.referenceNumber,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'upiId': upiId,
      'type': type,
      'category': category,
      'amount': amount,
      'date': date,
      'status': status,
      'paymentMethod': paymentMethod,
      'utr': utr,
      'referenceNumber': referenceNumber,
    };
  }

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as String,
      title: json['title'] as String,
      upiId: json['upiId'] as String,
      type: json['type'] as String,
      category: json['category'] as String,
      amount: (json['amount'] as num).toDouble(),
      date: json['date'] as String,
      status: json['status'] as String,
      paymentMethod: json['paymentMethod'] as String,
      utr: json['utr'] as String,
      referenceNumber: json['referenceNumber'] as String,
    );
  }
}

class ReceiptModel {
  final String id;
  final String utrNumber;
  final String date;
  final String time;
  final String recipientName;
  final double amount;
  final String status;
  final String remarks;

  const ReceiptModel({
    required this.id,
    required this.utrNumber,
    required this.date,
    required this.time,
    required this.recipientName,
    required this.amount,
    required this.status,
    required this.remarks,
  });
}

class MerchantModel {
  final String id;
  final String name;
  final String upiId;

  const MerchantModel({required this.id, required this.name, required this.upiId});
}

class CategoryModel {
  final String name;
  final String code;

  const CategoryModel({required this.name, required this.code});
}

class PaymentMethodModel {
  final String name;
  final String lastUsed;

  const PaymentMethodModel({required this.name, required this.lastUsed});
}

class StatementModel {
  final String id;
  final String month;
  final String year;
  final String fileUrl;

  const StatementModel({required this.id, required this.month, required this.year, required this.fileUrl});
}

class TransactionFilterModel {
  final String? category;
  final String? type;
  final DateTime? startDate;
  final DateTime? endDate;

  const TransactionFilterModel({this.category, this.type, this.startDate, this.endDate});
}

class TransactionSummaryModel {
  final double totalCredits;
  final double totalDebits;

  const TransactionSummaryModel({required this.totalCredits, required this.totalDebits});
}
