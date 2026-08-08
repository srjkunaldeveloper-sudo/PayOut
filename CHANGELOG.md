# Changelog

## [1.8.0] - Phase 11 Backend-Ready Core Integration & API Adapter Foundation - 2026-08-08

### Added & Upgraded
- **Central Composition Root & Dependency Injection**:
  - `lib/core/di/app_dependencies.dart`: Implemented `AppDependencies` singleton and composition root to wire and manage all 15 domain repositories with constructor DI.
  - `lib/core/di/di.dart`: Public export barrel for dependency management.
- **Central Environment & Repository Configuration**:
  - `lib/core/config/app_config.dart`: Added `RepositoryMode` (`mock`, `api`) enum and central API base URLs and timeouts.
- **Sanitized Network Logging**:
  - `lib/core/network/logging_interceptor.dart`: Strict credential and PII sanitization. Strips `Authorization`, `Cookie`, `Set-Cookie`, `x-api-key`, passwords, and token payloads.
- **Enriched Network Exceptions & Response Wrapper**:
  - `lib/core/network/network_exception.dart`: Added `NetworkExceptionType` enum and `fromStatusCode` factory.
  - `lib/core/network/api_response.dart`: Added HTTP status code mapping and `hasData` helper.
  - `lib/core/network/api_client.dart`: Extended with full HTTP verb suite (`GET`, `POST`, `PUT`, `PATCH`, `DELETE`).
  - `lib/core/network/auth_interceptor.dart`: Enriched with Bearer token injection and 401 handling boundaries.
- **Backend Handoff Documentation**:
  - `docs/BACKEND_REPOSITORY_MAP.md`: Complete matrix mapping all 15 domain repositories, mock vs. API implementations, and file boundaries.
  - `docs/API_INTEGRATION_GUIDE.md`: Developer guide with practical step-by-step mock-to-API replacement tutorial.
  - `docs/BACKEND_HANDOFF.md`: Comprehensive handoff specification.
- **Architecture Verification Suite**:
  - `test/unit/repository_architecture_test.dart`: Automated test suite verifying composition root, `AppConfig`, `ApiResponse`, and `NetworkException`.

## [1.7.0] - Phase 10 Merchant Console & Rewards Ecosystem Upgrade - 2026-08-08

### Added & Upgraded
- **Merchant Console & Store Ecosystem Upgrade**:
  - `merchant_models.dart`: Centralized domain models for `MerchantProfileModel`, `MerchantSalesSummaryModel`, `MerchantTransactionModel`, `SettlementModel`, `MerchantOfferModel`, `BusinessInsightModel`, and `InvoiceModel`.
  - `MerchantService`: Clean aggregation functions for `calculateTotalSettled`, `calculateSalesSummary`, `filterTransactions`, `filterOffers`, and `isSettlementEligible` with business logic decoupled from presentation.
  - `MerchantValidator`: Validation suite (`validateBusinessName`, `validateGST`, `validatePAN`, `validateMobile`, `validateEmail`, `validatePincode`, `validateSettlementAmount`).
  - `MerchantRepository` & `MockMerchantRepository`: Constructor dependency injection of `TransactionRepository` and `NotificationRepository`.
  - Realistic Demo Outcomes: ₹100 = FAILED, ₹200 = PENDING, other = SUCCESS encapsulated in repository.
  - Standardized Logging: `MerchantLogger` with timestamped `[DEMO MODE]` logs and zero PII.
  - `MerchantProfileScreen`: Business details, verified GSTIN, PAN, KYC status, store UPI ID, and masked settlement bank.
  - `MerchantTransactionsScreen`: Search by customer, Txn ID, or UTR, status chips (`SUCCESS`, `PENDING`, `FAILED`), and payment mode chips (`UPI`, `CARD`, `WALLET`).
  - `MerchantSettlementScreen`: Available settlement balance, destination bank account selector from `BankAccountRepository`, review bottom sheet, and 6-digit MPIN checkout via `PaymentMPINVerificationScreen`.
  - `MerchantScreen`: Redesigned business console hero dashboard, store sales metrics, static QR dialog, quick actions, active promotions, and recent payments.
