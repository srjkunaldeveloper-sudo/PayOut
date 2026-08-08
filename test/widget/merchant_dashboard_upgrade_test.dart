import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:payout/features/merchant/presentation/merchant_screen.dart';
import 'package:payout/features/merchant/presentation/merchant_profile_screen.dart';
import 'package:payout/features/merchant/presentation/merchant_transactions_screen.dart';
import 'package:payout/features/merchant/repositories/merchant_repository.dart';

void main() {
  testWidgets('MerchantScreen renders sales dashboard, quick actions, and navigates to profile and transactions', (WidgetTester tester) async {
    final mockRepo = MockMerchantRepository();

    await tester.pumpWidget(
      MaterialApp(
        home: MerchantScreen(merchantRepository: mockRepo),
      ),
    );

    // Initial loading and data settling
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();

    // Verify Business Console Dashboard
    expect(find.text('Business Console'), findsOneWidget);
    expect(find.text("Today's Store Sales"), findsOneWidget);
    expect(find.text('Settlement Balance'), findsOneWidget);
    expect(find.textContaining('Instant Sweep'), findsWidgets);
    expect(find.text('Merchant Actions'), findsOneWidget);

    // Verify Quick Actions
    expect(find.text('Store Static QR Code'), findsOneWidget);
    expect(find.text('Store Transactions'), findsOneWidget);
    expect(find.text('Business Profile'), findsOneWidget);
    expect(find.text('Settlement History'), findsOneWidget);

    // Tap Business Profile
    await tester.ensureVisible(find.text('Business Profile'));
    await tester.tap(find.text('Business Profile'));
    await tester.pumpAndSettle();

    // Verify MerchantProfileScreen
    expect(find.byType(MerchantProfileScreen), findsOneWidget);
    expect(find.text('Store Information'), findsOneWidget);
    expect(find.text('Tax & KYC Compliance'), findsOneWidget);
    expect(find.text('GSTIN'), findsOneWidget);

    // Pop back to Merchant Dashboard
    Navigator.pop(tester.element(find.byType(MerchantProfileScreen)));
    await tester.pumpAndSettle();

    // Tap Store Transactions
    await tester.ensureVisible(find.text('Store Transactions'));
    await tester.tap(find.text('Store Transactions'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();

    // Verify MerchantTransactionsScreen
    expect(find.byType(MerchantTransactionsScreen), findsOneWidget);
    expect(find.text('Aarav Sharma'), findsOneWidget);
    expect(find.text('Priya Patel'), findsOneWidget);
  });
}
