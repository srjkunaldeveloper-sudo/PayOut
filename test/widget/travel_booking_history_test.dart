import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:payout/core/widgets/widgets.dart';
import 'package:payout/features/travel/presentation/my_bookings_screen.dart';

void main() {
  testWidgets('MyBookingsScreen renders tabs, displays details modal, and handles dummy cancellation with refund estimate', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MyBookingsScreen(),
      ),
    );

    // Initial load
    expect(find.text('My Bookings'), findsOneWidget);
    expect(find.text('Upcoming'), findsOneWidget);
    expect(find.text('Completed'), findsOneWidget);
    expect(find.text('Cancelled'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    // Verify Active Bookings list
    expect(find.textContaining('IndiGo'), findsWidgets);
    expect(find.textContaining('Oppenheimer'), findsWidgets);
    expect(find.textContaining('Taj Palace'), findsWidgets);

    // Tap first booking card
    await tester.tap(find.textContaining('IndiGo').first);
    await tester.pumpAndSettle();

    // Verify Booking Details Modal
    expect(find.text('Flight Booking Details'), findsOneWidget);
    expect(find.text('Cancel Booking'), findsOneWidget);

    // Tap Cancel Booking
    await tester.tap(find.text('Cancel Booking'));
    await tester.pumpAndSettle();

    // Verify Cancellation Modal & Demo Refund Estimate
    expect(find.text('Confirm Cancellation'), findsWidgets);
    expect(find.text('Demo Refund Estimate'), findsOneWidget);
    expect(find.text('Cancellation Charges'), findsOneWidget);

    // Confirm Cancellation
    final confirmBtn = find.widgetWithText(PrimaryButton, 'Confirm Cancellation');
    await tester.tap(confirmBtn);
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    // Verify SnackBar confirmation
    expect(find.text('Booking cancelled successfully. Demo refund initiated.'), findsOneWidget);

    // Switch to Cancelled tab
    await tester.tap(find.text('Cancelled'));
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    // Verify cancelled booking listed
    expect(find.textContaining('IndiGo'), findsWidgets);
    expect(find.text('CANCELLED'), findsWidgets);
  });
}
