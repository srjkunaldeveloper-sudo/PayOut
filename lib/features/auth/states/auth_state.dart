enum AuthStatus {
  idle,
  typing,
  loading,
  success,
  failure,
  networkError,
  serverError,
  otpExpired,
  sessionExpired,
  tooManyAttempts,
  permissionDenied,
  biometricFailed,
}

class AuthState {
  final AuthStatus status;
  final String? errorMessage;

  const AuthState({required this.status, this.errorMessage});

  bool get isIdle => status == AuthStatus.idle;
  bool get isLoading => status == AuthStatus.loading;
  bool get isSuccess => status == AuthStatus.success;
  bool get isFailure => status != AuthStatus.success && status != AuthStatus.loading && status != AuthStatus.idle;
}
