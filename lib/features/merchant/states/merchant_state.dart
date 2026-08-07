enum MerchantStatus {
  idle,
  loading,
  loaded,
  updating,
  success,
  failed,
}

class MerchantState {
  final MerchantStatus status;
  final String? errorMessage;

  const MerchantState({required this.status, this.errorMessage});
}
