import 'package:payout/features/merchant/models/merchant_models.dart';
import 'package:payout/features/merchant/dummy/dummy_merchant_data.dart';
import 'package:payout/features/merchant/services/merchant_logger.dart';
import 'package:payout/features/transactions/models/transaction_models.dart';
import 'package:payout/features/transactions/repositories/transaction_repository.dart';
import 'package:payout/features/notifications/models/notification_models.dart';
import 'package:payout/features/notifications/repositories/notification_repository.dart';

abstract class MerchantRepository {
  Future<MerchantProfileModel> getMerchantProfile();
  Future<MerchantSalesSummaryModel> getSalesSummary();
  Future<double> getAvailableSettlementBalance();
  Future<List<MerchantTransactionModel>> getTransactions();
  Future<List<SettlementModel>> getSettlements();
  Future<List<MerchantOfferModel>> getOffers();
  Future<bool> requestSettlement({
    required double amount,
    required String bankAccountId,
  });
  Future<SettlementModel?> getSettlementStatus(String settlementId);
  Future<List<SettlementModel>> getSettlementHistory();
  Future<List<BusinessInsightModel>> getBusinessInsights();
}

class MockMerchantRepository implements MerchantRepository {
  final TransactionRepository _transactionRepository;
  final NotificationRepository _notificationRepository;

  MockMerchantRepository({
    TransactionRepository? transactionRepository,
    NotificationRepository? notificationRepository,
  })  : _transactionRepository = transactionRepository ?? MockTransactionRepository(),
        _notificationRepository = notificationRepository ?? MockNotificationRepository();

  @override
  Future<MerchantProfileModel> getMerchantProfile() async {
    // TODO(api): GET /merchant/profile
    await Future.delayed(const Duration(milliseconds: 300));
    MerchantLogger.logProfileLoaded(DummyMerchantData.dummyProfile.id);
    return DummyMerchantData.dummyProfile;
  }

  @override
  Future<MerchantSalesSummaryModel> getSalesSummary() async {
    // TODO(api): GET /merchant/sales-summary
    await Future.delayed(const Duration(milliseconds: 300));
    return DummyMerchantData.dummySalesSummary;
  }

  @override
  Future<double> getAvailableSettlementBalance() async {
    // TODO(api): GET /merchant/settlement-balance
    await Future.delayed(const Duration(milliseconds: 250));
    return DummyMerchantData.availableSettlementBalance;
  }

  @override
  Future<List<MerchantTransactionModel>> getTransactions() async {
    // TODO(api): GET /merchant/transactions
    await Future.delayed(const Duration(milliseconds: 350));
    return List.from(DummyMerchantData.dummyTransactions);
  }

  @override
  Future<List<SettlementModel>> getSettlements() async {
    // TODO(api): GET /merchant/settlements
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(DummyMerchantData.dummySettlements);
  }

  @override
  Future<List<SettlementModel>> getSettlementHistory() async {
    return getSettlements();
  }

  @override
  Future<List<MerchantOfferModel>> getOffers() async {
    // TODO(api): GET /merchant/offers
    await Future.delayed(const Duration(milliseconds: 250));
    return List.from(DummyMerchantData.dummyOffers);
  }

  @override
  Future<List<BusinessInsightModel>> getBusinessInsights() async {
    // TODO(api): GET /merchant/insights
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(DummyMerchantData.dummyInsights);
  }

  @override
  Future<bool> requestSettlement({
    required double amount,
    required String bankAccountId,
  }) async {
    // TODO(api): POST /merchant/settlements
    await Future.delayed(const Duration(milliseconds: 600));

    // Simulated Outcome Rules:
    // Amount == 100 => FAILED
    // Amount == 200 => PENDING
    // Other => SUCCESS
    if (amount == 100.0) {
      MerchantLogger.log('Settlement request failed for simulated amount: ₹100');
      return false;
    }

    final isPending = amount == 200.0;
    final status = isPending ? 'PENDING' : 'SUCCESS';
    final settlementId = 'SET-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}';
    final utrNumber = 'UTR${DateTime.now().millisecondsSinceEpoch}';

    final settlement = SettlementModel(
      id: settlementId,
      settlementId: settlementId,
      amount: amount,
      settlementDate: 'Today, Just now',
      status: status,
      bankAccountMasked: bankAccountId.isNotEmpty ? bankAccountId : 'HDFC Bank •••• 9832',
      utr: utrNumber,
    );

    DummyMerchantData.dummySettlements.insert(0, settlement);
    if (!isPending) {
      DummyMerchantData.availableSettlementBalance =
          (DummyMerchantData.availableSettlementBalance - amount).clamp(0.0, double.infinity);
    }

    MerchantLogger.logSettlementTriggered(amount);

    // Record in Transaction Repository
    final txn = TransactionModel(
      id: settlementId,
      title: 'Merchant Bank Settlement',
      upiId: 'settlement@payout.bank',
      type: 'DEBIT',
      category: 'Transfer',
      amount: amount,
      date: 'Today',
      status: isPending ? 'PENDING' : 'SUCCESS',
      paymentMethod: 'Bank Transfer (NEFT/IMPS)',
      utr: utrNumber,
      referenceNumber: 'REF-$settlementId',
    );
    await _transactionRepository.addTransaction(txn);

    // Dispatch Notification
    final notif = NotificationModel(
      id: 'NOT-${DateTime.now().millisecondsSinceEpoch.toString().substring(6)}',
      title: isPending ? 'Merchant Settlement Processing' : 'Merchant Settlement Successful',
      description: isPending
          ? 'Your settlement of ₹${amount.toStringAsFixed(2)} is pending bank confirmation.'
          : '₹${amount.toStringAsFixed(2)} has been successfully transferred to your linked bank account ($bankAccountId).',
      category: 'Payment',
      time: 'Just now',
      isRead: false,
      relatedEntityId: settlementId,
      relatedTransactionId: settlementId,
    );
    await _notificationRepository.addNotification(notif);

    return true;
  }

  @override
  Future<SettlementModel?> getSettlementStatus(String settlementId) async {
    // TODO(api): GET /merchant/settlements/{id}
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return DummyMerchantData.dummySettlements.firstWhere((s) => s.id == settlementId || s.settlementId == settlementId);
    } catch (_) {
      return null;
    }
  }
}
