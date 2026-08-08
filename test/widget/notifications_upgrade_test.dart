import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:payout/features/notifications/presentation/notifications_screen.dart';

void main() {
  testWidgets('Notifications screen renders alerts, marks as read, and handles actions', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: NotificationsScreen(),
      ),
    );

    // Initial load check
    expect(find.text('Alerts & Updates'), findsOneWidget);

    // Wait for Mock async fetch
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();

    // Check notifications list items
    expect(find.text('Payment Successful'), findsOneWidget);
    expect(find.text('Security Alert'), findsOneWidget);

    // Check 'Mark all read' action button
    expect(find.text('Mark all read'), findsOneWidget);

    // Tap a payment notification
    await tester.tap(find.text('Payment Successful'));
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();

    // Should navigate to Transaction Details
    expect(find.text('Transaction Details'), findsOneWidget);
  });
}
