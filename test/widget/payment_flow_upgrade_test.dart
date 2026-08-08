import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:payout/core/widgets/widgets.dart';
import 'package:payout/features/bank_accounts/presentation/link_bank_flow.dart';
import 'package:payout/features/payments/presentation/mpin_verification_screen.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({'mpin': '123456'});
  });

  testWidgets('LinkBankFlow renders select bank, account details, SIM and OTP verification steps', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: LinkBankFlow(),
      ),
    );

    // Resolve getSupportedBanks future
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    // Initial step: Select Bank
    expect(find.text('Select your bank'), findsOneWidget);
    expect(find.text('Popular Banks'), findsOneWidget);
    expect(find.text('Punjab National Bank'), findsOneWidget);

    // Select HDFC Bank
    await tester.tap(find.text('HDFC Bank').first);
    await tester.pumpAndSettle();

    // Step 1: Account Details
    expect(find.text('Account Details'), findsOneWidget);
    expect(find.byType(Form), findsOneWidget);

    // Enter valid details
    await tester.enterText(find.widgetWithText(TextFormField, 'Account Holder Name'), 'Rahul Sharma');
    await tester.enterText(find.widgetWithText(TextFormField, 'Account Number'), '5010024125849');
    await tester.enterText(find.widgetWithText(TextFormField, 'Confirm Account Number'), '5010024125849');
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    // Step 2: SIM Verification
    expect(find.text('SIM Mobile Verification'), findsOneWidget);
    expect(find.text('Send Verification OTP'), findsOneWidget);

    await tester.tap(find.text('Send Verification OTP'));
    await tester.pumpAndSettle();

    // Step 3: Enter Verification OTP
    expect(find.text('Enter Verification OTP'), findsOneWidget);
    await tester.enterText(find.byType(TextField), '123456');
    await tester.tap(find.widgetWithText(PrimaryButton, 'Verify OTP'), warnIfMissed: false);
    await tester.pumpAndSettle();

    // Step 4: Verification Method Selection
    expect(find.text('Select account verification method'), findsOneWidget);
    await tester.tap(find.text('Debit Card'));
    await tester.pumpAndSettle();

    // Step 5: Verify Card
    expect(find.text('Verify Debit Card Details'), findsOneWidget);
    await tester.enterText(find.widgetWithText(TextFormField, 'Last 6 Digits of Debit Card'), '123456');
    await tester.enterText(find.widgetWithText(TextFormField, 'Expiry Date (MM/YY)'), '12/29');
    await tester.tap(find.text('Verify Card & Link Account'), warnIfMissed: false);
    await tester.pumpAndSettle();

    // Step 6: Summary success
    expect(find.text('Bank Account Linked!'), findsOneWidget);
  });

  testWidgets('PaymentMPINVerificationScreen renders and handles input sequence', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: PaymentMPINVerificationScreen(
          recipientName: 'Rahul Sharma',
          recipientDetail: 'rahul@upi',
          recipientType: 'UPI',
          amount: 500.0,
          note: 'Demo payment',
          methodId: 'wallet',
        ),
      ),
    );

    // Resolve readMPIN future
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Enter 6-Digit MPIN'), findsOneWidget);
    expect(find.text('Confirm transfer of ₹500.00 to Rahul Sharma.'), findsOneWidget);

    // Tap 6 digits keypad
    await tester.tap(find.text('1'));
    await tester.tap(find.text('2'));
    await tester.tap(find.text('3'));
    await tester.tap(find.text('4'));
    await tester.tap(find.text('5'));
    await tester.tap(find.text('6'));
    
    // Resolve delayed verification timer and verification screen push
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();
  });
}
