import 'package:payout/features/bills/models/bill_models.dart';
import 'package:payout/features/bills/dummy/dummy_bill_data.dart';
import 'package:payout/features/payments/models/payments_models.dart';
import 'package:payout/features/transactions/models/transaction_models.dart';
import 'package:payout/features/transactions/repositories/transaction_repository.dart';

abstract class BillRepository {
  Future<List<BillerModel>> getBillers();
  Future<List<BillerModel>> searchBiller(String query);
  Future<BillModel?> fetchBill(String billerId, String consumerNumber);
  Future<List<BillModel>> getDueBills();
  Future<TransferResponseModel> payBill({
    required String billId,
    required double amount,
    required String methodId,
  });
}

class MockBillRepository implements BillRepository {
  final TransactionRepository _transactionRepository;

  MockBillRepository(this._transactionRepository);

  @override
  Future<List<BillerModel>> getBillers() async {
    // TODO(api): GET /billers
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(DummyBillData.dummyBillers);
  }

  @override
  Future<List<BillerModel>> searchBiller(String query) async {
    // TODO(api): GET /billers/search
    await Future.delayed(const Duration(milliseconds: 300));
    if (query.isEmpty) {
      return List.from(DummyBillData.dummyBillers);
    }
    return DummyBillData.dummyBillers
        .where((b) => b.name.toLowerCase().contains(query.toLowerCase()) || b.category.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  @override
  Future<BillModel?> fetchBill(String billerId, String consumerNumber) async {
    // TODO(api): POST /bills/fetch
    await Future.delayed(const Duration(milliseconds: 700));
    final index = DummyBillData.dummyBills.indexWhere((b) => b.consumerNumber == consumerNumber);
    if (index != -1) {
      return DummyBillData.dummyBills[index];
    }
    // Return dynamically generated mock bill details if consumer is not pre-defined
    final billerIndex = DummyBillData.dummyBillers.indexWhere((b) => b.id == billerId);
    final billerName = billerIndex != -1 ? DummyBillData.dummyBillers[billerIndex].name : 'Utility Biller';
    
    return BillModel(
      id: 'BILL-${100 + consumerNumber.hashCode % 900}',
      billerName: billerName,
      consumerNumber: consumerNumber,
      amount: 1250.00,
      dueDate: 'Aug 25, 2026',
      status: 'DUE',
      consumerName: 'Rahul Sharma',
      billNumber: 'BL-87216',
      billDate: 'Aug 10, 2026',
      lateFee: 0.00,
    );
  }

  @override
  Future<List<BillModel>> getDueBills() async {
    // TODO(api): GET /bills/due
    await Future.delayed(const Duration(milliseconds: 300));
    return DummyBillData.dummyBills.where((b) => b.status == 'DUE').toList();
  }

  @override
  Future<TransferResponseModel> payBill({
    required String billId,
    required double amount,
    required String methodId,
  }) async {
    // TODO(api): POST /bills/pay
    await Future.delayed(const Duration(milliseconds: 1000));
    final randNum = DateTime.now().millisecondsSinceEpoch.toString();
    final randomId = 'TXN-BILL-$randNum';
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

    // Fetch details to create transaction
    final index = DummyBillData.dummyBills.indexWhere((b) => b.id == billId);
    String billerName = 'Utility Biller';
    String consumerNumber = 'N/A';
    if (index != -1) {
      billerName = DummyBillData.dummyBills[index].billerName;
      consumerNumber = DummyBillData.dummyBills[index].consumerNumber;
      if (!isPending) {
        // Mark as paid in dynamic dummy memory
        DummyBillData.dummyBills[index] = DummyBillData.dummyBills[index].copyWith(status: 'PAID');
      }
    }

    // Create a transaction record through the transaction abstraction
    final tx = TransactionModel(
      id: randomId,
      title: 'Bill Payment - $billerName',
      upiId: '$consumerNumber@biller'.toLowerCase(),
      type: 'DEBIT',
      category: 'Bill Payment',
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
