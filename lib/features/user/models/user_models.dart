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
  final String? dob;
  final String memberSince;
  final int linkedBankCount;
  final String? avatarUrl;

  const UserProfileModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.isKycVerified,
    required this.address,
    this.dob,
    this.memberSince = 'March 2024',
    this.linkedBankCount = 2,
    this.avatarUrl,
  });

  UserProfileModel copyWith({
    String? name,
    String? email,
    String? phone,
    bool? isKycVerified,
    String? address,
    String? dob,
    String? memberSince,
    int? linkedBankCount,
    String? avatarUrl,
  }) {
    return UserProfileModel(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      isKycVerified: isKycVerified ?? this.isKycVerified,
      address: address ?? this.address,
      dob: dob ?? this.dob,
      memberSince: memberSince ?? this.memberSince,
      linkedBankCount: linkedBankCount ?? this.linkedBankCount,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'isKycVerified': isKycVerified,
      'address': address,
      'dob': dob,
      'memberSince': memberSince,
      'linkedBankCount': linkedBankCount,
      'avatarUrl': avatarUrl,
    };
  }

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      isKycVerified: json['isKycVerified'] as bool,
      address: json['address'] as String,
      dob: json['dob'] as String?,
      memberSince: json['memberSince'] as String? ?? 'March 2024',
      linkedBankCount: json['linkedBankCount'] as int? ?? 2,
      avatarUrl: json['avatarUrl'] as String?,
    );
  }
}

class PreferenceModel {
  final String theme;
  final String language;
  final bool biometricEnabled;
  final bool appLockEnabled;
  final bool paymentNotif;
  final bool rechargeNotif;
  final bool billsNotif;
  final bool offersNotif;

  const PreferenceModel({
    required this.theme,
    required this.language,
    required this.biometricEnabled,
    this.appLockEnabled = true,
    this.paymentNotif = true,
    this.rechargeNotif = true,
    this.billsNotif = true,
    this.offersNotif = true,
  });

  PreferenceModel copyWith({
    String? theme,
    String? language,
    bool? biometricEnabled,
    bool? appLockEnabled,
    bool? paymentNotif,
    bool? rechargeNotif,
    bool? billsNotif,
    bool? offersNotif,
  }) {
    return PreferenceModel(
      theme: theme ?? this.theme,
      language: language ?? this.language,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      appLockEnabled: appLockEnabled ?? this.appLockEnabled,
      paymentNotif: paymentNotif ?? this.paymentNotif,
      rechargeNotif: rechargeNotif ?? this.rechargeNotif,
      billsNotif: billsNotif ?? this.billsNotif,
      offersNotif: offersNotif ?? this.offersNotif,
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
  final String status; // NOT_STARTED, IN_PROGRESS, VERIFIED, PENDING, REJECTED, NEEDS_ACTION
  final String documentType;
  final String documentNumber;
  final bool personalDetailsSubmitted;
  final bool panVerified;
  final bool documentUploaded;
  final bool bankVerified;
  final String? panNumber;
  final String? verifiedDate;
  final String? rejectionReason;

  const KYCModel({
    required this.status,
    required this.documentType,
    required this.documentNumber,
    this.personalDetailsSubmitted = false,
    this.panVerified = false,
    this.documentUploaded = false,
    this.bankVerified = false,
    this.panNumber,
    this.verifiedDate,
    this.rejectionReason,
  });

  KYCModel copyWith({
    String? status,
    String? documentType,
    String? documentNumber,
    bool? personalDetailsSubmitted,
    bool? panVerified,
    bool? documentUploaded,
    bool? bankVerified,
    String? panNumber,
    String? verifiedDate,
    String? rejectionReason,
  }) {
    return KYCModel(
      status: status ?? this.status,
      documentType: documentType ?? this.documentType,
      documentNumber: documentNumber ?? this.documentNumber,
      personalDetailsSubmitted: personalDetailsSubmitted ?? this.personalDetailsSubmitted,
      panVerified: panVerified ?? this.panVerified,
      documentUploaded: documentUploaded ?? this.documentUploaded,
      bankVerified: bankVerified ?? this.bankVerified,
      panNumber: panNumber ?? this.panNumber,
      verifiedDate: verifiedDate ?? this.verifiedDate,
      rejectionReason: rejectionReason ?? this.rejectionReason,
    );
  }
}
