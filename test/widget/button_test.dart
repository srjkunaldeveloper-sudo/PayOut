import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:payout/core/widgets/widgets.dart';

void main() {
  testWidgets('PrimaryButton renders label content correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PrimaryButton(
            text: 'Submit Transfer',
            onPressed: () {},
          ),
        ),
      ),
    );

    expect(find.text('Submit Transfer'), findsOneWidget);
  });
}
