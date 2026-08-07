# Changelog

## [1.0.1] - 2026-08-07

### Added
- **Global AppConfig Configuration:** Global AppConfig introduced for application-wide configuration.
- **Authentication Demo Mode:** Added for client presentation. Controlled via `AppConfig.isDemoMode`.
- **Dynamic OTP verification stubs:** Accept any 6-digit verification code under Demo Mode (e.g., 000000, 111111, 999999).
- **Consolidated logging console output prefixes:** Prepend `[DEMO MODE]` logs to authentication flows.
