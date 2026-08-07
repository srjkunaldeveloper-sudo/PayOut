import 'package:payout/features/user/models/user_models.dart';

class DummyUserData {
  static UserProfileModel currentUser = const UserProfileModel(
    name: 'Rahul Sharma',
    email: 'rahulsharma@okaxis',
    phone: '9876543210',
    isKycVerified: true,
    address: '42, Park Street, New Delhi, India',
  );

  static KYCModel currentKYC = const KYCModel(
    status: 'VERIFIED',
    documentType: 'PAN Card',
    documentNumber: 'ABCDE1234F',
  );

  static PreferenceModel currentPreferences = const PreferenceModel(
    theme: 'Dark Mode',
    language: 'English',
    biometricEnabled: true,
  );

  static RewardSummaryModel currentRewards = const RewardSummaryModel(
    cashbackEarned: 240.00,
    pointsEarned: 1200,
  );

  static final List<LinkedBankModel> linkedBanks = [
    const LinkedBankModel(bankName: 'HDFC Bank', accountNumber: '•••• 8901', isPrimary: true),
    const LinkedBankModel(bankName: 'Axis Bank', accountNumber: '•••• 1234', isPrimary: false),
  ];

  static final List<SavedCardModel> savedCards = [
    const SavedCardModel(cardHolderName: 'Rahul Sharma', cardNumber: '•••• •••• •••• 5678', expiry: '12/29', cardType: 'VISA'),
  ];
}
