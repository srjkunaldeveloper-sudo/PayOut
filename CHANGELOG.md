# Changelog

## [1.4.0] - Phase 7 User Profile, KYC Center & Settings Upgrade - 2026-08-08

### Added & Upgraded
- **User Profile Domain Upgrade**:
  - `UserProfileModel`: Extended with `dob`, `memberSince`, `avatarUrl`, and dynamic `linkedBankCount`.
  - `UserValidator`: Added full validation suite (`validateName`, `validateEmail`, `validateDOB` with age >= 18 check, `validatePhone`, `validateOTP`, `validatePAN`, and `validateAadhaar`).
  - `ProfileScreen`: Upgraded with user avatar, dynamic details, overview cards (Member Since, Linked Bank Accounts), KYC status badge, and sub-screen navigation.
  - `EditProfileScreen`: Built profile editing form with inline field validation and dedicated 6-digit OTP verification flow for mobile number updates.
- **KYC Verification Center & Multi-Step Wizard**:
  - `KYCModel`: Extended with `personalDetailsSubmitted`, `panVerified`, `documentUploaded`, `bankVerified`, `panNumber`, `verifiedDate`, and `rejectionReason`.
  - `KYCStatusScreen`: Built full verification center with 5-stage progress indicator, status banners (Verified, Under Review / Pending, Needs Action, Rejected), unlocked account benefits, and dynamic action buttons.
  - `KYCFlowScreen`: Interactive 5-step wizard covering Personal Details, PAN Verification, Identity Document upload simulation (Aadhaar, Passport, Driving Licence, Voter ID), Bank Account verification (integrating with `BankAccountRepository`), and Review & Submit step with success confirmation.
  - Outcomes Isolation: Encapsulated submission and status verification logic within `MockUserRepository`.
- **Settings & Security Upgrade**:
  - `SettingsScreen`: Grouped into Account, Security & Access (6-digit MPIN change, Biometric login switch, App lock switch), Notification Preferences (Payment, Recharge, Bills, Offers), App Preferences (Language selector: English / Hindi), Support, and Logout.
  - `PaymentMPINVerificationScreen`: Integrated into Security settings for authorized MPIN changes.
  - `AboutScreen`: Added config-driven demo mode badge, version/build indicators, and legal document links.
  - Session Management: Seamless session persistence with explicit logout confirmation modal clearing session via `SessionManager.instance.logout()`.
- **Home Integration**:
  - `HomeScreen`: Profile navigation awaits return to automatically refresh user greeting and KYC status badge via `HomeRepository`.
- **Widget Test Suites**:
  - Added `profile_upgrade_test.dart`, `kyc_flow_test.dart`, and `settings_upgrade_test.dart`. All 16 test suites passing.

## [1.3.0] - Phase 6 QR Payments, Transaction History & Notifications Upgrade - 2026-08-08

### Added & Upgraded
- **QR Payments Pipeline Upgrade**:
  - `QRType` Enum: Added support for `merchant`, `personal`, `invalid`, `expired`, and `unsupported` QR types.
  - `QRResolutionResult`: Defined structured resolution model.
  - `QrRepository`: Added `resolveQR` abstraction and deterministic implementation in `MockQrRepository`.
  - `DummyQrData`: Centralized deterministic QR payloads (`SRJ Foods`, `Rahul Sharma`, invalid, expired, and unsupported signatures).
  - `ScanQRScreen`: Upgraded with visual laser scanning animation, interactive Demo QR Scenarios selector, verified merchant banners, error modals with "Scan Again" CTA, and direct handoff to `AmountEntryScreen`.
- **Payments & Ledger Integration**:
  - Constructor Dependency Injection: Injected `TransactionRepository` and `NotificationRepository` into `MockPaymentsRepository`.
  - Centralized Transaction & Notification Creation: Executing payments creates records in `TransactionRepository` and dispatches alerts via `NotificationRepository`.
  - Centralized Outcome Rules: Retained ₹100 = FAILED, ₹200 = PENDING, other = SUCCESS simulation strictly inside `MockPaymentsRepository`.
- **Transaction History & Details Upgrade**:
  - Categories Filter: Added tabs for `All`, `Sent`, `Received`, `Recharge`, `Bills`, `QR Payments`, `Bank Transfer`, and `Wallet`.
  - Search Querying: Live filtering across recipient names, UPI IDs, transaction IDs, categories, and amounts.
  - `TransactionDetailScreen`: Created dedicated detail view with status banner, full metadata breakdown, UTR, Reference ID, and "View Receipt" CTA.
- **Notifications & Home Synchronization**:
  - `NotificationModel`: Extended with `actionRoute`, `relatedEntityId`, and `relatedTransactionId`.
  - `NotificationRepository`: Added `addNotification` interface and implementation.
  - `NotificationsScreen`: Supported mark as read on tap, meaningful navigation to `TransactionDetailScreen`, "Mark all read" header action, and swipe-to-delete.
  - `HomeScreen`: Automatically refreshes dashboard state and notification badges on return from payments, scanner, or notifications.
- **Widget Tests**:
  - Added `qr_payment_flow_test.dart`, `transaction_history_upgrade_test.dart`, and `notifications_upgrade_test.dart`.

## [1.2.0] - Phase 5 Recharge & Bills Product Upgrade - 2026-08-08

### Added & Upgraded
- **Recharge & Bills Domain Upgrade**:
  - `RechargePlanModel`: Added `operator`, `calls`, and `sms` allowance properties.
  - `BillModel`: Added `consumerName`, `billNumber`, `billDate`, and `lateFee` properties.
  - `dummyPlans` & `dummyBillers`: Expanded full catalog for Jio, Airtel, Vi, BSNL across Popular, Unlimited, Data, Validity, Talktime, and SMS categories, alongside complete BBPS utilities (Electricity, Water, DTH, LPG, Broadband, Mobile Postpaid).
  - Constructor Dependency Injection: Injected `TransactionRepository` into `MockRechargeRepository` and `MockBillRepository`.
  - Transaction Ledger Integration: Added `addTransaction` method to `TransactionRepository` and created transactions in the transaction ledger for all recharge and bill payments.
  - Dynamic Payment Source Selection: Reused wallet and linked bank accounts selector in checkout sheets.
  - 6-Digit MPIN Security: Reused `PaymentMPINVerificationScreen` keypad with callback hooks.
  - Processing & Outcomes: Created dedicated `RechargeProcessingScreen`, `RechargePendingScreen`, `RechargeFailedScreen`, `BillProcessingScreen`, `BillSuccessScreen`, `BillPendingScreen`, and `BillFailedScreen`.
  - Outcomes Isolation: Enforced ₹100 = FAILED and ₹200 = PENDING deterministic demo criteria exclusively inside `MockRechargeRepository` and `MockBillRepository`.
  - Widget Tests: Added `recharge_bills_flow_upgrade_test.dart` covering both recharge and bill flows end-to-end.

## [1.0.1] - 2026-08-07

### Added
- **Production Hardening & Release Readiness:** Set up abstract Dio API clients, network request interceptors, PIN lock manager, encryption utils, Firebase mock services, localizations base, unit and widget test files, and GitHub actions configuration.
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
