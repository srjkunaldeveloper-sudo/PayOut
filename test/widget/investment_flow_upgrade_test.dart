import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:payout/core/widgets/widgets.dart';
import 'package:payout/features/financial/investments/presentation/investments_screen.dart';
import 'package:payout/features/payments/presentation/mpin_verification_screen.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({'mpin': '123456'});
  });

  testWidgets('InvestmentsScreen renders portfolio, handles fund selection, risk disclosure modal, and MPIN checkout', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: InvestmentsScreen(),
      ),
    );

    // Initial load
    expect(find.text('Wealth & Investments'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();

    // Verify portfolio & holdings
    expect(find.text('Total Portfolio Value'), findsOneWidget);
    expect(find.text('My Active Holdings'), findsOneWidget);
    expect(find.text('Nippon India Large Cap Fund'), findsWidgets);

    // Tap Invest Now on first fund
    final investButtons = find.widgetWithText(PrimaryButton, 'Invest Now');
    await tester.ensureVisible(investButtons.first);
    await tester.tap(investButtons.first);
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();

    // Verify Investment Order Screen
    expect(find.text('Investment Mode'), findsOneWidget);
    expect(find.text('One-Time (Lumpsum)'), findsOneWidget);
    expect(find.text('Monthly SIP'), findsOneWidget);

    // Enter Investment Amount
    final amountField = find.widgetWithText(AppTextField, 'Investment Amount (₹)');
    await tester.enterText(amountField, '5000');
    await tester.pumpAndSettle();

    // Tap Continue
    final continueButton = find.widgetWithText(PrimaryButton, 'Continue to Risk Acknowledgement');
    await tester.ensureVisible(continueButton);
    await tester.tap(continueButton);
    await tester.pumpAndSettle();

    // Verify Risk Disclosure Modal
    expect(find.text('Market Risk Disclosure'), findsOneWidget);
    expect(find.byType(CheckboxListTile), findsOneWidget);

    // Check Risk Acknowledgement
    await tester.tap(find.byType(CheckboxListTile));
    await tester.pumpAndSettle();

    // Tap Authorize Payment
    final payButton = find.widgetWithText(PrimaryButton, 'Authorize Payment (6-Digit MPIN)');
    await tester.ensureVisible(payButton);
    await tester.tap(payButton);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 500));

    // Verify on PaymentMPINVerificationScreen
    expect(find.byType(PaymentMPINVerificationScreen), findsOneWidget);
    expect(find.text('Enter 6-Digit MPIN'), findsOneWidget);
    expect(find.textContaining('Nippon India Large Cap Fund'), findsOneWidget);
  });
}
