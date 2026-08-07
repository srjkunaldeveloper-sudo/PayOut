# Migration Instructions - Payout v1.0.0

This guide outlines the steps required to transition from old mock implementations to the new production-ready structure.

---

## 🛠️ Step-by-Step Transition

1. **Substitute Repository Instantiations:**
   - Locate abstract contracts (`UserRepository`, `PaymentsRepository`, `TravelRepository`, etc.).
   - Replace dummy implementations with service gateways linking `ApiClient`.

2. **Configure API Endpoints Base URL:**
   - Define custom endpoints in `AppConfig` or read via environment configurations.
