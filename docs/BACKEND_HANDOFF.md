# Backend Handoff Specification

This document provides a comprehensive technical handoff for backend engineers, system architects, and API developers integrating production backend microservices into the **Payout** Flutter codebase.

---

## A. Architecture Overview

Payout is built following Clean Architecture with strict boundary separation:
- **Presentation Layer (`lib/features/*/presentation/`):** Pure UI widgets, view states, and page animations. Completely decoupled from HTTP clients and dummy storage.
- **Domain Layer (`lib/features/*/models/`, `validators/`, `services/`):** Pure domain models, regex validation rules, calculation engines, and formatting helpers.
- **Repository Interface Layer (`lib/features/*/repositories/`):** Strongly typed abstract contracts with explicit `// TODO(api)` annotations.
- **Data Layer (`Mock*Repository` / Future `Api*Repository`):** Data sourcing, API DTO serialization, latency simulation, and caching.
- **Central Composition Root (`lib/core/di/app_dependencies.dart`):** Central dependency resolver for repository instantiation and dependency injection.

---

## B. Repository Inventory

1. `AuthRepository` ([auth_repository.dart](file:///Users/macbook/StudioProjects/payout/lib/features/auth/repositories/auth_repository.dart))
2. `UserRepository` ([user_repository.dart](file:///Users/macbook/StudioProjects/payout/lib/features/user/repositories/user_repository.dart))
3. `WalletRepository` ([wallet_repository.dart](file:///Users/macbook/StudioProjects/payout/lib/features/wallet/repositories/wallet_repository.dart))
4. `PaymentsRepository` ([payments_repository.dart](file:///Users/macbook/StudioProjects/payout/lib/features/payments/repositories/payments_repository.dart))
5. `BankAccountRepository` ([bank_account_repository.dart](file:///Users/macbook/StudioProjects/payout/lib/features/bank_accounts/repositories/bank_account_repository.dart))
6. `TransactionRepository` ([transaction_repository.dart](file:///Users/macbook/StudioProjects/payout/lib/features/transactions/repositories/transaction_repository.dart))
7. `NotificationRepository` ([notification_repository.dart](file:///Users/macbook/StudioProjects/payout/lib/features/notifications/repositories/notification_repository.dart))
8. `RechargeRepository` ([recharge_repository.dart](file:///Users/macbook/StudioProjects/payout/lib/features/recharge/repositories/recharge_repository.dart))
9. `BillRepository` ([bill_repository.dart](file:///Users/macbook/StudioProjects/payout/lib/features/bills/repositories/bill_repository.dart))
10. `QrRepository` ([qr_repository.dart](file:///Users/macbook/StudioProjects/payout/lib/features/qr/repositories/qr_repository.dart))
11. `FinancialRepository` ([financial_repository.dart](file:///Users/macbook/StudioProjects/payout/lib/features/financial/shared/repositories/financial_repository.dart))
12. `TravelRepository` ([travel_repository.dart](file:///Users/macbook/StudioProjects/payout/lib/features/travel/shared/repositories/travel_repository.dart))
13. `MerchantRepository` ([merchant_repository.dart](file:///Users/macbook/StudioProjects/payout/lib/features/merchant/repositories/merchant_repository.dart))
14. `RewardRepository` ([reward_repository.dart](file:///Users/macbook/StudioProjects/payout/lib/features/rewards/repositories/reward_repository.dart))
15. `HomeRepository` ([home_repository.dart](file:///Users/macbook/StudioProjects/payout/lib/features/home/repositories/home_repository.dart))

---

## C. Mock → API Replacement Blueprint

To replace a mock repository with a real API repository:
1. Implement the corresponding `*Repository` interface in a new `Api*Repository` class.
2. Inject `ApiClient` into the constructor.
3. Parse HTTP responses into the domain models via `Model.fromJson(json)`.
4. Register the new repository in `AppDependencies` (`lib/core/di/app_dependencies.dart`).

---

## D. Endpoint Integration Locations

All repository interfaces contain standardized `// TODO(api)` annotations indicating the expected REST endpoint paths:
- **Auth:** `GET /auth/session`, `POST /auth/login`, `POST /auth/otp/request`, `POST /auth/otp/verify`, `POST /auth/mpin/setup`, `POST /auth/mpin/verify`
- **User & KYC:** `GET /user/profile`, `PUT /user/profile`, `POST /user/kyc/submit`, `GET /user/kyc/status`
- **Wallet:** `GET /wallet/balance`, `POST /wallet/add-money`, `POST /wallet/auto-add`
- **Payments:** `GET /beneficiaries`, `POST /beneficiaries`, `POST /payments/transfer`, `GET /payments/receipt/{id}`
- **Bank Accounts:** `GET /bank-accounts`, `POST /bank-accounts/link`, `DELETE /bank-accounts/{id}`
- **Transactions:** `GET /transactions`, `GET /transactions/{id}`, `GET /transactions/statement`
- **Notifications:** `GET /notifications`, `POST /notifications/{id}/read`, `DELETE /notifications/{id}`
- **Recharge & Bills:** `GET /recharge/plans`, `POST /recharge/execute`, `GET /bills/categories`, `POST /bills/fetch`, `POST /bills/pay`
- **QR:** `POST /qr/resolve`, `GET /qr/generate-static`
- **Financial Products:** `GET /loans/catalog`, `POST /loans/apply`, `GET /insurance/plans`, `POST /insurance/quote`, `POST /insurance/buy`, `GET /investments/funds`, `POST /investments/order`, `GET /portfolio`
- **Travel Ecosystem:** `POST /travel/flights/search`, `POST /travel/flights/book`, `POST /travel/trains/search`, `POST /travel/trains/book`, `POST /travel/buses/search`, `POST /travel/buses/book`, `POST /travel/hotels/search`, `POST /travel/hotels/book`, `POST /travel/movies/cinemas`, `POST /travel/movies/book`, `GET /travel/bookings`, `POST /travel/bookings/{id}/cancel`
- **Merchant Console:** `GET /merchant/profile`, `GET /merchant/sales-summary`, `GET /merchant/settlement-balance`, `GET /merchant/transactions`, `GET /merchant/settlements`, `POST /merchant/settlements`, `GET /merchant/offers`
- **Rewards & Cashback:** `GET /rewards/summary`, `GET /rewards/coupons`, `GET /rewards/scratch-cards`, `POST /rewards/scratch-cards/{id}/open`, `POST /rewards/coupons/{id}/redeem`, `GET /rewards/cashback`

---

## E. Authentication & Token Boundary

- `AuthInterceptor` ([auth_interceptor.dart](file:///Users/macbook/StudioProjects/payout/lib/core/network/auth_interceptor.dart)): Automatically attaches `Authorization: Bearer <accessToken>`.
- `SessionManager` ([session_manager.dart](file:///Users/macbook/StudioProjects/payout/features/auth/services/session_manager.dart)): Encapsulates memory and persistent token sessions.
- `DioClient` ([dio_client.dart](file:///Users/macbook/StudioProjects/payout/lib/core/network/dio_client.dart)): Manages base URLs, timeout policies, and interceptors.

---

## F. Error Handling Strategy

Network errors are mapped into typed `NetworkException` instances:
```dart
try {
  final response = await _apiClient.get('/path');
  return Model.fromJson(response.data);
} on DioException catch (e) {
  throw NetworkException.fromStatusCode(e.response?.statusCode, e.message ?? 'Unknown error');
}
```

---

## G. Environment Configuration

All environment toggles are centralized inside `AppConfig` ([app_config.dart](file:///Users/macbook/StudioProjects/payout/lib/core/config/app_config.dart)):
```dart
class AppConfig {
  static const RepositoryMode repositoryMode = RepositoryMode.api; // Switch between mock and api
  static const String apiBaseUrl = 'https://api.payout.app/v1';
}
```

---

## H. Files Backend Developers Should Modify vs. NOT Modify

### Files to Add / Modify
- `lib/features/*/repositories/api_*_repository.dart` (Add real API implementations)
- `lib/core/di/app_dependencies.dart` (Register API repositories)
- `lib/core/config/app_config.dart` (Configure base URLs and environment modes)

### Files to NOT Modify
- All Presentation Screens (`lib/features/*/presentation/`)
- Pure Domain Services (`lib/features/*/services/`)
- Input Validators (`lib/features/*/validators/`)
- Payment Engine (`PaymentMPINVerificationScreen`, `PaymentProcessingScreen`)

---

## I. Testing & Verification Checklist

- [ ] Run `flutter analyze` — verify 0 errors and 0 warnings.
- [ ] Run `flutter test` — verify all unit, service, and widget test suites pass.
- [ ] Verify offline demo mode works completely when `AppConfig.repositoryMode = RepositoryMode.mock`.
