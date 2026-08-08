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

/// Central Dependency Injection & Composition Root for Payout application.
/// Manages instantiation and dependency wiring for all domain repositories.
class AppDependencies {
  static AppDependencies? _instance;

  final AuthRepository authRepository;
  final UserRepository userRepository;
  final WalletRepository walletRepository;
  final TransactionRepository transactionRepository;
  final NotificationRepository notificationRepository;
  final PaymentsRepository paymentsRepository;
  final BankAccountRepository bankAccountRepository;
  final RechargeRepository rechargeRepository;
  final BillRepository billRepository;
  final QrRepository qrRepository;
  final FinancialRepository financialRepository;
  final TravelRepository travelRepository;
  final MerchantRepository merchantRepository;
  final RewardRepository rewardRepository;
  final HomeRepository homeRepository;

  AppDependencies({
    AuthRepository? authRepository,
    UserRepository? userRepository,
    WalletRepository? walletRepository,
    TransactionRepository? transactionRepository,
    NotificationRepository? notificationRepository,
    PaymentsRepository? paymentsRepository,
    BankAccountRepository? bankAccountRepository,
    RechargeRepository? rechargeRepository,
    BillRepository? billRepository,
    QrRepository? qrRepository,
    FinancialRepository? financialRepository,
    TravelRepository? travelRepository,
    MerchantRepository? merchantRepository,
    RewardRepository? rewardRepository,
    HomeRepository? homeRepository,
  })  : transactionRepository = transactionRepository ?? MockTransactionRepository(),
        notificationRepository = notificationRepository ?? MockNotificationRepository(),
        userRepository = userRepository ?? MockUserRepository(),
        walletRepository = walletRepository ?? MockWalletRepository(),
        authRepository = authRepository ?? MockAuthRepository(),
        bankAccountRepository = bankAccountRepository ?? MockBankAccountRepository(),
        paymentsRepository = paymentsRepository ??
            MockPaymentsRepository(
              transactionRepository ?? MockTransactionRepository(),
              notificationRepository ?? MockNotificationRepository(),
            ),
        rechargeRepository = rechargeRepository ??
            MockRechargeRepository(
              transactionRepository ?? MockTransactionRepository(),
            ),
        billRepository = billRepository ??
            MockBillRepository(
              transactionRepository ?? MockTransactionRepository(),
            ),
        qrRepository = qrRepository ?? MockQrRepository(),
        financialRepository = financialRepository ??
            MockFinancialRepository(
              transactionRepository: transactionRepository ?? MockTransactionRepository(),
              notificationRepository: notificationRepository ?? MockNotificationRepository(),
              userRepository: userRepository ?? MockUserRepository(),
            ),
        travelRepository = travelRepository ??
            MockTravelRepository(
              transactionRepository: transactionRepository ?? MockTransactionRepository(),
              notificationRepository: notificationRepository ?? MockNotificationRepository(),
            ),
        merchantRepository = merchantRepository ??
            MockMerchantRepository(
              transactionRepository: transactionRepository ?? MockTransactionRepository(),
              notificationRepository: notificationRepository ?? MockNotificationRepository(),
            ),
        rewardRepository = rewardRepository ??
            MockRewardRepository(
              transactionRepository: transactionRepository ?? MockTransactionRepository(),
              notificationRepository: notificationRepository ?? MockNotificationRepository(),
            ),
        homeRepository = homeRepository ??
            MockHomeRepository(
              userRepository: userRepository ?? MockUserRepository(),
              walletRepository: walletRepository ?? MockWalletRepository(),
              transactionRepository: transactionRepository ?? MockTransactionRepository(),
              notificationRepository: notificationRepository ?? MockNotificationRepository(),
              rewardRepository: rewardRepository ?? MockRewardRepository(),
            );

  /// Default singleton instance
  static AppDependencies get instance {
    _instance ??= AppDependencies();
    return _instance!;
  }

  /// Override for testing or customized composition
  static void setInstance(AppDependencies dependencies) {
    _instance = dependencies;
  }

  /// Reset instance
  static void reset() {
    _instance = null;
  }
}
