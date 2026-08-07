import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/widgets.dart';
import 'package:payout/features/travel/presentation/booking_success_screen.dart';
import 'package:payout/features/travel/shared/models/travel_models.dart';
import 'package:payout/features/travel/shared/repositories/travel_repository.dart';
import 'package:payout/features/travel/shared/services/travel_service.dart';

// 1. TRAIN SEARCH SCREEN
class TrainSearchScreen extends StatefulWidget {
  const TrainSearchScreen({super.key});

  @override
  State<TrainSearchScreen> createState() => _TrainSearchScreenState();
}

class _TrainSearchScreenState extends State<TrainSearchScreen> {
  final TextEditingController _fromController = TextEditingController(text: 'Delhi (NDLS)');
  final TextEditingController _toController = TextEditingController(text: 'Mumbai (MMCT)');

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
                        labelText: 'From Station',
                        prefixIcon: Icon(Icons.train_rounded),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s16),
                    TextField(
                      controller: _toController,
                      decoration: const InputDecoration(
                        labelText: 'To Station',
                        prefixIcon: Icon(Icons.train_rounded),
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
                              labelText: 'Quota',
                              hintText: 'General',
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
                  text: 'Search Trains',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TrainResultsScreen(
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

// 2. TRAIN RESULTS SCREEN
class TrainResultsScreen extends StatefulWidget {
  final String from;
  final String to;

  const TrainResultsScreen({super.key, required this.from, required this.to});

  @override
  State<TrainResultsScreen> createState() => _TrainResultsScreenState();
}

class _TrainResultsScreenState extends State<TrainResultsScreen> {
  final TravelRepository _travelRepository = MockTravelRepository();
  List<TrainModel> _trains = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTrains();
  }

  Future<void> _loadTrains() async {
    final list = await _travelRepository.getTrains();
    if (mounted) {
      setState(() {
        _trains = list;
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
              itemCount: _trains.length,
              itemBuilder: (context, index) {
                final train = _trains[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.s16),
                  child: AppCard(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TrainDetailsScreen(
                            from: widget.from,
                            to: widget.to,
                            train: train,
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
                              train.trainName,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                              ),
                            ),
                            Text(
                              '₹${train.price.toStringAsFixed(0)}',
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
                              'Train: ${train.trainNumber}',
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13.0,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const Text(
                              'Available',
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

// 3. TRAIN DETAILS SCREEN
class TrainDetailsScreen extends StatelessWidget {
  final String from;
  final String to;
  final TrainModel train;

  const TrainDetailsScreen({
    super.key,
    required this.from,
    required this.to,
    required this.train,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Train Details'),
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
                      train.trainName,
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
                      'Train Number: ${train.trainNumber}',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13.0,
                        color: AppColors.textSecondary,
                      ),
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
                        builder: (context) => TrainPassengerDetailsScreen(
                          from: from,
                          to: to,
                          train: train,
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
class TrainPassengerDetailsScreen extends StatefulWidget {
  final String from;
  final String to;
  final TrainModel train;

  const TrainPassengerDetailsScreen({
    super.key,
    required this.from,
    required this.to,
    required this.train,
  });

  @override
  State<TrainPassengerDetailsScreen> createState() => _TrainPassengerDetailsScreenState();
}

class _TrainPassengerDetailsScreenState extends State<TrainPassengerDetailsScreen> {
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
                  text: 'Select Berth',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TrainBerthSelectionScreen(
                          from: widget.from,
                          to: widget.to,
                          train: widget.train,
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

// 5. BERTH SELECTION SCREEN
class TrainBerthSelectionScreen extends StatefulWidget {
  final String from;
  final String to;
  final TrainModel train;
  final String passengerName;

  const TrainBerthSelectionScreen({
    super.key,
    required this.from,
    required this.to,
    required this.train,
    required this.passengerName,
  });

  @override
  State<TrainBerthSelectionScreen> createState() => _TrainBerthSelectionScreenState();
}

class _TrainBerthSelectionScreenState extends State<TrainBerthSelectionScreen> {
  String? _selectedBerth = 'Lower Berth';

  Widget _buildBerthOption(String berth) {
    final isSelected = _selectedBerth == berth;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.s12),
      child: AppCard(
        onTap: () {
          setState(() {
            _selectedBerth = berth;
          });
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              berth,
              style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold),
            ),
            Icon(
              isSelected ? Icons.check_circle_rounded : Icons.radio_button_off_rounded,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Choose Berth'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.s24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select Preferred Berth Type',
                style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: AppSpacing.s16),
              _buildBerthOption('Lower Berth'),
              _buildBerthOption('Middle Berth'),
              _buildBerthOption('Upper Berth'),
              _buildBerthOption('Side Lower'),
              _buildBerthOption('Side Upper'),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  text: 'Continue with $_selectedBerth',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TrainFareSummaryScreen(
                          from: widget.from,
                          to: widget.to,
                          train: widget.train,
                          passengerName: widget.passengerName,
                          berth: _selectedBerth!,
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

// 6. FARE SUMMARY SCREEN
class TrainFareSummaryScreen extends StatefulWidget {
  final String from;
  final String to;
  final TrainModel train;
  final String passengerName;
  final String berth;

  const TrainFareSummaryScreen({
    super.key,
    required this.from,
    required this.to,
    required this.train,
    required this.passengerName,
    required this.berth,
  });

  @override
  State<TrainFareSummaryScreen> createState() => _TrainFareSummaryScreenState();
}

class _TrainFareSummaryScreenState extends State<TrainFareSummaryScreen> {
  final TravelRepository _travelRepository = MockTravelRepository();
  bool _isBooking = false;

  void _bookTicket() async {
    setState(() {
      _isBooking = true;
    });

    final totalCost = TravelService.calculateTotalCost(rate: widget.train.price, quantity: 1);
    final success = await _travelRepository.bookTicket('Train', widget.train.id, totalCost);

    if (mounted) {
      setState(() {
        _isBooking = false;
      });

      if (success) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BookingSuccessScreen(
              serviceName: 'Train Ticket: ${widget.train.trainName}',
              details: '${widget.from} to ${widget.to} • Train No: ${widget.train.trainNumber} • Preference: ${widget.berth}',
              amount: totalCost,
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalCost = TravelService.calculateTotalCost(rate: widget.train.price, quantity: 1);

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
                        Expanded(
                          child: Text(
                            widget.train.trainName,
                            style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.s8),
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
                        Text('₹${widget.train.price.toStringAsFixed(0)}', style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.s8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text('Catering Charges', style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.textSecondary)),
                        Text('Included', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 12)),
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
