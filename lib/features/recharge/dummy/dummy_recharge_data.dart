import 'package:payout/features/recharge/models/recharge_models.dart';

class DummyRechargeData {
  static final List<OperatorModel> dummyOperators = [
    const OperatorModel(name: 'Jio', logoUrl: ''),
    const OperatorModel(name: 'Airtel', logoUrl: ''),
    const OperatorModel(name: 'Vi', logoUrl: ''),
    const OperatorModel(name: 'BSNL', logoUrl: ''),
  ];

  static final List<RechargePlanModel> dummyPlans = [
    const RechargePlanModel(
      id: 'PLAN-299',
      amount: 299.00,
      validity: '28 Days',
      data: '1.5 GB/Day',
      description: 'Unlimited local & STD calls, 100 SMS/day, access to Jio Cinema and Jio TV apps.',
      category: 'Popular',
    ),
    const RechargePlanModel(
      id: 'PLAN-719',
      amount: 719.00,
      validity: '84 Days',
      data: '2.0 GB/Day',
      description: 'Super value pack. Includes Disney+ Hotstar mobile subscription for 3 months.',
      category: 'Unlimited',
    ),
    const RechargePlanModel(
      id: 'PLAN-155',
      amount: 155.00,
      validity: '28 Days',
      data: '2.0 GB Total',
      description: 'Budget pack with unlimited calling and 300 SMS total.',
      category: 'Talktime',
    ),
    const RechargePlanModel(
      id: 'PLAN-19',
      amount: 19.00,
      validity: 'Active Plan',
      data: '1.0 GB Total',
      description: 'Data booster pack for emergency high speed usage.',
      category: 'Data Only',
    ),
  ];

  static final List<RecentRechargeModel> dummyRecents = [
    const RecentRechargeModel(
      id: 'REC-301',
      mobileNumber: '9876543210',
      operatorName: 'Jio',
      amount: 299.0,
      date: 'Today, 2:30 PM',
    ),
    const RecentRechargeModel(
      id: 'REC-302',
      mobileNumber: '8765432109',
      operatorName: 'Airtel',
      amount: 719.0,
      date: 'Yesterday',
    ),
  ];
}
