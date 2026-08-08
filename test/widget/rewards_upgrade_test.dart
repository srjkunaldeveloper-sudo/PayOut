import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:payout/features/rewards/presentation/rewards_screen.dart';
import 'package:payout/features/rewards/presentation/cashback_history_screen.dart';
import 'package:payout/features/rewards/repositories/reward_repository.dart';

void main() {
  testWidgets('RewardsScreen renders cashback summary, scratch cards, coupons, and navigates to cashback history', (WidgetTester tester) async {
    final mockRepo = MockRewardRepository();

    await tester.pumpWidget(
      MaterialApp(
        home: RewardsScreen(rewardRepository: mockRepo),
      ),
    );

    // Initial loading and data settling
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();

    // Verify Rewards Screen Dashboard
    expect(find.text('Rewards & Cashback'), findsOneWidget);
    expect(find.text('Lifetime Cashback Earned'), findsOneWidget);
    expect(find.text('Mystery Scratch Cards'), findsOneWidget);
    expect(find.text('My Active Coupons'), findsOneWidget);
    expect(find.text('Recent Cashback History'), findsOneWidget);

    // Verify Scratch Cards Carousel
    expect(find.text('SCRATCH'), findsWidgets);

    // Verify Coupons
    expect(find.textContaining('SWIGGY100'), findsWidgets);
    expect(find.textContaining('MYNTRA20'), findsWidgets);

    // Tap History link in Hero Card
    await tester.tap(find.text('History'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();

    // Verify CashbackHistoryScreen
    expect(find.byType(CashbackHistoryScreen), findsOneWidget);
    expect(find.text('Cashback History'), findsOneWidget);
    expect(find.text('Merchant QR Payment at SRJ Foods'), findsOneWidget);
  });
}
