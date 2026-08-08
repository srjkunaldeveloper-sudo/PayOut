import 'package:payout/features/qr/models/qr_models.dart';

class DummyQrData {
  // Deterministic Demo Scenarios
  static const String validMerchantPayload = 'upi://pay?pa=srjfoods@upi&pn=SRJ%20Foods&mc=5812';
  static const String validPersonalPayload = 'upi://pay?pa=rahul@upi&pn=Rahul%20Sharma';
  static const String invalidPayload = 'INVALID_QR_SAMPLE';
  static const String expiredPayload = 'EXPIRED_QR_SAMPLE';
  static const String unsupportedPayload = 'UNSUPPORTED_QR_SAMPLE';

  static final List<MerchantModel> dummyMerchants = [
    const MerchantModel(
      id: 'MER-SRJ-01',
      name: 'SRJ Foods',
      upiId: 'srjfoods@upi',
      category: 'Food & Dining',
      rating: 4.8,
      distance: '0.2 km',
      cashbackText: 'Flat 5% cashback on payments above ₹200',
      offers: ['Get 10% off on all weekend special dishes', 'Free dessert on bills above ₹500'],
      isVerified: true,
    ),
    const MerchantModel(
      id: 'MER-101',
      name: 'Starbucks Coffee',
      upiId: 'starbucks@okaxis',
      category: 'Food & Beverage',
      rating: 4.6,
      distance: '0.4 km',
      cashbackText: 'Flat 5% cashback on payments above ₹200',
      offers: ['Get 10% off on your first latte brew'],
      isVerified: true,
    ),
    const MerchantModel(
      id: 'MER-102',
      name: 'Domino\'s Pizza',
      upiId: 'dominos@okhdfcbank',
      category: 'Food & Beverage',
      rating: 4.2,
      distance: '1.2 km',
      cashbackText: 'Earn up to ₹100 cashback points on weekend orders',
      offers: ['Buy 1 Get 1 free on medium hand-tossed pizzas'],
      isVerified: true,
    ),
  ];

  static final List<QRHistoryModel> dummyHistory = [
    const QRHistoryModel(
      id: 'QR-TXN-101',
      date: 'Today, 1:45 PM',
      merchantName: 'SRJ Foods',
      amount: 500.00,
      status: 'SUCCESS',
    ),
    const QRHistoryModel(
      id: 'QR-TXN-102',
      date: 'Yesterday, 8:20 PM',
      merchantName: 'Domino\'s Pizza',
      amount: 680.00,
      status: 'SUCCESS',
    ),
  ];
}
