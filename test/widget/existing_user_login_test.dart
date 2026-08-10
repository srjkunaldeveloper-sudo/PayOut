import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:payout/features/auth/presentation/existing_user_login_screen.dart';
import 'package:payout/features/auth/presentation/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:payout/features/auth/repositories/auth_repository.dart';

import 'package:payout/features/dashboard/presentation/dashboard_shell.dart';

void main() {
  testWidgets('LoginScreen navigates to ExistingUserLoginScreen on tapping Login', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        home: LoginScreen(authRepository: MockAuthRepository()),
      ),
    );

    // Verify "Already have an account? Login" is visible
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

    // Verify ExistingUserLoginScreen is shown
    expect(find.byType(ExistingUserLoginScreen), findsOneWidget);
  });

  testWidgets('ExistingUserLoginScreen validates credentials and routes directly to Home (DashboardShell)', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.binding.setSurfaceSize(const Size(800, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        home: ExistingUserLoginScreen(authRepository: MockAuthRepository()),
      ),
    );

    // Verify header and fields
    expect(find.text('Welcome '), findsOneWidget);
    expect(find.text('Back'), findsOneWidget);
    expect(find.text('Login to continue to your Payout account.'), findsOneWidget);
    expect(find.text('Email Address'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Forgot Password?'), findsOneWidget);

    final textFields = find.byType(TextField);
    expect(textFields, findsNWidgets(2));

    // Enter email & password
    await tester.enterText(textFields.at(0), 'kunal.singh@example.com');
    await tester.enterText(textFields.at(1), 'Secret123');
    await tester.pumpAndSettle();

    // Tap Login
    final loginButton = find.text('Login');
    await tester.tap(loginButton);
    await tester.pumpAndSettle();

    // Verify DashboardShell (Home) is reached directly
    expect(find.byType(DashboardShell), findsOneWidget);
  });
}
