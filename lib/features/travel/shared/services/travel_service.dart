import 'package:payout/features/travel/shared/models/travel_models.dart';

class TravelService {
  // ==========================================
  // 1. FARE CALCULATIONS
  // ==========================================

  /// Calculate full flight fare breakdown (Base + 12% GST + Convenience Fee - Discount)
  static FlightFareModel calculateFlightFare({
    required double basePricePerPassenger,
    required int passengers,
    double discount = 0.0,
  }) {
    final baseFare = basePricePerPassenger * passengers;
    final taxes = baseFare * 0.12; // 12% GST
    final convenienceFee = 250.0 * passengers;
    final total = (baseFare + taxes + convenienceFee - discount).clamp(0.0, double.infinity);

    return FlightFareModel(
      baseFare: baseFare,
      taxes: taxes,
      convenienceFee: convenienceFee,
      discount: discount,
      totalFare: total,
    );
  }

  /// Calculate train total fare (Fares per class + ₹30 IRCTC convenience charge)
  static double calculateTrainFare({
    required double classFare,
    required int passengers,
  }) {
    if (classFare <= 0 || passengers <= 0) return 0.0;
    const irctcServiceCharge = 35.40; // ₹30 + 18% GST
    return (classFare * passengers) + irctcServiceCharge;
  }

  /// Calculate bus fare from chosen seats
  static double calculateBusFare({
    required List<BusSeatModel> selectedSeats,
  }) {
    if (selectedSeats.isEmpty) return 0.0;
    final seatTotal = selectedSeats.fold<double>(0.0, (sum, s) => sum + s.price);
    const busGst = 0.05; // 5% GST
    return seatTotal + (seatTotal * busGst);
  }

  /// Calculate hotel duration in nights
  static int calculateStayNights(DateTime checkIn, DateTime checkOut) {
    final diff = checkOut.difference(checkIn).inDays;
    return diff > 0 ? diff : 1;
  }

  /// Calculate hotel stay pricing breakdown
  static Map<String, double> calculateHotelPricing({
    required double pricePerNight,
    required int nights,
    required int rooms,
  }) {
    final roomCharges = pricePerNight * nights * rooms;
    final taxes = roomCharges * 0.18; // 18% Luxury hospitality GST
    final total = roomCharges + taxes;

    return {
      'roomCharges': roomCharges,
      'taxes': taxes,
      'total': total,
    };
  }

  /// Calculate cinema ticket pricing breakdown (Seats + Convenience Fee + 18% GST on fee)
  static Map<String, double> calculateMoviePricing({
    required List<MovieSeatModel> selectedSeats,
    double feePerTicket = 25.0,
  }) {
    if (selectedSeats.isEmpty) {
      return {'subtotal': 0.0, 'convenienceFee': 0.0, 'taxes': 0.0, 'total': 0.0};
    }

    final subtotal = selectedSeats.fold<double>(0.0, (sum, s) => sum + s.price);
    final convenienceFee = feePerTicket * selectedSeats.length;
    final taxes = convenienceFee * 0.18; // 18% GST on convenience fee
    final total = subtotal + convenienceFee + taxes;

    return {
      'subtotal': subtotal,
      'convenienceFee': convenienceFee,
      'taxes': taxes,
      'total': total,
    };
  }

  /// Calculate demo refund and cancellation penalty
  static Map<String, double> calculateRefundEstimate(TravelBookingModel booking) {
    double cancellationFeePercent = 0.20; // 20% standard cancellation fee
    if (booking.category == 'Flight') {
      cancellationFeePercent = 0.25;
    } else if (booking.category == 'Movie') {
      cancellationFeePercent = 0.50; // Higher cinema last-minute penalty
    } else if (booking.category == 'Hotel') {
      cancellationFeePercent = 0.15;
    }

    final cancellationFee = booking.totalAmount * cancellationFeePercent;
    final estimatedRefund = (booking.totalAmount - cancellationFee).clamp(0.0, double.infinity);

    return {
      'cancellationFee': cancellationFee,
      'estimatedRefund': estimatedRefund,
    };
  }

