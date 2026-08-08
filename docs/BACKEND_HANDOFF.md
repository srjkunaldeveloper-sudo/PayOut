# Backend Handoff Instructions

This file serves as a guide for backend team developers integrating remote REST APIs.

---

## 📂 Mapping Guides
- **Authentication:** Connects OTP trigger verification endpoints.
- **Payments:** Handles NPCI interfaces, bank account linkings, and UPI transactions.
- **User Settings:** Interfaces preferences configuration changes (themes, languages).
- **Merchant & Rewards:** Integrates sales analytics maps, settlement requests, active coupons, and scratch cards.
- **Financial Products:** Integrates active loan offers checkers, insurance premium billing checkouts, and mutual funds portfolio indicators.
- **Travel Enterprise:**
  - `TravelRepository`: Abstract interface ready for `ApiTravelRepository` implementation.
  - `searchFlights`: Maps to airline GDS / flight aggregator search API.
  - `searchTrains`: Maps to IRCTC reservation & PNR availability API.
  - `searchBuses`: Maps to RedBus / AbhiBus / bus operator GDS API.
  - `searchHotels`: Maps to hotel aggregator / CRS API.
  - `getMovies`, `getMovieTheatres`, `getMovieShows`, `getMovieSeats`: Maps to BookMyShow / District / cinema chain API.
  - `createBooking`: Receives `TravelBookingModel` upon successful MPIN payment, returns confirmed booking with PNR / voucher code.
  - `cancelBooking`: Initiates cancellation & triggers refund workflow.
- **Core Network client:** Connects target REST base URLs directly to `ApiClient`.
