import 'package:payout/features/travel/shared/models/travel_models.dart';

class DummyTravelData {
  // ==========================================
  // 1. FLIGHTS CATALOG
  // ==========================================

  static final List<FlightModel> dummyFlights = [
    const FlightModel(
      id: 'FLI-101',
      airline: 'IndiGo Airlines',
      flightNumber: '6E-2432',
      from: 'Delhi (DEL)',
      to: 'Mumbai (BOM)',
      departureTime: '06:15 AM',
      arrivalTime: '08:30 AM',
      duration: '2h 15m',
      stops: 0,
      baggage: '15 kg Check-in, 7 kg Cabin',
      price: 4950.0,
      isRefundable: true,
      amenities: ['Standard Legroom', 'USB Charging', 'Paid Snacks'],
    ),
    const FlightModel(
      id: 'FLI-102',
      airline: 'Air India',
      flightNumber: 'AI-809',
      from: 'Delhi (DEL)',
      to: 'Bengaluru (BLR)',
      departureTime: '09:00 AM',
      arrivalTime: '11:45 AM',
      duration: '2h 45m',
      stops: 0,
      baggage: '20 kg Check-in, 7 kg Cabin',
      price: 6800.0,
      isRefundable: true,
      amenities: ['Complimentary Meal', 'In-seat Power', 'Extra Recline'],
    ),
    const FlightModel(
      id: 'FLI-103',
      airline: 'Vistara (Tata SIA)',
      flightNumber: 'UK-955',
      from: 'Mumbai (BOM)',
      to: 'Goa (GOX)',
      departureTime: '13:30 PM',
      arrivalTime: '14:45 PM',
      duration: '1h 15m',
      stops: 0,
      baggage: '15 kg Check-in, 7 kg Cabin',
      price: 3450.0,
      isRefundable: true,
      amenities: ['Starbucks Coffee', 'Hot Snack', 'Wi-Fi Portal'],
    ),
    const FlightModel(
      id: 'FLI-104',
      airline: 'Akasa Air',
      flightNumber: 'QP-1304',
      from: 'Delhi (DEL)',
      to: 'Mumbai (BOM)',
      departureTime: '18:45 PM',
      arrivalTime: '21:05 PM',
      duration: '2h 20m',
      stops: 0,
      baggage: '15 kg Check-in, 7 kg Cabin',
      price: 4350.0,
      isRefundable: false,
      amenities: ['USB Fast Charge', 'Pre-book Meals'],
    ),
    const FlightModel(
      id: 'FLI-105',
      airline: 'SpiceJet',
      flightNumber: 'SG-291',
      from: 'Delhi (DEL)',
      to: 'Jaipur (JAI)',
      departureTime: '20:10 PM',
      arrivalTime: '21:10 PM',
      duration: '1h 00m',
      stops: 0,
      baggage: '15 kg Check-in',
      price: 2600.0,
      isRefundable: true,
      amenities: ['SpiceMax Extra Legroom'],
    ),
  ];

  // ==========================================
  // 2. TRAINS CATALOG
  // ==========================================

  static final List<TrainModel> dummyTrains = [
    const TrainModel(
      id: 'TRN-201',
      trainName: 'New Delhi Mumbai Rajdhani Express',
      trainNumber: '12952',
      from: 'New Delhi (NDLS)',
      to: 'Mumbai Central (MMCT)',
      departureTime: '16:55 PM',
      arrivalTime: '08:35 AM',
      duration: '15h 40m',
      runningDays: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
      price: 2450.0,
      classes: [
        TrainClassAvailability(className: '3A', fare: 2450.0, status: 'AVAILABLE', seatsAvailable: 42),
        TrainClassAvailability(className: '2A', fare: 3850.0, status: 'AVAILABLE', seatsAvailable: 14),
        TrainClassAvailability(className: '1A', fare: 5200.0, status: 'RAC 4', seatsAvailable: 0),
        TrainClassAvailability(className: 'SL', fare: 820.0, status: 'WL 12', seatsAvailable: 0),
      ],
    ),
    const TrainModel(
      id: 'TRN-202',
      trainName: 'Vande Bharat Express Special',
      trainNumber: '22436',
      from: 'New Delhi (NDLS)',
      to: 'Varanasi Junction (BSB)',
      departureTime: '06:00 AM',
      arrivalTime: '14:00 PM',
      duration: '8h 00m',
      runningDays: ['Tue', 'Wed', 'Fri', 'Sat', 'Sun'],
      price: 1750.0,
      classes: [
        TrainClassAvailability(className: 'CC', fare: 1750.0, status: 'AVAILABLE', seatsAvailable: 68),
        TrainClassAvailability(className: 'EC', fare: 3300.0, status: 'AVAILABLE', seatsAvailable: 18),
      ],
    ),
    const TrainModel(
      id: 'TRN-203',
      trainName: 'Howrah Duronto Express',
      trainNumber: '12274',
      from: 'New Delhi (NDLS)',
      to: 'Howrah Junction (HWH)',
      departureTime: '12:40 PM',
      arrivalTime: '06:20 AM',
      duration: '17h 40m',
      runningDays: ['Tue', 'Sat'],
      price: 2150.0,
      classes: [
        TrainClassAvailability(className: '3A', fare: 2150.0, status: 'AVAILABLE', seatsAvailable: 29),
        TrainClassAvailability(className: '2A', fare: 3400.0, status: 'AVAILABLE', seatsAvailable: 8),
        TrainClassAvailability(className: 'SL', fare: 750.0, status: 'AVAILABLE', seatsAvailable: 110),
      ],
    ),
  ];

