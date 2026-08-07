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

