import 'package:payout/features/user/models/user_models.dart';

class DummyUserData {
  static UserProfileModel currentUser = const UserProfileModel(
    name: 'Rahul Sharma',
    email: 'rahul.sharma@payout.com',
    phone: '9876543210',
    isKycVerified: true,
    address: '42, Park Street, New Delhi, India',
    dob: '15/08/1995',
    memberSince: 'March 2024',
    linkedBankCount: 2,
  );

  static KYCModel currentKYC = const KYCModel(
    status: 'VERIFIED',
    documentType: 'PAN Card',
    documentNumber: 'ABCDE1234F',
    personalDetailsSubmitted: true,
    panVerified: true,
    documentUploaded: true,
    bankVerified: true,
    panNumber: 'ABCDE1234F',
    verifiedDate: '12 March 2024',
  );

  static PreferenceModel currentPreferences = const PreferenceModel(
    theme: 'Light Mode',
    language: 'English',
    biometricEnabled: true,
    appLockEnabled: true,
    paymentNotif: true,
    rechargeNotif: true,
    billsNotif: true,
    offersNotif: true,
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
