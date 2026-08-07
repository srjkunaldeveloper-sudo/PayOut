class AddressModel {
  final String street;
  final String city;
  final String state;
  final String pinCode;

  const AddressModel({required this.street, required this.city, required this.state, required this.pinCode});

  Map<String, dynamic> toJson() {
    return {'street': street, 'city': city, 'state': state, 'pinCode': pinCode};
  }

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      street: json['street'] as String,
      city: json['city'] as String,
      state: json['state'] as String,
      pinCode: json['pinCode'] as String,
    );
  }
}

class UserProfileModel {
  final String name;
  final String email;
  final String phone;
  final bool isKycVerified;
  final String address;

  const UserProfileModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.isKycVerified,
    required this.address,
  });

  UserProfileModel copyWith({
    String? name,
    String? email,
    String? phone,
    bool? isKycVerified,
    String? address,
  }) {
    return UserProfileModel(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      isKycVerified: isKycVerified ?? this.isKycVerified,
      address: address ?? this.address,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'isKycVerified': isKycVerified,
      'address': address,
    };
  }

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      isKycVerified: json['isKycVerified'] as bool,
      address: json['address'] as String,
    );
  }
}

class PreferenceModel {
  final String theme;
  final String language;
  final bool biometricEnabled;

  const PreferenceModel({required this.theme, required this.language, required this.biometricEnabled});

  PreferenceModel copyWith({String? theme, String? language, bool? biometricEnabled}) {
    return PreferenceModel(
      theme: theme ?? this.theme,
      language: language ?? this.language,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
    );
  }
}

class LinkedBankModel {
  final String bankName;
  final String accountNumber;
  final bool isPrimary;

  const LinkedBankModel({required this.bankName, required this.accountNumber, required this.isPrimary});
}

class SavedCardModel {
  final String cardHolderName;
  final String cardNumber;
  final String expiry;
  final String cardType;

  const SavedCardModel({
    required this.cardHolderName,
    required this.cardNumber,
    required this.expiry,
    required this.cardType,
  });
}

class RewardSummaryModel {
  final double cashbackEarned;
  final int pointsEarned;

  const RewardSummaryModel({required this.cashbackEarned, required this.pointsEarned});
}

class KYCModel {
  final String status; // VERIFIED, PENDING, REJECTED
  final String documentType;
  final String documentNumber;

  const KYCModel({required this.status, required this.documentType, required this.documentNumber});
}
