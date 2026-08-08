import 'package:flutter_test/flutter_test.dart';
import 'package:payout/features/merchant/models/merchant_models.dart';
import 'package:payout/features/merchant/services/merchant_service.dart';

void main() {
  group('MerchantService Tests', () {
    test('calculateTotalSettled sums only SUCCESS settlements', () {
      final settlements = [
        const SettlementModel(id: '1', settlementId: '1', amount: 5000.0, settlementDate: 'Today', status: 'SUCCESS'),
        const SettlementModel(id: '2', settlementId: '2', amount: 3000.0, settlementDate: 'Today', status: 'FAILED'),
        const SettlementModel(id: '3', settlementId: '3', amount: 2000.0, settlementDate: 'Today', status: 'SUCCESS'),
      ];

      final total = MerchantService.calculateTotalSettled(settlements);
      expect(total, equals(7000.0));
    });

    test('calculateSalesSummary aggregates transaction counts and average values', () {
      final txns = [
        const MerchantTransactionModel(id: '1', transactionId: 'T1', customerName: 'Aarav', amount: 1000.0, paymentMethod: 'UPI', status: 'SUCCESS', dateTime: 'Today', utr: 'U1'),
        const MerchantTransactionModel(id: '2', transactionId: 'T2', customerName: 'Priya', amount: 2000.0, paymentMethod: 'CARD', status: 'SUCCESS', dateTime: 'Today', utr: 'U2'),
        const MerchantTransactionModel(id: '3', transactionId: 'T3', customerName: 'Rohit', amount: 500.0, paymentMethod: 'WALLET', status: 'FAILED', dateTime: 'Today', utr: 'U3'),
      ];

      final summary = MerchantService.calculateSalesSummary(txns, todaySales: 3000.0);
      expect(summary.transactionCount, equals(3));
      expect(summary.successfulTransactions, equals(2));
      expect(summary.failedTransactions, equals(1));
      expect(summary.averageTransactionValue, equals(1500.0));
    });

    test('filterTransactions filters by query, status, and payment method', () {
      final txns = [
        const MerchantTransactionModel(id: '1', transactionId: 'TXN-101', customerName: 'Aarav Sharma', amount: 1000.0, paymentMethod: 'UPI', status: 'SUCCESS', dateTime: 'Today', utr: 'UTR001'),
        const MerchantTransactionModel(id: '2', transactionId: 'TXN-102', customerName: 'Priya Patel', amount: 2000.0, paymentMethod: 'CARD', status: 'PENDING', dateTime: 'Today', utr: 'UTR002'),
      ];

      // Query filter
      final byQuery = MerchantService.filterTransactions(txns, query: 'Aarav');
      expect(byQuery.length, equals(1));
      expect(byQuery.first.customerName, equals('Aarav Sharma'));

      // Status filter
      final byStatus = MerchantService.filterTransactions(txns, status: 'PENDING');
      expect(byStatus.length, equals(1));
      expect(byStatus.first.status, equals('PENDING'));

      // Method filter
      final byMethod = MerchantService.filterTransactions(txns, paymentMethod: 'CARD');
      expect(byMethod.length, equals(1));
      expect(byMethod.first.paymentMethod, equals('CARD'));
    });

    test('isSettlementEligible checks boundaries', () {
      expect(MerchantService.isSettlementEligible(balance: 10000.0, amount: 50.0), isFalse); // < 100
      expect(MerchantService.isSettlementEligible(balance: 10000.0, amount: 15000.0), isFalse); // > balance
      expect(MerchantService.isSettlementEligible(balance: 10000.0, amount: 5000.0), isTrue);
    });
  });
}