  // ==========================================
  // 3. BUSES CATALOG
  // ==========================================

  static List<BusSeatModel> generateBusSeats(double basePrice) {
    final List<BusSeatModel> seats = [];
    final rows = ['A', 'B', 'C', 'D', 'E', 'F', 'G'];
    for (int r = 0; r < rows.length; r++) {
      for (int c = 1; c <= 4; c++) {
        final seatNum = '${rows[r]}$c';
        final isAvailable = (r + c) % 3 != 0; // Deterministic availability
        final isLadies = c == 1 && r <= 2;
        seats.add(
          BusSeatModel(
            seatNumber: seatNum,
            row: r,
            col: c,
            isAvailable: isAvailable,
            isLadies: isLadies,
            isSleeper: r >= 4,
            price: basePrice + (r >= 4 ? 200.0 : 0.0),
          ),
        );
      }
    }
    return seats;
  }

  static final List<BusModel> dummyBuses = [
    BusModel(
      id: 'BUS-301',
      operatorName: 'Zingbus Premium AC Sleeper',
      busType: 'AC Sleeper (2+1)',
      from: 'Delhi (Kashmere Gate)',
      to: 'Jaipur (Sindhi Camp)',
      departureTime: '22:30 PM',
      arrivalTime: '04:45 AM',
      duration: '6h 15m',
      rating: 4.7,
      price: 650.0,
      availableSeats: 22,
      seats: generateBusSeats(650.0),
    ),
    BusModel(
      id: 'BUS-302',
      operatorName: 'IntrCity SmartBus AC Seater',
      busType: 'Bharat Benz AC Seater',
      from: 'Delhi (Majnu Ka Tilla)',
      to: 'Manali (Private Bus Stand)',
      departureTime: '19:00 PM',
      arrivalTime: '08:30 AM',
      duration: '13h 30m',
      rating: 4.8,
      price: 1250.0,
      availableSeats: 16,
      seats: generateBusSeats(1250.0),
    ),
    BusModel(
      id: 'BUS-303',
      operatorName: 'SRS Travels Multi-Axle Volvo',
      busType: 'Volvo AC Semi-Sleeper',
      from: 'Bengaluru (Majestic)',
      to: 'Hyderabad (Ameerpet)',
      departureTime: '21:15 PM',
      arrivalTime: '06:00 AM',
      duration: '8h 45m',
      rating: 4.5,
      price: 890.0,
      availableSeats: 24,
      seats: generateBusSeats(890.0),
    ),
  ];

  // ==========================================
  // 4. HOTELS CATALOG
  // ==========================================

