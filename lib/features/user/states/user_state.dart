enum UserStatus {
  idle,
  loading,
  loaded,
  updating,
  success,
  failed,
}

class UserState {
  final UserStatus status;
  final String? errorMessage;

  const UserState({required this.status, this.errorMessage});
}
