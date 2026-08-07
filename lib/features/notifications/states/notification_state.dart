enum NotificationStatus {
  idle,
  loading,
  loaded,
  empty,
  failed,
}

class NotificationState {
  final NotificationStatus status;
  final String? errorMessage;

  const NotificationState({required this.status, this.errorMessage});

  bool get isIdle => status == NotificationStatus.idle;
  bool get isLoading => status == NotificationStatus.loading;
  bool get isLoaded => status == NotificationStatus.loaded;
  bool get isEmpty => status == NotificationStatus.empty;
  bool get isFailed => status == NotificationStatus.failed;
}
