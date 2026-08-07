# Changelog

## [1.0.1] - 2026-08-07

### Added
- **Travel Enterprise Production Readiness:** Restructured flight ticketing, train berth allocations, bus layouts, hotel suites booking, and multiplex movie seats tracking flows to fetch data models via `MockTravelRepository` under `lib/features/travel/`.
- **Financial Products Production Readiness:** Consolidated loans eligibility checks, insurance coverage summaries, and investment portfolio tracking maps under a unified directory structure inside `lib/features/financial/`.
- **Merchant & Rewards Production Readiness:** Centralized all sales analytics, settlements timelines, cashback status, scratch cards, and active coupon codes under `lib/features/merchant/` and `lib/features/rewards/`.
- **Persistent Login Session (Demo Mode):** Integrated persistent session tracking via `SecureStorageService` and `SharedPreferences` to keep users logged in until they explicitly logout.
- **User Domain Production Readiness:** Centralized all settings configs, KYC verification details, and profile parameters under `lib/features/user/`.
- **Recharge & Bills Production Readiness:** Upgraded operators and utilities plan selectors to mock repositories under `lib/features/recharge/` and `lib/features/bills/`.
- **Transactions & Notifications Production Readiness:** Upgraded transaction histories and alerts feeds to use structured models and mock repository contracts under `lib/features/transactions/` and `lib/features/notifications/`.
- **QR Production Readiness:** Consolidated scan_qr and my_qr into a unified `qr` module layout. Linked scanner and personal display triggers to `MockQrRepository` and model serializers.
- **Payments Production Readiness:** Upgraded the payments module directory structure into Domain-Driven Design (DDD) layers. Controlled via mock repository contracts.
- **Dedicated Payment outcome screens:** Added `PaymentPendingScreen`, `PaymentFailedScreen`, and a detailed `ReceiptScreen` mapping transaction UTR codes.
- **Global AppConfig Configuration:** Global AppConfig introduced for application-wide configuration.
- **Authentication Demo Mode:** Added for client presentation. Controlled via `AppConfig.isDemoMode`.
- **Dynamic OTP verification stubs:** Accept any 6-digit verification code under Demo Mode (e.g., 000000, 111111, 999999).
- **Consolidated logging console output prefixes:** Prepend `[DEMO MODE]` logs to authentication flows.
