# Version Ledger Changelog

All notable changes to the Payout project are recorded here.

---

## [1.10.0] - 2026-08-08

### Audited & Decoupled
- Performed a deep codebase audit to guarantee that a backend team can replace Mock repositories with Api repositories with zero UI regression or code rewrites.
- Completely decoupled presentation screen widgets from direct imports of mock and dummy datasets (`DummyQrData`, `DummyHomeData`).
- Standardized constructor DI to fallback to `AppDependencies.instance` container across all 15 domains, preventing direct widget construction of Mock repository classes.
- Full automated testing passes cleanly with 70 success runs.

## [1.0.1] - 2026-08-07

### Added
- Integrated Phase 12 Production Hardening network client, security controls, and CI pipelines setup.
- Integrated Phase 11 Travel booking search indices, seat layout selectors, and boarding passes layouts under `lib/features/travel/`.
- Integrated Phase 10 Loans EMI trackers, active insurance cover policies, and investment growth portfolios under `lib/features/financial/`.
- Integrated Phase 9 Merchant dashboard analytics and active rewards coupons under `lib/features/merchant/` and `lib/features/rewards/`.
- Integrated persistent session tracking via `SecureStorageService` and `SharedPreferences` to keep users logged in until they explicitly logout.
- Integrated Phase 8 User Profile, settings configurations, and KYC checks under `lib/features/user/`.
- Integrated Phase 7 Mobile Recharge & utility bills under `lib/features/recharge/` and `lib/features/bills/`.
- Consolidated transaction lists and alert notifications.
