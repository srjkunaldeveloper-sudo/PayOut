import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:payout/core/widgets/widgets.dart';
import 'package:payout/features/payments/presentation/mpin_verification_screen.dart';
import 'package:payout/features/travel/presentation/movie_flow.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({'mpin': '123456'});
  });

  testWidgets('Movie booking flow: movie discovery, city selection, theatre & show selection, cinema seat map, ticket review and MPIN checkout', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MovieHomeScreen(),
      ),
    );

    // Initial load
    expect(find.text('District Movies'), findsOneWidget);
    expect(find.text('Now Showing'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();

    // Verify Movies Catalog
    expect(find.text('Oppenheimer'), findsOneWidget);
    expect(find.text('Dune: Part Two'), findsOneWidget);

    // Tap Book Tickets on first movie
    final bookButtons = find.widgetWithText(PrimaryButton, 'Book Tickets');
    await tester.tap(bookButtons.first);
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();

    // Verify Movie Detail Screen
    expect(find.text('Available Formats'), findsOneWidget);
    expect(find.text('Select Theatre & Showtimes (Delhi)'), findsOneWidget);

    // Tap Select Theatre & Showtimes
    final selectTheatreBtn = find.widgetWithText(PrimaryButton, 'Select Theatre & Showtimes (Delhi)');
    await tester.tap(selectTheatreBtn);
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();

    // Verify Showtime Selection Screen
    expect(find.text('Today'), findsOneWidget);
    expect(find.text('PVR INOX Director\'s Cut'), findsOneWidget);
    expect(find.text('11:15 AM'), findsWidgets);

    // Tap First Showtime
    await tester.tap(find.text('11:15 AM').first);
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();

    // Verify Cinema Seat Map Screen
    expect(find.text('SCREEN THIS WAY'), findsOneWidget);
    expect(find.text('Select Seats'), findsOneWidget);

    // Tap Seat 1 in Row A (A1)
    await tester.tap(find.text('1').first);
    await tester.pumpAndSettle();

    // Tap Pay Button
    final payBtn = find.widgetWithText(PrimaryButton, 'Pay ₹479.50');
    expect(payBtn, findsOneWidget);
    await tester.tap(payBtn);
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();

    // Verify Ticket Review Screen
    expect(find.text('Review Movie Tickets'), findsOneWidget);
    expect(find.text('PVR INOX Director\'s Cut • IMAX 3D'), findsOneWidget);

    // Fill Contact Details
    final nameField = find.widgetWithText(AppTextField, 'Primary Contact Name');
    await tester.enterText(nameField, 'Rahul Sharma');

    final mobileField = find.widgetWithText(AppTextField, 'Mobile Number for SMS Ticket');
    await tester.enterText(mobileField, '9876543210');

    final emailField = find.widgetWithText(AppTextField, 'Email for E-Ticket');
    await tester.enterText(emailField, 'rahul.sharma@example.com');
    await tester.pumpAndSettle();

    // Tap Authorize Payment
    final authBtn = find.widgetWithText(PrimaryButton, 'Authorize Payment (6-Digit MPIN)');
    await tester.ensureVisible(authBtn);
    await tester.tap(authBtn);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 500));

    // Verify on PaymentMPINVerificationScreen
    expect(find.byType(PaymentMPINVerificationScreen), findsOneWidget);
    expect(find.text('Enter 6-Digit MPIN'), findsOneWidget);
    expect(find.textContaining('PVR INOX'), findsOneWidget);
  });
}