  static final List<HotelModel> dummyHotels = [
    const HotelModel(
      id: 'HTL-401',
      name: 'Taj Palace Luxury Stays & Resort',
      city: 'New Delhi',
      location: 'Chanakyapuri Diplomatic Enclave, New Delhi',
      pricePerNight: 11500.0,
      rating: 4.9,
      reviewCount: 3420,
      propertyType: '5-Star Luxury',
      amenities: ['Free Wi-Fi', 'Swimming Pool', 'Luxury Spa', 'Buffet Breakfast', 'Airport Shuttle', 'Gym'],
      rooms: [
        HotelRoomModel(
          id: 'ROOM-101',
          roomType: 'Deluxe Garden View Room',
          occupancy: 2,
          bedType: '1 King Bed',
          amenities: ['Complimentary High-speed Wi-Fi', 'City View', 'Bathtub & Rain Shower', 'Tea/Coffee Maker'],
          pricePerNight: 11500.0,
        ),
        HotelRoomModel(
          id: 'ROOM-102',
          roomType: 'Executive Suite with Lounge Access',
          occupancy: 3,
          bedType: '1 King Bed + 1 Rollaway',
          amenities: ['Club Lounge Access', 'Butler Service', 'Complimentary Evening Cocktails', 'Jacuzzi'],
          pricePerNight: 19800.0,
        ),
      ],
    ),
    const HotelModel(
      id: 'HTL-402',
      name: 'Hyatt Regency Premium Stays',
      city: 'Mumbai',
      location: 'Bandra Kurla Complex (BKC), Mumbai',
      pricePerNight: 8900.0,
      rating: 4.6,
      reviewCount: 2180,
      propertyType: '5-Star Hotel',
      amenities: ['Free Wi-Fi', 'Rooftop Pool', 'Fitness Center', 'Multi-cuisine Restaurant', 'Valet Parking'],
      rooms: [
        HotelRoomModel(
          id: 'ROOM-201',
          roomType: 'Standard King Room',
          occupancy: 2,
          bedType: '1 King Bed',
          amenities: ['Wi-Fi', 'Smart TV', 'Mini Bar', 'Work Desk'],
          pricePerNight: 8900.0,
        ),
        HotelRoomModel(
          id: 'ROOM-202',
          roomType: 'Deluxe Twin City View',
          occupancy: 2,
          bedType: '2 Twin Beds',
          amenities: ['Skyline View', 'Complimentary Breakfast', 'Bathrobes'],
          pricePerNight: 10400.0,
        ),
      ],
    ),
    const HotelModel(
      id: 'HTL-403',
      name: 'The Oberoi Beachfront Palms',
      city: 'Goa',
      location: 'Candolim Beach Road, North Goa',
      pricePerNight: 7400.0,
      rating: 4.8,
      reviewCount: 1890,
      propertyType: 'Boutique Beach Resort',
      amenities: ['Private Beach Access', 'Infinity Pool', 'Sunset Bar', 'Free Breakfast', 'Water Sports'],
      rooms: [
        HotelRoomModel(
          id: 'ROOM-301',
          roomType: 'Sea View Balcony Cottage',
          occupancy: 2,
          bedType: '1 Queen Bed',
          amenities: ['Private Balcony', 'Ocean Breeze View', 'Complimentary Wine Bottle'],
          pricePerNight: 7400.0,
        ),
      ],
    ),
  ];

  // ==========================================
  // 5. MOVIES (ZOMATO / DISTRICT STYLE)
  // ==========================================

