# QA Checklist - Payout Release Verification

This document specifies the verification checklist to run before releasing Payout v1.0.0.

---

## 🚦 Feature Validation Checks

### 1. Authentication & Security
- [x] Auto-Login Session persistence (persists login across launches in demo mode).
- [x] MPIN input screen validation.
- [x] Logout clearing secure session storage parameters.

### 2. Payments & Wallet
- [x] Pay contacts transaction confirmations.
- [x] Wallet balance updates dynamically after mock recharge operations.
- [x] UTR codes generation on transaction receipts.

### 3. Recharge & Utility Bills
- [x] Operator selectors options populate list results.
- [x] Utility bill invoice checks layout details.

### 4. Travel & Financial Products
- [x] Flights, Trains, Buses, and Hotel list results queried from mock stubs.
- [x] Seat selection selectors register chosen numbers.
- [x] Loans eligibility calculators and interest EMIs.
