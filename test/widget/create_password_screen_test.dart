import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:payout/features/auth/models/auth_models.dart';
import 'package:payout/features/auth/presentation/create_password_screen.dart';
import 'package:payout/features/auth/presentation/mpin_screen.dart';
import 'package:payout/features/auth/repositories/auth_repository.dart';

void main() {
  testWidgets('CreatePasswordScreen validates requirements and transitions to MPIN', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final mockRepo = MockAuthRepository(
      initialUser: const UserModel(
        id: 'USR-STABLE-PHONE-UID',
        name: 'Phone User',
        phone: '+91 9876543210',
      ),
    );

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

    // Verify transition to MPINScreen
    expect(find.byType(MPINScreen), findsOneWidget);

    // Verify SAME stable UID was preserved and email was linked
    expect(mockRepo.currentUser?.id, equals('USR-STABLE-PHONE-UID'));
    expect(mockRepo.currentUser?.email, equals('test@example.com'));
  });
}
