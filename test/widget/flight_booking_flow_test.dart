import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:payout/core/widgets/widgets.dart';
import 'package:payout/features/payments/presentation/mpin_verification_screen.dart';
import 'package:payout/features/travel/presentation/flight_flow.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({'mpin': '123456'});
  });

  testWidgets('Flight booking flow: search, select flight, enter passenger, review and MPIN checkout', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: FlightSearchScreen(),
      ),
    );

    // Initial search screen verification
    expect(find.text('Book Flights'), findsOneWidget);
    expect(find.text('Search Flights'), findsOneWidget);

    // Enter Search Cities using TextFormField finders
    final textFields = find.byType(TextFormField);
    await tester.enterText(textFields.at(0), 'Delhi (DEL)');
    await tester.enterText(textFields.at(1), 'Mumbai (BOM)');
    await tester.pumpAndSettle();

    // Tap Search Flights
    final searchButton = find.widgetWithText(PrimaryButton, 'Search Flights');
    await tester.ensureVisible(searchButton);
    await tester.tap(searchButton);
    await tester.pumpAndSettle();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    // Verify Results Screen
    expect(find.text('Delhi (DEL) → Mumbai (BOM)'), findsOneWidget);
    expect(find.textContaining('IndiGo'), findsWidgets);

    // Tap Select Flight on first flight
    final selectButtons = find.widgetWithText(PrimaryButton, 'Select Flight');
    await tester.tap(selectButtons.first);
    await tester.pumpAndSettle();

    // Verify Passenger Details Screen
    expect(find.text('Passenger Details'), findsOneWidget);
    expect(find.text('Passenger Information'), findsOneWidget);

    // Fill Passenger Details Form
    final passengerInputs = find.byType(TextFormField);
    await tester.enterText(passengerInputs.at(0), 'Rahul Sharma');
    await tester.enterText(passengerInputs.at(1), '15/08/1995');
    await tester.enterText(passengerInputs.at(2), '9876543210');
    await tester.enterText(passengerInputs.at(3), 'rahul.sharma@example.com');
    await tester.pumpAndSettle();

    // Tap Review Flight Booking
    final reviewButton = find.widgetWithText(PrimaryButton, 'Review Flight Booking');
    await tester.ensureVisible(reviewButton);
    await tester.tap(reviewButton);
    await tester.pumpAndSettle();

    // Verify Review Modal
    expect(find.text('Review Flight Booking'), findsWidgets);

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
