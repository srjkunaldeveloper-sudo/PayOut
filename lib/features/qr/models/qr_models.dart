class MerchantModel {
  final String id;
  final String name;
  final String upiId;
  final String category;
  final double rating;
  final String distance;
  final String cashbackText;
  final List<String> offers;
  final bool isVerified;

  const MerchantModel({
    required this.id,
    required this.name,
    required this.upiId,
    required this.category,
    required this.rating,
    required this.distance,
    required this.cashbackText,
    required this.offers,
    required this.isVerified,
  });

  MerchantModel copyWith({
    String? id,
    String? name,
    String? upiId,
    String? category,
    double? rating,
    String? distance,
    String? cashbackText,
    List<String>? offers,
    bool? isVerified,
  }) {
    return MerchantModel(
      id: id ?? this.id,
      name: name ?? this.name,
      upiId: upiId ?? this.upiId,
      category: category ?? this.category,
      rating: rating ?? this.rating,
      distance: distance ?? this.distance,
      cashbackText: cashbackText ?? this.cashbackText,
      offers: offers ?? this.offers,
      isVerified: isVerified ?? this.isVerified,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'upiId': upiId,
      'category': category,
      'rating': rating,
      'distance': distance,
      'cashbackText': cashbackText,
      'offers': offers,
      'isVerified': isVerified,
    };
  }

  factory MerchantModel.fromJson(Map<String, dynamic> json) {
    return MerchantModel(
      id: json['id'] as String,
      name: json['name'] as String,
      upiId: json['upiId'] as String,
      category: json['category'] as String,
      rating: (json['rating'] as num).toDouble(),
      distance: json['distance'] as String,
      cashbackText: json['cashbackText'] as String,
      offers: List<String>.from(json['offers'] as List),
      isVerified: json['isVerified'] as bool,
    );
  }
}

class MerchantCategoryModel {
  final String name;
  final String code;

  const MerchantCategoryModel({required this.name, required this.code});
}

class MerchantOfferModel {
  final String title;
  final String description;
  final String code;

  const MerchantOfferModel({required this.title, required this.description, required this.code});
}

class MerchantLocationModel {
  final double latitude;
  final double longitude;
  final String address;

  const MerchantLocationModel({required this.latitude, required this.longitude, required this.address});
}

class MerchantRatingModel {
  final double average;
  final int count;

  const MerchantRatingModel({required this.average, required this.count});
}

class MerchantReviewModel {
  final String reviewerName;
  final String text;
  final double rating;

  const MerchantReviewModel({required this.reviewerName, required this.text, required this.rating});
}

class QRModel {
  final String payload;
  final String type;
  final String? expiryTime;

  const QRModel({required this.payload, required this.type, this.expiryTime});
}

class ScanResultModel {
  final bool success;
  final String payload;
  final String? errorMessage;

  const ScanResultModel({required this.success, required this.payload, this.errorMessage});
}

class PersonalQRModel {
  final String upiId;
  final String qrCodeUrl;
  final String userName;

  const PersonalQRModel({required this.upiId, required this.qrCodeUrl, required this.userName});
}

class BusinessQRModel {
  final String upiId;
  final String qrCodeUrl;
  final String merchantName;

  const BusinessQRModel({required this.upiId, required this.qrCodeUrl, required this.merchantName});
}

class QRHistoryModel {
  final String id;
  final String date;
  final String merchantName;
  final double amount;
  final String status;

  const QRHistoryModel({
    required this.id,
    required this.date,
    required this.merchantName,
    required this.amount,
    required this.status,
  });
}

class QRPaymentRequest {
  final String merchantId;
  final double amount;
  final String remarks;

  const QRPaymentRequest({required this.merchantId, required this.amount, required this.remarks});
}

class QRPaymentResponse {
  final bool success;
  final String transactionId;
  final String status;

  const QRPaymentResponse({required this.success, required this.transactionId, required this.status});
}