- **Rewards, Coupons & Cashback Upgrade**:
  - `reward_models.dart`: Centralized domain models for `CouponModel`, `ScratchCardModel`, `CashbackModel`, `RewardSummaryModel`, and `RewardModel`.
  - `RewardService`: Clean calculation engines for `calculateTotalCashback`, `calculateRewardSummary`, `filterCoupons`, `filterCashbacks`, and `calculateDiscountAmount`.
  - `RewardValidator`: Validation suite (`validateCouponCode`, `validateCouponEligibility`, `validateMinimumSpend`, `validateRewardAmount`).
  - `RewardRepository` & `MockRewardRepository`: Constructor dependency injection of `TransactionRepository` and `NotificationRepository`.
  - `ScratchCardScreen`: Interactive tap-to-scratch reveal animation, prize amount crediting to rewards wallet, and automatic transaction + notification dispatch.
  - `CouponDetailsScreen`: Discount hero card, promo code copy button, terms & breakdown, minimum spend limits, and coupon redemption action.
  - `CashbackHistoryScreen`: Filter chips (`All`, `AVAILABLE`, `PENDING`, `EXPIRED`) with itemized cashback ledger and transaction references.
  - `RewardsScreen`: Lifetime cashback earned hero card, mystery scratch cards horizontal carousel, category-filtered active coupons, invite friends banner, and history preview.
- **Testing & Verification**:
  - 9 dedicated Phase 10 test suites covering models, validators, services, merchant dashboard, settlement flow, rewards hub, scratch card reveal, and coupon redemption.
  - 100% test pass rate across all 49 test suites in the repository.

## [1.6.0] - Phase 9 Travel & Booking Ecosystem Upgrade (Flights, Trains, Buses, Hotels, Movies, My Bookings) - 2026-08-08

### Added & Upgraded
- **Travel Domain Architecture & Centralized Models**:
  - `travel_models.dart`: Centralized domain models for `FlightModel`, `FlightSearchRequest`, `FlightFareModel`, `FlightPassengerModel`, `TrainModel`, `TrainSearchRequest`, `TrainClassAvailability`, `TrainPassengerModel`, `BusModel`, `BusSearchRequest`, `BusSeatModel`, `BusPassengerModel`, `HotelModel`, `HotelSearchRequest`, `HotelRoomModel`, `HotelGuestModel`, `MovieModel`, `MovieTheatreModel`, `MovieShowModel`, `MovieSeatModel`, `TravelBookingModel`, and `TravelBookingStatus`.
  - `TravelService`: Centralized calculation engines for `calculateFlightFare`, `calculateTrainFare`, `calculateBusFare`, `calculateStayNights`, `calculateHotelPricing`, `calculateMoviePricing`, and `calculateRefundEstimate` with zero pricing logic in UI widgets.
  - `TravelValidator`: Input validation suite (`validatePassengerName`, `validateAge`, `validateMobile`, `validateEmail`, `validateSearchCities`, `validateTravelDates`, `validatePassengerCount`).
  - `TravelRepository` & `MockTravelRepository`: Constructor dependency injection of `TransactionRepository` and `NotificationRepository`.
  - Realistic Demo Outcomes: ₹100 = FAILED, ₹200 = PAYMENT_PENDING, other = CONFIRMED encapsulated in repository.
  - Standardized Logging: `TravelLogger` with timestamped `[DEMO MODE]` logs and zero PII.
- **Paytm-Style Flight Booking Flow**:
  - `FlightSearchScreen`: One Way / Round Trip toggle, non-prefilled origin/destination inputs, date pickers, pax & class selectors.
  - `FlightResultsScreen`: Non-stop filter, airline chips, dynamic pricing cards, and flight selection.
  - `FlightPassengerAndReviewScreen`: Clean passenger information form, live fare breakdown (Base + 12% GST + Fee), and 6-digit MPIN checkout.
- **Paytm-Style IRCTC Train Reservation**:
  - `TrainSearchScreen`: Origin/Destination station inputs, date picker, class quota selection.
  - `TrainResultsScreen`: Class availability cards (`3A`, `2A`, `1A`, `SL`) with live seat status (`AVAILABLE`, `RAC`, `WL`) and fares.
  - `TrainPassengerAndReviewScreen`: Passenger form with berth choice, IRCTC service charges, and MPIN checkout.
- **Paytm-Style Bus Booking Flow**:
  - `BusSearchScreen`: Boarding & drop cities, date picker, AC/Non-AC filter chips.
  - `BusResultsScreen`: Operator ratings, amenities, starting fare, and seat availability.
  - `BusSeatSelectionScreen`: Interactive bus layout with Available, Selected, Occupied, and Ladies seat statuses, live total fare ticker, and passenger checkout.
- **Hotel Stays & Luxury Resorts Flow**:
  - `HotelSearchScreen`: Destination search, check-in / check-out date range, stay nights counter, room/guest selectors.
  - `HotelResultsScreen`: Star rating filters, luxury property cards with amenities chips.
  - `HotelGuestAndReviewScreen`: Room selection, guest information form, 18% GST calculation, and MPIN checkout.
