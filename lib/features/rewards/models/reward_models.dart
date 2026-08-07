class RewardModel {
  final String id;
  final String title;
  final String type;
  final String description;

  const RewardModel({
    required this.id,
    required this.title,
    required this.type,
    required this.description,
  });

  RewardModel copyWith({
    String? id,
    String? title,
    String? type,
    String? description,
  }) {
    return RewardModel(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'title': title, 'type': type, 'description': description};
  }

  factory RewardModel.fromJson(Map<String, dynamic> json) {
    return RewardModel(
      id: json['id'] as String,
      title: json['title'] as String,
      type: json['type'] as String,
      description: json['description'] as String,
    );
  }
}

class CouponModel {
  final String id;
  final String merchantName;
  final String discountCode;
  final String expiryDate;

  const CouponModel({
    required this.id,
    required this.merchantName,
    required this.discountCode,
    required this.expiryDate,
  });

  CouponModel copyWith({
    String? id,
    String? merchantName,
    String? discountCode,
    String? expiryDate,
  }) {
    return CouponModel(
      id: id ?? this.id,
      merchantName: merchantName ?? this.merchantName,
      discountCode: discountCode ?? this.discountCode,
      expiryDate: expiryDate ?? this.expiryDate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'merchantName': merchantName,
      'discountCode': discountCode,
      'expiryDate': expiryDate,
    };
  }

  factory CouponModel.fromJson(Map<String, dynamic> json) {
    return CouponModel(
      id: json['id'] as String,
      merchantName: json['merchantName'] as String,
      discountCode: json['discountCode'] as String,
      expiryDate: json['expiryDate'] as String,
    );
  }
}

class CashbackModel {
  final String id;
  final double amount;
  final String date;

  const CashbackModel({required this.id, required this.amount, required this.date});
}

class ScratchCardModel {
  final String id;
  final double amount;
  final bool isScratched;

  const ScratchCardModel({required this.id, required this.amount, required this.isScratched});

  ScratchCardModel copyWith({String? id, double? amount, bool? isScratched}) {
    return ScratchCardModel(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      isScratched: isScratched ?? this.isScratched,
    );
  }
}
