import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:payout/core/widgets/widgets.dart';
import 'package:payout/features/financial/insurance/presentation/insurance_screen.dart';
import 'package:payout/features/payments/presentation/mpin_verification_screen.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({'mpin': '123456'});
  });

  testWidgets('InsuranceScreen renders catalog, builds premium quote, and routes to MPIN checkout', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: InsuranceScreen(),
      ),
    );

    // Initial load
    expect(find.text('Insurance Marketplace'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();

    // Verify catalog policies
    expect(find.text('Care Health Shield Max'), findsOneWidget);
    expect(find.text('ICICI Pru iProtect Smart'), findsOneWidget);

    // Tap Get Covered on first policy
    final getCoveredButtons = find.widgetWithText(PrimaryButton, 'Get Covered');
    await tester.tap(getCoveredButtons.first);
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();

    // Verify Quote Builder screen
    expect(find.text('Care Health Shield Max'), findsWidgets);
    expect(find.text('Estimated Annual Premium'), findsOneWidget);

    // Enter Applicant Information
    final nameField = find.widgetWithText(AppTextField, 'Proposer Full Name');
    await tester.enterText(nameField, 'Rahul Sharma');

    final ageField = find.widgetWithText(AppTextField, 'Age (Years)');
    await tester.enterText(ageField, '28');

    await tester.pumpAndSettle();

    // Tap Review Policy
    final reviewButton = find.widgetWithText(PrimaryButton, 'Review Policy & Continue');
    await tester.ensureVisible(reviewButton);
    await tester.tap(reviewButton);
    await tester.pumpAndSettle();

    // Verify Review Modal
    expect(find.text('Review Policy Checkout'), findsOneWidget);

    // Tap Proceed to Pay
    final payButton = find.widgetWithText(PrimaryButton, 'Proceed to Pay ₹531.00');
    expect(payButton, findsOneWidget);
    await tester.ensureVisible(payButton);
    await tester.tap(payButton);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 500));

    // Verify on PaymentMPINVerificationScreen
    expect(find.byType(PaymentMPINVerificationScreen), findsOneWidget);
    expect(find.text('Enter 6-Digit MPIN'), findsOneWidget);
    expect(find.textContaining('Care Health Insurance'), findsOneWidget);
  });
}
