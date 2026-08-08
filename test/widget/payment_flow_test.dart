import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:payout/features/payments/presentation/payment_pending_screen.dart';

void main() {
  testWidgets('PaymentPendingScreen renders and checks status', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: PaymentPendingScreen(
          recipientName: 'HDFC Bank',
          recipientDetail: 'Checking •••• 5849',
          amount: 200.0,
          transactionId: 'PAY-12345',
          note: 'Rent payment',
        ),
      ),
    );

    expect(find.text('Payment Pending'), findsOneWidget);
    expect(find.text('₹200.00'), findsOneWidget);
    expect(find.text('Check Status'), findsOneWidget);

    await tester.tap(find.text('Check Status'), warnIfMissed: false);
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
  });
}
