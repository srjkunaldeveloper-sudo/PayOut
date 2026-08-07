enum RechargeStatus {
  idle,
  loading,
  loaded,
  processing,
  success,
  failed,
}

class RechargeState {
  final RechargeStatus status;
  final String? errorMessage;

  const RechargeState({required this.status, this.errorMessage});
}
