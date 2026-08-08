# Backend Repository Handoff Map

This document outlines the complete domain repository matrix for the **Payout** application, mapping each domain contract to its current mock implementation, future API implementation, required dependencies, and developer touchpoints.

---

## 🗺️ Repository Matrix

| Domain Repository | Current Mock Implementation | Future API Implementation | Core Responsibilities | Backend Endpoint Categories | Dependencies | Files to Change for Backend | Files NOT to Touch |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **AuthRepository** | `MockAuthRepository` | `ApiAuthRepository` | Login, OTP generation, MPIN setup, Biometric auth, Session tokens | `/auth/login`, `/auth/otp/*`, `/auth/mpin/*` | None | `api_auth_repository.dart`, token storage | `auth_screen.dart`, `otp_screen.dart`, `mpin_setup_screen.dart` |
| **UserRepository** | `MockUserRepository` | `ApiUserRepository` | Profile retrieval, KYC verification, document uploads, settings | `/user/profile`, `/user/kyc/*`, `/user/preferences` | None | `api_user_repository.dart` | `profile_screen.dart`, `kyc_screen.dart`, `settings_screen.dart` |
| **WalletRepository** | `MockWalletRepository` | `ApiWalletRepository` | Balance tracking, wallet top-up, auto-add rules | `/wallet/balance`, `/wallet/topup`, `/wallet/auto-add` | `TransactionRepository`, `NotificationRepository` | `api_wallet_repository.dart` | `wallet_screen.dart`, `topup_bottom_sheet.dart` |
| **PaymentsRepository** | `MockPaymentsRepository` | `ApiPaymentsRepository` | P2P transfers, beneficiary management, bank payouts | `/payments/transfer`, `/beneficiaries/*` | `TransactionRepository`, `NotificationRepository` | `api_payments_repository.dart` | `payment_screen.dart`, `mpin_verification_screen.dart`, `payment_processing_screen.dart` |
| **BankAccountRepository** | `MockBankAccountRepository` | `ApiBankAccountRepository` | Bank linking, account verification, primary account toggle | `/bank-accounts/*`, `/bank-accounts/link` | None | `api_bank_account_repository.dart` | `bank_accounts_screen.dart`, `link_bank_flow.dart` |
| **TransactionRepository** | `MockTransactionRepository` | `ApiTransactionRepository` | Transaction ledger, statement generation, filter queries | `/transactions/*`, `/transactions/statement` | None | `api_transaction_repository.dart` | `transaction_screen.dart`, `transaction_detail_screen.dart` |
| **NotificationRepository** | `MockNotificationRepository` | `ApiNotificationRepository` | Push alerts feed, unread counters, notification read states | `/notifications/*`, `/notifications/read` | None | `api_notification_repository.dart` | `notifications_screen.dart` |
| **RechargeRepository** | `MockRechargeRepository` | `ApiRechargeRepository` | Mobile recharge plans, operator catalogs, circle lookups | `/recharge/plans`, `/recharge/operators`, `/recharge/execute` | `TransactionRepository`, `NotificationRepository` | `api_recharge_repository.dart` | `recharge_screen.dart`, `plan_selector_screen.dart` |
| **BillRepository** | `MockBillRepository` | `ApiBillRepository` | BBPS utility invoices, electricity, water, gas, broadband | `/bills/fetch`, `/bills/pay`, `/bills/categories` | `TransactionRepository`, `NotificationRepository` | `api_bill_repository.dart` | `bills_screen.dart`, `bill_payment_screen.dart` |
| **QrRepository** | `MockQrRepository` | `ApiQrRepository` | Static QR generation, dynamic QR resolution, merchant deep links | `/qr/resolve`, `/qr/generate` | `PaymentsRepository`, `TransactionRepository` | `api_qr_repository.dart` | `qr_scanner_screen.dart`, `personal_qr_screen.dart` |
| **FinancialRepository** | `MockFinancialRepository` | `ApiFinancialRepository` | Personal/business loans, insurance quotes & policies, SIP mutual funds | `/loans/*`, `/insurance/*`, `/investments/*` | `TransactionRepository`, `NotificationRepository`, `UserRepository` | `api_financial_repository.dart` | `loans_screen.dart`, `insurance_screen.dart`, `investments_screen.dart` |
| **TravelRepository** | `MockTravelRepository` | `ApiTravelRepository` | Flights (GDS), Trains (IRCTC), Buses, Hotels (CRS), Cinema tickets | `/travel/flights/*`, `/travel/trains/*`, `/travel/buses/*`, `/travel/hotels/*`, `/travel/movies/*`, `/travel/bookings/*` | `TransactionRepository`, `NotificationRepository` | `api_travel_repository.dart` | All travel search, results, seat selection, and passenger review screens |
| **MerchantRepository** | `MockMerchantRepository` | `ApiMerchantRepository` | Business metrics, store profile, transactions, instant settlement sweeps | `/merchant/profile`, `/merchant/sales-summary`, `/merchant/settlements`, `/merchant/settlement-balance`, `/merchant/offers` | `TransactionRepository`, `NotificationRepository` | `api_merchant_repository.dart` | `merchant_screen.dart`, `merchant_profile_screen.dart`, `merchant_settlement_screen.dart`, `merchant_transactions_screen.dart` |
| **RewardRepository** | `MockRewardRepository` | `ApiRewardRepository` | Cashback ledger, mystery scratch cards, brand coupons | `/rewards/summary`, `/rewards/scratch-cards/*`, `/rewards/coupons/*`, `/rewards/cashback` | `TransactionRepository`, `NotificationRepository` | `api_reward_repository.dart` | `rewards_screen.dart`, `scratch_card_screen.dart`, `coupon_details_screen.dart`, `cashback_history_screen.dart` |
| **HomeRepository** | `MockHomeRepository` | `ApiHomeRepository` | Unified dashboard aggregator (profile, wallet, recent txns, unread alerts) | `/dashboard/home` | `UserRepository`, `WalletRepository`, `TransactionRepository`, `NotificationRepository`, `RewardRepository` | `api_home_repository.dart` | `home_screen.dart` |

---

## 🔒 Architectural Isolation Rule

All Presentation Screens and UI Widgets must communicate **only** with repository interfaces or domain services. Under no circumstance should a widget directly instantiate HTTP network clients or import mock/dummy storage data classes.
