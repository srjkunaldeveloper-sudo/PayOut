import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:payout/core/widgets/widgets.dart';
import 'package:payout/features/user/presentation/profile_screen.dart';

void main() {
  testWidgets('Profile screen renders user overview and handles edit profile updates', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ProfileScreen(),
      ),
    );

    // Initial load check
    expect(find.text('My Profile'), findsOneWidget);

    // Wait for Mock async fetch
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();

    // Verify user details
    expect(find.text('Rahul Sharma'), findsWidgets);
    expect(find.text('+91 9876543210'), findsOneWidget);
    expect(find.text('KYC Verified'), findsOneWidget);
    expect(find.text('Member Since'), findsOneWidget);

    // Tap Edit Personal Details
    await tester.tap(find.text('Edit Personal Details'));
    await tester.pumpAndSettle();

    // Verify Edit Profile Screen
    expect(find.text('Edit Profile'), findsOneWidget);
    expect(find.text('Full Name'), findsOneWidget);
    expect(find.text('Email Address'), findsOneWidget);

    // Enter updated name
    final nameField = find.widgetWithText(AppTextField, 'Full Name');
    await tester.enterText(nameField, 'Rahul Dev Sharma');
    await tester.pumpAndSettle();

    // Ensure Save Changes button is visible
    final saveButton = find.widgetWithText(PrimaryButton, 'Save Changes');
    await tester.ensureVisible(saveButton);
    await tester.tap(saveButton);
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();

    // Verify confirmation modal
    expect(find.text('Profile Updated'), findsOneWidget);

    // Tap Done
    await tester.tap(find.widgetWithText(PrimaryButton, 'Done'));
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();

    // Verify back on profile screen with updated name
    expect(find.text('Rahul Dev Sharma'), findsWidgets);
  });
}
