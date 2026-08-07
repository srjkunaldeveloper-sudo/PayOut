import 'package:payout/features/bills/models/bill_models.dart';
import 'package:payout/features/bills/dummy/dummy_bill_data.dart';

abstract class BillRepository {
  Future<List<BillerModel>> getBillers();
  Future<List<BillerModel>> searchBiller(String query);
  Future<BillModel?> fetchBill(String billerId, String consumerNumber);
  Future<List<BillModel>> getDueBills();
}

class MockBillRepository implements BillRepository {
  @override
  Future<List<BillerModel>> getBillers() async {
    // TODO: Connect utility providers directory API endpoint
    await Future.delayed(const Duration(milliseconds: 400));
    return List.from(DummyBillData.dummyBillers);
  }

  @override
  Future<List<BillerModel>> searchBiller(String query) async {
    // TODO: Connect providers database search engine
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
    // TODO: Connect fetch current bills gateway API endpoint
    await Future.delayed(const Duration(milliseconds: 700));
    final index = DummyBillData.dummyBills.indexWhere((b) => b.consumerNumber == consumerNumber);
    if (index != -1) {
      return DummyBillData.dummyBills[index];
    }
    // Return a dynamically generated mock bill if customer is not found (for demo)
    return BillModel(
      id: 'BILL-${100 + consumerNumber.hashCode % 900}',
      billerName: 'Selected Utility Provider',
      consumerNumber: consumerNumber,
      amount: 1250.00,
      dueDate: 'Aug 25, 2026',
      status: 'DUE',
    );
  }

  @override
  Future<List<BillModel>> getDueBills() async {
    // TODO: Connect due invoices ledger log API endpoint
    await Future.delayed(const Duration(milliseconds: 500));
    return DummyBillData.dummyBills.where((b) => b.status == 'DUE').toList();
  }
}
