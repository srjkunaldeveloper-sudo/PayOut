import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:payout/core/widgets/widgets.dart';
import 'package:payout/features/user/presentation/kyc_status_screen.dart';
import 'package:payout/features/user/presentation/kyc_flow_screen.dart';

void main() {
  testWidgets('KYC status dashboard renders verification stages and benefits', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: KYCStatusScreen(),
      ),
    );

    // Initial load check
    expect(find.text('KYC Verification Center'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();

    // Verify status and checklist
    expect(find.text('KYC Verified'), findsOneWidget);
    expect(find.text('1. Personal Information'), findsOneWidget);
    expect(find.text('2. PAN Authentication'), findsOneWidget);
    expect(find.text('3. Identity Proof'), findsOneWidget);
    expect(find.text('4. Bank Account Verification'), findsOneWidget);
    expect(find.text('5. Regulatory Compliance'), findsOneWidget);
  });

  testWidgets('KYCFlowScreen completes 5-step wizard and submits verification', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: KYCFlowScreen(),
      ),
    );

    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();

    // Step 1: Personal Details
    expect(find.text('Step 1 of 5: Personal Details'), findsOneWidget);
    await tester.tap(find.widgetWithText(PrimaryButton, 'Continue'));
    await tester.pumpAndSettle();

    // Step 2: PAN Verification
    expect(find.text('Step 2 of 5: PAN Verification'), findsOneWidget);
    final panField = find.widgetWithText(AppTextField, '10-Digit PAN Number');
    await tester.enterText(panField, 'ABCDE1234F');
    await tester.tap(find.widgetWithText(PrimaryButton, 'Continue'));
    await tester.pumpAndSettle();

    // Step 3: Identity Document
    expect(find.text('Step 3 of 5: Identity Document'), findsOneWidget);
    final docField = find.widgetWithText(AppTextField, 'Aadhaar Card Number');
    await tester.enterText(docField, '123456789012');
    await tester.tap(find.widgetWithText(PrimaryButton, 'Continue'));
    await tester.pumpAndSettle();

    // Step 4: Bank Verification
    expect(find.text('Step 4 of 5: Bank Verification'), findsOneWidget);
    await tester.tap(find.widgetWithText(PrimaryButton, 'Continue'));
    await tester.pumpAndSettle();

    // Step 5: Review & Submit
    expect(find.text('Step 5 of 5: Review & Submit'), findsOneWidget);
    await tester.tap(find.widgetWithText(PrimaryButton, 'Submit KYC'));

    // Wait for async submission
    await tester.pump(const Duration(milliseconds: 900));
    await tester.pumpAndSettle();

    // Success dialog
    expect(find.text('KYC Verified Successfully!'), findsOneWidget);
    await tester.tap(find.widgetWithText(PrimaryButton, 'Done'));
    await tester.pumpAndSettle();
  });
}
