import 'package:payout/core/di/app_dependencies.dart';
import 'package:payout/features/home/models/home_models.dart';
import 'package:payout/features/home/repositories/home_repository.dart';
import 'package:payout/features/transactions/models/transaction_models.dart';

class HomeService {
  final HomeRepository _homeRepository;

  HomeService({HomeRepository? homeRepository})
      : _homeRepository = homeRepository ?? AppDependencies.instance.homeRepository;

  Future<HomeDashboardModel> getDashboardData() {
    return _homeRepository.getDashboard();
  }

  Future<HomeDashboardModel> refreshDashboardData() {
    return _homeRepository.refreshDashboard();
  }

  bool shouldShowNotificationBadge(int unreadCount) => unreadCount > 0;

  List<TransactionModel> getTopTransactions(List<TransactionModel> transactions, {int limit = 3}) {
    if (transactions.isEmpty) return [];
    return transactions.take(limit).toList();
  }
}
