import 'package:payout/features/travel/shared/models/travel_models.dart';
import 'package:payout/features/travel/shared/dummy/dummy_travel_data.dart';
import 'package:payout/features/travel/shared/services/travel_logger.dart';

abstract class TravelRepository {
  Future<List<FlightModel>> getFlights();
  Future<List<TrainModel>> getTrains();
  Future<List<BusModel>> getBuses();
  Future<List<HotelModel>> getHotels();
  Future<List<MovieModel>> getMovies();
  Future<bool> bookTicket(String category, String itemId, double totalCost);
  Future<bool> cancelBooking(String bookingId);
}

class MockTravelRepository implements TravelRepository {
  @override
  Future<List<FlightModel>> getFlights() async {
    // TODO: Connect commercial aviation schedules API
    await Future.delayed(const Duration(milliseconds: 400));
    return List.from(DummyTravelData.dummyFlights);
  }

  @override
  Future<List<TrainModel>> getTrains() async {
    // TODO: Connect IRCTC reservation endpoints
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(DummyTravelData.dummyTrains);
  }

  @override
  Future<List<BusModel>> getBuses() async {
    // TODO: Connect local bus operators catalogs aggregator
    await Future.delayed(const Duration(milliseconds: 350));
    return List.from(DummyTravelData.dummyBuses);
  }

  @override
  Future<List<HotelModel>> getHotels() async {
    // TODO: Connect bookings listing inventories API
    await Future.delayed(const Duration(milliseconds: 450));
    return List.from(DummyTravelData.dummyHotels);
  }

  @override
  Future<List<MovieModel>> getMovies() async {
    // TODO: Connect multiplex cinema showtimes aggregator API
    await Future.delayed(const Duration(milliseconds: 250));
    return List.from(DummyTravelData.dummyMovies);
  }

  @override
  Future<bool> bookTicket(String category, String itemId, double totalCost) async {
    // TODO: Connect tickets inventory locks and payment captures API
    await Future.delayed(const Duration(milliseconds: 600));
    TravelLogger.logBookingSubmitted(category, itemId, totalCost);
    return true;
  }

  @override
  Future<bool> cancelBooking(String bookingId) async {
    // TODO: Connect refund processing and cancellation API gateway
    await Future.delayed(const Duration(milliseconds: 500));
    TravelLogger.logBookingCancelled(bookingId);
    return true;
  }
}
