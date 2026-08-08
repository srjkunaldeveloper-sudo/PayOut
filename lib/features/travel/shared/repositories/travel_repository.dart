import 'package:payout/features/notifications/models/notification_models.dart';
import 'package:payout/features/notifications/repositories/notification_repository.dart';
import 'package:payout/features/transactions/models/transaction_models.dart';
import 'package:payout/features/transactions/repositories/transaction_repository.dart';
import 'package:payout/features/travel/shared/dummy/dummy_travel_data.dart';
import 'package:payout/features/travel/shared/models/travel_models.dart';
import 'package:payout/features/travel/shared/services/travel_logger.dart';

abstract class TravelRepository {
  // TODO(api): GET /travel/flights/search?from={from}&to={to}&date={date}&passengers={passengers}
  Future<List<FlightModel>> searchFlights(FlightSearchRequest request);

  // TODO(api): GET /travel/trains/search?from={from}&to={to}&date={date}&class={class}
  Future<List<TrainModel>> searchTrains(TrainSearchRequest request);

  // TODO(api): GET /travel/buses/search?from={from}&to={to}&date={date}&isAC={isAC}
  Future<List<BusModel>> searchBuses(BusSearchRequest request);

  // TODO(api): GET /travel/hotels/search?city={city}&checkIn={checkIn}&checkOut={checkOut}&guests={guests}
  Future<List<HotelModel>> searchHotels(HotelSearchRequest request);

  // TODO(api): GET /travel/movies?city={city}
  Future<List<MovieModel>> getMovies({String? city});

  // TODO(api): GET /travel/movies/{movieId}/theatres?city={city}&date={date}
  Future<List<MovieTheatreModel>> getMovieTheatres(String movieId, {required String city, required String date});

  // TODO(api): GET /travel/movies/{movieId}/theatres/{theatreId}/shows?date={date}
  Future<List<MovieShowModel>> getMovieShows(String movieId, String theatreId, {required String date});

  // TODO(api): GET /travel/shows/{showId}/seats
  Future<List<MovieSeatModel>> getMovieSeats(String showId, {double basePrice = 350.0});

  // TODO(api): POST /travel/bookings
  Future<TravelBookingModel> createBooking(TravelBookingModel booking);

  // TODO(api): GET /travel/bookings/{id}
  Future<TravelBookingModel?> getBooking(String bookingId);

  // TODO(api): GET /travel/bookings?category={category}&status={status}
  Future<List<TravelBookingModel>> getBookings({String? category, String? status});

  // TODO(api): POST /travel/bookings/{id}/cancel
  Future<bool> cancelBooking(String bookingId);
}

class MockTravelRepository implements TravelRepository {
  final TransactionRepository _transactionRepository;
  final NotificationRepository _notificationRepository;
  final List<TravelBookingModel> _bookings = List.from(DummyTravelData.dummyBookings);

  MockTravelRepository({
    required TransactionRepository transactionRepository,
    required NotificationRepository notificationRepository,
  })  : _transactionRepository = transactionRepository,
        _notificationRepository = notificationRepository;

  @override
  Future<List<FlightModel>> searchFlights(FlightSearchRequest request) async {
    // TODO(api): Connect commercial flight schedules and seat availability API
    await Future.delayed(const Duration(milliseconds: 350));
    return List.from(DummyTravelData.dummyFlights);
  }

  @override
  Future<List<TrainModel>> searchTrains(TrainSearchRequest request) async {
    // TODO(api): Connect IRCTC railway reservation and live availability API
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(DummyTravelData.dummyTrains);
  }

  @override
  Future<List<BusModel>> searchBuses(BusSearchRequest request) async {
    // TODO(api): Connect intercity bus operator seat inventory API
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(DummyTravelData.dummyBuses);
  }

  @override
  Future<List<HotelModel>> searchHotels(HotelSearchRequest request) async {
    // TODO(api): Connect hotel property inventory and live room rate API
    await Future.delayed(const Duration(milliseconds: 350));
    return List.from(DummyTravelData.dummyHotels);
  }

  @override
  Future<List<MovieModel>> getMovies({String? city}) async {
    // TODO(api): Connect cinema distribution and multiplex catalogue API
    await Future.delayed(const Duration(milliseconds: 250));
    return List.from(DummyTravelData.dummyMovies);
  }

  @override
  Future<List<MovieTheatreModel>> getMovieTheatres(String movieId, {required String city, required String date}) async {
    // TODO(api): Connect multiplex theatre listings and city screen API
    await Future.delayed(const Duration(milliseconds: 200));
    return List.from(DummyTravelData.dummyTheatres);
  }