- **Zomato / District-Style Movie Ticket Experience**:
  - `MovieHomeScreen`: City selector (Delhi, Mumbai, Bengaluru, etc.), Now Showing / Coming Soon tabs, language & genre filters.
  - `MovieDetailScreen`: Poster card, audience ratings, votes count, duration, synopsis, and cast chips.
  - `MovieShowtimeSelectionScreen`: Horizontal date picker, multiplex theatres (PVR INOX, Cinepolis) with distance, format badges, and showtime slots.
  - `CinemaSeatSelectionScreen`: Curved cinema screen graphic, seat matrix (Rows A-F) with Regular, Premium, and Recliner tiers, live ticket counter, and checkout.
  - `MovieTicketReviewScreen`: Itemized ticket breakdown (Subtotal + Convenience Fee + GST), SMS/Email contact form, and MPIN verification.
- **Universal Booking Confirmation & History**:
  - `TravelBookingSuccessScreen`: Universal confirmation card with category icon, status badge, PNR/Voucher code, passenger info, and quick actions.
  - `MyBookingsScreen`: Upcoming, Completed, and Cancelled tabs, category filter pills, booking details modal sheet, and interactive cancellation dialog with live demo refund estimation.
- **Widget Test Suites**:
  - Added 6 new test suites (`flight_booking_flow_test.dart`, `train_booking_flow_test.dart`, `bus_booking_flow_test.dart`, `hotel_booking_flow_test.dart`, `movie_booking_flow_test.dart`, `travel_booking_history_test.dart`). All 25 test suites passing (100%).

## [1.5.0] - Phase 8 Financial Products Ecosystem Upgrade (Loans, Insurance, Investments) - 2026-08-08

### Added & Upgraded
- **Financial Domain Architecture & Models**:
  - `financial_models.dart`: Centralized domain models for `LoanModel`, `LoanEmiCalculation`, `LoanApplicationModel`, `InsurancePolicyModel`, `InsuranceQuoteModel`, `InsurancePurchaseModel`, `InvestmentModel`, `InvestmentOrderModel`, `PortfolioHoldingModel`, and `PortfolioModel`.
  - `FinancialService`: Centralized calculation engines for `calculateEMI(...)` and `calculateInsurancePremium(...)` with zero computation logic in UI widgets.
  - `FinancialValidator`: Input validation suite (`validateName`, `validateDOB`, `validatePAN`, `validateMonthlyIncome`, `validateLoanAmount`, `validateAge`, `validateInvestmentAmount`).
  - `FinancialRepository` & `MockFinancialRepository`: Constructor dependency injection of `TransactionRepository`, `NotificationRepository`, and `UserRepository`.
  - Realistic Demo Outcomes: ₹100 = REJECTED, ₹200 = PENDING, other = APPROVED strictly encapsulated inside `MockFinancialRepository`.
- **Loans & Credit Facility Flow**:
  - `LoansScreen`: Category pills, non-prefilled applicant application form, live EMI and total interest calculation preview, KYC verification check (`UserRepository.getKYC()`) with redirect to `KYCFlowScreen` when unverified, and detailed application review bottom sheet.
  - `FinancialSuccessScreen`: Comprehensive loan application outcome card supporting APPROVED, PENDING, and REJECTED states with sanctioned details and contextual actions.
- **Insurance Marketplace & Instant Quotes**:
  - `InsuranceScreen`: Category filters (Health, Life, Motor, Travel), policy detail cards with bulleted benefits, interactive quote builder with real-time premium updates, and review bottom sheet routing to the centralized `PaymentMPINVerificationScreen`.
  - Dynamic Ledger & Notification: Policy issuance dispatches payment transactions and user notifications.
- **Wealth & Investments Marketplace**:
  - `InvestmentsScreen`: Live portfolio valuation card with invested vs current returns, dynamic holdings list, category funds exploration, order builder supporting One-Time (Lumpsum) and Monthly SIP with date selection.
  - Risk Disclosure Modal: Mandatory market risk acknowledgement checkbox before routing to `PaymentMPINVerificationScreen`.
  - Dynamic Portfolio Updates: Successful orders automatically update user holdings and portfolio value.
- **Home Integration**:
  - `HomeScreen`: Automatically refreshes dashboard state upon returning from financial product services.
- **Widget Test Suites**:
  - Added `loan_flow_upgrade_test.dart`, `insurance_flow_upgrade_test.dart`, and `investment_flow_upgrade_test.dart`. All 19 test suites passing.

## [1.4.0] - Phase 7 User Profile, KYC Center & Settings Upgrade - 2026-08-08

