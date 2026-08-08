class CouponModel {
  final String id;
  final String code;
  final String title;
  final String description;
  final String discountType; // 'PERCENTAGE' or 'FLAT'
  final double discountValue;
  final double minimumSpend;
  final double maximumDiscount;
  final String validFrom;
  final String validUntil;
  final String category;
  final int usageLimit;
  final int usedCount;
  final bool isActive;

  const CouponModel({
    required this.id,
    required this.code,
    required this.title,
    required this.description,
    this.discountType = 'PERCENTAGE',
    required this.discountValue,
    this.minimumSpend = 500.0,
    this.maximumDiscount = 200.0,
    this.validFrom = '01 Aug 2026',
    required this.validUntil,
    this.category = 'Shopping',
    this.usageLimit = 1,
    this.usedCount = 0,
    this.isActive = true,
  });

  // Backward compatibility getters
  String get merchantName => title;
  String get discountCode => code;
  String get expiryDate => validUntil;

  CouponModel copyWith({
    String? id,
    String? code,
    String? title,
    String? description,
    String? discountType,
    double? discountValue,
    double? minimumSpend,
    double? maximumDiscount,
    String? validFrom,
    String? validUntil,
    String? category,
    int? usageLimit,
    int? usedCount,
    bool? isActive,
  }) {
    return CouponModel(
      id: id ?? this.id,
      code: code ?? this.code,
      title: title ?? this.title,
      description: description ?? this.description,
      discountType: discountType ?? this.discountType,
      discountValue: discountValue ?? this.discountValue,
      minimumSpend: minimumSpend ?? this.minimumSpend,
      maximumDiscount: maximumDiscount ?? this.maximumDiscount,
      validFrom: validFrom ?? this.validFrom,
      validUntil: validUntil ?? this.validUntil,
      category: category ?? this.category,
      usageLimit: usageLimit ?? this.usageLimit,
      usedCount: usedCount ?? this.usedCount,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'title': title,
      'description': description,
      'discountType': discountType,
      'discountValue': discountValue,
      'minimumSpend': minimumSpend,
      'maximumDiscount': maximumDiscount,
      'validFrom': validFrom,
      'validUntil': validUntil,
      'category': category,
      'usageLimit': usageLimit,
      'usedCount': usedCount,
      'isActive': isActive,
    };
  }

  factory CouponModel.fromJson(Map<String, dynamic> json) {
    return CouponModel(
      id: json['id'] as String,
      code: json['code'] as String? ?? json['discountCode'] as String? ?? '',
      title: json['title'] as String? ?? json['merchantName'] as String? ?? '',
      description: json['description'] as String? ?? '',
      discountType: json['discountType'] as String? ?? 'PERCENTAGE',
      discountValue: (json['discountValue'] as num?)?.toDouble() ?? 10.0,
      minimumSpend: (json['minimumSpend'] as num?)?.toDouble() ?? 500.0,
      maximumDiscount: (json['maximumDiscount'] as num?)?.toDouble() ?? 200.0,
      validFrom: json['validFrom'] as String? ?? '01 Aug 2026',
      validUntil: json['validUntil'] as String? ?? json['expiryDate'] as String? ?? '',
      category: json['category'] as String? ?? 'Shopping',
      usageLimit: json['usageLimit'] as int? ?? 1,
      usedCount: json['usedCount'] as int? ?? 0,
      isActive: json['isActive'] as bool? ?? true,
    );
  }
}

class ScratchCardModel {
  final String id;
  final String title;
  final String description;
  final String rewardType; // 'CASHBACK' or 'DISCOUNT'
  final double rewardValue;
  final String status; // 'UNSCRATCHED', 'SCRATCHED', 'EXPIRED'
  final String expiresAt;
  final String? claimedAt;

  const ScratchCardModel({
    required this.id,
    required this.title,
    required this.description,
    this.rewardType = 'CASHBACK',
    required this.rewardValue,
    this.status = 'UNSCRATCHED',
    required this.expiresAt,
    this.claimedAt,
  });

  // Backward compatibility getters
  double get amount => rewardValue;
  bool get isScratched => status.toUpperCase() == 'SCRATCHED';

