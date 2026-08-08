import 'package:payout/features/merchant/models/merchant_models.dart';
import 'package:payout/features/merchant/constants/merchant_constants.dart';

class MerchantService {
  static double calculateTotalSettled(List<SettlementModel> list) {
    return list
        .where((s) => s.status.toUpperCase() == 'SUCCESS')
        .map((s) => s.amount)
        .fold(0.0, (sum, val) => sum + val);
  }

  static MerchantSalesSummaryModel calculateSalesSummary(
    List<MerchantTransactionModel> transactions, {
    double todaySales = 42560.80,
    double weeklySales = 284120.50,
    double monthlySales = 1145900.00,
  }) {
    final successTxns = transactions.where((t) => t.status.toUpperCase() == 'SUCCESS').toList();
    final failedTxns = transactions.where((t) => t.status.toUpperCase() == 'FAILED').toList();
    final totalSuccessAmount = successTxns.fold(0.0, (sum, t) => sum + t.amount);
    final avgValue = successTxns.isEmpty ? 0.0 : totalSuccessAmount / successTxns.length;

    return MerchantSalesSummaryModel(
      todaySales: todaySales,
      weeklySales: weeklySales,
      monthlySales: monthlySales,
      transactionCount: transactions.length,
      successfulTransactions: successTxns.length,
      failedTransactions: failedTxns.length,
      averageTransactionValue: avgValue > 0 ? avgValue : 1182.24,
    );
  }

  static List<MerchantTransactionModel> filterTransactions(
    List<MerchantTransactionModel> transactions, {
    String? query,
    String? status,
    String? paymentMethod,
  }) {
    return transactions.where((t) {
      if (query != null && query.trim().isNotEmpty) {
        final q = query.trim().toLowerCase();
        final matchCustomer = t.customerName.toLowerCase().contains(q);
        final matchId = t.transactionId.toLowerCase().contains(q);
        final matchUtr = t.utr.toLowerCase().contains(q);
        if (!matchCustomer && !matchId && !matchUtr) return false;
      }
      if (status != null && status != 'All' && status.isNotEmpty) {
        if (t.status.toUpperCase() != status.toUpperCase()) return false;
      }
      if (paymentMethod != null && paymentMethod != 'All' && paymentMethod.isNotEmpty) {
        if (t.paymentMethod.toUpperCase() != paymentMethod.toUpperCase()) return false;
      }
      return true;
    }).toList();
  }

  static List<MerchantOfferModel> filterOffers(
    List<MerchantOfferModel> offers, {
    bool onlyActive = true,
  }) {
    if (!onlyActive) return List.from(offers);
    return offers.where((o) => o.isActive).toList();
  }

  static bool isSettlementEligible({
    required double balance,
    required double amount,
  }) {
    if (amount < MerchantConstants.minimumSettlementAmount) return false;
    if (amount > MerchantConstants.maximumSettlementAmount) return false;
    if (amount > balance) return false;
    return true;
  }
}
