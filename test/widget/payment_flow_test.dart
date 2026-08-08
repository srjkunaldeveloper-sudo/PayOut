import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:payout/features/payments/presentation/payment_pending_screen.dart';

void main() {
  testWidgets('PaymentPendingScreen renders and starts payment pipeline', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: PaymentPendingScreen(
          recipientName: 'HDFC Bank',
          recipientDetail: 'hdfc@okaxis',
          recipientType: 'UPI',
          amount: 2222.0,
          note: 'Rent payment',
        ),
      ),
    );

    expect(find.text('Processing Payment...'), findsOneWidget);
    expect(find.text('₹2222.00'), findsOneWidget);

    // Wait for the mock timer to resolve (1.5 seconds)
    await tester.pumpAndSettle(const Duration(seconds: 2));
  });
}
