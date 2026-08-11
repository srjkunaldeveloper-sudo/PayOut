import 'dart:async';
import 'package:payout/core/result/app_result.dart';
import 'package:payout/features/auth/models/auth_models.dart';
import 'package:payout/features/auth/repositories/auth_repository.dart';
import 'package:payout/features/auth/services/firebase_auth_service.dart';

/// Real Firebase implementation of AuthRepository.
/// Integrates with FirebaseAuthService for production and API environments.
class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuthService _firebaseAuthService;

  FirebaseAuthRepository({FirebaseAuthService? firebaseAuthService})
      : _firebaseAuthService = firebaseAuthService ?? FirebaseAuthService();

  @override
  UserModel? get currentUser => _firebaseAuthService.currentUser;

  @override
  Stream<UserModel?> get authStateChanges => _firebaseAuthService.authStateChanges;

  @override
  Future<bool> createMPIN(String mpin) async {
    return true;
  }

  @override
  Future<AppResult<UserModel>> registerWithEmailPassword({
    required String email,
    required String password,
    String? name,
    String? phone,
  }) {
    return _firebaseAuthService.registerWithEmailAndPassword(
      email: email,
      password: password,
      name: name,
      phone: phone,
    );
  }

  @override
  Future<AppResult<UserModel>> signInWithEmailPassword({
    required String email,
    required String password,
  }) {
    return _firebaseAuthService.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<AppResult<void>> signOut() {
    return _firebaseAuthService.signOut();
  }

  @override
  Future<AppResult<void>> deleteAccount({String? currentPassword}) {
    return _firebaseAuthService.deleteAccount(currentPassword: currentPassword);
  }
}
