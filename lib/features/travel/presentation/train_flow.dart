import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/app_button.dart';
import 'package:payout/core/widgets/app_card.dart';
import 'package:payout/features/travel/presentation/booking_success_screen.dart';

// 1. SEARCH TRAIN SCREEN
class TrainSearchScreen extends StatefulWidget {
  const TrainSearchScreen({super.key});

  @override
  State<TrainSearchScreen> createState() => _TrainSearchScreenState();
}

class _TrainSearchScreenState extends State<TrainSearchScreen> {
  final TextEditingController _fromController = TextEditingController(text: 'Delhi (NDLS)');
  final TextEditingController _toController = TextEditingController(text: 'Jaipur (JP)');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Search Trains'),
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
                        labelText: 'Origin Station',
                        prefixIcon: Icon(Icons.train_rounded),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s16),
                    TextField(
                      controller: _toController,
                      decoration: const InputDecoration(
                        labelText: 'Destination Station',
                        prefixIcon: Icon(Icons.train_rounded),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s16),
                    const TextField(
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Date of Travel',
                        hintText: 'Aug 26, 2026',
                        prefixIcon: Icon(Icons.calendar_today_rounded),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  text: 'Search Trains',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TrainListScreen(
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

// 2. TRAIN LIST SCREEN
class TrainListScreen extends StatelessWidget {
  final String from;
  final String to;

  const TrainListScreen({super.key, required this.from, required this.to});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> trains = [
      {'name': 'Vande Bharat Express (20978)', 'time': '06:00 AM - 10:45 AM', 'duration': '4h 45m', 'price': 1250.0},
      {'name': 'Rajdhani Express (12958)', 'time': '08:15 PM - 12:30 AM', 'duration': '4h 15m', 'price': 1100.0},
      {'name': 'Shatabdi Express (12015)', 'time': '06:10 AM - 10:40 AM', 'duration': '4h 30m', 'price': 980.0},
      {'name': 'Tejas Express (12585)', 'time': '03:40 PM - 07:55 PM', 'duration': '4h 15m', 'price': 1400.0},
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: '$from to $to'),
      body: ListView.builder(
        padding: const EdgeInsets.all(AppSpacing.s24),
        itemCount: trains.length,
        itemBuilder: (context, index) {
          final train = trains[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.s16),
            child: AppCard(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TrainSeatSelectionScreen(
                      from: from,
                      to: to,
                      trainData: train,
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
                        train['name'],
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                        ),
                      ),
                      Text(
                        '₹${train['price']}',
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
                        train['time'],
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12.0,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        train['duration'],
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
class TrainSeatSelectionScreen extends StatefulWidget {
  final String from;
  final String to;
  final Map<String, dynamic> trainData;

  const TrainSeatSelectionScreen({
    super.key,
    required this.from,
    required this.to,
    required this.trainData,
  });

  @override
  State<TrainSeatSelectionScreen> createState() => _TrainSeatSelectionScreenState();
}

class _TrainSeatSelectionScreenState extends State<TrainSeatSelectionScreen> {
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
      appBar: const CustomAppBar(title: 'Select Berth / Seat'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.s24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Available Sleeper Berths',
                style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: AppSpacing.s16),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 4,
                  children: [
                    _buildSeat('LB-01'),
                    _buildSeat('UB-02'),
                    _buildSeat('LB-03'),
                    _buildSeat('UB-04'),
                    _buildSeat('LB-05'),
                    _buildSeat('UB-06'),
                    _buildSeat('LB-07'),
                    _buildSeat('UB-08'),
                    _buildSeat('LB-09'),
                    _buildSeat('UB-10'),
                    _buildSeat('LB-11'),
                    _buildSeat('UB-12'),
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  text: 'Confirm Berth',
                  onPressed: _selectedSeat != null
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TrainPassengerDetailsScreen(
                                from: widget.from,
                                to: widget.to,
                                trainData: widget.trainData,
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

// 4. PASSENGER DETAILS SCREEN
class TrainPassengerDetailsScreen extends StatefulWidget {
  final String from;
  final String to;
  final Map<String, dynamic> trainData;
  final String selectedSeat;

  const TrainPassengerDetailsScreen({
    super.key,
    required this.from,
    required this.to,
    required this.trainData,
    required this.selectedSeat,
  });

  @override
  State<TrainPassengerDetailsScreen> createState() => _TrainPassengerDetailsScreenState();
}

class _TrainPassengerDetailsScreenState extends State<TrainPassengerDetailsScreen> {
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
                child: AppButton(
                  text: 'Review Ticket',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TrainReviewScreen(
                          from: widget.from,
                          to: widget.to,
                          trainData: widget.trainData,
                          passengerName: _nameController.text,
                          passengerAge: _ageController.text,
                          selectedSeat: widget.selectedSeat,
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
class TrainReviewScreen extends StatefulWidget {
  final String from;
  final String to;
  final Map<String, dynamic> trainData;
  final String passengerName;
  final String passengerAge;
  final String selectedSeat;

  const TrainReviewScreen({
    super.key,
    required this.from,
    required this.to,
    required this.trainData,
    required this.passengerName,
    required this.passengerAge,
    required this.selectedSeat,
  });

  @override
  State<TrainReviewScreen> createState() => _TrainReviewScreenState();
}

class _TrainReviewScreenState extends State<TrainReviewScreen> {
  bool _isProcessing = false;

  void _bookTrain() {
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
              serviceName: 'Train Booking - ${widget.trainData['name']}',
              details: '${widget.from} to ${widget.to} • Berth ${widget.selectedSeat} • ${widget.passengerName}',
              amount: widget.trainData['price'],
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
      appBar: const CustomAppBar(title: 'Review Ticket'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.s24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Review Journey',
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
                          widget.trainData['name'],
                          style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '₹${widget.trainData['price']}',
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
                'Berth & Traveler',
                style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: AppSpacing.s12),
              AppCard(
                child: Row(
                  children: [
                    const Icon(Icons.train_outlined, color: AppColors.primary),
                    const SizedBox(width: AppSpacing.s12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.passengerName, style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold)),
                        Text('Berth: ${widget.selectedSeat} • Age: ${widget.passengerAge}', style: const TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.textSecondary)),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  text: 'Pay ₹${widget.trainData['price']}',
                  isLoading: _isProcessing,
                  onPressed: _isProcessing ? null : _bookTrain,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
