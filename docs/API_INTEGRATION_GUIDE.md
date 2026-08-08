# API Integration Instructions

To connect Payout UI to your production backend servers, replace the mock implementations.

---

## 🛠️ Integration Checklist

1. **Dio Setup:** The global `Dio` client is initialized in `lib/core/network/dio_client.dart` with token interceptors.
2. **Repositories:**
   - Extend existing abstract contract interfaces (`UserRepository`, `PaymentsRepository`, `MerchantRepository`, `RewardRepository`, `FinancialRepository`, `TravelRepository`, etc.).
   - Swap instances in feature widgets or service injects with the new backend repository implementations.
3. **Serializations:** Verify that the JSON models match your API payload schemas.

---

## ✈️ Travel & Booking Endpoints (Phase 9)

| Action | HTTP Method | Endpoint | Request Payload / Params | Return Model |
| :--- | :---: | :--- | :--- | :--- |
| **Search Flights** | `POST` | `/api/v1/travel/flights/search` | `FlightSearchRequest` | `List<FlightModel>` |
| **Search Trains** | `POST` | `/api/v1/travel/trains/search` | `TrainSearchRequest` | `List<TrainModel>` |
| **Search Buses** | `POST` | `/api/v1/travel/buses/search` | `BusSearchRequest` | `List<BusModel>` |
| **Search Hotels** | `POST` | `/api/v1/travel/hotels/search` | `HotelSearchRequest` | `List<HotelModel>` |
| **Get Cinema Movies** | `GET` | `/api/v1/travel/movies?city={city}` | None | `List<MovieModel>` |
| **Get Multiplex Theatres**| `GET` | `/api/v1/travel/movies/{movieId}/theatres` | `city`, `date` | `List<MovieModel>` |
| **Get Cinema Seats** | `GET` | `/api/v1/travel/movies/shows/{showId}/seats`| None | `List<MovieSeatModel>` |
| **Create Travel Booking**| `POST` | `/api/v1/travel/bookings` | `TravelBookingModel` | `TravelBookingModel` |
| **Get User Bookings** | `GET` | `/api/v1/travel/bookings?category={cat}` | Query parameters | `List<TravelBookingModel>` |
| **Cancel Booking** | `POST` | `/api/v1/travel/bookings/{id}/cancel` | None | `{ success: true, refundAmount: double }` |
