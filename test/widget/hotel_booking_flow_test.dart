import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:payout/core/widgets/widgets.dart';
import 'package:payout/features/payments/presentation/mpin_verification_screen.dart';
import 'package:payout/features/travel/presentation/hotel_flow.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({'mpin': '123456'});
  });

  testWidgets('Hotel booking flow: search destination, filter hotels, room selection, guest form, review and MPIN checkout', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: HotelSearchScreen(),
      ),
    );

    // Initial search screen verification
    expect(find.text('Hotel Stays & Resorts'), findsOneWidget);
    expect(find.text('Search Hotels'), findsOneWidget);

    // Enter Destination City
    final cityField = find.widgetWithText(AppTextField, 'City / Destination / Area');
    await tester.enterText(cityField, 'New Delhi');
    await tester.pumpAndSettle();

    // Tap Search Hotels
    final searchButton = find.widgetWithText(PrimaryButton, 'Search Hotels');
    await tester.ensureVisible(searchButton);
    await tester.tap(searchButton);
    await tester.pumpAndSettle();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    // Verify Results Screen
    expect(find.text('Hotels in New Delhi'), findsOneWidget);
    expect(find.text('Taj Palace Luxury Stays & Resort'), findsOneWidget);

    // Tap Select Room on first hotel
    final selectRoomButtons = find.widgetWithText(PrimaryButton, 'Select Room');
    await tester.tap(selectRoomButtons.first);
    await tester.pumpAndSettle();

    // Verify Guest Details Screen
    expect(find.text('Guest Details'), findsOneWidget);
    expect(find.text('Lead Guest Information'), findsOneWidget);

    // Fill Guest Info
    final nameField = find.widgetWithText(AppTextField, 'Primary Guest Name');
    await tester.enterText(nameField, 'Rahul Sharma');

    final mobileField = find.widgetWithText(AppTextField, 'Mobile Number');
    await tester.enterText(mobileField, '9876543210');

    final emailField = find.widgetWithText(AppTextField, 'Email Address');
    await tester.enterText(emailField, 'rahul.sharma@example.com');
    await tester.pumpAndSettle();

    // Tap Review Hotel Reservation
    final reviewButton = find.widgetWithText(PrimaryButton, 'Review Hotel Reservation');
    await tester.ensureVisible(reviewButton);
    await tester.tap(reviewButton);
    await tester.pumpAndSettle();

    // Verify Review Modal
    expect(find.text('Review Hotel Reservation'), findsWidgets);
    expect(find.text('Taj Palace Luxury Stays & Resort'), findsWidgets);

    // Tap Proceed to Pay
    final payButton = find.widgetWithText(PrimaryButton, 'Proceed to Pay ₹27140.00');
    expect(payButton, findsOneWidget);
    await tester.ensureVisible(payButton);
    await tester.tap(payButton);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 500));

    // Verify on PaymentMPINVerificationScreen
    expect(find.byType(PaymentMPINVerificationScreen), findsOneWidget);
    expect(find.text('Enter 6-Digit MPIN'), findsOneWidget);
    expect(find.textContaining('Taj Palace'), findsOneWidget);
  });
}
