import 'package:payout/features/recharge/models/recharge_models.dart';
import 'package:payout/features/recharge/dummy/dummy_recharge_data.dart';
import 'package:payout/features/payments/models/payments_models.dart';
import 'package:payout/features/transactions/models/transaction_models.dart';
import 'package:payout/features/transactions/repositories/transaction_repository.dart';

abstract class RechargeRepository {
  Future<List<OperatorModel>> getOperators();
  Future<List<RechargePlanModel>> getPlans(String operatorName);
  Future<List<RecentRechargeModel>> getRecentRecharges();
  Future<TransferResponseModel> rechargeMobile({
    required String mobileNumber,
    required String operator,
    required double amount,
    required String planId,
    required String methodId,
  });
}

class MockRechargeRepository implements RechargeRepository {
  final TransactionRepository _transactionRepository;

  MockRechargeRepository(this._transactionRepository);

  @override
  Future<List<OperatorModel>> getOperators() async {
    // TODO(api): GET /recharge/operators
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(DummyRechargeData.dummyOperators);
  }

  @override
  Future<List<RechargePlanModel>> getPlans(String operatorName) async {
    // TODO(api): GET /recharge/plans
    await Future.delayed(const Duration(milliseconds: 300));
    final query = operatorName.toLowerCase();
    return DummyRechargeData.dummyPlans.where((p) {
      if (operatorName.isEmpty) return true;
      final op = p.operator.toLowerCase();
      return query.contains(op) || op.contains(query);
    }).toList();
  }

  @override
  Future<List<RecentRechargeModel>> getRecentRecharges() async {
    // TODO(api): GET /recharge/recents
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(DummyRechargeData.dummyRecents);
  }

  @override
  Future<TransferResponseModel> rechargeMobile({
    required String mobileNumber,
    required String operator,
    required double amount,
    required String planId,
    required String methodId,
  }) async {
    // TODO(api): POST /recharge
    await Future.delayed(const Duration(milliseconds: 1000));
    final randNum = DateTime.now().millisecondsSinceEpoch.toString();
    final randomId = 'TXN-REC-$randNum';
    final utr = 'UTR$randNum';

    // Outcome isolation stubs based on amount (₹100 = FAILED, ₹200 = PENDING, other = SUCCESS)
    if (amount == 100.0) {
      return TransferResponseModel(
        success: false,
        transactionId: randomId,
        utrNumber: utr,
        status: 'FAILED',
        date: DateTime.now().toString(),
      );
    }

    final isPending = amount == 200.0;
    final status = isPending ? 'PENDING' : 'SUCCESS';

    // Create a transaction record through the transaction abstraction
    final tx = TransactionModel(
      id: randomId,
      title: 'Mobile Recharge - $operator',
      upiId: '$mobileNumber@$operator'.toLowerCase(),
      type: 'DEBIT',
      category: 'Mobile Recharge',
      amount: amount,
      date: 'Just now',
      status: status,
      paymentMethod: methodId == 'wallet' ? 'Payout Wallet' : 'Bank Account',
      utr: utr,
      referenceNumber: 'REF$randNum',
    );
    await _transactionRepository.addTransaction(tx);

    return TransferResponseModel(
      success: !isPending,
      transactionId: randomId,
      utrNumber: utr,
      status: status,
      date: DateTime.now().toString(),
    );
  }
}
