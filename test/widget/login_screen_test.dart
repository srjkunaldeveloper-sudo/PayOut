import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:payout/features/auth/presentation/create_password_screen.dart';
import 'package:payout/features/auth/presentation/existing_user_login_screen.dart';
import 'package:payout/features/auth/presentation/login_screen.dart';
import 'package:payout/features/auth/repositories/auth_repository.dart';

void main() {
  testWidgets('LoginScreen renders clickable policy text links', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: LoginScreen(authRepository: MockAuthRepository()),
      ),
    );

    // Verify policy text links are visible
    final richTextFinder = find.byWidgetPredicate(
      (widget) => widget is RichText && widget.text.toPlainText().contains('Privacy Policy'),
    );
    expect(richTextFinder, findsOneWidget);
  });

  testWidgets('LoginScreen enters email and navigates directly to CreatePasswordScreen', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final mockRepo = MockAuthRepository();

    await tester.pumpWidget(
      MaterialApp(
        home: LoginScreen(authRepository: mockRepo),
      ),
    );

    // Find email field
    final emailField = find.widgetWithText(TextField, 'name@example.com');
    expect(emailField, findsOneWidget);

    // Enter email
    await tester.enterText(emailField, 'newuser@payout.com');
    await tester.pumpAndSettle();

    // Tap Continue button
    final continueButton = find.text('Continue');
    expect(continueButton, findsOneWidget);
    await tester.tap(continueButton);
    await tester.pumpAndSettle();

    // Verify CreatePasswordScreen is shown
    expect(find.byType(CreatePasswordScreen), findsOneWidget);
    expect(find.text('Create Password'), findsOneWidget);
  });

  testWidgets('LoginScreen navigates to ExistingUserLoginScreen when tapping Login text link', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final mockRepo = MockAuthRepository();

    await tester.pumpWidget(
      MaterialApp(
        home: LoginScreen(authRepository: mockRepo),
      ),
    );

    final richTextFinder = find.byWidgetPredicate(
      (widget) => widget is RichText && widget.text.toPlainText().contains('Already have an account? Login'),
    );
    expect(richTextFinder, findsOneWidget);

    final richText = tester.widget<RichText>(richTextFinder);
    final textSpan = richText.text as TextSpan;
    final loginSpan = textSpan.children!.firstWhere(
      (span) => span is TextSpan && span.text == 'Login',
    ) as TextSpan;

    (loginSpan.recognizer as TapGestureRecognizer).onTap!();
    await tester.pumpAndSettle();

    expect(find.byType(ExistingUserLoginScreen), findsOneWidget);
  });
}
