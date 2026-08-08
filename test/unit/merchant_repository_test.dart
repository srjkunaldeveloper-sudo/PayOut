import 'package:flutter_test/flutter_test.dart';
import 'package:payout/features/merchant/dummy/dummy_merchant_data.dart';
import 'package:payout/features/merchant/repositories/merchant_repository.dart';

void main() {
  group('MerchantRepository Settlement Balance & Flow Tests', () {
    late MockMerchantRepository repository;

    setUp(() {
      DummyMerchantData.availableSettlementBalance = 18450.0;
      repository = MockMerchantRepository();
    });

    test('getAvailableSettlementBalance returns expected initial balance', () async {
      final balance = await repository.getAvailableSettlementBalance();
      expect(balance, equals(18450.0));
    });

    test('requestSettlement deducts balance on success and reflects in subsequent getAvailableSettlementBalance call', () async {
      final initialBalance = await repository.getAvailableSettlementBalance();
      expect(initialBalance, equals(18450.0));

      final success = await repository.requestSettlement(
        amount: 5000.0,
        bankAccountId: 'HDFC Bank •••• 9832',
      );

      expect(success, isTrue);

      final updatedBalance = await repository.getAvailableSettlementBalance();
      expect(updatedBalance, equals(13450.0));
    });

    test('failed settlement (amount == 100) does not deduct available balance', () async {
      final initialBalance = await repository.getAvailableSettlementBalance();

      final success = await repository.requestSettlement(
        amount: 100.0,
        bankAccountId: 'HDFC Bank •••• 9832',
      );

      expect(success, isFalse);

      final balanceAfterFail = await repository.getAvailableSettlementBalance();
      expect(balanceAfterFail, equals(initialBalance));
    });
  });
}
