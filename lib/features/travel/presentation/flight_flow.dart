import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/widgets.dart';
import 'package:payout/features/travel/presentation/booking_success_screen.dart';

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
class FlightResultsScreen extends StatelessWidget {
  final String from;
  final String to;

  const FlightResultsScreen({super.key, required this.from, required this.to});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> flights = [
      {'airline': 'IndiGo', 'time': '08:30 AM - 10:45 AM', 'stops': 'Non-stop', 'price': 4200.0},
      {'airline': 'Air India', 'time': '11:45 AM - 02:00 PM', 'stops': 'Non-stop', 'price': 4800.0},
      {'airline': 'Akasa Air', 'time': '06:15 PM - 08:35 PM', 'stops': 'Non-stop', 'price': 3900.0},
      {'airline': 'SpiceJet', 'time': '09:00 PM - 11:30 PM', 'stops': 'Non-stop', 'price': 4100.0},
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: '$from to $to'),
      body: ListView.builder(
        padding: const EdgeInsets.all(AppSpacing.s24),
        itemCount: flights.length,
        itemBuilder: (context, index) {
          final flight = flights[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.s16),
            child: AppCard(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FlightDetailsScreen(
                      from: from,
                      to: to,
                      flightData: flight,
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
                        flight['airline'],
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                        ),
                      ),
                      Text(
                        '₹${flight['price']}',
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
                        flight['time'],
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13.0,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        flight['stops'],
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12.0,
                          color: flight['stops'] == 'Non-stop' ? AppColors.success : AppColors.textSecondary,
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
  final Map<String, dynamic> flightData;

  const FlightDetailsScreen({
    super.key,
    required this.from,
    required this.to,
    required this.flightData,
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
                      flightData['airline'],
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
                      'Timing: ${flightData['time']} (${flightData['stops']})',
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
                          flightData: flightData,
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
  final Map<String, dynamic> flightData;

  const FlightPassengerDetailsScreen({
    super.key,
    required this.from,
    required this.to,
    required this.flightData,
  });

  @override
  State<FlightPassengerDetailsScreen> createState() => _FlightPassengerDetailsScreenState();
}

class _FlightPassengerDetailsScreenState extends State<FlightPassengerDetailsScreen> {
  final TextEditingController _nameController = TextEditingController(text: 'Alex Morgan');
  final TextEditingController _ageController = TextEditingController(text: '28');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Passenger Info'),
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
                  text: 'Review Booking',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FlightReviewScreen(
                          from: widget.from,
                          to: widget.to,
                          flightData: widget.flightData,
                          passengerName: _nameController.text,
                          passengerAge: _ageController.text,
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

// 5. REVIEW SCREEN
class FlightReviewScreen extends StatefulWidget {
  final String from;
  final String to;
  final Map<String, dynamic> flightData;
  final String passengerName;
  final String passengerAge;

  const FlightReviewScreen({
    super.key,
    required this.from,
    required this.to,
    required this.flightData,
    required this.passengerName,
    required this.passengerAge,
  });

  @override
  State<FlightReviewScreen> createState() => _FlightReviewScreenState();
}

class _FlightReviewScreenState extends State<FlightReviewScreen> {
  bool _isProcessing = false;

  void _bookFlight() {
    setState(() {
      _isProcessing = true;
    });

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => BookingSuccessScreen(
              serviceName: 'Flight Ticket - ${widget.flightData['airline']}',
              details: '${widget.from} to ${widget.to} • ${widget.passengerName}',
              amount: widget.flightData['price'],
            ),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Review Booking'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.s24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Review Flight',
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
                          widget.flightData['airline'],
                          style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '₹${widget.flightData['price']}',
                          style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, color: AppColors.primary),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.s8),
                    Row(
                      children: [
                        Text('${widget.from} → ${widget.to}', style: const TextStyle(fontFamily: 'Inter', fontSize: 13, color: AppColors.textSecondary)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.s24),
              const Text(
                'Passenger Details',
                style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: AppSpacing.s12),
              AppCard(
                child: Row(
                  children: [
                    const Icon(Icons.person_outline_rounded, color: AppColors.primary),
                    const SizedBox(width: AppSpacing.s12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.passengerName, style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold)),
                        Text('Age: ${widget.passengerAge}', style: const TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.textSecondary)),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  text: 'Pay ₹${widget.flightData['price']}',
                  isLoading: _isProcessing,
                  onPressed: _isProcessing ? null : _bookFlight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
