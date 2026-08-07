import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/widgets.dart';
import 'package:payout/features/travel/presentation/booking_success_screen.dart';
import 'package:payout/features/travel/shared/models/travel_models.dart';
import 'package:payout/features/travel/shared/repositories/travel_repository.dart';
import 'package:payout/features/travel/shared/services/travel_service.dart';

// 1. BUS SEARCH SCREEN
class BusSearchScreen extends StatefulWidget {
  const BusSearchScreen({super.key});

  @override
  State<BusSearchScreen> createState() => _BusSearchScreenState();
}

class _BusSearchScreenState extends State<BusSearchScreen> {
  final TextEditingController _fromController = TextEditingController(text: 'Delhi');
  final TextEditingController _toController = TextEditingController(text: 'Jaipur');

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
                        prefixIcon: Icon(Icons.directions_bus_rounded),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s16),
                    TextField(
                      controller: _toController,
                      decoration: const InputDecoration(
                        labelText: 'To City',
                        prefixIcon: Icon(Icons.directions_bus_rounded),
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
                        builder: (context) => BusResultsScreen(
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

// 2. BUS RESULTS SCREEN
class BusResultsScreen extends StatefulWidget {
  final String from;
  final String to;

  const BusResultsScreen({super.key, required this.from, required this.to});

  @override
  State<BusResultsScreen> createState() => _BusResultsScreenState();
}

class _BusResultsScreenState extends State<BusResultsScreen> {
  final TravelRepository _travelRepository = MockTravelRepository();
  List<BusModel> _buses = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBuses();
  }

  Future<void> _loadBuses() async {
    final list = await _travelRepository.getBuses();
    if (mounted) {
      setState(() {
        _buses = list;
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
              itemCount: _buses.length,
              itemBuilder: (context, index) {
                final bus = _buses[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.s16),
                  child: AppCard(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BusDetailsScreen(
                            from: widget.from,
                            to: widget.to,
                            bus: bus,
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
                              bus.operatorName,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                              ),
                            ),
                            Text(
                              '₹${bus.price.toStringAsFixed(0)}',
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
                          children: const [
                            Text(
                              'AC Sleeper (2+1)',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13.0,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              '12 Seats Left',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12.0,
                                color: Colors.orange,
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

// 3. BUS DETAILS SCREEN
class BusDetailsScreen extends StatelessWidget {
  final String from;
  final String to;
  final BusModel bus;

  const BusDetailsScreen({
    super.key,
    required this.from,
    required this.to,
    required this.bus,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Bus Details'),
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
                      bus.operatorName,
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
                        builder: (context) => BusSeatSelectionScreen(
                          from: from,
                          to: to,
                          bus: bus,
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

// 4. SEAT SELECTION SCREEN
class BusSeatSelectionScreen extends StatefulWidget {
  final String from;
  final String to;
  final BusModel bus;

  const BusSeatSelectionScreen({
    super.key,
    required this.from,
    required this.to,
    required this.bus,
  });

  @override
  State<BusSeatSelectionScreen> createState() => _BusSeatSelectionScreenState();
}

class _BusSeatSelectionScreenState extends State<BusSeatSelectionScreen> {
  String? _selectedSeat;

  Widget _buildSeat(String code) {
    final isSelected = _selectedSeat == code;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedSeat = code;
        });
      },
      child: Container(
        margin: const EdgeInsets.all(6.0),
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: isSelected ? AppColors.primary : AppColors.divider, width: 1.5),
        ),
        alignment: Alignment.center,
        child: Text(
          code,
          style: TextStyle(
            fontFamily: 'Inter',
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
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.s24),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildSeat('L1'),
                          _buildSeat('L2'),
                          const SizedBox(width: AppSpacing.s32),
                          _buildSeat('L3'),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildSeat('L4'),
                          _buildSeat('L5'),
                          const SizedBox(width: AppSpacing.s32),
                          _buildSeat('L6'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  text: _selectedSeat == null ? 'Select Seat' : 'Continue with $_selectedSeat',
                  onPressed: _selectedSeat == null
                      ? null
                      : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BusFareSummaryScreen(
                                from: widget.from,
                                to: widget.to,
                                bus: widget.bus,
                                seatCode: _selectedSeat!,
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

// 5. FARE SUMMARY SCREEN
class BusFareSummaryScreen extends StatefulWidget {
  final String from;
  final String to;
  final BusModel bus;
  final String seatCode;

  const BusFareSummaryScreen({
    super.key,
    required this.from,
    required this.to,
    required this.bus,
    required this.seatCode,
  });

  @override
  State<BusFareSummaryScreen> createState() => _BusFareSummaryScreenState();
}

class _BusFareSummaryScreenState extends State<BusFareSummaryScreen> {
  final TravelRepository _travelRepository = MockTravelRepository();
  bool _isBooking = false;

  void _bookTicket() async {
    setState(() {
      _isBooking = true;
    });

    final totalCost = TravelService.calculateTotalCost(rate: widget.bus.price, quantity: 1);
    final success = await _travelRepository.bookTicket('Bus', widget.bus.id, totalCost);

    if (mounted) {
      setState(() {
        _isBooking = false;
      });

      if (success) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BookingSuccessScreen(
              serviceName: 'Bus Ticket: ${widget.bus.operatorName}',
              details: '${widget.from} to ${widget.to} • Seat: ${widget.seatCode}',
              amount: totalCost,
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalCost = TravelService.calculateTotalCost(rate: widget.bus.price, quantity: 1);

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
                            widget.bus.operatorName,
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
                        Text('₹${widget.bus.price.toStringAsFixed(0)}', style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 12)),
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
