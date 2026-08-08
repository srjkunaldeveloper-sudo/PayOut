import 'package:flutter_test/flutter_test.dart';
import 'package:payout/features/merchant/validators/merchant_validator.dart';

void main() {
  group('MerchantValidator Tests', () {
    test('validateBusinessName checks length and empty', () {
      expect(MerchantValidator.validateBusinessName('').isValid, isFalse);
      expect(MerchantValidator.validateBusinessName('SR').isValid, isFalse);
      expect(MerchantValidator.validateBusinessName('SRJ Supermarket').isValid, isTrue);
    });

    test('validateGST checks 15-digit GSTIN pattern', () {
      expect(MerchantValidator.validateGST('').isValid, isFalse);
      expect(MerchantValidator.validateGST('INVALID123').isValid, isFalse);
      expect(MerchantValidator.validateGST('22AAAAA1111A1Z1').isValid, isTrue);
    });

    test('validatePAN checks 10-character PAN pattern', () {
      expect(MerchantValidator.validatePAN('').isValid, isFalse);
      expect(MerchantValidator.validatePAN('AABC123').isValid, isFalse);
      expect(MerchantValidator.validatePAN('AABCP8832K').isValid, isTrue);
    });

    test('validateMobile checks 10-digit Indian mobile number', () {
      expect(MerchantValidator.validateMobile('').isValid, isFalse);
      expect(MerchantValidator.validateMobile('12345').isValid, isFalse);
      expect(MerchantValidator.validateMobile('9876543210').isValid, isTrue);
    });

    test('validateEmail checks standard email pattern', () {
      expect(MerchantValidator.validateEmail('').isValid, isFalse);
      expect(MerchantValidator.validateEmail('invalid-email').isValid, isFalse);
      expect(MerchantValidator.validateEmail('merchant@payout.app').isValid, isTrue);
    });

    test('validatePincode checks 6-digit postal code', () {
      expect(MerchantValidator.validatePincode('').isValid, isFalse);
      expect(MerchantValidator.validatePincode('123').isValid, isFalse);
      expect(MerchantValidator.validatePincode('201301').isValid, isTrue);
    });

    test('validateSettlementAmount checks min, max, and available balance limits', () {
      expect(MerchantValidator.validateSettlementAmount(null).isValid, isFalse);
      expect(MerchantValidator.validateSettlementAmount(0.0).isValid, isFalse);
      expect(MerchantValidator.validateSettlementAmount(50.0).isValid, isFalse); // < 100
      expect(MerchantValidator.validateSettlementAmount(600000.0).isValid, isFalse); // > 500000
      expect(MerchantValidator.validateSettlementAmount(15000.0, availableBalance: 10000.0).isValid, isFalse); // > balance
      expect(MerchantValidator.validateSettlementAmount(5000.0, availableBalance: 10000.0).isValid, isTrue);
    });
  });
}