  @override
  Future<List<MovieShowModel>> getMovieShows(String movieId, String theatreId, {required String date}) async {
    // TODO(api): Connect theatre showtimes schedule API
    await Future.delayed(const Duration(milliseconds: 200));
    return List.from(DummyTravelData.dummyShows);
  }

  @override
  Future<List<MovieSeatModel>> getMovieSeats(String showId, {double basePrice = 350.0}) async {
    // TODO(api): Connect real-time cinema seat lock and allocation API
    await Future.delayed(const Duration(milliseconds: 200));
    return DummyTravelData.generateCinemaSeats(basePrice);
  }

  @override
  Future<TravelBookingModel> createBooking(TravelBookingModel booking) async {
    // TODO(api): Connect unified booking confirmation and ticketing engine API
    await Future.delayed(const Duration(milliseconds: 400));

    // Centralized demo outcome simulation:
    // ₹100.00 -> FAILED
    // ₹200.00 -> PAYMENT_PENDING
    // Other amounts -> CONFIRMED
    String outcomeStatus = 'CONFIRMED';
    if (booking.totalAmount == 100.0) {
      outcomeStatus = 'FAILED';
    } else if (booking.totalAmount == 200.0) {
      outcomeStatus = 'PAYMENT_PENDING';
    }

    final confirmedBooking = booking.copyWith(status: outcomeStatus);
    _bookings.insert(0, confirmedBooking);

    if (outcomeStatus == 'CONFIRMED') {
      // 1. Ledger Record
      await _transactionRepository.addTransaction(
        TransactionModel(
          id: confirmedBooking.transactionId,
          title: '${confirmedBooking.category} Booking - ${confirmedBooking.title}',
          upiId: '${confirmedBooking.category.toLowerCase()}@payout',
          type: 'DEBIT',
          category: '${confirmedBooking.category} Booking',
          amount: confirmedBooking.totalAmount,
          date: 'Today',
          status: 'SUCCESS',
          paymentMethod: 'UPI / Wallet',
          utr: 'UTR${DateTime.now().millisecondsSinceEpoch.toString().substring(1)}',
          referenceNumber: confirmedBooking.referenceCode,
        ),
      );

      // 2. Notification Dispatch
      await _notificationRepository.addNotification(
        NotificationModel(
          id: 'NOT-TRV-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
          title: '${confirmedBooking.category} Booking Confirmed! 🎉',
          description: 'Your ${confirmedBooking.category.toLowerCase()} booking with ${confirmedBooking.title} is confirmed. Ref: ${confirmedBooking.referenceCode}.',
          category: 'Payment',
          time: 'Just now',
          isRead: false,
          actionRoute: '/travel/bookings',
          relatedEntityId: confirmedBooking.id,
          relatedTransactionId: confirmedBooking.transactionId,
        ),
      );

      TravelLogger.logBookingSubmitted(confirmedBooking.category, confirmedBooking.title, confirmedBooking.totalAmount);
    }

    return confirmedBooking;
  }

  @override
  Future<TravelBookingModel?> getBooking(String bookingId) async {
    // TODO(api): Connect booking lookup by ID API
    await Future.delayed(const Duration(milliseconds: 150));
    try {
      return _bookings.firstWhere((b) => b.id == bookingId);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<TravelBookingModel>> getBookings({String? category, String? status}) async {
    // TODO(api): Connect user bookings history API
    await Future.delayed(const Duration(milliseconds: 250));
    var results = List<TravelBookingModel>.from(_bookings);

    if (category != null && category.isNotEmpty && category != 'All') {
      results = results.where((b) => b.category.toLowerCase() == category.toLowerCase()).toList();
    }
    if (status != null && status.isNotEmpty) {
      results = results.where((b) => b.status.toUpperCase() == status.toUpperCase()).toList();
    }

    return results;
  }

  @override
  Future<bool> cancelBooking(String bookingId) async {
    // TODO(api): Connect booking cancellation and refund processing API
    await Future.delayed(const Duration(milliseconds: 350));
    final index = _bookings.indexWhere((b) => b.id == bookingId);
    if (index != -1) {
      final old = _bookings[index];
      _bookings[index] = old.copyWith(status: 'CANCELLED');

      // Dispatch cancellation alert
      await _notificationRepository.addNotification(
        NotificationModel(
          id: 'NOT-CAN-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
          title: '${old.category} Booking Cancelled',
          description: 'Your booking for ${old.title} (${old.referenceCode}) has been cancelled.',
          category: 'Payment',
          time: 'Just now',
          isRead: false,
          actionRoute: '/travel/bookings',
          relatedEntityId: old.id,
        ),
      );

      TravelLogger.logBookingCancelled(bookingId);
      return true;
    }
    return false;
  }
}
