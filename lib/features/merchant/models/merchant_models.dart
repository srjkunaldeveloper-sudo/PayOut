class MerchantProfileModel {
  final String id;
  final String businessName;
  final String ownerName;
  final String gstNumber;

  const MerchantProfileModel({
    required this.id,
    required this.businessName,
    required this.ownerName,
    required this.gstNumber,
  });

  MerchantProfileModel copyWith({
    String? id,
    String? businessName,
    String? ownerName,
    String? gstNumber,
  }) {
    return MerchantProfileModel(
      id: id ?? this.id,
      businessName: businessName ?? this.businessName,
      ownerName: ownerName ?? this.ownerName,
      gstNumber: gstNumber ?? this.gstNumber,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'businessName': businessName, 'ownerName': ownerName, 'gstNumber': gstNumber};
  }

  factory MerchantProfileModel.fromJson(Map<String, dynamic> json) {
    return MerchantProfileModel(
      id: json['id'] as String,
      businessName: json['businessName'] as String,
      ownerName: json['ownerName'] as String,
      gstNumber: json['gstNumber'] as String,
    );
  }
}

class SettlementModel {
  final String id;
  final double amount;
  final String date;
  final String status;

  const SettlementModel({
    required this.id,
    required this.amount,
    required this.date,
    required this.status,
  });

  SettlementModel copyWith({
    String? id,
    double? amount,
    String? date,
    String? status,
  }) {
    return SettlementModel(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'amount': amount, 'date': date, 'status': status};
  }

  factory SettlementModel.fromJson(Map<String, dynamic> json) {
    return SettlementModel(
      id: json['id'] as String,
      amount: (json['amount'] as num).toDouble(),
      date: json['date'] as String,
      status: json['status'] as String,
    );
  }
}

class BusinessInsightModel {
  final String title;
  final String value;
  final double changePercentage;

  const BusinessInsightModel({
    required this.title,
    required this.value,
    required this.changePercentage,
  });
}

class InvoiceModel {
  final String id;
  final String customerName;
  final double amount;
  final String date;

  const InvoiceModel({
    required this.id,
    required this.customerName,
    required this.amount,
    required this.date,
  });
}
