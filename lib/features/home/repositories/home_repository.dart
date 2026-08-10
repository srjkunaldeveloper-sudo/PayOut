import 'package:payout/features/home/models/home_models.dart';
import 'package:payout/features/home/dummy/dummy_home_data.dart';
import 'package:payout/features/user/repositories/user_repository.dart';
import 'package:payout/features/wallet/repositories/wallet_repository.dart';
import 'package:payout/features/transactions/repositories/transaction_repository.dart';
import 'package:payout/features/notifications/repositories/notification_repository.dart';
import 'package:payout/features/rewards/repositories/reward_repository.dart';
import 'package:payout/features/user/models/user_models.dart';
import 'package:payout/features/wallet/models/wallet_models.dart';
import 'package:payout/features/transactions/models/transaction_models.dart';
import 'package:payout/features/rewards/models/reward_models.dart';

abstract class HomeRepository {
  Future<HomeDashboardModel> getDashboard();
  Future<HomeDashboardModel> refreshDashboard();
}

class MockHomeRepository implements HomeRepository {
  final UserRepository _userRepository;
  final WalletRepository _walletRepository;
  final TransactionRepository _transactionRepository;
  final NotificationRepository _notificationRepository;
  final RewardRepository _rewardRepository;

  MockHomeRepository({
    UserRepository? userRepository,
    WalletRepository? walletRepository,
    TransactionRepository? transactionRepository,
    NotificationRepository? notificationRepository,
    RewardRepository? rewardRepository,
  })  : _userRepository = userRepository ?? MockUserRepository(),
        _walletRepository = walletRepository ?? MockWalletRepository(),
        _transactionRepository = transactionRepository ?? MockTransactionRepository(),
        _notificationRepository = notificationRepository ?? MockNotificationRepository(),
        _rewardRepository = rewardRepository ?? MockRewardRepository();

  @override
  Future<HomeDashboardModel> getDashboard() async {
    // Latency simulator
    await Future.delayed(const Duration(milliseconds: 600));

    final results = await Future.wait([
      _userRepository.getProfile(),
      _walletRepository.getWallet(),
      _transactionRepository.getTransactions(),
      _notificationRepository.getUnreadCount(),
      _rewardRepository.getCoupons(),
    ]);

    return HomeDashboardModel(
      user: results[0] as UserProfileModel,
      wallet: results[1] as WalletModel,
      recentTransactions: results[2] as List<TransactionModel>,
      unreadNotificationCount: results[3] as int,
      offers: results[4] as List<CouponModel>,
      popularDestinations: List.from(DummyHomeData.popularDestinations),
      financialPromotions: List.from(DummyHomeData.financialPromotions),
    );
  }

  @override
  Future<HomeDashboardModel> refreshDashboard() => getDashboard();
}