  static final List<MovieModel> dummyMovies = [
    const MovieModel(
      id: 'MOV-501',
      title: 'Oppenheimer',
      language: 'English',
      genre: 'Biography • Drama • History',
      rating: 8.9,
      votes: 98400,
      duration: '3h 00m',
      releaseDate: '21 Jul, 2026',
      synopsis: 'The story of American scientist J. Robert Oppenheimer and his role in the development of the atomic bomb during World War II.',
      cast: ['Cillian Murphy', 'Emily Blunt', 'Matt Damon', 'Robert Downey Jr.'],
      formats: ['IMAX 70mm', 'IMAX 3D', '4DX', '2D'],
      isNowShowing: true,
    ),
    const MovieModel(
      id: 'MOV-502',
      title: 'Dune: Part Two',
      language: 'English',
      genre: 'Action • Adventure • Sci-Fi',
      rating: 8.8,
      votes: 76200,
      duration: '2h 46m',
      releaseDate: '15 Mar, 2026',
      synopsis: 'Paul Atreides unites with Chani and the Fremen while seeking revenge against the conspirators who destroyed his family.',
      cast: ['Timothée Chalamet', 'Zendaya', 'Rebecca Ferguson', 'Javier Bardem'],
      formats: ['IMAX 3D', '4DX', '2D'],
      isNowShowing: true,
    ),
    const MovieModel(
      id: 'MOV-503',
      title: 'Jawan: Extended Cut',
      language: 'Hindi',
      genre: 'Action • Thriller • Drama',
      rating: 8.4,
      votes: 112000,
      duration: '2h 50m',
      releaseDate: '10 Jan, 2026',
      synopsis: 'A high-octane action thriller outlining the emotional journey of a man set out to correct the wrongs in society.',
      cast: ['Shah Rukh Khan', 'Nayanthara', 'Vijay Sethupathi', 'Deepika Padukone'],
      formats: ['2D', '4DX'],
      isNowShowing: true,
    ),
    const MovieModel(
      id: 'MOV-504',
      title: 'Interstellar: 10th Anniversary',
      language: 'English',
      genre: 'Adventure • Sci-Fi • Drama',
      rating: 9.0,
      votes: 145000,
      duration: '2h 49m',
      releaseDate: '01 Aug, 2026',
      synopsis: 'When Earth becomes uninhabitable in the future, a farmer and ex-NASA pilot is tasked to pilot a spacecraft along with a team of researchers.',
      cast: ['Matthew McConaughey', 'Anne Hathaway', 'Jessica Chastain', 'Michael Caine'],
      formats: ['IMAX 3D', '2D'],
      isNowShowing: true,
    ),
    const MovieModel(
      id: 'MOV-505',
      title: 'Fighter',
      language: 'Hindi',
      genre: 'Action • Aerial • Thriller',
      rating: 7.9,
      votes: 43000,
      duration: '2h 46m',
      releaseDate: '26 Jan, 2026',
      synopsis: 'Top IAF aviators come together to form Air Dragons, facing imminent dangers while maintaining national security.',
      cast: ['Hrithik Roshan', 'Deepika Padukone', 'Anil Kapoor'],
      formats: ['3D', '2D'],
      isNowShowing: true,
    ),
    // Coming Soon
    const MovieModel(
      id: 'MOV-506',
      title: 'Avatar: Fire and Ash',
      language: 'English',
      genre: 'Action • Adventure • Fantasy',
      rating: 9.2,
      votes: 21000,
      duration: '3h 15m',
      releaseDate: '19 Dec, 2026',
      synopsis: 'Jake Sully and Neytiri encounter a new, aggressive volcanic clan of Na\'vi known as the Ash People.',
      cast: ['Sam Worthington', 'Zoe Saldana', 'Sigourney Weaver'],
      formats: ['IMAX 3D', '3D 4DX'],
      isNowShowing: false,
    ),
    const MovieModel(
      id: 'MOV-507',
      title: 'War 2',
      language: 'Hindi',
      genre: 'Spy • Action • Thriller',
      rating: 8.7,
      votes: 15400,
      duration: '2h 40m',
      releaseDate: '14 Aug, 2026',
      synopsis: 'Major Kabir Dhaliwal crosses paths with a lethal intelligence operative in the grand YRF Spy Universe confrontation.',
      cast: ['Hrithik Roshan', 'N. T. Rama Rao Jr.', 'Kiara Advani'],
      formats: ['IMAX', '4DX', '2D'],
      isNowShowing: false,
    ),
  ];

  static final List<MovieTheatreModel> dummyTheatres = [
    const MovieTheatreModel(
      id: 'THTR-01',
      name: 'PVR INOX Director\'s Cut',
      city: 'Delhi',
      location: 'Ambience Mall, Vasant Kunj',
      distance: '3.2 km away',
      rating: 4.8,
      amenities: ['Recliner Seats', 'Dolby Atmos', 'Gourmet In-seat Dining', 'Valet Parking'],
    ),
    const MovieTheatreModel(
      id: 'THTR-02',
      name: 'Cinepolis IMAX & 4DX',
      city: 'Delhi',
      location: 'DLF Avenue, Saket',
      distance: '5.1 km away',
      rating: 4.7,
      amenities: ['IMAX Laser Screen', 'Coffee House', 'Wheelchair Friendly'],
    ),
    const MovieTheatreModel(
      id: 'THTR-03',
      name: 'PVR Superplex',
      city: 'Delhi',
      location: 'Logix City Centre, Sector 32',
      distance: '7.8 km away',
      rating: 4.5,
      amenities: ['4DX Motion Seats', 'Dolby 7.1', 'Food Court'],
    ),
    const MovieTheatreModel(
      id: 'THTR-04',
      name: 'PVR Maison INOX',
      city: 'Mumbai',
      location: 'Jio World Drive, BKC',
      distance: '2.1 km away',
      rating: 4.9,
      amenities: ['Luxury Recliner', 'Laser Projection', 'Exclusive Lounge'],
    ),
  ];

  static final List<MovieShowModel> dummyShows = [
    const MovieShowModel(
      id: 'SHW-101',
      movieId: 'MOV-501',
      theatreId: 'THTR-01',
      time: '11:15 AM',
      format: 'IMAX 3D',
      language: 'English',
      pricePerSeat: 450.0,
      availableSeats: 38,
    ),
    const MovieShowModel(
      id: 'SHW-102',
      movieId: 'MOV-501',
      theatreId: 'THTR-01',
      time: '02:45 PM',
      format: 'IMAX 3D',
      language: 'English',
      pricePerSeat: 520.0,
      availableSeats: 22,
    ),
    const MovieShowModel(
      id: 'SHW-103',
      movieId: 'MOV-501',
      theatreId: 'THTR-01',
      time: '06:30 PM',
      format: 'IMAX 3D',
      language: 'English',
      pricePerSeat: 650.0,
      availableSeats: 14,
    ),
    const MovieShowModel(
      id: 'SHW-104',
      movieId: 'MOV-501',
      theatreId: 'THTR-02',
      time: '01:30 PM',
      format: '2D Dolby',
      language: 'English',
      pricePerSeat: 320.0,
      availableSeats: 45,
    ),
    const MovieShowModel(
      id: 'SHW-105',
      movieId: 'MOV-501',
      theatreId: 'THTR-02',
      time: '05:00 PM',
      format: '4DX',
      language: 'English',
      pricePerSeat: 580.0,
      availableSeats: 18,
    ),
  ];

