enum PaymentStatus {
  idle,
  loading,
  searching,
  processing,
  success,
  pending,
  failed,
  cancelled,
  limitExceeded,
  serverError,
  networkError,
}

class PaymentsState {
  final PaymentStatus status;
  final String? errorMessage;

  const PaymentsState({required this.status, this.errorMessage});

  bool get isIdle => status == PaymentStatus.idle;
  bool get isLoading => status == PaymentStatus.loading;
  bool get isSearching => status == PaymentStatus.searching;
  bool get isProcessing => status == PaymentStatus.processing;
  bool get isSuccess => status == PaymentStatus.success;
  bool get isPending => status == PaymentStatus.pending;
  bool get isFailed => status == PaymentStatus.failed;
}
