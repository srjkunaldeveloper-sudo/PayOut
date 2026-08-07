import 'package:payout/features/transactions/models/transaction_models.dart';
import 'package:payout/features/transactions/dummy/dummy_transaction_data.dart';
import 'package:payout/features/transactions/services/transaction_logger.dart';

abstract class TransactionRepository {
  Future<List<TransactionModel>> getTransactions();
  Future<List<TransactionModel>> searchTransactions(String query);
  Future<List<TransactionModel>> filterTransactions(TransactionFilterModel filters);
  Future<ReceiptModel> getReceipt(String txnId);
  Future<bool> exportStatement(String month, String format);
}

class MockTransactionRepository implements TransactionRepository {
  @override
  Future<List<TransactionModel>> getTransactions() async {
    // TODO: Connect transactions history database endpoint
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(DummyTransactionData.dummyTransactions);
  }

  @override
  Future<List<TransactionModel>> searchTransactions(String query) async {
    // TODO: Connect transactions search text indexing endpoint
    await Future.delayed(const Duration(milliseconds: 300));
    TransactionLogger.logSearch(query);
    if (query.isEmpty) {
      return List.from(DummyTransactionData.dummyTransactions);
    }
    return DummyTransactionData.dummyTransactions
        .where((t) => t.title.toLowerCase().contains(query.toLowerCase()) || t.upiId.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  @override
  Future<List<TransactionModel>> filterTransactions(TransactionFilterModel filters) async {
    // TODO: Connect transactions category filters endpoint
    await Future.delayed(const Duration(milliseconds: 400));
    Iterable<TransactionModel> results = DummyTransactionData.dummyTransactions;
    if (filters.category != null && filters.category != 'All') {
      TransactionLogger.logFilter('category', filters.category!);
      results = results.where((t) => t.category.toLowerCase() == filters.category!.toLowerCase());
    }
    if (filters.type != null && filters.type != 'All') {
      TransactionLogger.logFilter('type', filters.type!);
      results = results.where((t) => t.type.toLowerCase() == filters.type!.toLowerCase());
    }
    return results.toList();
  }

  @override
  Future<ReceiptModel> getReceipt(String txnId) async {
    // TODO: Connect verified receipt database endpoint
    await Future.delayed(const Duration(milliseconds: 400));
    final index = DummyTransactionData.dummyTransactions.indexWhere((t) => t.id == txnId);
    if (index != -1) {
      final t = DummyTransactionData.dummyTransactions[index];
      return ReceiptModel(
        id: t.id,
        utrNumber: t.utr,
        date: t.date.split(',')[0],
        time: t.date.contains(',') ? t.date.split(',')[1].trim() : '12:00 PM',
        recipientName: t.title,
        amount: t.amount,
        status: t.status,
        remarks: 'Payment processed successfully.',
      );
    }
    return ReceiptModel(
      id: txnId,
      utrNumber: 'UTR000000000000',
      date: 'Today',
      time: 'Just Now',
      recipientName: 'Unknown',
      amount: 0.0,
      status: 'FAILED',
      remarks: 'Transaction not found.',
    );
  }

  @override
  Future<bool> exportStatement(String month, String format) async {
    // TODO: Connect statement export/generation gateway
    await Future.delayed(const Duration(milliseconds: 1000));
    TransactionLogger.logExport(month, format);
    return true;
  }
}