  static List<MovieSeatModel> generateCinemaSeats(double basePrice) {
    final List<MovieSeatModel> seats = [];
    final rows = ['A', 'B', 'C', 'D', 'E', 'F'];

    for (int r = 0; r < rows.length; r++) {
      for (int c = 1; c <= 8; c++) {
        final seatId = '${rows[r]}$c';
        final isOccupied = (r == 1 && (c == 3 || c == 4)) || (r == 3 && c == 5);
        String type = 'Regular';
        double price = basePrice;

        if (rows[r] == 'E' || rows[r] == 'F') {
          type = 'Recliner';
          price = basePrice + 180.0;
        } else if (rows[r] == 'C' || rows[r] == 'D') {
          type = 'Premium';
          price = basePrice + 80.0;
        }

        seats.add(
          MovieSeatModel(
            id: seatId,
            row: rows[r],
            number: c,
            type: type,
            price: price,
            isAvailable: !isOccupied,
          ),
        );
      }
    }
    return seats;
  }

  // ==========================================
  // 6. DYNAMIC BOOKINGS LEDGER
  // ==========================================

  static final List<TravelBookingModel> dummyBookings = [
    const TravelBookingModel(
      id: 'BKG-FLI-892',
      category: 'Flight',
      title: 'IndiGo Airlines',
      subtitle: 'Flight 6E-2432 (Economy)',
      routeOrLocation: 'Delhi (DEL) → Mumbai (BOM)',
      travelDate: '25 Aug, 2026',
      quantity: 1,
      seatOrRoomNumbers: ['12F'],
      primaryContactName: 'Rahul Sharma',
      contactPhone: '9876543210',
      totalAmount: 5794.0,
      convenienceFee: 250.0,
      taxes: 594.0,
      status: 'CONFIRMED',
      referenceCode: 'PNR-6E8892',
      transactionId: 'TXN-FLI-178601',
      createdAt: '12 Aug, 2026',
      cancellationPolicy: 'Cancellation available up to 4 hours before departure.',
      demoRefundEstimate: 4345.5,
    ),
    const TravelBookingModel(
      id: 'BKG-MOV-441',
      category: 'Movie',
      title: 'Oppenheimer (IMAX 3D)',
      subtitle: 'PVR INOX Director\'s Cut, Saket',
      routeOrLocation: 'Audi 2 • Delhi',
      travelDate: 'Tomorrow, 06:30 PM',
      quantity: 2,
      seatOrRoomNumbers: ['E4', 'E5'],
      primaryContactName: 'Rahul Sharma',
      contactPhone: '9876543210',
      totalAmount: 1359.0,
      convenienceFee: 50.0,
      taxes: 9.0,
      status: 'CONFIRMED',
      referenceCode: 'TKT-OPP-9482',
      transactionId: 'TXN-MOV-178602',
      createdAt: 'Today',
      cancellationPolicy: 'Cancellation available up to 2 hours before show.',
      demoRefundEstimate: 679.5,
    ),
    const TravelBookingModel(
      id: 'BKG-HTL-109',
      category: 'Hotel',
      title: 'Taj Palace Luxury Stays',
      subtitle: 'Deluxe Garden View Room',
      routeOrLocation: 'Chanakyapuri, New Delhi',
      travelDate: '10 Sep, 2026',
      returnOrCheckOutDate: '12 Sep, 2026',
      quantity: 2,
      seatOrRoomNumbers: ['Room 304'],
      primaryContactName: 'Rahul Sharma',
      contactPhone: '9876543210',
      totalAmount: 27140.0,
      taxes: 4140.0,
      status: 'CONFIRMED',
      referenceCode: 'VCH-TAJ-9938',
      transactionId: 'TXN-HTL-178603',
      createdAt: '10 Aug, 2026',
      cancellationPolicy: 'Free cancellation up to 24 hours before check-in.',
      demoRefundEstimate: 23069.0,
    ),
  ];
}
