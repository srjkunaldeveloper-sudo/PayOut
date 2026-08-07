import 'package:payout/features/travel/shared/models/travel_models.dart';

class DummyTravelData {
  static final List<FlightModel> dummyFlights = [
    const FlightModel(id: 'FLI-101', airline: 'IndiGo Airlines', flightNumber: '6E-2432', from: 'DEL', to: 'BOM', price: 5430.0),
    const FlightModel(id: 'FLI-102', airline: 'Air India Express', flightNumber: 'AI-809', from: 'DEL', to: 'BLR', price: 7200.0),
  ];

  static final List<TrainModel> dummyTrains = [
    const TrainModel(id: 'TRN-201', trainName: 'New Delhi Mumbai Rajdhani Express', trainNumber: '12952', from: 'NDLS', to: 'MMCT', price: 2450.0),
    const TrainModel(id: 'TRN-202', trainName: 'Vande Bharat Express Special', trainNumber: '22436', from: 'NDLS', to: 'BSB', price: 1850.0),
  ];

  static final List<BusModel> dummyBuses = [
    const BusModel(id: 'BUS-301', operatorName: 'Zingbus Premium Sleeper', from: 'Delhi', to: 'Jaipur', price: 650.0),
    const BusModel(id: 'BUS-302', operatorName: 'IntrCity SmartBus AC Seater', from: 'Delhi', to: 'Manali', price: 1250.0),
  ];

  static final List<HotelModel> dummyHotels = [
    const HotelModel(id: 'HTL-401', name: 'Taj Palace Luxury Suite Resorts', location: 'Chanakyapuri, New Delhi', pricePerNight: 12500.0, rating: 4.8),
    const HotelModel(id: 'HTL-402', name: 'Hyatt Regency Premium Stays', location: 'Bandra, Mumbai', pricePerNight: 8900.0, rating: 4.5),
  ];

  static final List<MovieModel> dummyMovies = [
    const MovieModel(id: 'MOV-501', title: 'Oppenheimer (IMAX 3D)', genre: 'Biography / Drama', pricePerSeat: 450.0),
    const MovieModel(id: 'MOV-502', title: 'Barbie (2D English)', genre: 'Comedy / Fantasy', pricePerSeat: 300.0),
  ];
}
