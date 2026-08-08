import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:payout/core/widgets/widgets.dart';
import 'package:payout/features/financial/loans/presentation/loans_screen.dart';

void main() {
  testWidgets('LoansScreen renders catalog, validates applicant inputs, calculates EMI and submits application', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: LoansScreen(),
      ),
    );

    // Initial load
    expect(find.text('Loans & Credit'), findsOneWidget);

    // Wait for Mock async loading
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();

    // Verify catalog items
    expect(find.text('Pre-Approved Credit Line'), findsOneWidget);
    expect(find.text('Instant Personal Loan'), findsOneWidget);
    expect(find.text('MSME Business Growth Loan'), findsOneWidget);

    // Tap Check Eligibility on first loan
    final checkButtons = find.widgetWithText(PrimaryButton, 'Check Eligibility');
    await tester.tap(checkButtons.first);
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();

    // Verify Application Form
    expect(find.text('Instant Personal Loan'), findsWidgets);
    expect(find.text('KYC Authenticated ✓'), findsOneWidget);
    expect(find.text('Estimated Monthly EMI'), findsOneWidget);

    // Enter Applicant Information
    final nameField = find.widgetWithText(AppTextField, 'Full Name');
    await tester.enterText(nameField, 'Rahul Sharma');

    final dobField = find.widgetWithText(AppTextField, 'Date of Birth (DD/MM/YYYY)');
    await tester.enterText(dobField, '15/08/1995');

    final incomeField = find.widgetWithText(AppTextField, 'Monthly Income (₹)');
    await tester.enterText(incomeField, '65000');

    final panField = find.widgetWithText(AppTextField, 'PAN Card Number');
    await tester.enterText(panField, 'ABCDE1234F');

    await tester.pumpAndSettle();

    // Tap Review Application
    final reviewButton = find.widgetWithText(PrimaryButton, 'Review Application');
    await tester.ensureVisible(reviewButton);
    await tester.tap(reviewButton);
    await tester.pumpAndSettle();

    // Verify Review Modal
    expect(find.text('Review Loan Application'), findsOneWidget);
    expect(find.text('Rahul Sharma'), findsWidgets);
    expect(find.text('ABCDE1234F'), findsWidgets);

    // Confirm Submission
    final submitButton = find.widgetWithText(PrimaryButton, 'Confirm & Submit Application');
    await tester.tap(submitButton);

    // Wait for async submission
    await tester.pump(const Duration(milliseconds: 1000));
    await tester.pumpAndSettle();

    // Verify Outcome Screen
    expect(find.text('Loan Application Approved'), findsOneWidget);
    expect(find.text('Sanctioned Amount'), findsOneWidget);
  });
}
