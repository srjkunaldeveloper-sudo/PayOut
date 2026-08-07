# Architecture Guidelines

Payout follows a Feature-First DDD folder hierarchy structure.

---

## 🏗️ Layering Strategy

### 1. Presentation
- Widgets, screen controllers, state flows.
- Absolutely zero business logic inside widgets.

### 2. Domain / Models
- Pure Dart entities, immutable states, and contract interfaces.
- Serialization methods (`toJson` / `fromJson`).

### 3. Data / Repositories
- Data providers, local secure storages, and remote API gateways.
- Contract implementation layers (`MockUserRepository`, etc.).
