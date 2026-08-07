# Project Folder Structure

Payout is modularized to ensure maximum isolation between functional domains.

---

## 🌳 Structure Layout

```text
lib/
├── core/
│   ├── config/       # Global AppConfig definitions
│   ├── theme/        # V2 layout colors and typography
│   └── widgets/      # Common components library V2
└── features/
    ├── auth/         # Login, OTP verification screens
    ├── user/         # Profile, Settings, KYC status pages
    ├── payments/     # Transfers, bank accounts, receipts
    ├── transactions/ # Statements query logs
    ├── notifications/# Alerts push stubs
    └── qr/           # Camera scans and generator displays
```
