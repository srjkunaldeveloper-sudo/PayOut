# Payout Architecture Guidelines

This document outlines the architectural conventions used in the **Payout** application to separate UI rendering, user actions validation, mock database stubs, and state parameters.

---

## 📁 Domain-Driven Directory Layout

Features (e.g. `auth`, `wallet`) follow a Clean Architecture pattern:

```
feature_name/
├── presentation/         # Flutter Widgets, Screens, and custom layout controls
│   └── widgets/          # Feature-specific reusable UI widgets
├── models/               # Strongly typed Request/Response data models
├── repositories/         # Abstract repository contracts and mock implementations
├── services/             # Analytics loggers, persistent session handlers, calculations
├── validators/           # Pure validation functions returning structured ValidationResults
├── constants/            # Feature-specific constants (lengths, timers, prefixes)
└── states/               # State classes and status enum definitions
```

---

## ⚙️ Global Configuration

All application-wide toggles are stored inside `lib/core/config/app_config.dart` ([app_config.dart](file:///Users/macbook/StudioProjects/payout/lib/core/config/app_config.dart)):
- `isDemoMode`: Bypasses strict OTP validations for presentations and client reviews.
- `enableLogs`: Master toggle for console logs and analytics telemetry.
- `repositoryMode`: Determines whether modules connect to mock data repositories or production services via `RepositoryMode.mock` and `RepositoryMode.api`.

---

## 💳 Payments Domain
The Payments module is organized to handle multiple instruments:
- **Validators:** `PaymentsValidator` verifies that amount ranges, IFSC formats, and VPA strings conform to National Payments Corporation of India (NPCI) criteria.
- **Repository:** `PaymentsRepository` coordinates verified beneficiary contacts retrieval, payments execution, and receipt generation.

---

## 🔍 QR Scan & Generator Domain
The consolidated QR module under `lib/features/qr/` merges camera scanner overlays and personal QR displays:
- **Validators:** `QrValidator` parses and validates incoming deep-links and merchant UPI addresses.
- **Repository:** `QrRepository` retrieves scanned merchant locations and configures personal scan credentials.

---

## 📊 Transactions & Notifications Domains
Separates history feeds, filtering engines, and alert push systems:
- **Validators:** `TransactionValidator` manages date range filters and statements search parameters.
- **Repositories:** `TransactionRepository` and `NotificationRepository` handle bulk database queries, swipes to delete, and PDF receipt downloads.

---

## 📱 Recharge & Bills Domains
Coordinates operator catalogues, data plans compare matrix, and utility invoice checks:
- **Validators:** `RechargeValidator` and `BillValidator` confirm mobile digits formatting and consumer number lengths.
- **Repositories:** `RechargeRepository` and `BillRepository` resolve operators listings and fetch billing status.

---

## 👤 User Domain
Stores preference configurations, identity compliance, and session controls:
- **Validators:** `UserValidator` confirms Aadhaar and PAN check structures.
- **Repository:** `UserRepository` manages user profiling data and document uploads.

---

## 💼 Merchant & Rewards Ecosystem Domain (Phase 10)
Provides comprehensive merchant business console, instant settlement sweep, loyalty rewards, mystery scratch cards, and promo coupons:
- **Merchant Models (`merchant_models.dart`):** `MerchantProfileModel`, `MerchantSalesSummaryModel`, `MerchantTransactionModel`, `SettlementModel`, `MerchantOfferModel`, `BusinessInsightModel`.
- **Merchant Calculations (`MerchantService`):** Pure aggregation functions for `calculateTotalSettled`, `calculateSalesSummary`, `filterTransactions`, `filterOffers`, and `isSettlementEligible`.
- **Merchant Validation (`MerchantValidator`):** `validateBusinessName`, `validateGST`, `validatePAN`, `validateMobile`, `validateEmail`, `validatePincode`, `validateSettlementAmount`.
- **Merchant Repository (`MerchantRepository` & `MockMerchantRepository`):** Constructor-injected `TransactionRepository` and `NotificationRepository`. Instant settlement sweeps route through `PaymentMPINVerificationScreen` with 6-digit MPIN authorization.
- **Rewards Models (`reward_models.dart`):** `CouponModel`, `ScratchCardModel`, `CashbackModel`, `RewardSummaryModel`, `RewardModel`.
- **Rewards Calculations (`RewardService`):** Pure functions for `calculateTotalCashback`, `calculateRewardSummary`, `filterCoupons`, `filterCashbacks`, and `calculateDiscountAmount`.
- **Rewards Validation (`RewardValidator`):** `validateCouponCode`, `validateCouponEligibility`, `validateMinimumSpend`, `validateRewardAmount`.
- **Rewards Repository (`RewardRepository` & `MockRewardRepository`):** Constructor-injected `TransactionRepository` and `NotificationRepository`. Interactive scratch cards credit rewards wallet and dispatch ledger transactions and push notifications.
- **Standardized Logging:** `MerchantLogger` and `RewardLogger` with timestamped `[DEMO MODE]` logs and zero PII.

---

## 🏦 Financial Products Domain
Coordinates loan assessments, EMI calculators, insurance packages, and portfolio assets:
- **Validators:** `FinancialValidator` confirms PAN compliance and minimum transaction boundaries.
- **Repository:** `FinancialRepository` manages portfolios status updates, policy checkouts, and loan applications.

---

## ✈️ Travel & Booking Ecosystem Domain (Phase 9)
Coordinates full in-app travel discovery, seat maps, multiplex ticketing, and reservation management:
- **Centralized Models (`travel_models.dart`):** `FlightModel`, `TrainModel`, `BusModel`, `HotelModel`, `MovieModel`, `TravelBookingModel`.
- **Calculations & Business Logic (`TravelService`):** Dedicated pure service functions for `calculateFlightFare`, `calculateTrainFare`, `calculateBusFare`, `calculateStayNights`, `calculateHotelPricing`, `calculateMoviePricing`, and `calculateRefundEstimate`. Zero pricing computations reside in widgets.
- **Validators (`TravelValidator`):** `validatePassengerName`, `validateAge`, `validateMobile`, `validateEmail`, `validateSearchCities`, `validateTravelDates`, `validatePassengerCount`.
- **Repository (`TravelRepository` & `MockTravelRepository`):** Constructor-injected `TransactionRepository` and `NotificationRepository`. Only `CONFIRMED` bookings dispatch transactions and user alerts. Contains clear `// TODO(api)` hooks for future airline, IRCTC, bus GDS, hotel CRS, and cinema ticketing engine backend integrations.
- **Unified MPIN Payment Integration:** All bookings seamlessly route through `PaymentMPINVerificationScreen` with 6-digit MPIN authorization.
- **Standardized Logging (`TravelLogger`):** Timestamped `[DEMO MODE]` logging with zero PII.

---

## 🔒 Security, Core Network & Dependency Injection Infrastructure (Phase 11 & 13)
- **Central Composition Root (`AppDependencies`):** Manages singleton instances, constructor DI wiring, and service locator inversion across all 15 domain repositories without external heavy packages.
- **Central Repository & Environment Config (`AppConfig`):** Central source of truth for `RepositoryMode` (`mock`, `api`), base API URLs, and timeout policies.
- **Network Layer (`DioClient`, `ApiClient`):** Pre-configured Dio HTTP client with `AuthInterceptor`, sanitized `LoggingInterceptor`, full HTTP verbs (`GET`, `POST`, `PUT`, `PATCH`, `DELETE`), and standard `ApiResponse<T>` / `NetworkException` error mapping.
- **Security & PII Sanitization:** Token manager (`TokenManager`), session store (`SessionManager`), cryptographic helpers (`EncryptionHelper`), and zero-PII network interceptors that strip tokens, cookies, and sensitive payload data from logs.
- **Decoupled Mock Strategy (Phase 13):** All presentation screens are completely decoupled from dummy/mock data files and never construct mock repository classes inline. Constructors support DI and resolve default fallbacks strictly via `AppDependencies.instance` container, guaranteeing full REST API replaceability without UI modifications.