  // ==========================================
  // 2. FILTERING & SORTING ENGINES
  // ==========================================

  static List<FlightModel> filterFlights(
    List<FlightModel> flights, {
    bool nonStopOnly = false,
    String? airline,
    String sortBy = 'price', // price, duration, departure
  }) {
    var result = List<FlightModel>.from(flights);

    if (nonStopOnly) {
      result = result.where((f) => f.stops == 0).toList();
    }
    if (airline != null && airline.isNotEmpty && airline != 'All Airlines') {
      result = result.where((f) => f.airline.toLowerCase().contains(airline.toLowerCase())).toList();
    }

    if (sortBy == 'price') {
      result.sort((a, b) => a.price.compareTo(b.price));
    } else if (sortBy == 'duration') {
      result.sort((a, b) => a.duration.compareTo(b.duration));
    } else if (sortBy == 'departure') {
      result.sort((a, b) => a.departureTime.compareTo(b.departureTime));
    }

    return result;
  }

  static List<TrainModel> filterTrains(
    List<TrainModel> trains, {
    String? selectedClass,
  }) {
    if (selectedClass == null || selectedClass.isEmpty || selectedClass == 'All Classes') {
      return trains;
    }
    return trains.where((t) => t.classes.any((c) => c.className == selectedClass)).toList();
  }

  static List<BusModel> filterBuses(
    List<BusModel> buses, {
    bool? isAC,
    String? busType,
    String sortBy = 'price',
  }) {
    var result = List<BusModel>.from(buses);

    if (isAC != null) {
      result = result.where((b) => isAC ? b.busType.contains('AC') : !b.busType.contains('AC')).toList();
    }
    if (busType != null && busType.isNotEmpty && busType != 'All Types') {
      result = result.where((b) => b.busType.toLowerCase().contains(busType.toLowerCase())).toList();
    }

    if (sortBy == 'price') {
      result.sort((a, b) => a.price.compareTo(b.price));
    } else if (sortBy == 'rating') {
      result.sort((a, b) => b.rating.compareTo(a.rating));
    }

    return result;
  }

  static List<HotelModel> filterHotels(
    List<HotelModel> hotels, {
    double minRating = 0.0,
    String? propertyType,
    String sortBy = 'recommended', // recommended, price_low, price_high, rating
  }) {
    var result = List<HotelModel>.from(hotels);

    if (minRating > 0.0) {
      result = result.where((h) => h.rating >= minRating).toList();
    }
    if (propertyType != null && propertyType.isNotEmpty && propertyType != 'All') {
      result = result.where((h) => h.propertyType.toLowerCase().contains(propertyType.toLowerCase())).toList();
    }

    if (sortBy == 'price_low') {
      result.sort((a, b) => a.pricePerNight.compareTo(b.pricePerNight));
    } else if (sortBy == 'price_high') {
      result.sort((a, b) => b.pricePerNight.compareTo(a.pricePerNight));
    } else if (sortBy == 'rating') {
      result.sort((a, b) => b.rating.compareTo(a.rating));
    }

    return result;
  }

  static List<MovieModel> filterMovies(
    List<MovieModel> movies, {
    String? language,
    String? genre,
    bool nowShowingOnly = false,
  }) {
    var result = List<MovieModel>.from(movies);

    if (nowShowingOnly) {
      result = result.where((m) => m.isNowShowing).toList();
    }
    if (language != null && language.isNotEmpty && language != 'All') {
      result = result.where((m) => m.language.toLowerCase() == language.toLowerCase()).toList();
    }
    if (genre != null && genre.isNotEmpty && genre != 'All') {
      result = result.where((m) => m.genre.toLowerCase().contains(genre.toLowerCase())).toList();
    }

    return result;
  }
}
