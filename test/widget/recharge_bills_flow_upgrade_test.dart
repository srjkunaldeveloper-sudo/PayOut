import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:payout/core/widgets/widgets.dart';
import 'package:payout/features/recharge/presentation/recharge_screen.dart';
import 'package:payout/features/bills/presentation/bills_screen.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({'mpin': '123456'});
  });

  testWidgets('Mobile Recharge flow validation, operator grid, and plan selector reviews', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: RechargeScreen(),
      ),
    );

    // Initial load check
    expect(find.text('Enter Mobile Number'), findsOneWidget);
    expect(find.text('Favorites'), findsOneWidget);

    // Enter valid 10-digit mobile number
    await tester.enterText(find.byType(TextFormField), '9876543210');
    await tester.pump();

    // Tap proceed to operator selection
    await tester.tap(find.widgetWithText(PrimaryButton, 'Proceed to Operators'));
    await tester.pumpAndSettle();

    // Select Operator Screen
    expect(find.text('Select Operator'), findsOneWidget);
    expect(find.text('Jio Prepaid'), findsOneWidget);

    // Select Jio
    await tester.tap(find.text('Jio Prepaid'));
    await tester.pumpAndSettle();

    // Plan Selection Screen - Wait for Mock delay
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    expect(find.text('Select Plan'), findsOneWidget);
    expect(find.text('Validity: 28 Days'), findsAtLeast(1));

    // Tap first plan to trigger BottomSheet details
    await tester.tap(find.text('Validity: 28 Days').first);
    await tester.pumpAndSettle();

    // BottomSheet open
    expect(find.text('Plan Benefits'), findsOneWidget);

    // Tap continue inside BottomSheet
    await tester.tap(find.widgetWithText(PrimaryButton, 'Continue'));
    await tester.pumpAndSettle();

    // Review Screen
    expect(find.text('Review Recharge'), findsOneWidget);
  });

  testWidgets('Bills category grid, biller selector, consumer input, and details fetch reviews', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: BillsScreen(),
      ),
    );

    // Wait for Mock due bills load delay
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    // Check categories
    expect(find.text('Bills & Utilities'), findsOneWidget);

    // Scroll down to bring categories grid into view
    await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -400));
    await tester.pumpAndSettle();

    // Tap Electricity
    await tester.tap(find.text('Electricity'));
    await tester.pumpAndSettle();

    // Consumer Number Screen
    expect(find.text('Select Biller / Provider'), findsOneWidget);

    // Enter consumer number
    await tester.enterText(find.byType(TextFormField), '542019382');
    await tester.pump();

    await tester.tap(find.widgetWithText(PrimaryButton, 'Fetch Bill'));
    await tester.pumpAndSettle();

    // Wait for Mock fetch bill delay
    await tester.pump(const Duration(milliseconds: 800));
    await tester.pumpAndSettle();

    // Bill Details Screen
    expect(find.text('Bill Details'), findsOneWidget);
    expect(find.text('Account Details'), findsOneWidget);
    expect(find.text('Rahul Sharma'), findsOneWidget);

    // Scroll down to bring Continue to Pay into view
    await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -300));
    await tester.pumpAndSettle();

    // Tap Continue to Pay
    await tester.tap(find.widgetWithText(PrimaryButton, 'Continue to Pay'));
    await tester.pumpAndSettle();

    // Review Bill Screen
    expect(find.text('Review Bill Payment'), findsOneWidget);
  });
}
