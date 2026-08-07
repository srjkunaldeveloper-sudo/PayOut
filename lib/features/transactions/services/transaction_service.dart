import 'package:payout/features/transactions/models/transaction_models.dart';

class TransactionService {
  static Map<String, List<TransactionModel>> groupTransactionsByDate(List<TransactionModel> list) {
    final Map<String, List<TransactionModel>> groups = {
      'Today': [],
      'Yesterday': [],
      'This Week': [],
      'Earlier': [],
    };

    for (final tx in list) {
      if (tx.date.startsWith('Today')) {
        groups['Today']!.add(tx);
      } else if (tx.date.startsWith('Yesterday')) {
        groups['Yesterday']!.add(tx);
      } else if (tx.date.startsWith('This Week')) {
        groups['This Week']!.add(tx);
      } else {
        groups['Earlier']!.add(tx);
      }
    }

    // Clean up empty lists
    groups.removeWhere((key, val) => val.isEmpty);
    return groups;
  }
}
