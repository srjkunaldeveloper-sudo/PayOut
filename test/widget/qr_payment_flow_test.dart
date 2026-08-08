import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:payout/core/widgets/widgets.dart';
import 'package:payout/features/qr/presentation/scan_qr_screen.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({'mpin': '123456'});
  });

  testWidgets('QR scanner renders frame, handles demo scenario selection and verification', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ScanQRScreen(),
      ),
    );

    // Initial load check
    expect(find.text('Scan QR Code'), findsOneWidget);
    expect(find.text('Align QR code inside the frame to scan'), findsOneWidget);

    // Wait for auto-resolution of SRJ Foods
    await tester.pump(const Duration(milliseconds: 700));
    await tester.pump(const Duration(milliseconds: 300));

    // Verify SRJ Foods is resolved
    expect(find.text('SRJ Foods'), findsOneWidget);
    expect(find.text('Verified'), findsOneWidget);

    // Open Demo QR Scenarios sheet
    await tester.tap(find.text('Demo QR'));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Select Demo QR Scenario'), findsOneWidget);
    expect(find.byKey(const Key('demo_invalid')), findsOneWidget);

    // Select Invalid QR Code
    await tester.tap(find.byKey(const Key('demo_invalid')));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump(const Duration(milliseconds: 300));

    // Wait for resolution and modal presentation
    await tester.pump(const Duration(milliseconds: 700));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump(const Duration(milliseconds: 300));

    // Verify Error Modal
    expect(find.text('QR Code Not Supported'), findsOneWidget);
    expect(find.text('Scan Again'), findsOneWidget);

    // Tap Scan Again
    await tester.tap(find.widgetWithText(PrimaryButton, 'Scan Again'));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump(const Duration(milliseconds: 300));

    // Open Demo QR again and select Expired QR
    await tester.tap(find.text('Demo QR'));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump(const Duration(milliseconds: 300));

    await tester.tap(find.byKey(const Key('demo_expired')));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump(const Duration(milliseconds: 300));

    await tester.pump(const Duration(milliseconds: 700));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('QR Code Expired'), findsOneWidget);

    // Tap Scan Again
    await tester.tap(find.widgetWithText(PrimaryButton, 'Scan Again'));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump(const Duration(milliseconds: 300));

    // Open Demo QR and select Valid Personal QR
    await tester.tap(find.text('Demo QR'));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump(const Duration(milliseconds: 300));

    await tester.tap(find.byKey(const Key('demo_personal')));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump(const Duration(milliseconds: 300));

    await tester.pump(const Duration(milliseconds: 700));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Rahul Sharma'), findsOneWidget);

    // Tap Continue to Pay
    await tester.tap(find.widgetWithText(PrimaryButton, 'Continue to Pay'));
    await tester.pumpAndSettle();

    // Verified navigated to Amount Entry
    expect(find.text('Enter Amount'), findsOneWidget);
    expect(find.text('Rahul Sharma'), findsOneWidget);
  });
}
