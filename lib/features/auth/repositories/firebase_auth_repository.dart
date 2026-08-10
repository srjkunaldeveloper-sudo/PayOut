import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
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
  Future<LoginResponse> login(LoginRequest request) async {
    final completer = Completer<LoginResponse>();
    await _firebaseAuthService.verifyPhoneNumber(
      phoneNumber: '${request.countryCode}${request.mobile}',
      onCodeSent: (verificationId, token) {
        if (!completer.isCompleted) {
          completer.complete(LoginResponse(
            success: true,
            sessionId: verificationId,
          ));
        }
      },
      onVerificationFailed: (errorMessage) {
        if (!completer.isCompleted) {
          completer.complete(LoginResponse(
            success: false,
            message: errorMessage,
          ));
        }
      },
      onCodeAutoRetrievalTimeout: (verificationId) {
        if (!completer.isCompleted) {
          completer.complete(LoginResponse(
            success: true,
            sessionId: verificationId,
          ));
        }
      },
    );
    return completer.future;
  }

  @override
  Future<OTPResponse> verifyOTP(OTPRequest request) async {
    final result = await _firebaseAuthService.signInWithPhoneOTP(
      verificationId: request.sessionId,
      smsCode: request.code,
    );

    if (result.isSuccess && result.data != null) {
      return OTPResponse(
        success: true,
        user: result.data,
        accessToken: 'FIREBASE-TOKEN-${result.data!.id}',
        refreshToken: 'FIREBASE-REFRESH-${result.data!.id}',
      );
    } else {
      return OTPResponse(
        success: false,
        message: result.message ?? 'Verification failed. Please try again.',
      );
    }
  }

  @override
  Future<bool> createMPIN(String mpin) async {
    return true;
  }

  @override
  Future<bool> resendOTP(String phone) async {
    final completer = Completer<bool>();
    await _firebaseAuthService.verifyPhoneNumber(
      phoneNumber: phone,
      onCodeSent: (verificationId, token) {
        if (!completer.isCompleted) completer.complete(true);
      },
      onVerificationFailed: (errorMessage) {
        if (!completer.isCompleted) completer.complete(false);
      },
      onCodeAutoRetrievalTimeout: (_) {
        if (!completer.isCompleted) completer.complete(true);
      },
    );
    return completer.future;
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
  Future<AppResult<UserModel>> linkEmailPasswordCredential({
    required String email,
    required String password,
    String? name,
  }) {
    return _firebaseAuthService.linkEmailPasswordCredential(
      email: email,
      password: password,
      name: name,
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
  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required void Function(String verificationId, int? resendToken) onCodeSent,
    required void Function(String errorMessage) onVerificationFailed,
    required void Function(String verificationId) onCodeAutoRetrievalTimeout,
    void Function(PhoneAuthCredential credential)? onVerificationCompleted,
    Duration timeout = const Duration(seconds: 60),
    int? resendToken,
  }) {
    return _firebaseAuthService.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      onCodeSent: onCodeSent,
      onVerificationFailed: onVerificationFailed,
      onCodeAutoRetrievalTimeout: onCodeAutoRetrievalTimeout,
      onVerificationCompleted: onVerificationCompleted,
      timeout: timeout,
      resendToken: resendToken,
    );
  }

  @override
  Future<AppResult<UserModel>> verifyPhoneOTP({
    required String verificationId,
    required String smsCode,
  }) {
    return _firebaseAuthService.signInWithPhoneOTP(
      verificationId: verificationId,
      smsCode: smsCode,
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
