enum WalletStatus {
  idle,
  loading,
  refreshing,
  success,
  empty,
  error,
  walletFrozen,
  walletBlocked,
  insufficientBalance,
  limitExceeded,
}

class WalletState {
  final WalletStatus status;
  final String? errorMessage;

  const WalletState({required this.status, this.errorMessage});

  bool get isIdle => status == WalletStatus.idle;
  bool get isLoading => status == WalletStatus.loading;
  bool get isRefreshing => status == WalletStatus.refreshing;
  bool get isSuccess => status == WalletStatus.success;
  bool get isError => status == WalletStatus.error;
}
