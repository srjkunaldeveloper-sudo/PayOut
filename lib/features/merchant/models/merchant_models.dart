class MerchantProfileModel {
  final String id;
  final String businessName;
  final String ownerName;
  final String businessType;
  final String category;
  final String mobile;
  final String email;
  final String gstNumber;
  final String panNumber;
  final String address;
  final String city;
  final String state;
  final String pincode;
  final bool isVerified;
  final String verificationStatus;
  final String joinedDate;
  final String settlementAccountMasked;

  const MerchantProfileModel({
    required this.id,
    required this.businessName,
    required this.ownerName,
    this.businessType = 'Private Limited',
    this.category = 'Retail & Grocery',
    this.mobile = '9876543210',
    this.email = 'business@payout.app',
    required this.gstNumber,
    this.panNumber = 'AABCP8832K',
    this.address = 'Shop 42, Commercial Complex, Sector 18',
    this.city = 'Noida',
    this.state = 'Uttar Pradesh',
    this.pincode = '201301',
    this.isVerified = true,
    this.verificationStatus = 'VERIFIED',
    this.joinedDate = 'Jan 2024',
    this.settlementAccountMasked = 'HDFC Bank •••• 9832',
  });

  String get storeName => businessName;
  String get businessCategory => category;
  String get phoneNumber => mobile;
  String get kycStatus => verificationStatus;
  String get bankAccountMasked => settlementAccountMasked;
  String get upiId => '${businessName.toLowerCase().replaceAll(RegExp(r"[^a-z0-9]"), "")}@payout';

  MerchantProfileModel copyWith({
    String? id,
    String? businessName,
    String? ownerName,
    String? businessType,
    String? category,
    String? mobile,
    String? email,
    String? gstNumber,
    String? panNumber,
    String? address,
    String? city,
    String? state,
    String? pincode,
    bool? isVerified,
    String? verificationStatus,
    String? joinedDate,
    String? settlementAccountMasked,
  }) {
    return MerchantProfileModel(
      id: id ?? this.id,
      businessName: businessName ?? this.businessName,
      ownerName: ownerName ?? this.ownerName,
      businessType: businessType ?? this.businessType,
      category: category ?? this.category,
      mobile: mobile ?? this.mobile,
      email: email ?? this.email,
      gstNumber: gstNumber ?? this.gstNumber,
      panNumber: panNumber ?? this.panNumber,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      pincode: pincode ?? this.pincode,
      isVerified: isVerified ?? this.isVerified,
      verificationStatus: verificationStatus ?? this.verificationStatus,
      joinedDate: joinedDate ?? this.joinedDate,
      settlementAccountMasked: settlementAccountMasked ?? this.settlementAccountMasked,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'businessName': businessName,
      'ownerName': ownerName,
      'businessType': businessType,
      'category': category,
      'mobile': mobile,
      'email': email,
      'gstNumber': gstNumber,
      'panNumber': panNumber,
      'address': address,
      'city': city,
      'state': state,
      'pincode': pincode,
      'isVerified': isVerified,
      'verificationStatus': verificationStatus,
      'joinedDate': joinedDate,
      'settlementAccountMasked': settlementAccountMasked,
    };
  }

  factory MerchantProfileModel.fromJson(Map<String, dynamic> json) {
    return MerchantProfileModel(
      id: json['id'] as String,
      businessName: json['businessName'] as String,
      ownerName: json['ownerName'] as String,
      businessType: json['businessType'] as String? ?? 'Private Limited',
      category: json['category'] as String? ?? 'Retail & Grocery',
      mobile: json['mobile'] as String? ?? '9876543210',
      email: json['email'] as String? ?? 'business@payout.app',
      gstNumber: json['gstNumber'] as String,
      panNumber: json['panNumber'] as String? ?? 'AABCP8832K',
      address: json['address'] as String? ?? '',
      city: json['city'] as String? ?? '',
      state: json['state'] as String? ?? '',
      pincode: json['pincode'] as String? ?? '',
      isVerified: json['isVerified'] as bool? ?? true,
      verificationStatus: json['verificationStatus'] as String? ?? 'VERIFIED',
      joinedDate: json['joinedDate'] as String? ?? '',
      settlementAccountMasked: json['settlementAccountMasked'] as String? ?? 'HDFC Bank •••• 9832',
    );
  }
}

