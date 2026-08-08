import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:payout/features/auth/presentation/login_screen.dart';

void main() {
  testWidgets('LoginScreen renders clickable policy text links', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: LoginScreen(),
      ),
    );

    // Verify policy text links are visible
    final richTextFinder = find.byWidgetPredicate(
      (widget) => widget is RichText && widget.text.toPlainText().contains('Privacy Policy'),
    );
    expect(richTextFinder, findsOneWidget);
  });
}
