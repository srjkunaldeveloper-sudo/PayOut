import 'package:payout/features/qr/models/qr_models.dart';

class DummyQrData {
  static final List<MerchantModel> dummyMerchants = [
    const MerchantModel(
      id: 'MER-101',
      name: 'Starbucks Coffee',
      upiId: 'starbucks@okaxis',
      category: 'Food & Beverage',
      rating: 4.6,
      distance: '0.4 km',
      cashbackText: 'Flat 5% cashback on payments above ₹200',
      offers: ['Get 10% off on your first latte brew', 'Free upgrades to Grande sizing on select Wednesdays'],
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
      offers: ['Buy 1 Get 1 free on medium hand-tossed pizzas', '15% discount on checkout using Payout wallet'],
      isVerified: true,
    ),
    const MerchantModel(
      id: 'MER-103',
      name: 'Reliance Fresh',
      upiId: 'reliancefresh@okicici',
      category: 'Grocery',
      rating: 4.4,
      distance: '0.8 km',
      cashbackText: 'Flat ₹50 cashback rewards on purchase of ₹1,000+',
      offers: ['Free home shipping on orders above ₹2,000', 'Flat 5% off on fresh seasonal vegetables'],
      isVerified: true,
    ),
    const MerchantModel(
      id: 'MER-104',
      name: 'DMart Superstore',
      upiId: 'dmart@oksbi',
      category: 'Grocery',
      rating: 4.5,
      distance: '2.5 km',
      cashbackText: 'Earn 2x reward coins on household essentials',
      offers: ['Wholesale discount rates on bulk grocery packs'],
      isVerified: true,
    ),
    const MerchantModel(
      id: 'MER-105',
      name: 'Apollo Pharmacy',
      upiId: 'apollopharmacy@okaxis',
      category: 'Pharmacy',
      rating: 4.7,
      distance: '0.3 km',
      cashbackText: 'Save 10% extra on prescribed medical refills',
      offers: ['Free medical check-up voucher on transactions above ₹1,500'],
      isVerified: true,
    ),
    const MerchantModel(
      id: 'MER-106',
      name: 'Indian Oil Fuel Station',
      upiId: 'indianoil@okhdfcbank',
      category: 'Fuel',
      rating: 4.1,
      distance: '3.1 km',
      cashbackText: 'Surcharge fee waiver up to 1% on fuel checkouts',
      offers: ['Redeem Indian Oil extra points for fuel discounts'],
      isVerified: true,
    ),
  ];

  static final List<QRHistoryModel> dummyHistory = [
    const QRHistoryModel(
      id: 'QR-TXN-101',
      date: 'Today, 1:45 PM',
      merchantName: 'Starbucks Coffee',
      amount: 320.00,
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
