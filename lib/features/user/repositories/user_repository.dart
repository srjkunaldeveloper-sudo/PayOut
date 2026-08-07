import 'package:payout/features/user/models/user_models.dart';
import 'package:payout/features/user/dummy/dummy_user_data.dart';
import 'package:payout/features/user/services/user_logger.dart';

abstract class UserRepository {
  Future<UserProfileModel> getProfile();
  Future<bool> updateProfile(UserProfileModel profile);
  Future<KYCModel> getKYC();
  Future<bool> uploadDocument(String type, String code);
  Future<PreferenceModel> getPreferences();
  Future<bool> updatePreferences(PreferenceModel prefs);
}

class MockUserRepository implements UserRepository {
  @override
  Future<UserProfileModel> getProfile() async {
    // TODO: Connect user account profile database endpoint
    await Future.delayed(const Duration(milliseconds: 400));
    return DummyUserData.currentUser;
  }

  @override
  Future<bool> updateProfile(UserProfileModel profile) async {
    // TODO: Connect user account profile update gateway
    await Future.delayed(const Duration(milliseconds: 500));
    DummyUserData.currentUser = profile;
    UserLogger.logProfileUpdated();
    return true;
  }

  @override
  Future<KYCModel> getKYC() async {
    // TODO: Connect user identity verification status endpoint
    await Future.delayed(const Duration(milliseconds: 400));
    return DummyUserData.currentKYC;
  }

  @override
  Future<bool> uploadDocument(String type, String code) async {
    // TODO: Connect identity validation document scan scanner
    await Future.delayed(const Duration(milliseconds: 800));
    UserLogger.logKycDocumentUploaded(type);
    DummyUserData.currentKYC = KYCModel(status: 'PENDING', documentType: type, documentNumber: code);
    return true;
  }

  @override
  Future<PreferenceModel> getPreferences() async {
    // TODO: Connect settings synchronization endpoint
    await Future.delayed(const Duration(milliseconds: 300));
    return DummyUserData.currentPreferences;
  }

  @override
  Future<bool> updatePreferences(PreferenceModel prefs) async {
    // TODO: Connect settings update gateway
    await Future.delayed(const Duration(milliseconds: 300));
    DummyUserData.currentPreferences = prefs;
    UserLogger.logPreferenceChanged('language', prefs.language);
    return true;
  }
}
