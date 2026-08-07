enum RewardStatus {
  idle,
  loading,
  loaded,
  scratching,
  success,
  failed,
}

class RewardState {
  final RewardStatus status;
  final String? errorMessage;

  const RewardState({required this.status, this.errorMessage});
}
