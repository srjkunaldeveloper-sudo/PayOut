import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:payout/core/widgets/widgets.dart';
import 'package:payout/features/transactions/presentation/transaction_history_screen.dart';

void main() {
  testWidgets('Transaction history renders categories, search filtering, and detail navigation', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: TransactionHistoryScreen(),
      ),
    );

    // Initial load check
    expect(find.text('Transaction History'), findsOneWidget);

    // Wait for Mock async fetch
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();

    // Check categories chips
    expect(find.text('All'), findsOneWidget);
    expect(find.text('Sent'), findsOneWidget);
    expect(find.text('Received'), findsOneWidget);
    expect(find.text('QR Payments'), findsOneWidget);

    // Search query test
    await tester.enterText(find.byType(TextField), 'Starbucks');
    await tester.pumpAndSettle();

    expect(find.text('Starbucks Coffee'), findsOneWidget);

    // Clear search
    await tester.enterText(find.byType(TextField), '');
    await tester.pumpAndSettle();

    // Tap first transaction tile
    await tester.tap(find.byType(TransactionTile).first);
    await tester.pumpAndSettle();

    // Transaction Detail Screen
    expect(find.text('Transaction Details'), findsOneWidget);
    expect(find.text('Payment Source'), findsOneWidget);
    expect(find.text('UTR Number'), findsOneWidget);
    expect(find.text('Done'), findsOneWidget);
  });
}
