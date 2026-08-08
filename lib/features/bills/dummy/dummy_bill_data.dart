import 'package:payout/features/bills/models/bill_models.dart';

class DummyBillData {
  static final List<BillerModel> dummyBillers = [
    // Electricity
    const BillerModel(id: 'BLR-ELE-01', name: 'BESCOM Electricity', category: 'Electricity'),
    const BillerModel(id: 'BLR-ELE-02', name: 'BSES Rajdhani', category: 'Electricity'),
    const BillerModel(id: 'BLR-ELE-03', name: 'Tata Power Delhi', category: 'Electricity'),

    // Water
    const BillerModel(id: 'BLR-WAT-01', name: 'BWSSB Water Board', category: 'Water'),
    const BillerModel(id: 'BLR-WAT-02', name: 'Delhi Jal Board', category: 'Water'),

    // DTH
    const BillerModel(id: 'BLR-DTH-01', name: 'Tata Play DTH Services', category: 'DTH'),
    const BillerModel(id: 'BLR-DTH-02', name: 'Airtel Digital TV', category: 'DTH'),
    const BillerModel(id: 'BLR-DTH-03', name: 'Dish TV', category: 'DTH'),

    // LPG
    const BillerModel(id: 'BLR-LPG-01', name: 'Indane Gas Booking', category: 'LPG'),
    const BillerModel(id: 'BLR-LPG-02', name: 'HP Gas Booking', category: 'LPG'),
    const BillerModel(id: 'BLR-LPG-03', name: 'Bharatgas Booking', category: 'LPG'),

    // Broadband
    const BillerModel(id: 'BLR-BB-01', name: 'Airtel Xstream Broadband', category: 'Broadband'),
    const BillerModel(id: 'BLR-BB-02', name: 'JioFiber Broadband', category: 'Broadband'),

    // Mobile Postpaid
    const BillerModel(id: 'BLR-MPP-01', name: 'Airtel Postpaid Bills', category: 'Mobile Postpaid'),
    const BillerModel(id: 'BLR-MPP-02', name: 'Jio Postpaid Bills', category: 'Mobile Postpaid'),
  ];

  static final List<BillModel> dummyBills = [
    const BillModel(
      id: 'BILL-ELE-01',
      billerName: 'BESCOM Electricity',
      consumerNumber: '542019382',
      amount: 1248.00,
      dueDate: 'Aug 18, 2026',
      status: 'DUE',
      consumerName: 'Rahul Sharma',
      billNumber: 'EL-9081723',
      billDate: 'Aug 01, 2026',
      lateFee: 0.00,
    ),
    const BillModel(
      id: 'BILL-DTH-01',
      billerName: 'Tata Play DTH Services',
      consumerNumber: '109827384',
      amount: 450.00,
      dueDate: 'Aug 22, 2026',
      status: 'DUE',
      consumerName: 'Rahul Sharma',
      billNumber: 'DT-871625',
      billDate: 'Aug 05, 2026',
      lateFee: 0.00,
    ),
    const BillModel(
      id: 'BILL-WAT-01',
      billerName: 'BWSSB Water Board',
      consumerNumber: '908172635',
      amount: 280.00,
      dueDate: 'Aug 10, 2026',
      status: 'PAID',
      consumerName: 'Rahul Sharma',
      billNumber: 'WT-092831',
      billDate: 'Jul 25, 2026',
      lateFee: 0.00,
    ),
    const BillModel(
      id: 'BILL-LPG-01',
      billerName: 'Indane Gas Booking',
      consumerNumber: '9876543210',
      amount: 1050.00,
      dueDate: 'Aug 25, 2026',
      status: 'DUE',
      consumerName: 'Rahul Sharma',
      billNumber: 'LPG-87216',
      billDate: 'Aug 10, 2026',
      lateFee: 0.00,
    ),
  ];
}
