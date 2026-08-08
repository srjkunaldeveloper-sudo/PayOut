import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:payout/core/widgets/widgets.dart';
import 'package:payout/features/payments/presentation/mpin_verification_screen.dart';
import 'package:payout/features/travel/presentation/bus_flow.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({'mpin': '123456'});
  });

  testWidgets('Bus booking flow: search, select bus, interactive seat selection, passenger info, review and MPIN checkout', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: BusSearchScreen(),
      ),
    );

    // Initial search screen verification
    expect(find.text('Book Bus Tickets'), findsOneWidget);
    expect(find.text('Search Buses'), findsOneWidget);

    // Enter Search Cities
    final textFields = find.byType(TextFormField);
    await tester.enterText(textFields.at(0), 'Delhi (Kashmere Gate)');
    await tester.enterText(textFields.at(1), 'Jaipur (Sindhi Camp)');
    await tester.pumpAndSettle();

    // Tap Search Buses
    final searchButton = find.widgetWithText(PrimaryButton, 'Search Buses');
    await tester.ensureVisible(searchButton);
    await tester.tap(searchButton);
    await tester.pumpAndSettle();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    // Verify Results Screen
    expect(find.textContaining('Zingbus'), findsWidgets);

    // Tap Select Seats on first bus
    final selectSeatsButton = find.widgetWithText(PrimaryButton, 'Select Seats');
    await tester.tap(selectSeatsButton.first);
    await tester.pumpAndSettle();

    // Verify Seat Map Screen
    expect(find.text('Available'), findsOneWidget);
    expect(find.text('Selected'), findsOneWidget);

    // Tap Seat 'A1'
    await tester.tap(find.text('A1'));
    await tester.pumpAndSettle();

    // Verify Continue button enabled with price
    final continueButton = find.widgetWithText(PrimaryButton, 'Continue');
    expect(continueButton, findsOneWidget);
    await tester.tap(continueButton);
    await tester.pumpAndSettle();

    // Verify Passenger Screen
    expect(find.text('Primary Passenger Name'), findsOneWidget);

    // Fill Passenger Details
    final passengerInputs = find.byType(TextFormField);
    await tester.enterText(passengerInputs.at(0), 'Rahul Sharma');
    await tester.enterText(passengerInputs.at(1), '26');
    await tester.enterText(passengerInputs.at(2), '9876543210');
    await tester.pumpAndSettle();

    // Tap Review Bus Ticket
    final reviewButton = find.widgetWithText(PrimaryButton, 'Review Bus Ticket');
    await tester.ensureVisible(reviewButton);
    await tester.tap(reviewButton);
    await tester.pumpAndSettle();

    // Verify Review Modal
    expect(find.text('Review Bus Ticket Booking'), findsWidgets);

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
