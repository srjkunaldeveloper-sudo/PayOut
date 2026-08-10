import 'package:payout/features/user/models/user_models.dart';
import 'package:payout/features/wallet/models/wallet_models.dart';
import 'package:payout/features/transactions/models/transaction_models.dart';
import 'package:payout/features/rewards/models/reward_models.dart';

class HomeDashboardModel {
  final UserProfileModel user;
  final WalletModel wallet;
  final List<TransactionModel> recentTransactions;
  final int unreadNotificationCount;
  final List<CouponModel> offers;
  final List<Map<String, String>> popularDestinations;
  final List<Map<String, String>> financialPromotions;

  const HomeDashboardModel({
    required this.user,
    required this.wallet,
    required this.recentTransactions,
    required this.unreadNotificationCount,
    required this.offers,
    required this.popularDestinations,
    required this.financialPromotions,
  });

  HomeDashboardModel copyWith({
    UserProfileModel? user,
    WalletModel? wallet,
    List<TransactionModel>? recentTransactions,
    int? unreadNotificationCount,
    List<CouponModel>? offers,
    List<Map<String, String>>? popularDestinations,
    List<Map<String, String>>? financialPromotions,
  }) {
    return HomeDashboardModel(
      user: user ?? this.user,
      wallet: wallet ?? this.wallet,
      recentTransactions: recentTransactions ?? this.recentTransactions,
      unreadNotificationCount: unreadNotificationCount ?? this.unreadNotificationCount,
      offers: offers ?? this.offers,
      popularDestinations: popularDestinations ?? this.popularDestinations,
      financialPromotions: financialPromotions ?? this.financialPromotions,
    );
  }
}
