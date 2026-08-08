class OperatorModel {
  final String name;
  final String logoUrl;

  const OperatorModel({required this.name, required this.logoUrl});

  OperatorModel copyWith({String? name, String? logoUrl}) {
    return OperatorModel(
      name: name ?? this.name,
      logoUrl: logoUrl ?? this.logoUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'logoUrl': logoUrl};
  }

  factory OperatorModel.fromJson(Map<String, dynamic> json) {
    return OperatorModel(
      name: json['name'] as String,
      logoUrl: json['logoUrl'] as String,
    );
  }
}

class RechargePlanModel {
  final String id;
  final double amount;
  final String validity;
  final String data;
  final String description;
  final String category;
  final String operator;
  final String calls;
  final String sms;

  const RechargePlanModel({
    required this.id,
    required this.amount,
    required this.validity,
    required this.data,
    required this.description,
    required this.category,
    required this.operator,
    required this.calls,
    required this.sms,
  });

  RechargePlanModel copyWith({
    String? id,
    double? amount,
    String? validity,
    String? data,
    String? description,
    String? category,
    String? operator,
    String? calls,
    String? sms,
  }) {
    return RechargePlanModel(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      validity: validity ?? this.validity,
      data: data ?? this.data,
      description: description ?? this.description,
      category: category ?? this.category,
      operator: operator ?? this.operator,
      calls: calls ?? this.calls,
      sms: sms ?? this.sms,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'validity': validity,
      'data': data,
      'description': description,
      'category': category,
      'operator': operator,
      'calls': calls,
      'sms': sms,
    };
  }

  factory RechargePlanModel.fromJson(Map<String, dynamic> json) {
    return RechargePlanModel(
      id: json['id'] as String,
      amount: (json['amount'] as num).toDouble(),
      validity: json['validity'] as String,
      data: json['data'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      operator: json['operator'] as String? ?? '',
      calls: json['calls'] as String? ?? '',
      sms: json['sms'] as String? ?? '',
    );
  }
}

class RecentRechargeModel {
  final String id;
  final String mobileNumber;
  final String operatorName;
  final double amount;
  final String date;

  const RecentRechargeModel({
    required this.id,
    required this.mobileNumber,
    required this.operatorName,
    required this.amount,
    required this.date,
  });
}
