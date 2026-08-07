import 'package:payout/features/payments/models/payments_models.dart';

class DummyPaymentsData {
  static final List<BeneficiaryModel> dummyBeneficiaries = [
    const BeneficiaryModel(
      id: 'BEN-001',
      name: 'Rahul Sharma',
      upiId: 'rahul.sharma@okaxis',
      phone: '+91 9876543210',
      isFavourite: true,
      isVerified: true,
    ),
    const BeneficiaryModel(
      id: 'BEN-002',
      name: 'Priya Verma',
      upiId: 'priya.verma@okhdfcbank',
      phone: '+91 9988776655',
      isFavourite: true,
      isVerified: true,
    ),
    const BeneficiaryModel(
      id: 'BEN-003',
      name: 'Aman Gupta',
      upiId: 'aman.gupta@okicici',
      phone: '+91 9776655443',
      isFavourite: false,
      isVerified: false,
    ),
    const BeneficiaryModel(
      id: 'BEN-004',
      name: 'Sneha Patel',
      upiId: 'sneha.patel@oksbi',
      phone: '+91 9554433221',
      isFavourite: true,
      isVerified: true,
    ),
    const BeneficiaryModel(
      id: 'BEN-005',
      name: 'Rohit Singh',
      upiId: 'rohit.singh@okaxis',
      phone: '+91 9112233445',
      isFavourite: false,
      isVerified: true,
    ),
    const BeneficiaryModel(
      id: 'BEN-006',
      name: 'Neha Kapoor',
      upiId: 'neha.kapoor@okhdfcbank',
      phone: '+91 9334455667',
      isFavourite: false,
      isVerified: false,
    ),
    const BeneficiaryModel(
      id: 'BEN-007',
      name: 'Aditya Jain',
      upiId: 'aditya.jain@okicici',
      phone: '+91 9445566778',
      isFavourite: false,
      isVerified: true,
    ),
    const BeneficiaryModel(
      id: 'BEN-008',
      name: 'Anjali Mehta',
      upiId: 'anjali.mehta@oksbi',
      phone: '+91 9667788990',
      isFavourite: true,
      isVerified: true,
    ),
  ];

  static const List<PaymentMethodModel> dummyPaymentMethods = [
    PaymentMethodModel(
      id: 'PM-001',
      type: 'UPI',
      label: 'Google Pay UPI (@okaxis)',
      lastUsed: true,
      isDefault: true,
      isVerified: true,
      logoPath: 'upi',
    ),
    PaymentMethodModel(
      id: 'PM-002',
      type: 'Wallet',
      label: 'Payout Wallet',
      lastUsed: false,
      isDefault: false,
      isVerified: true,
      logoPath: 'wallet',
    ),
    PaymentMethodModel(
      id: 'PM-003',
      type: 'Bank Account',
      label: 'HDFC Bank •••• 9821',
      lastUsed: false,
      isDefault: false,
      isVerified: true,
      logoPath: 'bank',
    ),
    PaymentMethodModel(
      id: 'PM-004',
      type: 'Debit Card',
      label: 'Visa Debit Card •••• 5561',
      lastUsed: false,
      isDefault: false,
      isVerified: false,
      logoPath: 'card',
    ),
  ];

  static final List<RecentPaymentModel> dummyRecentPayments = [
    const RecentPaymentModel(
      id: 'PAY-801',
      recipientName: 'Rahul Sharma',
      upiId: 'rahul.sharma@okaxis',
      amount: 500.00,
      status: 'SUCCESS',
      date: 'Today, 2:30 PM',
    ),
    const RecentPaymentModel(
      id: 'PAY-802',
      recipientName: 'Priya Verma',
      upiId: 'priya.verma@okhdfcbank',
      amount: 1500.00,
      status: 'SUCCESS',
      date: 'Yesterday, 11:15 AM',
    ),
    const RecentPaymentModel(
      id: 'PAY-803',
      recipientName: 'Aman Gupta',
      upiId: 'aman.gupta@okicici',
      amount: 250.00,
      status: 'FAILED',
      date: 'Aug 04, 2026',
    ),
  ];

  static const PaymentLimitModel dummyLimits = PaymentLimitModel(
    dailyLimit: 100000.0,
    dailyRemaining: 98000.0,
    monthlyLimit: 1000000.0,
    monthlyRemaining: 950000.0,
  );
}
