import 'package:payout/features/home/models/home_models.dart';

enum HomeStatus { idle, loading, success, failure }

class HomeState {
  final HomeStatus status;
  final HomeDashboardModel? dashboard;
  final String? errorMessage;

  const HomeState({
    required this.status,
    this.dashboard,
    this.errorMessage,
  });

  bool get isLoading => status == HomeStatus.loading;
  bool get isSuccess => status == HomeStatus.success;
  bool get isFailure => status == HomeStatus.failure;
}
