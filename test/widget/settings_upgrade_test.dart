import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:payout/core/widgets/widgets.dart';
import 'package:payout/features/user/presentation/settings_screen.dart';

void main() {
  testWidgets('Settings screen renders categories, preference switches, and logout modal', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SettingsScreen(),
      ),
    );

    // Initial load check
    expect(find.text('Settings & Security'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();

    // Verify sections
    expect(find.text('Account'), findsOneWidget);
    expect(find.text('Security & Access'), findsOneWidget);
    expect(find.text('Notifications & Alerts'), findsOneWidget);
    expect(find.text('App Preferences'), findsOneWidget);
    expect(find.text('Support & Legal'), findsOneWidget);

    // Ensure Logout is visible and tap
    final logoutTile = find.text('Logout');
    await tester.ensureVisible(logoutTile);
    await tester.tap(logoutTile);
    await tester.pumpAndSettle();

    // Verify confirmation modal
    expect(find.text('Confirm Logout'), findsOneWidget);
    expect(find.text('Are you sure you want to log out of your Payout account?'), findsOneWidget);

    // Tap Cancel
    await tester.tap(find.widgetWithText(OutlinedButtonV2, 'Cancel'));
    await tester.pumpAndSettle();

    // Still on Settings
    expect(find.text('Settings & Security'), findsOneWidget);
  });
}