### Added & Upgraded
- **User Profile Domain Upgrade**:
  - `UserProfileModel`: Extended with `dob`, `memberSince`, `avatarUrl`, and dynamic `linkedBankCount`.
  - `UserValidator`: Added full validation suite (`validateName`, `validateEmail`, `validateDOB` with age >= 18 check, `validatePhone`, `validateOTP`, `validatePAN`, and `validateAadhaar`).
  - `ProfileScreen`: Upgraded with user avatar, dynamic details, overview cards (Member Since, Linked Bank Accounts), KYC status badge, and sub-screen navigation.
  - `EditProfileScreen`: Built profile editing form with inline field validation and dedicated 6-digit OTP verification flow for mobile number updates.
- **KYC Verification Center & Multi-Step Wizard**:
  - `KYCModel`: Extended with `personalDetailsSubmitted`, `panVerified`, `documentUploaded`, `bankVerified`, `panNumber`, `verifiedDate`, and `rejectionReason`.
  - `KYCStatusScreen`: Built full verification center with 5-stage progress indicator, status banners (Verified, Under Review / Pending, Needs Action, Rejected), unlocked account benefits, and dynamic action buttons.
  - `KYCFlowScreen`: Interactive 5-step wizard covering Personal Details, PAN Verification, Identity Document upload simulation (Aadhaar, Passport, Driving Licence, Voter ID), Bank Account verification (integrating with `BankAccountRepository`), and Review & Submit step with success confirmation.
  - Outcomes Isolation: Encapsulated submission and status verification logic within `MockUserRepository`.
- **Settings & Security Upgrade**:
  - `SettingsScreen`: Grouped into Account, Security & Access (6-digit MPIN change, Biometric login switch, App lock switch), Notification Preferences (Payment, Recharge, Bills, Offers), App Preferences (Language selector: English / Hindi), Support, and Logout.
  - `PaymentMPINVerificationScreen`: Integrated into Security settings for authorized MPIN changes.
  - `AboutScreen`: Added config-driven demo mode badge, version/build indicators, and legal document links.
  - Session Management: Seamless session persistence with explicit logout confirmation modal clearing session via `SessionManager.instance.logout()`.
- **Home Integration**:
  - `HomeScreen`: Profile navigation awaits return to automatically refresh user greeting and KYC status badge via `HomeRepository`.
- **Widget Test Suites**:
  - Added `profile_upgrade_test.dart`, `kyc_flow_test.dart`, and `settings_upgrade_test.dart`. All 16 test suites passing.

## [1.3.0] - Phase 6 QR Payments, Transaction History & Notifications Upgrade - 2026-08-08

### Added & Upgraded
- **QR Payments Pipeline Upgrade**:
  - `QRType` Enum: Added support for `merchant`, `personal`, `invalid`, `expired`, and `unsupported` QR types.
  - `QRResolutionResult`: Defined structured resolution model.
  - `QrRepository`: Added `resolveQR` abstraction and deterministic implementation in `MockQrRepository`.
  - `DummyQrData`: Centralized deterministic QR payloads (`SRJ Foods`, `Rahul Sharma`, invalid, expired, and unsupported signatures).
  - `ScanQRScreen`: Upgraded with visual laser scanning animation, interactive Demo QR Scenarios selector, verified merchant banners, error modals with "Scan Again" CTA, and direct handoff to `AmountEntryScreen`.
- **Payments & Ledger Integration**:
  - Constructor Dependency Injection: Injected `TransactionRepository` and `NotificationRepository` into `MockPaymentsRepository`.
  - Centralized Transaction & Notification Creation: Executing payments creates records in `TransactionRepository` and dispatches alerts via `NotificationRepository`.
  - Centralized Outcome Rules: Retained ₹100 = FAILED, ₹200 = PENDING, other = SUCCESS simulation strictly inside `MockPaymentsRepository`.
- **Transaction History & Details Upgrade**:
  - Categories Filter: Added tabs for `All`, `Sent`, `Received`, `Recharge`, `Bills`, `QR Payments`, `Bank Transfer`, and `Wallet`.
  - Search Querying: Live filtering across recipient names, UPI IDs, transaction IDs, categories, and amounts.
  - `TransactionDetailScreen`: Created dedicated detail view with status banner, full metadata breakdown, UTR, Reference ID, and "View Receipt" CTA.
- **Notifications & Home Synchronization**:
  - `NotificationModel`: Extended with `actionRoute`, `relatedEntityId`, and `relatedTransactionId`.
  - `NotificationRepository`: Added `addNotification` interface and implementation.
  - `NotificationsScreen`: Supported mark as read on tap, meaningful navigation to `TransactionDetailScreen`, "Mark all read" header action, and swipe-to-delete.
  - `HomeScreen`: Automatically refreshes dashboard state and notification badges on return from payments, scanner, or notifications.
