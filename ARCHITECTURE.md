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
- `enableMockRepository`: Determines whether modules connect to mock data repositories or production services.

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

## 💼 Merchant & Rewards Domains
Provides merchant invoice monitoring and loyalty offers management:
- **Validators:** `MerchantValidator` and `RewardValidator` check business details and coupon codes.
- **Repositories:** `MerchantRepository` and `RewardRepository` retrieve settlements and active scratch cards.

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

## 🔒 Security & Core Network Infrastructure
- **Network Layer:** API client bindings (`ApiClient`), request adapters configurations (`DioClient`), and safety interceptors (`AuthInterceptor`).
- **Security Protocols:** Credentials token lockers (`TokenManager`), cryptographic sanitation helpers (`EncryptionHelper`), and biometric checks triggers (`BiometricManager`).

