import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:payout/core/config/app_config.dart';
import 'package:payout/core/result/app_result.dart';
import 'package:payout/features/auth/constants/auth_constants.dart';
import 'package:payout/features/auth/models/auth_models.dart';
import 'package:payout/features/auth/services/auth_logger.dart';

abstract class AuthRepository {
  // Existing baseline methods
  Future<LoginResponse> login(LoginRequest request);
  Future<OTPResponse> verifyOTP(OTPRequest request);
  Future<bool> createMPIN(String mpin);
  Future<bool> resendOTP(String phone);

  // Authentication backend foundation methods
  Future<AppResult<UserModel>> registerWithEmailPassword({
    required String email,
    required String password,
    String? name,
    String? phone,
  });

  Future<AppResult<UserModel>> linkEmailPasswordCredential({
    required String email,
    required String password,
    String? name,
  });

  Future<AppResult<UserModel>> signInWithEmailPassword({
    required String email,
    required String password,
  });

  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required void Function(String verificationId, int? resendToken) onCodeSent,
    required void Function(String errorMessage) onVerificationFailed,
    required void Function(String verificationId) onCodeAutoRetrievalTimeout,
    void Function(PhoneAuthCredential credential)? onVerificationCompleted,
    Duration timeout = const Duration(seconds: 60),
    int? resendToken,
  });

  Future<AppResult<UserModel>> verifyPhoneOTP({
    required String verificationId,
    required String smsCode,
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
  Future<LoginResponse> login(LoginRequest request) async {
    AuthLogger.logLoginAttempt(request.mobile);
    await Future.delayed(const Duration(milliseconds: 300));

    if (AppConfig.isDemoMode) {
      return const LoginResponse(
        success: true,
        sessionId: 'DEMO-SESS-123456',
      );
    }

    if (request.mobile == '9999999999') {
      return const LoginResponse(success: false, message: 'This mobile number is blocked.');
    }

    return const LoginResponse(
      success: true,
      sessionId: 'SESS-123456',
    );
  }

  @override
  Future<OTPResponse> verifyOTP(OTPRequest request) async {
    AuthLogger.log('Verifying OTP code: ${request.code}');
    await Future.delayed(const Duration(milliseconds: 300));

    if (AppConfig.isDemoMode) {
      if (request.code.length == AuthConstants.otpLength) {
        const user = UserModel(
          id: 'USR-DEMO',
          name: 'Demo User',
          phone: '+91 9876543210',
        );
        _mockUser = user;
        _authStateController.add(user);
        return const OTPResponse(
          success: true,
          accessToken: 'DEMO-TOKEN-ACCESS',
          refreshToken: 'DEMO-TOKEN-REFRESH',
          user: user,
        );
      }
    }

    if (request.code == '123456') {
      const user = UserModel(
        id: 'USR-789',
        name: 'Rahul Sharma',
        phone: '+91 9876543210',
      );
      _mockUser = user;
      _authStateController.add(user);
      return const OTPResponse(
        success: true,
        accessToken: 'TOKEN-ACCESS-MOCK-999',
        refreshToken: 'TOKEN-REFRESH-MOCK-999',
        user: user,
      );
    } else {
      return const OTPResponse(success: false, message: 'Invalid verification code entered.');
    }
  }

  @override
  Future<bool> createMPIN(String mpin) async {
    AuthLogger.log('Saving MPIN payload');
    await Future.delayed(const Duration(milliseconds: 200));
    AuthLogger.logMPINCreated();
    return true;
  }

  @override
  Future<bool> resendOTP(String phone) async {
    AuthLogger.logOTPRequested(phone);
    await Future.delayed(const Duration(milliseconds: 200));
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

    // If already verified phone user exists, preserve the same UID
    final stableId = _mockUser?.id ?? 'USR-MOCK-${email.hashCode.abs() % 100000}';
    final user = UserModel(
      id: stableId,
      name: name ?? _mockUser?.name ?? 'Mock User',
      phone: phone ?? _mockUser?.phone ?? '+91 9876543210',
      email: email,
    );
    _mockUser = user;
    _authStateController.add(user);
    return AppResult.success(user);
  }

  @override
  Future<AppResult<UserModel>> linkEmailPasswordCredential({
    required String email,
    required String password,
    String? name,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));

    if (_mockUser == null) {
      return AppResult.failure(
        Exception('no-active-user'),
        message: 'No active session found to link credentials. Please sign in.',
      );
    }

    final linked = UserModel(
      id: _mockUser!.id,
      name: name ?? _mockUser!.name,
      phone: _mockUser!.phone,
      email: email,
    );
    _mockUser = linked;
    _authStateController.add(linked);
    return AppResult.success(linked);
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
  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required void Function(String verificationId, int? resendToken) onCodeSent,
    required void Function(String errorMessage) onVerificationFailed,
    required void Function(String verificationId) onCodeAutoRetrievalTimeout,
    void Function(PhoneAuthCredential credential)? onVerificationCompleted,
    Duration timeout = const Duration(seconds: 60),
    int? resendToken,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));
    if (phoneNumber.contains('0000000000')) {
      onVerificationFailed('Please enter a valid 10-digit mobile number.');
      return;
    }
    onCodeSent('MOCK-VERIFICATION-ID-123456', 1);
  }

  @override
  Future<AppResult<UserModel>> verifyPhoneOTP({
    required String verificationId,
    required String smsCode,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    if (smsCode == '123456' || (AppConfig.isDemoMode && smsCode.length == 6)) {
      const user = UserModel(
        id: 'USR-MOCK-PHONE-UID',
        name: 'Mock Phone User',
        phone: '+91 9876543210',
      );
      _mockUser = user;
      _authStateController.add(user);
      return AppResult.success(user);
    }

    return AppResult.failure(
      Exception('invalid-verification-code'),
      message: 'Invalid verification code entered. Please check and try again.',
    );
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
