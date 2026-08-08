import 'package:payout/features/rewards/models/reward_models.dart';
import 'package:payout/features/rewards/dummy/dummy_reward_data.dart';
import 'package:payout/features/rewards/services/reward_logger.dart';
import 'package:payout/features/transactions/models/transaction_models.dart';
import 'package:payout/features/transactions/repositories/transaction_repository.dart';
import 'package:payout/features/notifications/models/notification_models.dart';
import 'package:payout/features/notifications/repositories/notification_repository.dart';

abstract class RewardRepository {
  Future<RewardSummaryModel> getRewardSummary();
  Future<List<CouponModel>> getCoupons();
  Future<List<ScratchCardModel>> getScratchCards();
  Future<ScratchCardModel?> openScratchCard(String scratchCardId);
  Future<bool> redeemCoupon(String couponId);
  Future<List<CashbackModel>> getCashbackHistory();
  Future<List<CashbackModel>> getCashbacks();
  Future<bool> scratchCard(String id);
}

class MockRewardRepository implements RewardRepository {
  final TransactionRepository _transactionRepository;
  final NotificationRepository _notificationRepository;

  MockRewardRepository({
    TransactionRepository? transactionRepository,
    NotificationRepository? notificationRepository,
  })  : _transactionRepository = transactionRepository ?? MockTransactionRepository(),
        _notificationRepository = notificationRepository ?? MockNotificationRepository();

  @override
  Future<RewardSummaryModel> getRewardSummary() async {
    // TODO(api): GET /rewards/summary
    await Future.delayed(const Duration(milliseconds: 300));
    return DummyRewardData.dummySummary;
  }

  @override
  Future<List<CouponModel>> getCoupons() async {
    // TODO(api): GET /rewards/coupons
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(DummyRewardData.dummyCoupons);
  }

  @override
  Future<List<ScratchCardModel>> getScratchCards() async {
    // TODO(api): GET /rewards/scratch-cards
    await Future.delayed(const Duration(milliseconds: 350));
    return List.from(DummyRewardData.dummyScratchCards);
  }

  @override
  Future<ScratchCardModel?> openScratchCard(String scratchCardId) async {
    // TODO(api): POST /rewards/scratch-cards/{id}/open
    await Future.delayed(const Duration(milliseconds: 500));
    final index = DummyRewardData.dummyScratchCards.indexWhere((c) => c.id == scratchCardId);
    if (index != -1) {
      final card = DummyRewardData.dummyScratchCards[index];
      if (card.status.toUpperCase() == 'SCRATCHED') {
        return card;
      }

      final updatedCard = card.copyWith(
        status: 'SCRATCHED',
        claimedAt: 'Today, Just now',
        isScratched: true,
      );
      DummyRewardData.dummyScratchCards[index] = updatedCard;

      final txnId = 'TXN-CSH-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}';

      // Insert cashback entry
      final cashback = CashbackModel(
        id: 'CSH-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}',
        source: 'Scratch Card (${card.title})',
        amount: card.rewardValue,
        status: 'AVAILABLE',
        earnedAt: 'Today, Just now',
        transactionId: txnId,
      );
      DummyRewardData.dummyCashbacks.insert(0, cashback);

      RewardLogger.logScratchCardOpened(scratchCardId, card.rewardValue);

      // Record in transaction ledger
      final txn = TransactionModel(
        id: txnId,
        title: 'Cashback Reward Received',
        upiId: 'rewards@payout.app',
        type: 'CREDIT',
        category: 'Rewards',
        amount: card.rewardValue,
        date: 'Today',
        status: 'SUCCESS',
        paymentMethod: 'Payout Rewards Wallet',
        utr: 'UTR${DateTime.now().millisecondsSinceEpoch}',
        referenceNumber: 'REF-$scratchCardId',
      );
      await _transactionRepository.addTransaction(txn);

      // Dispatch notification
      final notif = NotificationModel(
        id: 'NOT-${DateTime.now().millisecondsSinceEpoch.toString().substring(6)}',
        title: 'Cashback Credited! 🎉',
        description: '₹${card.rewardValue.toStringAsFixed(2)} cashback has been credited to your rewards wallet from "${card.title}".',
        category: 'Offers',
        time: 'Just now',
        isRead: false,
        relatedEntityId: scratchCardId,
        relatedTransactionId: txnId,
      );
      await _notificationRepository.addNotification(notif);

      return updatedCard;
    }
    return null;
  }

  @override
  Future<bool> scratchCard(String id) async {
    final result = await openScratchCard(id);
    return result != null;
  }

  @override
  Future<bool> redeemCoupon(String couponId) async {
    // TODO(api): POST /rewards/coupons/{id}/redeem
    await Future.delayed(const Duration(milliseconds: 400));
    final index = DummyRewardData.dummyCoupons.indexWhere((c) => c.id == couponId);
    if (index != -1) {
      final coupon = DummyRewardData.dummyCoupons[index];
      final updated = coupon.copyWith(usedCount: coupon.usedCount + 1);
      DummyRewardData.dummyCoupons[index] = updated;

      RewardLogger.logCouponRedeemed(coupon.code);

      // Dispatch notification
      final notif = NotificationModel(
        id: 'NOT-${DateTime.now().millisecondsSinceEpoch.toString().substring(6)}',
        title: 'Coupon Code Copied',
        description: 'Use promo code "${coupon.code}" at checkout on ${coupon.title} to save ₹${coupon.discountValue.toInt()}.',
        category: 'Offers',
        time: 'Just now',
        isRead: false,
        relatedEntityId: couponId,
      );
      await _notificationRepository.addNotification(notif);

      return true;
    }
    return false;
  }

  @override
  Future<List<CashbackModel>> getCashbackHistory() async {
    // TODO(api): GET /rewards/cashback
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(DummyRewardData.dummyCashbacks);
  }

  @override
  Future<List<CashbackModel>> getCashbacks() async {
    return getCashbackHistory();
  }
}
