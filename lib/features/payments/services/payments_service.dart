import 'package:payout/features/payments/models/payments_models.dart';

class PaymentsService {
  static double calculateTotalSpent(List<RecentPaymentModel> payments) {
    return payments
        .where((p) => p.status == 'SUCCESS')
        .fold(0.0, (sum, item) => sum + item.amount);
  }
}
