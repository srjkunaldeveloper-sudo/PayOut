# Architecture Guidelines

Payout follows a Feature-First DDD folder hierarchy structure.

---

## 🏗️ Layering Strategy

### 1. Presentation
- Widgets, screen controllers, state flows.
- Absolutely zero business logic or network models logic inside widgets.
- Presentation layers **never** import dummy/mock data files directly or instantiate Mock repository classes manually. They must operate strictly via Dependency Injection.

### 2. Domain / Models
- Pure Dart entities, immutable states, and contract interfaces.
- Serialization methods (`toJson` / `fromJson`).

### 3. Data / Repositories
- Data providers, local secure storages, and remote API gateways.
- Contract implementation layers (`MockUserRepository`, etc.).

---

## 💼 Domain Repositories
Every feature operates under dedicated repositories, ensuring backend compatibility without modifying the UI layer. For example, `MerchantRepository`, `RewardRepository`, `FinancialRepository` and `TravelRepository` handle business dashboard details, scratch cards, user portfolios, and travel bookings. Core networking and security configurations reside under `lib/core/network/` and `lib/core/security/`.

## 📦 Dependency Injection & Fallbacks
Repository references inside widgets are injected via constructors. Widgets default their constructor repository fallbacks strictly to the central composition root singleton `AppDependencies.instance`, ensuring that switching environment modes (`RepositoryMode.mock` to `RepositoryMode.api`) swaps all dependencies system-wide without UI compilation errors or refactoring.
