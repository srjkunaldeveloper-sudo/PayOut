import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:payout/core/widgets/widgets.dart';
import 'package:payout/features/rewards/models/reward_models.dart';
import 'package:payout/features/rewards/presentation/scratch_card_screen.dart';
import 'package:payout/features/rewards/repositories/reward_repository.dart';

void main() {
  testWidgets('ScratchCardScreen handles interactive scratch reveal and cashback claiming', (WidgetTester tester) async {
    final mockRepo = MockRewardRepository();
    const card = ScratchCardModel(
      id: 'SCR-201',
      title: 'Weekend Mystery Scratch',
      description: 'Earned on merchant store payment',
      rewardValue: 75.0,
      status: 'UNSCRATCHED',
      expiresAt: '25 Aug 2026',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: ScratchCardScreen(
          card: card,
          rewardRepository: mockRepo,
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify initial screen elements
    expect(find.text('Mystery Scratch Card'), findsOneWidget);
    expect(find.text('Weekend Mystery Scratch'), findsOneWidget);
    expect(find.text('TAP TO SCRATCH'), findsOneWidget);
    expect(find.text('Scratch & Claim Reward'), findsOneWidget);

    // Tap Scratch & Claim Reward button
    final claimButton = find.widgetWithText(PrimaryButton, 'Scratch & Claim Reward');
    await tester.tap(claimButton);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 700));
    await tester.pumpAndSettle();

    // Verify Revealed State
    expect(find.text('YOU WON CASHBACK'), findsOneWidget);
    expect(find.text('₹75'), findsOneWidget);
    expect(find.text('CREDITED TO WALLET'), findsOneWidget);
    expect(find.text('Done & Back to Rewards'), findsOneWidget);
  });
}
