import 'package:payout/features/bills/models/bill_models.dart';

class BillService {
  static double calculateTotalOutstanding(List<BillModel> list) {
    return list
        .where((b) => b.status == 'DUE' || b.status == 'OVERDUE')
        .map((b) => b.amount)
        .fold(0.0, (sum, val) => sum + val);
  }
}
