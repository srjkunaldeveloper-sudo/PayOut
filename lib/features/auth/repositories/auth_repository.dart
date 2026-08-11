import 'dart:async';
import 'package:payout/core/result/app_result.dart';
import 'package:payout/features/auth/models/auth_models.dart';
import 'package:payout/features/auth/services/auth_logger.dart';

abstract class AuthRepository {
  /// Baseline MPIN creation support
  Future<bool> createMPIN(String mpin);

  /// Authentication backend methods (Email/Password only)
  Future<AppResult<UserModel>> registerWithEmailPassword({
    required String email,
    required String password,
    String? name,
    String? phone,
  });

  Future<AppResult<UserModel>> signInWithEmailPassword({
    required String email,
    required String password,
  });

  Future<AppResult<void>> signOut();

  Future<AppResult<void>> deleteAccount({String? currentPassword});

  UserModel? get currentUser;
  Stream<UserModel?> get authStateChanges;
}

class MockAuthRepository implements AuthRepository {
  UserModel? _mockUser;
  final _authStateController = StreamController<UserModel?>.broadcast();

  MockAuthRepository({UserModel? initialUser}) : _mockUser = initialUser;

  @override
  UserModel? get currentUser => _mockUser;

  @override
  Stream<UserModel?> get authStateChanges => _authStateController.stream;

  @override
  Future<bool> createMPIN(String mpin) async {
    AuthLogger.log('Saving MPIN payload');
    await Future.delayed(const Duration(milliseconds: 200));
    AuthLogger.logMPINCreated();
    return true;
  }

  @override
  Future<AppResult<UserModel>> registerWithEmailPassword({
    required String email,
    required String password,
    String? name,
    String? phone,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    if (email == 'existing@payout.com') {
      return AppResult.failure(
        Exception('email-already-in-use'),
        message: 'An account already exists with this email. Please log in.',
      );
    }

    final stableId = _mockUser?.id ?? 'USR-MOCK-${email.hashCode.abs() % 100000}';
    final user = UserModel(
      id: stableId,
      name: name ?? _mockUser?.name ?? 'Mock User',
      phone: phone ?? _mockUser?.phone ?? '',
      email: email,
    );
    _mockUser = user;
    _authStateController.add(user);
    return AppResult.success(user);
  }

  @override
  Future<AppResult<UserModel>> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    if (password == 'wrongpassword') {
      return AppResult.failure(
        Exception('wrong-password'),
        message: 'Incorrect password entered. Please try again.',
      );
    }

    if (email == 'unregistered@payout.com') {
      return AppResult.failure(
        Exception('user-not-found'),
        message: 'No account found with this email. Please check or create an account.',
      );
    }

    final user = UserModel(
      id: 'USR-MOCK-${email.hashCode.abs() % 100000}',
      name: 'Mock User',
      phone: '+91 9876543210',
      email: email,
    );
    _mockUser = user;
    _authStateController.add(user);
    return AppResult.success(user);
  }

  @override
  Future<AppResult<void>> signOut() async {
    await Future.delayed(const Duration(milliseconds: 100));
    _mockUser = null;
    _authStateController.add(null);
    return AppResult.success(null);
  }

  @override
  Future<AppResult<void>> deleteAccount({String? currentPassword}) async {
    await Future.delayed(const Duration(milliseconds: 200));
    if (_mockUser == null) {
      return AppResult.failure(
        Exception('user-not-found'),
        message: 'No active authenticated user session found.',
      );
    }
    _mockUser = null;
    _authStateController.add(null);
    return AppResult.success(null);
  }
}
