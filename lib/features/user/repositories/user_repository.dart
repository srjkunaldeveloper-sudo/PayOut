import 'package:payout/features/user/models/user_models.dart';
import 'package:payout/features/user/dummy/dummy_user_data.dart';
import 'package:payout/features/user/services/user_logger.dart';
import 'package:payout/features/bank_accounts/repositories/bank_account_repository.dart';

abstract class UserRepository {
  Future<UserProfileModel> getProfile();
  Future<bool> updateProfile(UserProfileModel profile);
  Future<bool> changeMobile(String newPhone, String otp);
  Future<KYCModel> getKYC();
  Future<KYCModel> submitKYC(KYCModel kycSubmission);
  Future<KYCModel> checkKYCStatus();
  Future<bool> uploadDocument(String type, String code);
  Future<PreferenceModel> getPreferences();
  Future<bool> updatePreferences(PreferenceModel prefs);
}

class MockUserRepository implements UserRepository {
  final BankAccountRepository? bankAccountRepository;

  MockUserRepository({this.bankAccountRepository});

  @override
  Future<UserProfileModel> getProfile() async {
    // TODO(api): GET /users/profile
    await Future.delayed(const Duration(milliseconds: 300));
    final linkedAccounts = await bankAccountRepository?.getLinkedAccounts();
    final count = linkedAccounts != null ? linkedAccounts.length : DummyUserData.currentUser.linkedBankCount;
    return DummyUserData.currentUser.copyWith(linkedBankCount: count);
  }

  @override
  Future<bool> updateProfile(UserProfileModel profile) async {
    // TODO(api): PUT /users/profile
    await Future.delayed(const Duration(milliseconds: 400));
    DummyUserData.currentUser = profile;
    UserLogger.logProfileUpdated();
    return true;
  }

  @override
  Future<bool> changeMobile(String newPhone, String otp) async {
    // TODO(api): POST /users/change-mobile/verify-otp
    await Future.delayed(const Duration(milliseconds: 400));
    DummyUserData.currentUser = DummyUserData.currentUser.copyWith(phone: newPhone);
    UserLogger.log('Mobile number updated successfully.');
    return true;
  }

  @override
  Future<KYCModel> getKYC() async {
    // TODO(api): GET /kyc/status
    await Future.delayed(const Duration(milliseconds: 300));
    return DummyUserData.currentKYC;
  }

  @override
  Future<KYCModel> submitKYC(KYCModel kycSubmission) async {
    // TODO(api): POST /kyc/submit
    await Future.delayed(const Duration(milliseconds: 800));
    final updated = kycSubmission.copyWith(
      status: 'VERIFIED',
      verifiedDate: 'Today, Just Now',
    );
    DummyUserData.currentKYC = updated;
    DummyUserData.currentUser = DummyUserData.currentUser.copyWith(isKycVerified: true);
    UserLogger.log('KYC submission processed successfully.');
    return updated;
  }

  @override
  Future<KYCModel> checkKYCStatus() async {
    // TODO(api): GET /kyc/status/check
    await Future.delayed(const Duration(milliseconds: 400));
    return DummyUserData.currentKYC;
  }

  @override
  Future<bool> uploadDocument(String type, String code) async {
    // TODO(api): POST /kyc/documents
    await Future.delayed(const Duration(milliseconds: 500));
    UserLogger.logKycDocumentUploaded(type);
    DummyUserData.currentKYC = DummyUserData.currentKYC.copyWith(
      documentUploaded: true,
      documentType: type,
      documentNumber: code,
    );
    return true;
  }

  @override
  Future<PreferenceModel> getPreferences() async {
    // TODO(api): GET /users/preferences
    await Future.delayed(const Duration(milliseconds: 300));
    return DummyUserData.currentPreferences;
  }

  @override
  Future<bool> updatePreferences(PreferenceModel prefs) async {
    // TODO(api): PUT /users/preferences
    await Future.delayed(const Duration(milliseconds: 300));
    DummyUserData.currentPreferences = prefs;
    UserLogger.logPreferenceChanged('language', prefs.language);
    return true;
  }
}
