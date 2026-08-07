enum FinancialStatus {
  idle,
  loading,
  loaded,
  processing,
  success,
  failed,
}

class FinancialState {
  final FinancialStatus status;
  final String? errorMessage;

  const FinancialState({required this.status, this.errorMessage});
}