- **Widget Tests**:
  - Added `qr_payment_flow_test.dart`, `transaction_history_upgrade_test.dart`, and `notifications_upgrade_test.dart`.

## [1.2.0] - Phase 5 Recharge & Bills Product Upgrade - 2026-08-08

### Added & Upgraded
- **Recharge & Bills Domain Upgrade**:
  - `RechargePlanModel`: Added `operator`, `calls`, and `sms` allowance properties.
  - `BillModel`: Added `consumerName`, `billNumber`, `billDate`, and `lateFee` properties.
  - `dummyPlans` & `dummyBillers`: Expanded full catalog for Jio, Airtel, Vi, BSNL across Popular, Unlimited, Data, Validity, Talktime, and SMS categories, alongside complete BBPS utilities (Electricity, Water, DTH, LPG, Broadband, Mobile Postpaid).
  - Constructor Dependency Injection: Injected `TransactionRepository` into `MockRechargeRepository` and `MockBillRepository`.
  - Transaction Ledger Integration: Added `addTransaction` method to `TransactionRepository` and created transactions in the transaction ledger for all recharge and bill payments.
  - Dynamic Payment Source Selection: Reused wallet and linked bank accounts selector in checkout sheets.
  - 6-Digit MPIN Security: Reused `PaymentMPINVerificationScreen` keypad with callback hooks.
  - Processing & Outcomes: Created dedicated `RechargeProcessingScreen`, `RechargePendingScreen`, `RechargeFailedScreen`, `BillProcessingScreen`, `BillSuccessScreen`, `BillPendingScreen`, and `BillFailedScreen`.
  - Outcomes Isolation: Enforced ₹100 = FAILED and ₹200 = PENDING deterministic demo criteria exclusively inside `MockRechargeRepository` and `MockBillRepository`.
  - Widget Tests: Added `recharge_bills_flow_upgrade_test.dart` covering both recharge and bill flows end-to-end.

## [1.0.1] - 2026-08-07

### Added
- **Production Hardening & Release Readiness:** Set up abstract Dio API clients, network request interceptors, PIN lock manager, encryption utils, Firebase mock services, localizations base, unit and widget test files, and GitHub actions configuration.
- **Travel Enterprise Production Readiness:** Restructured flight ticketing, train berth allocations, bus layouts, hotel suites booking, and multiplex movie seats tracking flows to fetch data models via `MockTravelRepository` under `lib/features/travel/`.
- **Financial Products Production Readiness:** Consolidated loans eligibility checks, insurance coverage summaries, and investment portfolio tracking maps under a unified directory structure inside `lib/features/financial/`.
- **Merchant & Rewards Production Readiness:** Centralized all sales analytics, settlements timelines, cashback status, scratch cards, and active coupon codes under `lib/features/merchant/` and `lib/features/rewards/`.
- **Persistent Login Session (Demo Mode):** Integrated persistent session tracking via `SecureStorageService` and `SharedPreferences` to keep users logged in until they explicitly logout.
- **User Domain Production Readiness:** Centralized all settings configs, KYC verification details, and profile parameters under `lib/features/user/`.
- **Recharge & Bills Production Readiness:** Upgraded operators and utilities plan selectors to mock repositories under `lib/features/recharge/` and `lib/features/bills/`.
- **Transactions & Notifications Production Readiness:** Upgraded transaction histories and alerts feeds to use structured models and mock repository contracts under `lib/features/transactions/` and `lib/features/notifications/`.
- **QR Production Readiness:** Consolidated scan_qr and my_qr into a unified `qr` module layout. Linked scanner and personal display triggers to `MockQrRepository` and model serializers.
- **Payments Production Readiness:** Upgraded the payments module directory structure into Domain-Driven Design (DDD) layers. Controlled via mock repository contracts.
- **Dedicated Payment outcome screens:** Added `PaymentPendingScreen`, `PaymentFailedScreen`, and a detailed `ReceiptScreen` mapping transaction UTR codes.
- **Global AppConfig Configuration:** Global AppConfig introduced for application-wide configuration.
- **Authentication Demo Mode:** Added for client presentation. Controlled via `AppConfig.isDemoMode`.
- **Dynamic OTP verification stubs:** Accept any 6-digit verification code under Demo Mode (e.g., 000000, 111111, 999999).
- **Consolidated logging console output prefixes:** Prepend `[DEMO MODE]` logs to authentication flows.
