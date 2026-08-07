enum TransactionStatus {
  idle,
  loading,
  loaded,
  searching,
  filtering,
  exporting,
  empty,
  failed,
}

class TransactionState {
  final TransactionStatus status;
  final String? errorMessage;

  const TransactionState({required this.status, this.errorMessage});

  bool get isIdle => status == TransactionStatus.idle;
  bool get isLoading => status == TransactionStatus.loading;
  bool get isLoaded => status == TransactionStatus.loaded;
  bool get isSearching => status == TransactionStatus.searching;
  bool get isFiltering => status == TransactionStatus.filtering;
  bool get isEmpty => status == TransactionStatus.empty;
}
