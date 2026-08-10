import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:payout/core/error/error_message_mapper.dart';
import 'package:payout/core/result/app_result.dart';
import 'package:payout/features/auth/models/auth_models.dart';
import 'package:payout/features/auth/services/auth_logger.dart';

/// Dedicated Firebase Authentication Service.
/// Encapsulates all Firebase Auth API interactions (Email/Password, Phone OTP, Credential Linking, Session).
/// Presentation layers should never access FirebaseAuth directly.
class FirebaseAuthService {
  final FirebaseAuth? _customAuth;

  FirebaseAuthService({FirebaseAuth? firebaseAuth}) : _customAuth = firebaseAuth;

  FirebaseAuth get _firebaseAuth {
    if (_customAuth != null) return _customAuth!;
    return FirebaseAuth.instance;
  }

  /// Returns the current authenticated domain user, using Firebase UID as the stable identifier.
  UserModel? get currentUser {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) return null;
      return _mapFirebaseUserToDomain(user);
    } catch (_) {
      return null;
    }
  }

  /// Authentication state changes stream mapped to domain UserModel.
  Stream<UserModel?> get authStateChanges {
    try {
      return _firebaseAuth.authStateChanges().map((user) {
        if (user == null) return null;
        return _mapFirebaseUserToDomain(user);
      });
    } catch (_) {
      return const Stream.empty();
    }
  }

  /// Registers a new user or links Email+Password to the already phone-authenticated user.
  /// Guarantees that Phone OTP verification + Password creation yields ONE single Firebase UID.
  Future<AppResult<UserModel>> registerWithEmailAndPassword({
    required String email,
    required String password,
    String? name,
    String? phone,
  }) async {
    try {
      final activeUser = _firebaseAuth.currentUser;

      // If user is already authenticated via Phone OTP during registration, link Email+Password credential
      if (activeUser != null) {
        AuthLogger.log('Linking email/password credential to active Firebase user: ${activeUser.uid}');
        final credential = EmailAuthProvider.credential(
          email: email.trim(),
          password: password,
        );

        final userCredential = await activeUser.linkWithCredential(credential);
        final linkedUser = userCredential.user ?? activeUser;

        // Ensure email and display name are updated on the linked user
        if (name != null && name.trim().isNotEmpty) {
          await linkedUser.updateDisplayName(name.trim());
        }

        final domainUser = _mapFirebaseUserToDomain(linkedUser, fallbackName: name, fallbackPhone: phone);
        AuthLogger.log('Email/password linked successfully to single UID: ${domainUser.id}');
        return AppResult.success(domainUser);
      }

      // Standalone new account creation
      AuthLogger.log('Firebase registration requested for: $email');
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final user = credential.user;
      if (user == null) {
        return AppResult.failure(
          Exception('User creation failed'),
          message: 'Failed to create user account. Please try again.',
        );
      }

      if (name != null && name.trim().isNotEmpty) {
        await user.updateDisplayName(name.trim());
      }

      final domainUser = _mapFirebaseUserToDomain(user, fallbackName: name, fallbackPhone: phone);
      AuthLogger.log('Firebase user registered successfully with UID: ${domainUser.id}');
      return AppResult.success(domainUser);
    } catch (e) {
      final userMessage = ErrorMessageMapper.map(e);
      AuthLogger.log('Firebase registration/linking failed: $userMessage');
      return AppResult.failure(e, message: userMessage);
    }
  }

  /// Explicit method to link Email + Password credential to the currently authenticated user.
  Future<AppResult<UserModel>> linkEmailPasswordCredential({
    required String email,
    required String password,
    String? name,
  }) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        return AppResult.failure(
          Exception('no-active-user'),
          message: 'No active session found to link credentials. Please sign in.',
        );
      }

      final credential = EmailAuthProvider.credential(
        email: email.trim(),
        password: password,
      );

      final userCredential = await user.linkWithCredential(credential);
      final linkedUser = userCredential.user ?? user;

      if (name != null && name.trim().isNotEmpty) {
        await linkedUser.updateDisplayName(name.trim());
      }

      final domainUser = _mapFirebaseUserToDomain(linkedUser, fallbackName: name);
      AuthLogger.log('Firebase credentials linked successfully for UID: ${domainUser.id}');
      return AppResult.success(domainUser);
    } catch (e) {
      final userMessage = ErrorMessageMapper.map(e);
      AuthLogger.log('Firebase credential linking failed: $userMessage');
      return AppResult.failure(e, message: userMessage);
    }
  }

  /// Sign in an existing user with email and password.
  Future<AppResult<UserModel>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      AuthLogger.log('Firebase email sign-in requested');
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final user = credential.user;
      if (user == null) {
        return AppResult.failure(
          Exception('Sign in failed'),
          message: 'Unable to sign in. Please verify your credentials.',
        );
      }

      final domainUser = _mapFirebaseUserToDomain(user);
      if (kDebugMode) {
        debugPrint('[FIREBASE_LOGIN_DIAGNOSTIC] success=true uid=${domainUser.id}');
      }
      AuthLogger.log('Firebase sign in successful for UID: ${domainUser.id}');
      return AppResult.success(domainUser);
    } catch (e) {
      if (e is FirebaseAuthException && kDebugMode) {
        debugPrint('[FIREBASE_LOGIN_DIAGNOSTIC] code=${e.code} message=${e.message}');
      }
      final userMessage = ErrorMessageMapper.map(e);
      AuthLogger.log('Firebase sign in failed: $userMessage');
      return AppResult.failure(e, message: userMessage);
    }
  }

  /// Start Phone Number OTP Verification.
  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required void Function(String verificationId, int? resendToken) onCodeSent,
    required void Function(String errorMessage) onVerificationFailed,
    required void Function(String verificationId) onCodeAutoRetrievalTimeout,
    void Function(PhoneAuthCredential credential)? onVerificationCompleted,
    Duration timeout = const Duration(seconds: 60),
    int? resendToken,
  }) async {
    try {
      AuthLogger.log('Firebase Phone verification initiated');
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: timeout,
        forceResendingToken: resendToken,
        verificationCompleted: (PhoneAuthCredential credential) {
          if (kDebugMode) {
            debugPrint('[FIREBASE_AUTH_DIAGNOSTIC] event=verification_completed');
          }
          AuthLogger.log('Firebase Phone auto-verification completed');
          if (onVerificationCompleted != null) {
            onVerificationCompleted(credential);
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          if (kDebugMode) {
            debugPrint('[FIREBASE_AUTH_DIAGNOSTIC] event=verification_failed code=${e.code} message=${e.message}');
          }
          final mappedError = ErrorMessageMapper.map(e);
          AuthLogger.log('Firebase Phone verification failed (code: ${e.code})');
          onVerificationFailed(mappedError);
        },
        codeSent: (String verificationId, int? token) {
          if (kDebugMode) {
            debugPrint('[FIREBASE_AUTH_DIAGNOSTIC] event=code_sent hasVerificationId=${verificationId.isNotEmpty}');
          }
          AuthLogger.log('Firebase SMS code sent successfully');
          onCodeSent(verificationId, token);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          if (kDebugMode) {
            debugPrint('[FIREBASE_AUTH_DIAGNOSTIC] event=code_auto_retrieval_timeout hasVerificationId=${verificationId.isNotEmpty}');
          }
          AuthLogger.log('Firebase SMS code auto-retrieval timeout');
          onCodeAutoRetrievalTimeout(verificationId);
        },
      );
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[FIREBASE_AUTH_DIAGNOSTIC] event=general_exception error=$e');
      }
      final mappedError = ErrorMessageMapper.map(e);
      onVerificationFailed(mappedError);
    }
  }

  /// Submit SMS code and sign in using the Phone verification ID.
  Future<AppResult<UserModel>> signInWithPhoneOTP({
    required String verificationId,
    required String smsCode,
  }) async {
    try {
      AuthLogger.log('Firebase phone OTP verification submitted');
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode.trim(),
      );

      final userCredential = await _firebaseAuth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user == null) {
        return AppResult.failure(
          Exception('Phone authentication failed'),
          message: 'Failed to verify phone OTP. Please try again.',
        );
      }

      final domainUser = _mapFirebaseUserToDomain(user);
      AuthLogger.log('Firebase Phone OTP authentication verified successfully for UID: ${domainUser.id}');
      return AppResult.success(domainUser);
    } catch (e) {
      final userMessage = ErrorMessageMapper.map(e);
      AuthLogger.log('Firebase phone OTP sign in failed: $userMessage');
      return AppResult.failure(e, message: userMessage);
    }
  }

  /// Sign out current Firebase session without deleting account.
  Future<AppResult<void>> signOut() async {
    try {
      await _firebaseAuth.signOut();
      AuthLogger.log('Firebase user signed out successfully');
      return AppResult.success(null);
    } catch (e) {
      final userMessage = ErrorMessageMapper.map(e);
      return AppResult.failure(e, message: userMessage);
    }
  }

  /// Delete user account from Firebase Auth (Play Store requirement).
  /// Reauthenticates with password if required by Firebase security policy.
  Future<AppResult<void>> deleteAccount({String? currentPassword}) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        return AppResult.failure(
          Exception('user-not-found'),
          message: 'No active authenticated user session found.',
        );
      }

      // If password is provided and user has email, reauthenticate prior to deletion
      if (currentPassword != null && user.email != null) {
        final credential = EmailAuthProvider.credential(
          email: user.email!,
          password: currentPassword,
        );
        await user.reauthenticateWithCredential(credential);
      }

      await user.delete();
      AuthLogger.log('Firebase user account deleted successfully.');
      return AppResult.success(null);
    } catch (e) {
      final userMessage = ErrorMessageMapper.map(e);
      AuthLogger.log('Firebase account deletion failed: $userMessage');
      return AppResult.failure(e, message: userMessage);
    }
  }

  /// Helper to convert a Firebase User to domain UserModel using UID as stable identifier.
  UserModel _mapFirebaseUserToDomain(User user, {String? fallbackName, String? fallbackPhone}) {
    String displayName = user.displayName ?? fallbackName ?? '';
    if (displayName.isEmpty && user.email != null && user.email!.contains('@')) {
      final prefix = user.email!.split('@').first.replaceAll(RegExp(r'[._]'), ' ');
      displayName = prefix.split(' ').map((w) => w.isNotEmpty ? '${w[0].toUpperCase()}${w.substring(1)}' : '').join(' ').trim();
    }
    if (displayName.isEmpty) {
      displayName = 'Payout User';
    }

    return UserModel(
      id: user.uid,
      name: displayName,
      phone: user.phoneNumber ?? fallbackPhone ?? '',
      email: user.email,
    );
  }
}
