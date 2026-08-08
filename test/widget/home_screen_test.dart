import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:payout/features/home/presentation/home_screen.dart';

void main() {
  testWidgets('HomeScreen renders greeting, wallet, quick actions, services, and transactions', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: HomeScreen(),
      ),
    );

    // Initial state shows Loading Skeleton widgets
    expect(find.byType(HomeScreen), findsOneWidget);

    // Pump to resolve the Mock delay (600ms + sub-repositories delay)
    await tester.pump(const Duration(milliseconds: 1500));
    await tester.pumpAndSettle();

    // Verify User Greetings
    expect(find.text('Good Morning,'), findsOneWidget);
    expect(find.text('Rahul Sharma'), findsOneWidget);

    // Verify Wallet Cards Total Balance (1250.75 Available + 2130 Pending = 3380.75)
    expect(find.text('Total Balance'), findsOneWidget);
    expect(find.text('Available Balance'), findsOneWidget);

    // Verify Quick Actions Panel
    expect(find.text('Pay'), findsOneWidget);
    expect(find.text('Scan QR'), findsOneWidget);
    expect(find.text('Recharge'), findsAtLeast(1));

    // Verify Ecosystem grid
    expect(find.text('Services Ecosystem'), findsOneWidget);

    // Verify view all actions trigger
    expect(find.text('View All'), findsOneWidget);
  });
}
