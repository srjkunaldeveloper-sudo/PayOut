import 'package:flutter_test/flutter_test.dart';
import 'package:payout/core/config/app_config.dart';
import 'package:payout/core/di/app_dependencies.dart';
import 'package:payout/core/error/error_message_mapper.dart';
import 'package:payout/features/auth/models/auth_models.dart';
import 'package:payout/features/auth/repositories/auth_repository.dart';
import 'package:payout/features/auth/repositories/firebase_auth_repository.dart';
import 'package:payout/features/auth/services/secure_storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('1. Firebase Auth Error Mapping & Safety Tests', () {
    test('ErrorMessageMapper maps FirebaseAuthException codes to user-friendly messages', () {
      expect(
        ErrorMessageMapper.mapFirebaseAuthCode('invalid-email'),
        equals('Please enter a valid email address.'),
      );
      expect(
        ErrorMessageMapper.mapFirebaseAuthCode('user-disabled'),
        equals('This account has been disabled. Please contact customer support.'),
      );
      expect(
        ErrorMessageMapper.mapFirebaseAuthCode('user-not-found'),
        equals('No account found with this email. Please check or create an account.'),
      );
      expect(
        ErrorMessageMapper.mapFirebaseAuthCode('wrong-password'),
        equals('Incorrect password entered. Please try again.'),
      );
      expect(
        ErrorMessageMapper.mapFirebaseAuthCode('invalid-credential'),
        equals('Invalid email or password. Please verify your credentials.'),
      );
      expect(
        ErrorMessageMapper.mapFirebaseAuthCode('email-already-in-use'),
        equals('An account already exists with this email. Please log in.'),
      );
      expect(
        ErrorMessageMapper.mapFirebaseAuthCode('weak-password'),
        equals('The password is too weak. Please use a stronger password.'),
      );
      expect(
        ErrorMessageMapper.mapFirebaseAuthCode('invalid-verification-code'),
        equals('Invalid verification code entered. Please check and try again.'),
      );
      expect(
        ErrorMessageMapper.mapFirebaseAuthCode('invalid-verification-id'),
        equals('Verification session has expired. Please request a new OTP.'),
      );
      expect(
        ErrorMessageMapper.mapFirebaseAuthCode('session-expired'),
        equals('Verification session has expired. Please request a new OTP.'),
      );
      expect(
        ErrorMessageMapper.mapFirebaseAuthCode('quota-exceeded'),
        equals('SMS quota exceeded. Please try again in a few minutes.'),
      );
      expect(
        ErrorMessageMapper.mapFirebaseAuthCode('too-many-requests'),
        equals('Too many failed attempts. Please try again after some time.'),
      );
      expect(
        ErrorMessageMapper.mapFirebaseAuthCode('network-request-failed'),
        equals('Network error. Please check your internet connection.'),
      );
      expect(
        ErrorMessageMapper.mapFirebaseAuthCode('invalid-phone-number'),
        equals('Please enter a valid 10-digit mobile number.'),
      );
    });

    test('ErrorMessageMapper does not expose raw stack traces or internal endpoints', () {
      final safeMessage = ErrorMessageMapper.map('Exception: StackTrace raw error 500 at auth.firebase.com/v1');
      expect(safeMessage, isNot(contains('StackTrace')));
      expect(safeMessage, isNot(contains('auth.firebase.com')));
    });
  });

  group('2. Email/Password Registration & Single Firebase UID Audit Tests', () {
    late MockAuthRepository mockAuthRepository;

    setUp(() {
      mockAuthRepository = MockAuthRepository();
    });

    test('New user email/password registration produces ONE single stable UID', () async {
      final registerResult = await mockAuthRepository.registerWithEmailPassword(
        email: 'john.doe@example.com',
        password: 'Password@123',
        name: 'John Doe',
      );

      expect(registerResult.isSuccess, isTrue);
      expect(registerResult.data, isNotNull);
      expect(registerResult.data!.id, isNotEmpty);
      expect(registerResult.data!.email, equals('john.doe@example.com'));
      expect(registerResult.data!.name, equals('John Doe'));
      expect(mockAuthRepository.currentUser?.id, equals(registerResult.data!.id));
    });

    test('Duplicate email registration returns email-already-in-use error', () async {
      final failResult = await mockAuthRepository.registerWithEmailPassword(
        email: 'existing@payout.com',
        password: 'Password@123',
      );

      expect(failResult.isSuccess, isFalse);
      expect(failResult.message, contains('An account already exists with this email'));
    });
  });

  group('3. Existing User Flow & Isolation Tests', () {
    late MockAuthRepository mockAuthRepository;

    setUp(() {
      mockAuthRepository = MockAuthRepository();
    });

    test('Existing user logs in directly with Email + Password without requiring phone OTP', () async {
      final loginResult = await mockAuthRepository.signInWithEmailPassword(
        email: 'existing.customer@example.com',
        password: 'ValidPassword1',
      );

      expect(loginResult.isSuccess, isTrue);
      expect(loginResult.data, isNotNull);
      expect(loginResult.data!.email, equals('existing.customer@example.com'));
      expect(mockAuthRepository.currentUser, isNotNull);
    });

    test('Sign out does NOT delete user account', () async {
      await mockAuthRepository.signInWithEmailPassword(
        email: 'user@payout.com',
        password: 'Password123',
      );
      expect(mockAuthRepository.currentUser, isNotNull);

      // Sign out
      final signOutResult = await mockAuthRepository.signOut();
      expect(signOutResult.isSuccess, isTrue);
      expect(mockAuthRepository.currentUser, isNull);

      // User can sign back in immediately because account is preserved
      final reLoginResult = await mockAuthRepository.signInWithEmailPassword(
        email: 'user@payout.com',
        password: 'Password123',
      );
      expect(reLoginResult.isSuccess, isTrue);
      expect(reLoginResult.data!.email, equals('user@payout.com'));
    });

    test('Account deletion contract is explicitly separated from sign out', () async {
      await mockAuthRepository.signInWithEmailPassword(
        email: 'user.delete@payout.com',
        password: 'Password123',
      );
      expect(mockAuthRepository.currentUser, isNotNull);

      final deleteResult = await mockAuthRepository.deleteAccount();
      expect(deleteResult.isSuccess, isTrue);
      expect(mockAuthRepository.currentUser, isNull);
    });
  });

  group('4. Security & Storage Safety Audit Tests', () {
    test('Plaintext password is never persisted in SecureStorageService or SharedPreferences', () async {
      SharedPreferences.setMockInitialValues({});

      // Save valid session data
      await SecureStorageService.saveToken('SAMPLE-ACCESS-TOKEN');
      await SecureStorageService.saveUserId('USR-SAMPLE-123');

      final prefs = await SharedPreferences.getInstance();
      final allKeys = prefs.getKeys();

      expect(allKeys.contains('password'), isFalse);
      expect(allKeys.contains('plain_password'), isFalse);
      expect(allKeys.contains('user_password'), isFalse);
      expect(allKeys.contains('otp_code'), isFalse);
    });
  });

  group('5. Mock Mode Isolation & DI Architecture Tests', () {
    setUp(() {
      AppDependencies.reset();
    });

    test('In API Mode (default), AppDependencies provides FirebaseAuthRepository', () {
      expect(AppConfig.repositoryMode, equals(RepositoryMode.api));
      final deps = AppDependencies.instance;
      expect(deps.authRepository, isA<FirebaseAuthRepository>());
    });

    test('AppDependencies allows constructor dependency override for testing', () {
      const customUser = UserModel(id: 'CUSTOM-1', name: 'Custom User', phone: '+919876543210');
      final customRepo = MockAuthRepository(initialUser: customUser);
      final deps = AppDependencies(authRepository: customRepo);

      expect(deps.authRepository, same(customRepo));
      expect(deps.authRepository.currentUser?.id, equals('CUSTOM-1'));
    });
  });
}
