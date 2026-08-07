# API Integration Instructions

To connect Payout UI to your production backend servers, replace the mock implementations.

---

## 🛠️ Integration Checklist

1. **Dio Setup:** The global `Dio` client is initialized in `lib/core/network/dio_client.dart` with token interceptors.
2. **Repositories:**
   - Extend existing abstract contract interfaces (`UserRepository`, `PaymentsRepository`, `MerchantRepository`, `RewardRepository`, `FinancialRepository`, `TravelRepository`, etc.).
   - Swap instances in feature widgets or service injects with the new backend repository implementations.
3. **Serializations:** Verify that the JSON models match your API payload schemas.
