import 'package:payout/features/bills/models/bill_models.dart';

class DummyBillData {
  static final List<BillerModel> dummyBillers = [
    const BillerModel(id: 'BLR-201', name: 'BESCOM Electricity', category: 'Electricity'),
    const BillerModel(id: 'BLR-202', name: 'BWSSB Water Board', category: 'Water'),
    const BillerModel(id: 'BLR-203', name: 'Indane LPG Cylinders', category: 'Gas'),
    const BillerModel(id: 'BLR-204', name: 'Tata Play DTH Services', category: 'DTH'),
  ];

  static final List<BillModel> dummyBills = [
    const BillModel(
      id: 'BILL-401',
      billerName: 'BESCOM Electricity',
      consumerNumber: '542019382',
      amount: 3200.00,
      dueDate: 'Aug 18, 2026',
      status: 'DUE',
    ),
    const BillModel(
      id: 'BILL-402',
      billerName: 'Tata Play DTH Services',
      consumerNumber: '109827384',
      amount: 450.00,
      dueDate: 'Aug 22, 2026',
      status: 'DUE',
    ),
    const BillModel(
      id: 'BILL-403',
      billerName: 'BWSSB Water Board',
      consumerNumber: '908172635',
      amount: 280.00,
      dueDate: 'Aug 10, 2026',
      status: 'PAID',
    ),
  ];
}
