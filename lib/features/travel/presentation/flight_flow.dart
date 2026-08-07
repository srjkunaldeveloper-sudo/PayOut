import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/widgets.dart';
import 'package:payout/features/travel/presentation/booking_success_screen.dart';
import 'package:payout/features/travel/shared/models/travel_models.dart';
import 'package:payout/features/travel/shared/repositories/travel_repository.dart';
import 'package:payout/features/travel/shared/services/travel_service.dart';

// 1. FLIGHT SEARCH SCREEN
class FlightSearchScreen extends StatefulWidget {
  const FlightSearchScreen({super.key});

  @override
  State<FlightSearchScreen> createState() => _FlightSearchScreenState();
}

class _FlightSearchScreenState extends State<FlightSearchScreen> {
  final TextEditingController _fromController = TextEditingController(text: 'Delhi (DEL)');
  final TextEditingController _toController = TextEditingController(text: 'Mumbai (BOM)');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Search Flights'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.s24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppCard(
                padding: const EdgeInsets.all(AppSpacing.s20),
                child: Column(
                  children: [
                    TextField(
                      controller: _fromController,
                      decoration: const InputDecoration(
                        labelText: 'From',
                        prefixIcon: Icon(Icons.flight_takeoff_rounded),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s16),
                    TextField(
                      controller: _toController,
                      decoration: const InputDecoration(
                        labelText: 'To',
                        prefixIcon: Icon(Icons.flight_land_rounded),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s16),
                    Row(
                      children: const [
                        Expanded(
                          child: TextField(
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: 'Date',
                              hintText: 'Aug 25, 2026',
                              prefixIcon: Icon(Icons.calendar_today_rounded),
                            ),
                          ),
                        ),
                        SizedBox(width: AppSpacing.s16),
                        Expanded(
                          child: TextField(
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: 'Passengers',
                              hintText: '1 Passenger',
                              prefixIcon: Icon(Icons.person_rounded),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  text: 'Search Flights',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FlightResultsScreen(
                          from: _fromController.text,
                          to: _toController.text,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 2. FLIGHT RESULTS SCREEN
class FlightResultsScreen extends StatefulWidget {
  final String from;
  final String to;

  const FlightResultsScreen({super.key, required this.from, required this.to});

  @override
  State<FlightResultsScreen> createState() => _FlightResultsScreenState();
}

class _FlightResultsScreenState extends State<FlightResultsScreen> {
  final TravelRepository _travelRepository = MockTravelRepository();
  List<FlightModel> _flights = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFlights();
  }

  Future<void> _loadFlights() async {
    final list = await _travelRepository.getFlights();
    if (mounted) {
      setState(() {
        _flights = list;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: '${widget.from} to ${widget.to}'),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary)))
          : ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.s24),
              itemCount: _flights.length,
              itemBuilder: (context, index) {
                final flight = _flights[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.s16),
                  child: AppCard(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FlightDetailsScreen(
                            from: widget.from,
                            to: widget.to,
                            flight: flight,
                          ),
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              flight.airline,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                              ),
                            ),
                            Text(
                              '₹${flight.price.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.s12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              flight.flightNumber,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13.0,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const Text(
                              'Non-stop',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12.0,
                                color: AppColors.success,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

// 3. FLIGHT DETAILS SCREEN
class FlightDetailsScreen extends StatelessWidget {
  final String from;
  final String to;
  final FlightModel flight;

  const FlightDetailsScreen({
    super.key,
    required this.from,
    required this.to,
    required this.flight,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Flight Details'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.s24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppCard(
                padding: const EdgeInsets.all(AppSpacing.s20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      flight.airline,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          from,
                          style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w600),
                        ),
                        const Icon(Icons.arrow_forward_rounded, color: AppColors.textSecondary, size: 16),
                        Text(
                          to,
                          style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.s12),
                    Text(
                      'Flight: ${flight.flightNumber} (Non-stop)',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13.0,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.s24),
              const Text(
                'Baggage Allowance',
                style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: AppSpacing.s12),
              AppCard(
                child: Column(
                  children: const [
                    ListTile(
                      leading: Icon(Icons.backpack_rounded, color: AppColors.primary),
                      title: Text('Cabin Baggage', style: TextStyle(fontFamily: 'Inter', fontSize: 13)),
                      trailing: Text('7 kg (1 piece)', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 13)),
                      contentPadding: EdgeInsets.zero,
                    ),
                    ListTile(
                      leading: Icon(Icons.backpack_outlined, color: AppColors.primary),
                      title: Text('Check-in Baggage', style: TextStyle(fontFamily: 'Inter', fontSize: 13)),
                      trailing: Text('15 kg (1 piece)', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 13)),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  text: 'Add Passenger Details',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FlightPassengerDetailsScreen(
                          from: from,
                          to: to,
                          flight: flight,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 4. PASSENGER DETAILS SCREEN
class FlightPassengerDetailsScreen extends StatefulWidget {
  final String from;
  final String to;
  final FlightModel flight;

  const FlightPassengerDetailsScreen({
    super.key,
    required this.from,
    required this.to,
    required this.flight,
  });

  @override
  State<FlightPassengerDetailsScreen> createState() => _FlightPassengerDetailsScreenState();
}

class _FlightPassengerDetailsScreenState extends State<FlightPassengerDetailsScreen> {
  final TextEditingController _nameController = TextEditingController(text: 'John Doe');
  final TextEditingController _ageController = TextEditingController(text: '28');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Passenger Details'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.s24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Enter Primary Passenger Information',
                style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: AppSpacing.s16),
              AppCard(
                padding: const EdgeInsets.all(AppSpacing.s20),
                child: Column(
                  children: [
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Full Name',
                        prefixIcon: Icon(Icons.person_rounded),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s16),
                    TextField(
                      controller: _ageController,
                      decoration: const InputDecoration(
                        labelText: 'Age',
                        prefixIcon: Icon(Icons.cake_rounded),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  text: 'Select Seat',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FlightSeatSelectionScreen(
                          from: widget.from,
                          to: widget.to,
                          flight: widget.flight,
                          passengerName: _nameController.text,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 5. SEAT SELECTION SCREEN
class FlightSeatSelectionScreen extends StatefulWidget {
  final String from;
  final String to;
  final FlightModel flight;
  final String passengerName;

  const FlightSeatSelectionScreen({
    super.key,
    required this.from,
    required this.to,
    required this.flight,
    required this.passengerName,
  });

  @override
  State<FlightSeatSelectionScreen> createState() => _FlightSeatSelectionScreenState();
}

class _FlightSeatSelectionScreenState extends State<FlightSeatSelectionScreen> {
  String? _selectedSeat;

  Widget _buildSeatRow(String rowNum) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildSeat('${rowNum}A'),
          _buildSeat('${rowNum}B'),
          _buildSeat('${rowNum}C'),
          const SizedBox(width: AppSpacing.s24),
          _buildSeat('${rowNum}D'),
          _buildSeat('${rowNum}E'),
          _buildSeat('${rowNum}F'),
        ],
      ),
    );
  }

  Widget _buildSeat(String seatCode) {
    final isSelected = _selectedSeat == seatCode;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedSeat = seatCode;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(6.0),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.divider,
            width: 1.5,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          seatCode,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Choose Seat'),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: AppSpacing.s24),
            const Text(
              'A  B  C      D  E  F',
              style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.s12),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildSeatRow('1'),
                    _buildSeatRow('2'),
                    _buildSeatRow('3'),
                    _buildSeatRow('4'),
                    _buildSeatRow('5'),
                    _buildSeatRow('6'),
                    _buildSeatRow('7'),
                    _buildSeatRow('8'),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.s24),
              child: SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  text: _selectedSeat == null ? 'Select a Seat' : 'Continue with Seat $_selectedSeat',
                  onPressed: _selectedSeat == null
                      ? null
                      : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FlightFareSummaryScreen(
                                from: widget.from,
                                to: widget.to,
                                flight: widget.flight,
                                passengerName: widget.passengerName,
                                seatCode: _selectedSeat!,
                              ),
                            ),
                          );
                        },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 6. FARE SUMMARY SCREEN
class FlightFareSummaryScreen extends StatefulWidget {
  final String from;
  final String to;
  final FlightModel flight;
  final String passengerName;
  final String seatCode;

  const FlightFareSummaryScreen({
    super.key,
    required this.from,
    required this.to,
    required this.flight,
    required this.passengerName,
    required this.seatCode,
  });

  @override
  State<FlightFareSummaryScreen> createState() => _FlightFareSummaryScreenState();
}

class _FlightFareSummaryScreenState extends State<FlightFareSummaryScreen> {
  final TravelRepository _travelRepository = MockTravelRepository();
  bool _isBooking = false;

  void _bookTicket() async {
    setState(() {
      _isBooking = true;
    });

    final totalCost = TravelService.calculateTotalCost(rate: widget.flight.price, quantity: 1);
    final success = await _travelRepository.bookTicket('Flight', widget.flight.id, totalCost);

    if (mounted) {
      setState(() {
        _isBooking = false;
      });

      if (success) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BookingSuccessScreen(
              serviceName: 'Flight Booking: ${widget.flight.airline}',
              details: '${widget.from} to ${widget.to} • Flight: ${widget.flight.flightNumber} • Seat: ${widget.seatCode}',
              amount: totalCost,
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalCost = TravelService.calculateTotalCost(rate: widget.flight.price, quantity: 1);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Fare Breakup'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.s24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Verify Pricing Breakup',
                style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: AppSpacing.s12),
              AppCard(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.flight.airline,
                          style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '₹${totalCost.toStringAsFixed(0)}',
                          style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, color: AppColors.primary),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.s12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Base Fare', style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.textSecondary)),
                        Text('₹${widget.flight.price.toStringAsFixed(0)}', style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.s8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text('Taxes & Fees (18%)', style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.textSecondary)),
                        Text('Included', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.s8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Seat Selection Fee', style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.textSecondary)),
                        const Text('Free', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  text: 'Confirm & Book Ticket',
                  isLoading: _isBooking,
                  onPressed: _isBooking ? null : _bookTicket,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