class MerchantSalesSummaryModel {
  final double todaySales;
  final double weeklySales;
  final double monthlySales;
  final int transactionCount;
  final int successfulTransactions;
  final int failedTransactions;
  final double averageTransactionValue;

  const MerchantSalesSummaryModel({
    required this.todaySales,
    required this.weeklySales,
    required this.monthlySales,
    required this.transactionCount,
    required this.successfulTransactions,
    required this.failedTransactions,
    required this.averageTransactionValue,
  });

  double get settlementPending => todaySales * 0.75;

  MerchantSalesSummaryModel copyWith({
    double? todaySales,
    double? weeklySales,
    double? monthlySales,
    int? transactionCount,
    int? successfulTransactions,
    int? failedTransactions,
    double? averageTransactionValue,
  }) {
    return MerchantSalesSummaryModel(
      todaySales: todaySales ?? this.todaySales,
      weeklySales: weeklySales ?? this.weeklySales,
      monthlySales: monthlySales ?? this.monthlySales,
      transactionCount: transactionCount ?? this.transactionCount,
      successfulTransactions: successfulTransactions ?? this.successfulTransactions,
      failedTransactions: failedTransactions ?? this.failedTransactions,
      averageTransactionValue: averageTransactionValue ?? this.averageTransactionValue,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'todaySales': todaySales,
      'weeklySales': weeklySales,
      'monthlySales': monthlySales,
      'transactionCount': transactionCount,
      'successfulTransactions': successfulTransactions,
      'failedTransactions': failedTransactions,
      'averageTransactionValue': averageTransactionValue,
    };
  }

  factory MerchantSalesSummaryModel.fromJson(Map<String, dynamic> json) {
    return MerchantSalesSummaryModel(
      todaySales: (json['todaySales'] as num).toDouble(),
      weeklySales: (json['weeklySales'] as num).toDouble(),
      monthlySales: (json['monthlySales'] as num).toDouble(),
      transactionCount: json['transactionCount'] as int,
      successfulTransactions: json['successfulTransactions'] as int,
      failedTransactions: json['failedTransactions'] as int,
      averageTransactionValue: (json['averageTransactionValue'] as num).toDouble(),
    );
  }
}

class MerchantTransactionModel {
  final String id;
  final String transactionId;
  final String customerName;
  final double amount;
  final String paymentMethod;
  final String status;
  final String dateTime;
  final String utr;

  const MerchantTransactionModel({
    required this.id,
    required this.transactionId,
    required this.customerName,
    required this.amount,
    required this.paymentMethod,
    required this.status,
    required this.dateTime,
    required this.utr,
  });

  MerchantTransactionModel copyWith({
    String? id,
    String? transactionId,
    String? customerName,
    double? amount,
    String? paymentMethod,
    String? status,
    String? dateTime,
    String? utr,
  }) {
    return MerchantTransactionModel(
      id: id ?? this.id,
      transactionId: transactionId ?? this.transactionId,
      customerName: customerName ?? this.customerName,
      amount: amount ?? this.amount,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      status: status ?? this.status,
      dateTime: dateTime ?? this.dateTime,
      utr: utr ?? this.utr,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'transactionId': transactionId,
      'customerName': customerName,
      'amount': amount,
      'paymentMethod': paymentMethod,
      'status': status,
      'dateTime': dateTime,
      'utr': utr,
    };
  }

