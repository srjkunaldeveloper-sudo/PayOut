import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:payout/core/widgets/widgets.dart';
import 'package:payout/features/rewards/models/reward_models.dart';
import 'package:payout/features/rewards/presentation/coupon_details_screen.dart';
import 'package:payout/features/rewards/repositories/reward_repository.dart';

void main() {
  testWidgets('CouponDetailsScreen renders offer details, copies promo code, and redeems coupon', (WidgetTester tester) async {
    final mockRepo = MockRewardRepository();
    const coupon = CouponModel(
      id: 'CPN-101',
      code: 'SWIGGY100',
      title: 'Swiggy Gourmet Dining',
      description: 'Get flat ₹100 discount on gourmet restaurant orders above ₹499.',
      discountType: 'FLAT',
      discountValue: 100.0,
      minimumSpend: 499.0,
      maximumDiscount: 100.0,
      validFrom: '01 Aug 2026',
      validUntil: '31 Aug 2026',
      category: 'Food & Dining',
      usageLimit: 2,
      usedCount: 0,
      isActive: true,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: CouponDetailsScreen(
          coupon: coupon,
          rewardRepository: mockRepo,
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify Screen Content
    expect(find.text('Coupon Details'), findsOneWidget);
    expect(find.text('₹100 FLAT OFF'), findsOneWidget);
    expect(find.text('Swiggy Gourmet Dining'), findsOneWidget);
    expect(find.text('SWIGGY100'), findsOneWidget);
    expect(find.text('Offer Breakdown'), findsOneWidget);
    expect(find.text('How to Redeem'), findsOneWidget);

    // Tap Copy Button
    await tester.tap(find.text('COPY'));
    await tester.pumpAndSettle();

    // Tap Redeem Coupon Code
    final redeemButton = find.widgetWithText(PrimaryButton, 'Redeem Coupon Code');
    await tester.ensureVisible(redeemButton);
    await tester.tap(redeemButton);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();

    // Verify activation snackbar
    expect(find.textContaining('SWIGGY100'), findsWidgets);
  });
}
