import 'package:payout/features/auth/models/auth_models.dart';
import 'package:payout/features/auth/services/auth_logger.dart';

abstract class AuthRepository {
  Future<LoginResponse> login(LoginRequest request);
  Future<OTPResponse> verifyOTP(OTPRequest request);
  Future<bool> createMPIN(String mpin);
  Future<bool> resendOTP(String phone);
}

class MockAuthRepository implements AuthRepository {
  @override
  Future<LoginResponse> login(LoginRequest request) async {
    AuthLogger.logLoginAttempt(request.mobile);
    await Future.delayed(const Duration(milliseconds: 1000));

    // Simulate blocked number simulation
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
    await Future.delayed(const Duration(milliseconds: 1000));

    if (request.code == '123456') {
      const user = UserModel(
        id: 'USR-789',
        name: 'Rahul Sharma',
        phone: '+91 9876543210',
      );
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
    await Future.delayed(const Duration(milliseconds: 800));
    AuthLogger.logMPINCreated();
    return true;
  }

  @override
  Future<bool> resendOTP(String phone) async {
    AuthLogger.logOTPRequested(phone);
    await Future.delayed(const Duration(milliseconds: 800));
    return true;
  }
}