  factory MerchantTransactionModel.fromJson(Map<String, dynamic> json) {
    return MerchantTransactionModel(
      id: json['id'] as String,
      transactionId: json['transactionId'] as String,
      customerName: json['customerName'] as String,
      amount: (json['amount'] as num).toDouble(),
      paymentMethod: json['paymentMethod'] as String,
      status: json['status'] as String,
      dateTime: json['dateTime'] as String,
      utr: json['utr'] as String,
    );
  }
}

class SettlementModel {
  final String id;
  final String settlementId;
  final double amount;
  final String settlementDate;
  final String status;
  final String bankAccountMasked;
  final String utr;

  const SettlementModel({
    required this.id,
    required this.settlementId,
    required this.amount,
    required this.settlementDate,
    required this.status,
    this.bankAccountMasked = 'HDFC Bank •••• 9832',
    this.utr = 'UTR983210982341',
  });

  // Backward compatibility getter for date
  String get date => settlementDate;

  SettlementModel copyWith({
    String? id,
    String? settlementId,
    double? amount,
    String? settlementDate,
    String? status,
    String? bankAccountMasked,
    String? utr,
  }) {
    return SettlementModel(
      id: id ?? this.id,
      settlementId: settlementId ?? this.settlementId,
      amount: amount ?? this.amount,
      settlementDate: settlementDate ?? this.settlementDate,
      status: status ?? this.status,
      bankAccountMasked: bankAccountMasked ?? this.bankAccountMasked,
      utr: utr ?? this.utr,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'settlementId': settlementId,
      'amount': amount,
      'settlementDate': settlementDate,
      'status': status,
      'bankAccountMasked': bankAccountMasked,
      'utr': utr,
    };
  }

  factory SettlementModel.fromJson(Map<String, dynamic> json) {
    return SettlementModel(
      id: json['id'] as String,
      settlementId: json['settlementId'] as String? ?? json['id'] as String,
      amount: (json['amount'] as num).toDouble(),
      settlementDate: json['settlementDate'] as String? ?? json['date'] as String? ?? '',
      status: json['status'] as String,
      bankAccountMasked: json['bankAccountMasked'] as String? ?? 'HDFC Bank •••• 9832',
      utr: json['utr'] as String? ?? 'UTR983210982341',
    );
  }
}

class MerchantOfferModel {
  final String id;
  final String title;
  final String description;
  final double discount;
  final String validFrom;
  final String validUntil;
  final double minimumTransactionAmount;
  final int usageLimit;
  final bool isActive;

  const MerchantOfferModel({
    required this.id,
    required this.title,
    required this.description,
    required this.discount,
    required this.validFrom,
    required this.validUntil,
    required this.minimumTransactionAmount,
    this.usageLimit = 100,
    this.isActive = true,
  });

  String get code => 'STORE${discount.toInt()}';
  double get minSpend => minimumTransactionAmount;
  double get discountPercent => discount;

  MerchantOfferModel copyWith({
    String? id,
    String? title,
    String? description,
    double? discount,
    String? validFrom,
    String? validUntil,
    double? minimumTransactionAmount,
    int? usageLimit,
    bool? isActive,
  }) {
    return MerchantOfferModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      discount: discount ?? this.discount,
      validFrom: validFrom ?? this.validFrom,
      validUntil: validUntil ?? this.validUntil,
      minimumTransactionAmount: minimumTransactionAmount ?? this.minimumTransactionAmount,
      usageLimit: usageLimit ?? this.usageLimit,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'discount': discount,
      'validFrom': validFrom,
      'validUntil': validUntil,
      'minimumTransactionAmount': minimumTransactionAmount,
      'usageLimit': usageLimit,
      'isActive': isActive,
    };
  }

  factory MerchantOfferModel.fromJson(Map<String, dynamic> json) {
    return MerchantOfferModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      discount: (json['discount'] as num).toDouble(),
      validFrom: json['validFrom'] as String,
      validUntil: json['validUntil'] as String,
      minimumTransactionAmount: (json['minimumTransactionAmount'] as num).toDouble(),
      usageLimit: json['usageLimit'] as int? ?? 100,
      isActive: json['isActive'] as bool? ?? true,
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
