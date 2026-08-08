import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:payout/core/widgets/widgets.dart';
import 'package:payout/features/payments/presentation/mpin_verification_screen.dart';
import 'package:payout/features/travel/presentation/train_flow.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({'mpin': '123456'});
  });

  testWidgets('Train reservation flow: search, select class, enter passenger, review and MPIN checkout', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: TrainSearchScreen(),
      ),
    );

    // Initial search screen verification
    expect(find.text('Train Reservation'), findsOneWidget);
    expect(find.text('Search Trains'), findsOneWidget);

    // Enter Search Stations
    final textFields = find.byType(TextFormField);
    await tester.enterText(textFields.at(0), 'New Delhi (NDLS)');
    await tester.enterText(textFields.at(1), 'Mumbai Central (MMCT)');
    await tester.pumpAndSettle();

    // Tap Search Trains
    final searchButton = find.widgetWithText(PrimaryButton, 'Search Trains');
    await tester.ensureVisible(searchButton);
    await tester.tap(searchButton);
    await tester.pumpAndSettle();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    // Verify Results Screen
    expect(find.text('New Delhi (NDLS) → Mumbai Central (MMCT)'), findsOneWidget);
    expect(find.textContaining('Rajdhani'), findsWidgets);
    expect(find.text('3A'), findsWidgets);

    // Tap Available Class Card on Train
    await tester.tap(find.textContaining('AVAILABLE').first);
    await tester.pumpAndSettle();

    // Verify Passenger Details Screen
    expect(find.text('Passenger Details'), findsOneWidget);
    expect(find.text('Passenger Information'), findsOneWidget);

    // Enter Passenger Info
    final passengerInputs = find.byType(TextFormField);
    await tester.enterText(passengerInputs.at(0), 'Rahul Sharma');
    await tester.enterText(passengerInputs.at(1), '29');
    await tester.enterText(passengerInputs.at(2), '9876543210');
    await tester.pumpAndSettle();

    // Tap Review Train Reservation
    final reviewButton = find.widgetWithText(PrimaryButton, 'Review Train Reservation');
    await tester.ensureVisible(reviewButton);
    await tester.tap(reviewButton);
    await tester.pumpAndSettle();

    // Verify Review Modal
    expect(find.text('Review Train Reservation'), findsWidgets);
    expect(find.text('IRCTC Service Charge'), findsOneWidget);

    // Tap Proceed to Pay
    final payButton = find.byWidgetPredicate(
      (widget) => widget is PrimaryButton && widget.text.contains('Proceed to Pay'),
    );
    expect(payButton, findsOneWidget);
    await tester.ensureVisible(payButton);
    await tester.tap(payButton);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 500));

    // Verify on PaymentMPINVerificationScreen
    expect(find.byType(PaymentMPINVerificationScreen), findsOneWidget);
    expect(find.text('Enter 6-Digit MPIN'), findsOneWidget);
  });
}
