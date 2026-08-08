import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:payout/core/widgets/widgets.dart';
import 'package:payout/features/bank_accounts/repositories/bank_account_repository.dart';
import 'package:payout/features/merchant/presentation/merchant_settlement_screen.dart';
import 'package:payout/features/merchant/repositories/merchant_repository.dart';
import 'package:payout/features/payments/presentation/mpin_verification_screen.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({'mpin': '123456'});
  });

  testWidgets('MerchantSettlementScreen handles amount input, bank selection, review sheet, and MPIN authorization', (WidgetTester tester) async {
    final mockMerchantRepo = MockMerchantRepository();
    final mockBankRepo = MockBankAccountRepository();

    await tester.pumpWidget(
      MaterialApp(
        home: MerchantSettlementScreen(
          merchantRepository: mockMerchantRepo,
          bankAccountRepository: mockBankRepo,
        ),
      ),
    );

    // Initial load settling
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();

    // Verify screen title & balance
    expect(find.text('Settlement & Instant Sweep'), findsOneWidget);
    expect(find.text('Available Settlement Balance'), findsOneWidget);
    expect(find.text('Destination Bank Account'), findsOneWidget);
    expect(find.text('Settlement Amount'), findsOneWidget);

    // Enter Settlement Amount
    final amountField = find.byType(TextFormField);
    expect(amountField, findsOneWidget);
    await tester.enterText(amountField, '5000');
    await tester.pumpAndSettle();

    // Tap Review Settlement Button
    final reviewButton = find.widgetWithText(PrimaryButton, 'Review Settlement');
    expect(reviewButton, findsOneWidget);
    await tester.ensureVisible(reviewButton);
    await tester.tap(reviewButton);
    await tester.pumpAndSettle();

    // Verify Review Modal Bottom Sheet
    expect(find.text('Review Settlement Request'), findsOneWidget);
    expect(find.text('IMPS Instant Sweep'), findsOneWidget);
    expect(find.text('FREE (₹0.00)'), findsOneWidget);

    // Tap Authorize Settlement via MPIN
    final authorizeButton = find.widgetWithText(PrimaryButton, 'Authorize Settlement via MPIN');
    expect(authorizeButton, findsOneWidget);
    await tester.ensureVisible(authorizeButton);
    await tester.tap(authorizeButton);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 500));

    // Verify on PaymentMPINVerificationScreen
    expect(find.byType(PaymentMPINVerificationScreen), findsOneWidget);
    expect(find.text('Enter 6-Digit MPIN'), findsOneWidget);
    expect(find.textContaining('Merchant Bank Settlement'), findsOneWidget);
  });
}
