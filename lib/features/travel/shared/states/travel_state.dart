enum TravelStatus {
  idle,
  loading,
  loaded,
  booking,
  success,
  failed,
}

class TravelState {
  final TravelStatus status;
  final String? errorMessage;

  const TravelState({required this.status, this.errorMessage});
}
