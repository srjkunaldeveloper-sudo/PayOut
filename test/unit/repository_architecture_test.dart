import 'package:flutter_test/flutter_test.dart';
import 'package:payout/core/config/app_config.dart';
import 'package:payout/core/di/app_dependencies.dart';
import 'package:payout/core/network/api_response.dart';
import 'package:payout/core/network/network_exception.dart';
import 'package:payout/features/auth/repositories/auth_repository.dart';
import 'package:payout/features/bank_accounts/repositories/bank_account_repository.dart';
import 'package:payout/features/bills/repositories/bill_repository.dart';
import 'package:payout/features/financial/shared/repositories/financial_repository.dart';
import 'package:payout/features/home/repositories/home_repository.dart';
import 'package:payout/features/merchant/repositories/merchant_repository.dart';
import 'package:payout/features/notifications/repositories/notification_repository.dart';
import 'package:payout/features/payments/repositories/payments_repository.dart';
import 'package:payout/features/qr/repositories/qr_repository.dart';
import 'package:payout/features/recharge/repositories/recharge_repository.dart';
import 'package:payout/features/rewards/repositories/reward_repository.dart';
import 'package:payout/features/transactions/repositories/transaction_repository.dart';
import 'package:payout/features/travel/shared/repositories/travel_repository.dart';
import 'package:payout/features/user/repositories/user_repository.dart';
import 'package:payout/features/wallet/repositories/wallet_repository.dart';

void main() {
  group('Phase 11 Core Architecture & DI Tests', () {
    setUp(() {
      AppDependencies.reset();
    });

    test('AppConfig provides centralized RepositoryMode and environment constants', () {
      expect(AppConfig.repositoryMode, equals(RepositoryMode.mock));
      expect(AppConfig.isDemoMode, isTrue);
      expect(AppConfig.apiBaseUrl, isNotEmpty);
      expect(AppConfig.connectTimeout.inSeconds, equals(15));
    });

    test('AppDependencies singleton instantiates and wires all domain repositories', () {
      final deps = AppDependencies.instance;

      expect(deps.authRepository, isA<AuthRepository>());
      expect(deps.userRepository, isA<UserRepository>());
      expect(deps.walletRepository, isA<WalletRepository>());
      expect(deps.transactionRepository, isA<TransactionRepository>());
      expect(deps.notificationRepository, isA<NotificationRepository>());
      expect(deps.paymentsRepository, isA<PaymentsRepository>());
      expect(deps.bankAccountRepository, isA<BankAccountRepository>());
      expect(deps.rechargeRepository, isA<RechargeRepository>());
      expect(deps.billRepository, isA<BillRepository>());
      expect(deps.qrRepository, isA<QrRepository>());
      expect(deps.financialRepository, isA<FinancialRepository>());
      expect(deps.travelRepository, isA<TravelRepository>());
      expect(deps.merchantRepository, isA<MerchantRepository>());
      expect(deps.rewardRepository, isA<RewardRepository>());
      expect(deps.homeRepository, isA<HomeRepository>());
    });

    test('AppDependencies allows custom repository overrides for testing and DI inversion', () {
      final customTxnRepo = MockTransactionRepository();
      final customNotifRepo = MockNotificationRepository();

      final customDeps = AppDependencies(
        transactionRepository: customTxnRepo,
        notificationRepository: customNotifRepo,
      );

      AppDependencies.setInstance(customDeps);

      expect(AppDependencies.instance.transactionRepository, same(customTxnRepo));
      expect(AppDependencies.instance.notificationRepository, same(customNotifRepo));
    });

    test('ApiResponse parses success and error payloads correctly', () {
      final successRes = ApiResponse<String>.success('data_payload', message: 'Success', statusCode: 200);
      expect(successRes.success, isTrue);
      expect(successRes.data, equals('data_payload'));
      expect(successRes.statusCode, equals(200));
      expect(successRes.hasData, isTrue);

      final errorRes = ApiResponse<String>.error('Unauthorized', statusCode: 401);
      expect(errorRes.success, isFalse);
      expect(errorRes.data, isNull);
      expect(errorRes.statusCode, equals(401));
      expect(errorRes.hasData, isFalse);
    });

    test('NetworkException categorizes HTTP status codes properly', () {
      final authErr = NetworkException.fromStatusCode(401, 'Invalid token');
      expect(authErr.type, equals(NetworkExceptionType.unauthorized));

      final notFoundErr = NetworkException.fromStatusCode(404, 'Not found');
      expect(notFoundErr.type, equals(NetworkExceptionType.notFound));

      final valErr = NetworkException.fromStatusCode(422, 'Validation failed');
      expect(valErr.type, equals(NetworkExceptionType.validationError));

      final serverErr = NetworkException.fromStatusCode(500, 'Internal server error');
      expect(serverErr.type, equals(NetworkExceptionType.serverError));
    });
  });
}