  ScratchCardModel copyWith({
    String? id,
    String? title,
    String? description,
    String? rewardType,
    double? rewardValue,
    String? status,
    String? expiresAt,
    String? claimedAt,
    bool? isScratched,
    double? amount,
  }) {
    return ScratchCardModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      rewardType: rewardType ?? this.rewardType,
      rewardValue: rewardValue ?? amount ?? this.rewardValue,
      status: status ?? (isScratched != null ? (isScratched ? 'SCRATCHED' : 'UNSCRATCHED') : this.status),
      expiresAt: expiresAt ?? this.expiresAt,
      claimedAt: claimedAt ?? this.claimedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'rewardType': rewardType,
      'rewardValue': rewardValue,
      'status': status,
      'expiresAt': expiresAt,
      'claimedAt': claimedAt,
    };
  }

  factory ScratchCardModel.fromJson(Map<String, dynamic> json) {
    return ScratchCardModel(
      id: json['id'] as String,
      title: json['title'] as String? ?? 'Scratch & Win',
      description: json['description'] as String? ?? 'Exciting reward inside!',
      rewardType: json['rewardType'] as String? ?? 'CASHBACK',
      rewardValue: (json['rewardValue'] as num?)?.toDouble() ?? (json['amount'] as num?)?.toDouble() ?? 50.0,
      status: json['status'] as String? ?? ((json['isScratched'] as bool? ?? false) ? 'SCRATCHED' : 'UNSCRATCHED'),
      expiresAt: json['expiresAt'] as String? ?? '30 Days',
      claimedAt: json['claimedAt'] as String?,
    );
  }
}

class CashbackModel {
  final String id;
  final String source;
  final double amount;
  final String status; // 'AVAILABLE', 'PENDING', 'EXPIRED'
  final String earnedAt;
  final String expiresAt;
  final String? transactionId;

  const CashbackModel({
    required this.id,
    this.source = 'Merchant UPI Payment',
    required this.amount,
    this.status = 'AVAILABLE',
    required this.earnedAt,
    this.expiresAt = '31 Dec 2026',
    this.transactionId,
  });

  // Backward compatibility getter
  String get date => earnedAt;

  CashbackModel copyWith({
    String? id,
    String? source,
    double? amount,
    String? status,
    String? earnedAt,
    String? expiresAt,
    String? transactionId,
  }) {
    return CashbackModel(
      id: id ?? this.id,
      source: source ?? this.source,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      earnedAt: earnedAt ?? this.earnedAt,
      expiresAt: expiresAt ?? this.expiresAt,
      transactionId: transactionId ?? this.transactionId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'source': source,
      'amount': amount,
      'status': status,
      'earnedAt': earnedAt,
      'expiresAt': expiresAt,
      'transactionId': transactionId,
    };
  }

  factory CashbackModel.fromJson(Map<String, dynamic> json) {
    return CashbackModel(
      id: json['id'] as String,
      source: json['source'] as String? ?? 'Merchant Payment',
      amount: (json['amount'] as num).toDouble(),
      status: json['status'] as String? ?? 'AVAILABLE',
      earnedAt: json['earnedAt'] as String? ?? json['date'] as String? ?? '',
      expiresAt: json['expiresAt'] as String? ?? '31 Dec 2026',
      transactionId: json['transactionId'] as String?,
    );
  }
}

class RewardSummaryModel {
  final double totalCashback;
  final double availableCashback;
  final double pendingCashback;
  final double expiredCashback;
  final int totalCoupons;

  const RewardSummaryModel({
    required this.totalCashback,
    required this.availableCashback,
    required this.pendingCashback,
    required this.expiredCashback,
    required this.totalCoupons,
  });

  RewardSummaryModel copyWith({
    double? totalCashback,
    double? availableCashback,
    double? pendingCashback,
    double? expiredCashback,
    int? totalCoupons,
  }) {
    return RewardSummaryModel(
      totalCashback: totalCashback ?? this.totalCashback,
      availableCashback: availableCashback ?? this.availableCashback,
      pendingCashback: pendingCashback ?? this.pendingCashback,
      expiredCashback: expiredCashback ?? this.expiredCashback,
      totalCoupons: totalCoupons ?? this.totalCoupons,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalCashback': totalCashback,
      'availableCashback': availableCashback,
      'pendingCashback': pendingCashback,
      'expiredCashback': expiredCashback,
      'totalCoupons': totalCoupons,
    };
  }

  factory RewardSummaryModel.fromJson(Map<String, dynamic> json) {
    return RewardSummaryModel(
      totalCashback: (json['totalCashback'] as num).toDouble(),
      availableCashback: (json['availableCashback'] as num).toDouble(),
      pendingCashback: (json['pendingCashback'] as num).toDouble(),
      expiredCashback: (json['expiredCashback'] as num).toDouble(),
      totalCoupons: json['totalCoupons'] as int,
    );
  }
}

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
