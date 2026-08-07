enum BillStatus {
  idle,
  loading,
  loaded,
  processing,
  success,
  failed,
}

class BillState {
  final BillStatus status;
  final String? errorMessage;

  const BillState({required this.status, this.errorMessage});
}
