import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:payout/core/widgets/states.dart';
import 'package:payout/features/wallet/models/wallet_models.dart';
import 'package:payout/features/wallet/presentation/wallet_screen.dart';
import 'package:payout/features/wallet/repositories/wallet_repository.dart';
import 'package:payout/features/notifications/models/notification_models.dart';
import 'package:payout/features/notifications/presentation/notifications_screen.dart';
import 'package:payout/features/notifications/repositories/notification_repository.dart';

class FailureMockWalletRepository extends MockWalletRepository {
  int callCount = 0;

  @override
  Future<WalletModel> getWallet() async {
    callCount++;
    throw Exception('Simulated wallet network error');
  }
}

class FailureMockNotificationRepository extends MockNotificationRepository {
  int callCount = 0;

  @override
  Future<List<NotificationModel>> getNotifications() async {
    callCount++;
    throw Exception('Simulated notifications server down');
  }
}

void main() {
  group('Standardized State & Retry Widget Tests', () {
    testWidgets('WalletScreen shows ErrorState and executes retry triggers on failure', (WidgetTester tester) async {
      final failRepo = FailureMockWalletRepository();

      await tester.pumpWidget(
        MaterialApp(
          home: WalletScreen(walletRepository: failRepo),
        ),
      );

      // Settle loading states
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpAndSettle();

      // Verify ErrorState is rendered
      expect(find.byType(ErrorState), findsOneWidget);
      expect(find.text('Simulated wallet network error'), findsOneWidget);

      final retryButton = find.text('Try Again');
      expect(retryButton, findsOneWidget);

      // Verify initial call count
      expect(failRepo.callCount, equals(1));

      // Tap Try Again and verify recall
      await tester.tap(retryButton);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpAndSettle();

      expect(failRepo.callCount, equals(2));
    });

    testWidgets('NotificationsScreen shows ErrorState and executes retry triggers on failure', (WidgetTester tester) async {
      final failRepo = FailureMockNotificationRepository();

      await tester.pumpWidget(
        MaterialApp(
          home: NotificationsScreen(notificationRepository: failRepo),
        ),
      );

      // Settle loading states
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpAndSettle();

      // Verify ErrorState is rendered
      expect(find.byType(ErrorState), findsOneWidget);
      expect(find.text('Simulated notifications server down'), findsOneWidget);

      final retryButton = find.text('Try Again');
      expect(retryButton, findsOneWidget);

      // Verify initial call count
      expect(failRepo.callCount, equals(1));

      // Tap Try Again and verify recall
      await tester.tap(retryButton);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpAndSettle();

      expect(failRepo.callCount, equals(2));
    });
  });
}
