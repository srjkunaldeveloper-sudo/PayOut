class LoginRequest {
  final String mobile;
  final String countryCode;

  const LoginRequest({required this.mobile, required this.countryCode});
}

class LoginResponse {
  final bool success;
  final String? message;
  final String? sessionId;

  const LoginResponse({required this.success, this.message, this.sessionId});
}

class OTPRequest {
  final String sessionId;
  final String code;

  const OTPRequest({required this.sessionId, required this.code});
}

class OTPResponse {
  final bool success;
  final String? message;
  final String? accessToken;
  final String? refreshToken;
  final UserModel? user;

  const OTPResponse({
    required this.success,
    this.message,
    this.accessToken,
    this.refreshToken,
    this.user,
  });
}

class MPINRequest {
  final String mpin;

  const MPINRequest({required this.mpin});
}

class SessionModel {
  final String accessToken;
  final String refreshToken;
  final DateTime expiry;

  const SessionModel({
    required this.accessToken,
    required this.refreshToken,
    required this.expiry,
  });
}

class UserModel {
  final String id;
  final String name;
  final String phone;
  final String? email;

  const UserModel({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
  });
}

class ErrorModel {
  final String code;
  final String message;

  const ErrorModel({required this.code, required this.message});
}
