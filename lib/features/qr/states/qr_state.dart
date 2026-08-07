enum QrStatus {
  idle,
  scanning,
  processing,
  found,
  verified,
  invalid,
  expired,
  permissionDenied,
  paymentReady,
  success,
  failed,
}

class QrState {
  final QrStatus status;
  final String? errorMessage;

  const QrState({required this.status, this.errorMessage});

  bool get isIdle => status == QrStatus.idle;
  bool get isScanning => status == QrStatus.scanning;
  bool get isProcessing => status == QrStatus.processing;
  bool get isSuccess => status == QrStatus.success;
  bool get isFailed => status == QrStatus.failed;
  bool get isPermissionDenied => status == QrStatus.permissionDenied;
  bool get isInvalid => status == QrStatus.invalid;
}
