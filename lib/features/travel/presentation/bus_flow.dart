import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/widgets.dart';
import 'package:payout/features/travel/presentation/booking_success_screen.dart';

// 1. SEARCH BUS SCREEN
class BusSearchScreen extends StatefulWidget {
  const BusSearchScreen({super.key});

  @override
  State<BusSearchScreen> createState() => _BusSearchScreenState();
}

class _BusSearchScreenState extends State<BusSearchScreen> {
  final TextEditingController _fromController = TextEditingController(text: 'Pune (Swargate)');
  final TextEditingController _toController = TextEditingController(text: 'Mumbai (Dadar)');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Search Buses'),
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
                        labelText: 'From City',
                        prefixIcon: Icon(Icons.directions_bus_filled_rounded),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s16),
                    TextField(
                      controller: _toController,
                      decoration: const InputDecoration(
                        labelText: 'To City',
                        prefixIcon: Icon(Icons.directions_bus_filled_rounded),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s16),
                    const TextField(
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Travel Date',
                        hintText: 'Aug 27, 2026',
                        prefixIcon: Icon(Icons.calendar_today_rounded),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  text: 'Search Buses',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BusListScreen(
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

// 2. BUS LIST SCREEN
class BusListScreen extends StatelessWidget {
  final String from;
  final String to;

  const BusListScreen({super.key, required this.from, required this.to});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> buses = [
      {'name': 'MSRTC Shivneri Volvo AC', 'time': '09:00 AM - 12:30 PM', 'duration': '3h 30m', 'price': 520.0},
      {'name': 'KSRTC Swift Multi-Axle', 'time': '11:30 AM - 03:00 PM', 'duration': '3h 30m', 'price': 480.0},
      {'name': 'Zingbus Premium Sleeper', 'time': '02:00 PM - 05:45 PM', 'duration': '3h 45m', 'price': 650.0},
      {'name': 'Orange Travels A/C Sleeper', 'time': '05:30 PM - 09:15 PM', 'duration': '3h 45m', 'price': 720.0},
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: '$from to $to'),
      body: ListView.builder(
        padding: const EdgeInsets.all(AppSpacing.s24),
        itemCount: buses.length,
        itemBuilder: (context, index) {
          final bus = buses[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.s16),
            child: AppCard(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BusSeatSelectionScreen(
                      from: from,
                      to: to,
                      busData: bus,
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
                        bus['name'],
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                        ),
                      ),
                      Text(
                        '₹${bus['price']}',
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
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
                        bus['time'],
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12.0,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        bus['duration'],
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12.0,
                          color: AppColors.textSecondary,
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

// 3. SEAT SELECTION SCREEN
class BusSeatSelectionScreen extends StatefulWidget {
  final String from;
  final String to;
  final Map<String, dynamic> busData;

  const BusSeatSelectionScreen({
    super.key,
    required this.from,
    required this.to,
    required this.busData,
  });

  @override
  State<BusSeatSelectionScreen> createState() => _BusSeatSelectionScreenState();
}

class _BusSeatSelectionScreenState extends State<BusSeatSelectionScreen> {
  String? _selectedSeat;

  Widget _buildSeat(String seatName) {
    final isSelected = _selectedSeat == seatName;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedSeat = seatName;
        });
      },
      child: Container(
        margin: const EdgeInsets.all(AppSpacing.s4),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.primaryLight.withOpacity(0.4),
          borderRadius: BorderRadius.circular(8.0),
        ),
        alignment: Alignment.center,
        child: Text(
          seatName,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 12.0,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : AppColors.primary,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Select Bus Seat'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.s24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Available Seats',
                style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: AppSpacing.s16),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 4,
                  children: [
                    _buildSeat('S-01'),
                    _buildSeat('S-02'),
                    _buildSeat('S-03'),
                    _buildSeat('S-04'),
                    _buildSeat('S-05'),
                    _buildSeat('S-06'),
                    _buildSeat('S-07'),
                    _buildSeat('S-08'),
                    _buildSeat('S-09'),
                    _buildSeat('S-10'),
                    _buildSeat('S-11'),
                    _buildSeat('S-12'),
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  text: 'Confirm Seat',
                  onPressed: _selectedSeat != null
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BusReviewScreen(
                                from: widget.from,
                                to: widget.to,
                                busData: widget.busData,
                                selectedSeat: _selectedSeat!,
                              ),
                            ),
                          );
                        }
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 4. REVIEW SCREEN
class BusReviewScreen extends StatefulWidget {
  final String from;
  final String to;
  final Map<String, dynamic> busData;
  final String selectedSeat;

  const BusReviewScreen({
    super.key,
    required this.from,
    required this.to,
    required this.busData,
    required this.selectedSeat,
  });

  @override
  State<BusReviewScreen> createState() => _BusReviewScreenState();
}

class _BusReviewScreenState extends State<BusReviewScreen> {
  bool _isProcessing = false;

  void _bookBus() {
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
              serviceName: 'Bus Booking - ${widget.busData['name']}',
              details: '${widget.from} to ${widget.to} • Seat ${widget.selectedSeat} • Passenger: Alex Morgan',
              amount: widget.busData['price'],
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
                'Review Bus Journey',
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
                          widget.busData['name'],
                          style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '₹${widget.busData['price']}',
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
                'Seat & Traveler',
                style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: AppSpacing.s12),
              AppCard(
                child: Row(
                  children: [
                    const Icon(Icons.directions_bus_outlined, color: AppColors.primary),
                    const SizedBox(width: AppSpacing.s12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Alex Morgan', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold)),
                        Text('Seat Number: ${widget.selectedSeat}', style: const TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.textSecondary)),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  text: 'Pay ₹${widget.busData['price']}',
                  isLoading: _isProcessing,
                  onPressed: _isProcessing ? null : _bookBus,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
