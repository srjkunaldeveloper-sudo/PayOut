import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:payout/features/auth/presentation/create_password_screen.dart';
import 'package:payout/features/auth/repositories/auth_repository.dart';
import 'package:payout/features/dashboard/presentation/dashboard_shell.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('CreatePasswordScreen validates requirements, registers user, and transitions to DashboardShell', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.binding.setSurfaceSize(const Size(800, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final mockRepo = MockAuthRepository();

    await tester.pumpWidget(
      MaterialApp(
        home: CreatePasswordScreen(
          email: 'test@example.com',
          authRepository: mockRepo,
        ),
      ),
    );

    // Verify initial screen elements
    expect(find.text('Create Password'), findsOneWidget);
    expect(find.text('Create a strong password to secure your account.'), findsOneWidget);
    expect(find.text('Password must contain:'), findsOneWidget);
    expect(find.text('8+ characters'), findsOneWidget);
    expect(find.text('One uppercase letter'), findsOneWidget);
    expect(find.text('One number'), findsOneWidget);

    // Find input fields
    final passwordField = find.widgetWithText(TextField, 'Enter your password');
    final confirmPasswordField = find.widgetWithText(TextField, 'Re-enter your password');

    // Type weak password
    await tester.enterText(passwordField, 'short');
    await tester.pumpAndSettle();

    // Type mismatching confirm password
    await tester.enterText(confirmPasswordField, 'different');
    await tester.pumpAndSettle();

    expect(find.text('Passwords do not match'), findsOneWidget);

    // Type valid password
    await tester.enterText(passwordField, 'Password123');
    await tester.enterText(confirmPasswordField, 'Password123');
    await tester.pumpAndSettle();

    // Passwords match and requirements satisfied
    expect(find.text('Passwords do not match'), findsNothing);

    // Tap Continue button
    final continueButton = find.text('Continue');
    await tester.tap(continueButton);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    // Verify transition to DashboardShell (Home)
    expect(find.byType(DashboardShell), findsOneWidget);

    // Verify user was registered with email and stable UID
    expect(mockRepo.currentUser, isNotNull);
    expect(mockRepo.currentUser?.email, equals('test@example.com'));
  });
}
