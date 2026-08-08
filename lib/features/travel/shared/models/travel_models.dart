// ==========================================
// 1. FLIGHT MODELS
// ==========================================

class FlightSearchRequest {
  final String from;
  final String to;
  final DateTime departureDate;
  final DateTime? returnDate;
  final bool isRoundTrip;
  final int passengers;
  final String cabinClass; // Economy, Premium Economy, Business

  const FlightSearchRequest({
    required this.from,
    required this.to,
    required this.departureDate,
    this.returnDate,
    this.isRoundTrip = false,
    this.passengers = 1,
    this.cabinClass = 'Economy',
  });
}

class FlightFareModel {
  final double baseFare;
  final double taxes;
  final double convenienceFee;
  final double discount;
  final double totalFare;

  const FlightFareModel({
    required this.baseFare,
    required this.taxes,
    required this.convenienceFee,
    required this.discount,
    required this.totalFare,
  });
}

class FlightModel {
  final String id;
  final String airline;
  final String flightNumber;
  final String from;
  final String to;
  final String departureTime;
  final String arrivalTime;
  final String duration;
  final int stops; // 0 for Non-stop
  final String baggage;
  final double price;
  final bool isRefundable;
  final List<String> amenities;

  const FlightModel({
    required this.id,
    required this.airline,
    required this.flightNumber,
    required this.from,
    required this.to,
    required this.departureTime,
    required this.arrivalTime,
    required this.duration,
    this.stops = 0,
    this.baggage = '15 kg Check-in, 7 kg Cabin',
    required this.price,
    this.isRefundable = true,
    this.amenities = const ['Snacks', 'USB Power', 'Legroom'],
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'airline': airline,
        'flightNumber': flightNumber,
        'from': from,
        'to': to,
        'departureTime': departureTime,
        'arrivalTime': arrivalTime,
        'duration': duration,
        'stops': stops,
        'baggage': baggage,
        'price': price,
        'isRefundable': isRefundable,
        'amenities': amenities,
      };

  factory FlightModel.fromJson(Map<String, dynamic> json) => FlightModel(
        id: json['id'] as String,
        airline: json['airline'] as String,
        flightNumber: json['flightNumber'] as String,
        from: json['from'] as String,
        to: json['to'] as String,
        departureTime: json['departureTime'] as String? ?? '06:00',
        arrivalTime: json['arrivalTime'] as String? ?? '08:15',
        duration: json['duration'] as String? ?? '2h 15m',
        stops: json['stops'] as int? ?? 0,
        baggage: json['baggage'] as String? ?? '15 kg Check-in',
        price: (json['price'] as num).toDouble(),
        isRefundable: json['isRefundable'] as bool? ?? true,
        amenities: (json['amenities'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const [],
      );
}

class FlightPassengerModel {
  final String fullName;
  final String dateOfBirth;
  final String gender;
  final String mobile;
  final String email;
  final String idType;
  final String idNumber;

  const FlightPassengerModel({
    required this.fullName,
    required this.dateOfBirth,
    required this.gender,
    required this.mobile,
    required this.email,
    this.idType = 'Aadhaar',
    this.idNumber = '',
  });

  Map<String, dynamic> toJson() => {
        'fullName': fullName,
        'dateOfBirth': dateOfBirth,
        'gender': gender,
        'mobile': mobile,
        'email': email,
        'idType': idType,
        'idNumber': idNumber,
      };
}

// ==========================================
// 2. TRAIN MODELS
// ==========================================

class TrainSearchRequest {
  final String from;
  final String to;
  final DateTime journeyDate;
  final int passengers;
  final String selectedClass;

  const TrainSearchRequest({
    required this.from,
    required this.to,
    required this.journeyDate,
    this.passengers = 1,
    this.selectedClass = 'All Classes',
  });
}

class TrainClassAvailability {
  final String className; // SL, 3A, 2A, 1A, CC, 2S
  final double fare;
  final String status; // AVAILABLE, RAC, WL, NOT_AVAILABLE
  final int seatsAvailable;

  const TrainClassAvailability({
    required this.className,
    required this.fare,
    required this.status,
    required this.seatsAvailable,
  });

  Map<String, dynamic> toJson() => {
        'className': className,
        'fare': fare,
        'status': status,
        'seatsAvailable': seatsAvailable,
      };
}

class TrainModel {
  final String id;
  final String trainName;
  final String trainNumber;
  final String from;
  final String to;
  final String departureTime;
  final String arrivalTime;
  final String duration;
  final List<String> runningDays;
  final List<TrainClassAvailability> classes;
  final double price; // Lowest base price

  const TrainModel({
    required this.id,
    required this.trainName,
    required this.trainNumber,
    required this.from,
    required this.to,
    required this.departureTime,
    required this.arrivalTime,
    required this.duration,
    required this.runningDays,
    required this.classes,
    required this.price,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'trainName': trainName,
        'trainNumber': trainNumber,
        'from': from,
        'to': to,
        'departureTime': departureTime,
        'arrivalTime': arrivalTime,
        'duration': duration,
        'runningDays': runningDays,
        'classes': classes.map((c) => c.toJson()).toList(),
        'price': price,
      };

  factory TrainModel.fromJson(Map<String, dynamic> json) => TrainModel(
        id: json['id'] as String,
        trainName: json['trainName'] as String,
        trainNumber: json['trainNumber'] as String,
        from: json['from'] as String,
        to: json['to'] as String,
        departureTime: json['departureTime'] as String? ?? '16:55',
        arrivalTime: json['arrivalTime'] as String? ?? '08:35',
        duration: json['duration'] as String? ?? '15h 40m',
        runningDays: (json['runningDays'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const ['M', 'T', 'W', 'T', 'F', 'S', 'S'],
        classes: const [],
        price: (json['price'] as num).toDouble(),
      );
}

class TrainPassengerModel {
  final String name;
  final int age;
  final String gender;
  final String berthPreference; // Lower, Middle, Upper, Side Lower, Side Upper, No Preference

  const TrainPassengerModel({
    required this.name,
    required this.age,
    required this.gender,
    this.berthPreference = 'No Preference',
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'age': age,
        'gender': gender,
        'berthPreference': berthPreference,
      };
}

// ==========================================
// 3. BUS MODELS
// ==========================================

class BusSearchRequest {
  final String from;
  final String to;
  final DateTime travelDate;
  final bool? isAC;

  const BusSearchRequest({
    required this.from,
    required this.to,
    required this.travelDate,
    this.isAC,
  });
}

class BusSeatModel {
  final String seatNumber;
  final int row;
  final int col;
  final bool isAvailable;
  final bool isLadies;
  final bool isSleeper;
  final double price;

  const BusSeatModel({
    required this.seatNumber,
    required this.row,
    required this.col,
    required this.isAvailable,
    this.isLadies = false,
    this.isSleeper = false,
    required this.price,
  });

  Map<String, dynamic> toJson() => {
        'seatNumber': seatNumber,
        'row': row,
        'col': col,
        'isAvailable': isAvailable,
        'isLadies': isLadies,
        'isSleeper': isSleeper,
        'price': price,
      };
}

class BusModel {
  final String id;
  final String operatorName;
  final String busType; // AC Sleeper (2+1), Bharat Benz AC Seater, Non-AC Seater
  final String from;
  final String to;
  final String departureTime;
  final String arrivalTime;
  final String duration;
  final double rating;
  final List<String> amenities;
  final double price;
  final int availableSeats;
  final List<BusSeatModel> seats;

  const BusModel({
    required this.id,
    required this.operatorName,
    required this.busType,
    required this.from,
    required this.to,
    required this.departureTime,
    required this.arrivalTime,
    required this.duration,
    this.rating = 4.5,
    this.amenities = const ['Live Tracking', 'Charging Point', 'Water Bottle', 'Blanket'],
    required this.price,
    this.availableSeats = 28,
    this.seats = const [],
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'operatorName': operatorName,
        'busType': busType,
        'from': from,
        'to': to,
        'departureTime': departureTime,
        'arrivalTime': arrivalTime,
        'duration': duration,
        'rating': rating,
        'amenities': amenities,
        'price': price,
        'availableSeats': availableSeats,
        'seats': seats.map((s) => s.toJson()).toList(),
      };

  factory BusModel.fromJson(Map<String, dynamic> json) => BusModel(
        id: json['id'] as String,
        operatorName: json['operatorName'] as String,
        busType: json['busType'] as String? ?? 'AC Sleeper',
        from: json['from'] as String,
        to: json['to'] as String,
        departureTime: json['departureTime'] as String? ?? '21:00',
        arrivalTime: json['arrivalTime'] as String? ?? '06:30',
        duration: json['duration'] as String? ?? '9h 30m',
        price: (json['price'] as num).toDouble(),
      );
}

class BusPassengerModel {
  final String name;
  final int age;
  final String gender;
  final String mobile;
  final String seatNumber;

  const BusPassengerModel({
    required this.name,
    required this.age,
    required this.gender,
    required this.mobile,
    required this.seatNumber,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'age': age,
        'gender': gender,
        'mobile': mobile,
        'seatNumber': seatNumber,
      };
}

// ==========================================
// 4. HOTEL MODELS
// ==========================================

class HotelSearchRequest {
  final String city;
  final DateTime checkIn;
  final DateTime checkOut;
  final int guests;
  final int rooms;

  const HotelSearchRequest({
    required this.city,
    required this.checkIn,
    required this.checkOut,
    this.guests = 2,
    this.rooms = 1,
  });
}

class HotelRoomModel {
  final String id;
  final String roomType; // Standard, Deluxe, Executive Suite
  final int occupancy;
  final String bedType; // King Bed, Twin Beds
  final List<String> amenities;
  final double pricePerNight;
  final String cancellationPolicy;

  const HotelRoomModel({
    required this.id,
    required this.roomType,
    this.occupancy = 2,
    required this.bedType,
    required this.amenities,
    required this.pricePerNight,
    this.cancellationPolicy = 'Free cancellation up to 24 hours before check-in',
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'roomType': roomType,
        'occupancy': occupancy,
        'bedType': bedType,
        'amenities': amenities,
        'pricePerNight': pricePerNight,
        'cancellationPolicy': cancellationPolicy,
      };
}

class HotelModel {
  final String id;
  final String name;
  final String city;
  final String location;
  final double pricePerNight;
  final double rating;
  final int reviewCount;
  final List<String> amenities;
  final String propertyType; // 5-Star Hotel, Boutique Resort, Luxury Villa
  final List<HotelRoomModel> rooms;
  final String cancellationPolicy;

  const HotelModel({
    required this.id,
    required this.name,
    required this.city,
    required this.location,
    required this.pricePerNight,
    this.rating = 4.5,
    this.reviewCount = 1240,
    this.amenities = const ['Free WiFi', 'Swimming Pool', 'Spa & Fitness', 'Breakfast Included', 'Restaurant'],
    this.propertyType = '5-Star Hotel',
    this.rooms = const [],
    this.cancellationPolicy = 'Free cancellation available',
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'city': city,
        'location': location,
        'pricePerNight': pricePerNight,
        'rating': rating,
        'reviewCount': reviewCount,
        'amenities': amenities,
        'propertyType': propertyType,
        'rooms': rooms.map((r) => r.toJson()).toList(),
        'cancellationPolicy': cancellationPolicy,
      };

  factory HotelModel.fromJson(Map<String, dynamic> json) => HotelModel(
        id: json['id'] as String,
        name: json['name'] as String,
        city: json['city'] as String? ?? 'New Delhi',
        location: json['location'] as String,
        pricePerNight: (json['pricePerNight'] as num).toDouble(),
        rating: (json['rating'] as num).toDouble(),
      );
}

class HotelGuestModel {
  final String guestName;
  final String mobile;
  final String email;
  final int numberOfGuests;
  final String specialRequest;

  const HotelGuestModel({
    required this.guestName,
    required this.mobile,
    required this.email,
    this.numberOfGuests = 2,
    this.specialRequest = '',
  });

  Map<String, dynamic> toJson() => {
        'guestName': guestName,
        'mobile': mobile,
        'email': email,
        'numberOfGuests': numberOfGuests,
        'specialRequest': specialRequest,
      };
}

// ==========================================
// 5. MOVIE & DISTRICT/ZOMATO MODELS
// ==========================================

class MovieModel {
  final String id;
  final String title;
  final String posterUrl;
  final String language;
  final String genre;
  final double rating;
  final int votes;
  final String duration;
  final String releaseDate;
  final String synopsis;
  final List<String> cast;
  final List<String> formats; // 2D, 3D, IMAX, 4DX
  final bool isNowShowing;

  const MovieModel({
    required this.id,
    required this.title,
    this.posterUrl = '',
    required this.language,
    required this.genre,
    this.rating = 8.8,
    this.votes = 42500,
    required this.duration,
    required this.releaseDate,
    required this.synopsis,
    required this.cast,
    this.formats = const ['2D', '3D', 'IMAX 3D'],
    this.isNowShowing = true,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'posterUrl': posterUrl,
        'language': language,
        'genre': genre,
        'rating': rating,
        'votes': votes,
        'duration': duration,
        'releaseDate': releaseDate,
        'synopsis': synopsis,
        'cast': cast,
        'formats': formats,
        'isNowShowing': isNowShowing,
      };

  factory MovieModel.fromJson(Map<String, dynamic> json) => MovieModel(
        id: json['id'] as String,
        title: json['title'] as String,
        language: json['language'] as String? ?? 'Hindi',
        genre: json['genre'] as String,
        duration: json['duration'] as String? ?? '2h 30m',
        releaseDate: json['releaseDate'] as String? ?? '2026',
        synopsis: json['synopsis'] as String? ?? '',
        cast: (json['cast'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const [],
      );
}

class MovieTheatreModel {
  final String id;
  final String name;
  final String city;
  final String location;
  final String distance;
  final double rating;
  final List<String> amenities;
  final String cancellationPolicy;

  const MovieTheatreModel({
    required this.id,
    required this.name,
    required this.city,
    required this.location,
    this.distance = '2.4 km away',
    this.rating = 4.6,
    this.amenities = const ['Recliner Seats', 'Dolby Atmos', 'Food Court', 'Parking'],
    this.cancellationPolicy = 'Cancellation available up to 2 hours before show',
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'city': city,
        'location': location,
        'distance': distance,
        'rating': rating,
        'amenities': amenities,
        'cancellationPolicy': cancellationPolicy,
      };
}

class MovieShowModel {
  final String id;
  final String movieId;
  final String theatreId;
  final String time; // e.g. 11:30 AM
  final String format; // 2D, 3D, IMAX, 4DX
  final String language;
  final double pricePerSeat;
  final int availableSeats;

  const MovieShowModel({
    required this.id,
    required this.movieId,
    required this.theatreId,
    required this.time,
    this.format = '2D',
    this.language = 'Hindi',
    required this.pricePerSeat,
    this.availableSeats = 48,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'movieId': movieId,
        'theatreId': theatreId,
        'time': time,
        'format': format,
        'language': language,
        'pricePerSeat': pricePerSeat,
        'availableSeats': availableSeats,
      };
}

class MovieSeatModel {
  final String id; // e.g. A1, B4
  final String row; // A, B, C
  final int number; // 1, 2, 3
  final String type; // Regular, Premium, Recliner
  final double price;
  final bool isAvailable;

  const MovieSeatModel({
    required this.id,
    required this.row,
    required this.number,
    this.type = 'Regular',
    required this.price,
    this.isAvailable = true,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'row': row,
        'number': number,
        'type': type,
        'price': price,
        'isAvailable': isAvailable,
      };
}

// ==========================================
// 6. UNIVERSAL BOOKING & LEDGER MODELS
// ==========================================

enum TravelBookingStatus {
  initiated,
  processing,
  confirmed,
  paymentPending,
  failed,
  cancelled,
}

class TravelBookingModel {
  final String id;
  final String category; // Flight, Train, Bus, Hotel, Movie
  final String title; // Airline / Train Name / Operator / Hotel / Movie
  final String subtitle; // Flight No / Train No / Room Type / Theatre
  final String routeOrLocation;
  final String travelDate;
  final String returnOrCheckOutDate;
  final int quantity; // Passengers / Guests / Seats / Rooms
  final List<String> seatOrRoomNumbers;
  final String primaryContactName;
  final String contactPhone;
  final double totalAmount;
  final double convenienceFee;
  final double taxes;
  final double discount;
  final String status; // CONFIRMED, PAYMENT_PENDING, FAILED, CANCELLED
  final String referenceCode; // PNR / E-Ticket No / Hotel Voucher
  final String transactionId;
  final String createdAt;
  final String cancellationPolicy;
  final double demoRefundEstimate;

  const TravelBookingModel({
    required this.id,
    required this.category,
    required this.title,
    required this.subtitle,
    required this.routeOrLocation,
    required this.travelDate,
    this.returnOrCheckOutDate = '',
    this.quantity = 1,
    this.seatOrRoomNumbers = const [],
    required this.primaryContactName,
    required this.contactPhone,
    required this.totalAmount,
    this.convenienceFee = 0.0,
    this.taxes = 0.0,
    this.discount = 0.0,
    required this.status,
    required this.referenceCode,
    required this.transactionId,
    required this.createdAt,
    this.cancellationPolicy = 'Standard Cancellation Policy applies.',
    this.demoRefundEstimate = 0.0,
  });

  TravelBookingModel copyWith({
    String? status,
    double? demoRefundEstimate,
  }) {
    return TravelBookingModel(
      id: id,
      category: category,
      title: title,
      subtitle: subtitle,
      routeOrLocation: routeOrLocation,
      travelDate: travelDate,
      returnOrCheckOutDate: returnOrCheckOutDate,
      quantity: quantity,
      seatOrRoomNumbers: seatOrRoomNumbers,
      primaryContactName: primaryContactName,
      contactPhone: contactPhone,
      totalAmount: totalAmount,
      convenienceFee: convenienceFee,
      taxes: taxes,
      discount: discount,
      status: status ?? this.status,
      referenceCode: referenceCode,
      transactionId: transactionId,
      createdAt: createdAt,
      cancellationPolicy: cancellationPolicy,
      demoRefundEstimate: demoRefundEstimate ?? this.demoRefundEstimate,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'category': category,
        'title': title,
        'subtitle': subtitle,
        'routeOrLocation': routeOrLocation,
        'travelDate': travelDate,
        'returnOrCheckOutDate': returnOrCheckOutDate,
        'quantity': quantity,
        'seatOrRoomNumbers': seatOrRoomNumbers,
        'primaryContactName': primaryContactName,
        'contactPhone': contactPhone,
        'totalAmount': totalAmount,
        'convenienceFee': convenienceFee,
        'taxes': taxes,
        'discount': discount,
        'status': status,
        'referenceCode': referenceCode,
        'transactionId': transactionId,
        'createdAt': createdAt,
        'cancellationPolicy': cancellationPolicy,
        'demoRefundEstimate': demoRefundEstimate,
      };
}
