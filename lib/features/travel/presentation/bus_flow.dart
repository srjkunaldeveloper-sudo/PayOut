import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/widgets.dart';
import 'package:payout/core/di/app_dependencies.dart';
import 'package:payout/features/payments/presentation/mpin_verification_screen.dart';
import 'package:payout/features/travel/presentation/booking_success_screen.dart';
import 'package:payout/features/travel/shared/models/travel_models.dart';
import 'package:payout/features/travel/shared/repositories/travel_repository.dart';
import 'package:payout/features/travel/shared/services/travel_service.dart';
import 'package:payout/features/travel/shared/validators/travel_validator.dart';

// ==========================================
// 1. BUS SEARCH SCREEN
// ==========================================

class BusSearchScreen extends StatefulWidget {
  final TravelRepository? travelRepository;

  const BusSearchScreen({super.key, this.travelRepository});

  @override
  State<BusSearchScreen> createState() => _BusSearchScreenState();
}

class _BusSearchScreenState extends State<BusSearchScreen> {
  late final TravelRepository _travelRepository;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();
  DateTime _travelDate = DateTime.now().add(const Duration(days: 3));
  bool? _isAC;

  @override
  void initState() {
    super.initState();
    _travelRepository = widget.travelRepository ?? AppDependencies.instance.travelRepository;
  }

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _travelDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
    );
    if (picked != null) {
      setState(() => _travelDate = picked);
    }
  }

  void _submitSearch() {
    if (!_formKey.currentState!.validate()) return;

    final from = _fromController.text.trim();
    final to = _toController.text.trim();

    final cityRes = TravelValidator.validateSearchCities(from, to);
    if (!cityRes.isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(cityRes.errorMessage!), backgroundColor: AppColors.error),
      );
      return;
    }

    final request = BusSearchRequest(
      from: from,
      to: to,
      travelDate: _travelDate,
      isAC: _isAC,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BusResultsScreen(
          request: request,
          travelRepository: _travelRepository,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.of(context).canPop();
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                if (canPop)
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.arrow_back_rounded,
                        color: Color(0xFF3F37C9),
                        size: 20,
                      ),
                    ),
                  ),
                const Expanded(
                  child: Center(
                    child: Text(
                      'Book Bus Tickets',
                      style: TextStyle(
                        fontFamily: 'Geist Sans',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F1F1F),
                      ),
                    ),
                  ),
                ),
                if (canPop)
                  const SizedBox(width: 40)
                else
                  const SizedBox(width: 16),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search Inputs Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF002E6E).withValues(alpha: 0.015),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.centerRight,
                        children: [
                          Column(
                            children: [
                              AppTextField(
                                controller: _fromController,
                                labelText: 'From City / Boarding Point',
                                hintText: 'e.g. Delhi (Kashmere Gate)',
                                prefix: const Icon(Icons.directions_bus_rounded, color: Color(0xFF3F37C9), size: 20),
                                validator: (v) => (v == null || v.trim().isEmpty) ? 'Origin city is required' : null,
                              ),
                              const SizedBox(height: 12),
                              AppTextField(
                                controller: _toController,
                                labelText: 'To City / Destination',
                                hintText: 'e.g. Jaipur (Sindhi Camp)',
                                prefix: const Icon(Icons.location_on_rounded, color: Color(0xFF3F37C9), size: 20),
                                validator: (v) => (v == null || v.trim().isEmpty) ? 'Destination city is required' : null,
                              ),
                            ],
                          ),
                          Positioned(
                            right: 12,
                            top: 42,
                            child: GestureDetector(
                              onTap: () {
                                final temp = _fromController.text;
                                _fromController.text = _toController.text;
                                _toController.text = temp;
                              },
                              child: Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color(0xFF3F37C9).withValues(alpha: 0.08),
                                  border: Border.all(color: Colors.white, width: 2),
                                ),
                                child: const Icon(
                                  Icons.swap_vert_rounded,
                                  color: Color(0xFF3F37C9),
                                  size: 18,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Date of Travel
                      InkWell(
                        onTap: () => _selectDate(context),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Date of Travel',
                                style: TextStyle(
                                  fontFamily: 'Geist Sans',
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  const Icon(Icons.calendar_today_rounded, size: 14, color: Color(0xFF3F37C9)),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${_travelDate.day}/${_travelDate.month}/${_travelDate.year}',
                                    style: const TextStyle(
                                      fontFamily: 'Geist Sans',
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1F1F1F),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Bus Type Segmented Control
                      Row(
                        children: [
                          _buildBusTypeChip('All Buses', _isAC == null, () => setState(() => _isAC = null)),
                          const SizedBox(width: 8),
                          _buildBusTypeChip('AC Only', _isAC == true, () => setState(() => _isAC = true)),
                          const SizedBox(width: 8),
                          _buildBusTypeChip('Non-AC', _isAC == false, () => setState(() => _isAC = false)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // Search CTA
                PrimaryButton(
                  text: 'Search Buses',
                  height: 56,
                  iconRight: Icons.arrow_forward_rounded,
                  onPressed: _submitSearch,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBusTypeChip(String label, bool isSelected, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 38,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: isSelected
                ? const LinearGradient(
                    colors: [Color(0xFF3F37C9), Color(0xFF2563EB)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: !isSelected ? const Color(0xFFF8FAFC) : null,
            borderRadius: BorderRadius.circular(10),
            border: !isSelected ? Border.all(color: const Color(0xFFE2E8F0)) : null,
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: const Color(0xFF3F37C9).withValues(alpha: 0.15),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Geist Sans',
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : const Color(0xFF1F1F1F),
            ),
          ),
        ),
      ),
    );
  }
}

// ==========================================
// 2. BUS RESULTS SCREEN
// ==========================================

class BusResultsScreen extends StatefulWidget {
  final BusSearchRequest request;
  final TravelRepository travelRepository;

  const BusResultsScreen({
    super.key,
    required this.request,
    required this.travelRepository,
  });

  @override
  State<BusResultsScreen> createState() => _BusResultsScreenState();
}

class _BusResultsScreenState extends State<BusResultsScreen> {
  bool _isLoading = true;
  List<BusModel> _buses = [];

  @override
  void initState() {
    super.initState();
    _fetchBuses();
  }

  Future<void> _fetchBuses() async {
    setState(() => _isLoading = true);
    final results = await widget.travelRepository.searchBuses(widget.request);
    if (mounted) {
      setState(() {
        _buses = results;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = TravelService.filterBuses(_buses, isAC: widget.request.isAC);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: '${widget.request.from} → ${widget.request.to}',
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : filtered.isEmpty
                ? const Center(child: Text('No buses available on this route', style: TextStyle(fontFamily: 'Geist Sans', color: AppColors.textSecondary)))
                : ListView.builder(
                    padding: const EdgeInsets.all(AppSpacing.s20),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final bus = filtered[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.s16),
                        child: AppCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      bus.operatorName,
                                      style: const TextStyle(fontFamily: 'Geist Sans', fontWeight: FontWeight.bold, fontSize: 14),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: AppColors.success.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.star_rounded, size: 14, color: AppColors.success),
                                        const SizedBox(width: 2),
                                        Text(
                                          bus.rating.toString(),
                                          style: const TextStyle(fontFamily: 'Geist Sans', fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.success),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(bus.busType, style: const TextStyle(fontFamily: 'Geist Sans', fontSize: 11, color: AppColors.textSecondary)),
                              const SizedBox(height: 12),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(bus.departureTime, style: const TextStyle(fontFamily: 'Geist Sans', fontWeight: FontWeight.bold, fontSize: 15)),
                                      Text(bus.from, style: const TextStyle(fontFamily: 'Geist Sans', fontSize: 11, color: AppColors.textSecondary)),
                                    ],
                                  ),
                                  Text(bus.duration, style: const TextStyle(fontFamily: 'Geist Sans', fontSize: 11, color: AppColors.textSecondary)),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(bus.arrivalTime, style: const TextStyle(fontFamily: 'Geist Sans', fontWeight: FontWeight.bold, fontSize: 15)),
                                      Text(bus.to, style: const TextStyle(fontFamily: 'Geist Sans', fontSize: 11, color: AppColors.textSecondary)),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              const Divider(color: AppColors.divider),
                              const SizedBox(height: 8),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('₹${bus.price.toInt()}', style: const TextStyle(fontFamily: 'Geist Sans', fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primary)),
                                      Text('${bus.availableSeats} seats left', style: const TextStyle(fontFamily: 'Geist Sans', fontSize: 10, color: AppColors.textSecondary)),
                                    ],
                                  ),
                                  PrimaryButton(
                                    text: 'Select Seats',
                                    width: 120,
                                    height: 38,
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => BusSeatSelectionScreen(
                                            bus: bus,
                                            request: widget.request,
                                            travelRepository: widget.travelRepository,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}

// ==========================================
// 3. BUS SEAT SELECTION SCREEN
// ==========================================

class BusSeatSelectionScreen extends StatefulWidget {
  final BusModel bus;
  final BusSearchRequest request;
  final TravelRepository travelRepository;

  const BusSeatSelectionScreen({
    super.key,
    required this.bus,
    required this.request,
    required this.travelRepository,
  });

  @override
  State<BusSeatSelectionScreen> createState() => _BusSeatSelectionScreenState();
}

class _BusSeatSelectionScreenState extends State<BusSeatSelectionScreen> {
  final List<BusSeatModel> _selectedSeats = [];

  void _toggleSeat(BusSeatModel seat) {
    if (!seat.isAvailable) return;

    setState(() {
      if (_selectedSeats.any((s) => s.seatNumber == seat.seatNumber)) {
        _selectedSeats.removeWhere((s) => s.seatNumber == seat.seatNumber);
      } else {
        if (_selectedSeats.length >= 6) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Maximum 6 seats allowed per booking.')),
          );
          return;
        }
        _selectedSeats.add(seat);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final totalFare = TravelService.calculateBusFare(selectedSeats: _selectedSeats);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: widget.bus.operatorName),
      body: SafeArea(
        child: Column(
          children: [
            // Legend
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s20, vertical: AppSpacing.s12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildLegendItem('Available', Colors.white, Border.all(color: AppColors.divider)),
                  _buildLegendItem('Selected', AppColors.primary, null),
                  _buildLegendItem('Occupied', Colors.grey.shade300, null),
                  _buildLegendItem('Ladies', Colors.pink.shade100, Border.all(color: Colors.pink.shade300)),
                ],
              ),
            ),
            const Divider(color: AppColors.divider),

            // Interactive Seat Layout Grid
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.s24),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.s16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      border: Border.all(color: AppColors.divider),
                    ),
                    child: Column(
                      children: [
                        // Steering Icon at front
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(Icons.directions_bus_outlined, color: AppColors.textSecondary, size: 28),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Seat rows
                        ...List.generate(7, (rowIndex) {
                          final rowSeats = widget.bus.seats.where((s) => s.row == rowIndex).toList();
                          if (rowSeats.isEmpty) return const SizedBox.shrink();

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Left 2 seats
                                if (rowSeats.isNotEmpty) _buildSeatWidget(rowSeats[0]),
                                const SizedBox(width: 8),
                                if (rowSeats.length > 1) _buildSeatWidget(rowSeats[1]),

                                // Aisle
                                const SizedBox(width: 32),

                                // Right 2 seats
                                if (rowSeats.length > 2) _buildSeatWidget(rowSeats[2]),
                                const SizedBox(width: 8),
                                if (rowSeats.length > 3) _buildSeatWidget(rowSeats[3]),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Bottom Fare and Proceed Ticker
            Container(
              padding: const EdgeInsets.all(AppSpacing.s20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -4)),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _selectedSeats.isEmpty ? 'Select Seats' : '${_selectedSeats.length} Seat(s) Selected',
                        style: const TextStyle(fontFamily: 'Geist Sans', fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      Text(
                        '₹${totalFare.toStringAsFixed(2)}',
                        style: const TextStyle(fontFamily: 'Geist Sans', fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.primary),
                      ),
                    ],
                  ),
                  PrimaryButton(
                    text: 'Continue',
                    width: 140,
                    height: 44,
                    onPressed: _selectedSeats.isNotEmpty
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BusPassengerScreen(
                                  bus: widget.bus,
                                  request: widget.request,
                                  selectedSeats: _selectedSeats,
                                  totalFare: totalFare,
                                  travelRepository: widget.travelRepository,
                                ),
                              ),
                            );
                          }
                        : null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeatWidget(BusSeatModel seat) {
    final isSelected = _selectedSeats.any((s) => s.seatNumber == seat.seatNumber);

    Color bg = Colors.white;
    Border? border = Border.all(color: AppColors.divider);

    if (isSelected) {
      bg = AppColors.primary;
      border = null;
    } else if (!seat.isAvailable) {
      bg = Colors.grey.shade300;
      border = null;
    } else if (seat.isLadies) {
      bg = Colors.pink.shade100;
      border = Border.all(color: Colors.pink.shade300);
    }

    return InkWell(
      onTap: () => _toggleSeat(seat),
      borderRadius: BorderRadius.circular(6),
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: bg,
          border: border,
          borderRadius: BorderRadius.circular(6),
        ),
        alignment: Alignment.center,
        child: Text(
          seat.seatNumber,
          style: TextStyle(
            fontFamily: 'Geist Sans',
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : (seat.isAvailable ? AppColors.textPrimary : Colors.grey.shade600),
          ),
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color, BoxBorder? border) {
    return Row(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(color: color, border: border, borderRadius: BorderRadius.circular(3)),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontFamily: 'Geist Sans', fontSize: 10, color: AppColors.textSecondary)),
      ],
    );
  }
}

// ==========================================
// 4. BUS PASSENGER & REVIEW SCREEN
// ==========================================

class BusPassengerScreen extends StatefulWidget {
  final BusModel bus;
  final BusSearchRequest request;
  final List<BusSeatModel> selectedSeats;
  final double totalFare;
  final TravelRepository travelRepository;

  const BusPassengerScreen({
    super.key,
    required this.bus,
    required this.request,
    required this.selectedSeats,
    required this.totalFare,
    required this.travelRepository,
  });

  @override
  State<BusPassengerScreen> createState() => _BusPassengerScreenState();
}

class _BusPassengerScreenState extends State<BusPassengerScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  String _gender = 'Male';

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

  void _showReviewModal() {
    if (!_formKey.currentState!.validate()) return;

    final seatNums = widget.selectedSeats.map((s) => s.seatNumber).join(', ');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(AppSpacing.s24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.divider, borderRadius: BorderRadius.circular(2))),
              ),
              const SizedBox(height: AppSpacing.s16),
              const Text('Review Bus Ticket Booking', style: TextStyle(fontFamily: 'Geist Sans', fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 4),
              const Text('Authorize ticket booking via 6-digit MPIN payment.', style: TextStyle(fontFamily: 'Geist Sans', fontSize: 12, color: AppColors.textSecondary)),
              const SizedBox(height: AppSpacing.s16),
              AppCard(
                child: Column(
                  children: [
                    _buildReviewRow('Operator', widget.bus.operatorName),
                    const Divider(color: AppColors.divider),
                    _buildReviewRow('Route', '${widget.request.from} → ${widget.request.to}'),
                    const Divider(color: AppColors.divider),
                    _buildReviewRow('Departure', widget.bus.departureTime),
                    const Divider(color: AppColors.divider),
                    _buildReviewRow('Seat(s)', seatNums),
                    const Divider(color: AppColors.divider),
                    _buildReviewRow('Passenger', '${_nameController.text.trim()} (${_ageController.text.trim()} Yrs, $_gender)'),
                    const Divider(color: AppColors.divider),
                    _buildReviewRow('Total Fare (Inc. GST)', '₹${widget.totalFare.toStringAsFixed(2)}', isTotal: true),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.s24),
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  text: 'Proceed to Pay ₹${widget.totalFare.toStringAsFixed(2)}',
                  onPressed: () {
                    Navigator.pop(modalContext);
                    _navigateToMPINPayment();
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.s12),
            ],
          ),
        );
      },
    );
  }

  void _navigateToMPINPayment() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentMPINVerificationScreen(
          recipientName: widget.bus.operatorName,
          recipientDetail: 'Bus Booking (${widget.selectedSeats.map((s) => s.seatNumber).join(', ')})',
          recipientType: 'Bus',
          amount: widget.totalFare,
          note: 'Bus Ticket ${widget.bus.id}',
          methodId: 'wallet',
          onSuccess: () async {
            final booking = TravelBookingModel(
              id: 'BKG-BUS-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
              category: 'Bus',
              title: widget.bus.operatorName,
              subtitle: widget.bus.busType,
              routeOrLocation: '${widget.request.from} → ${widget.request.to}',
              travelDate: '${widget.request.travelDate.day}/${widget.request.travelDate.month}/${widget.request.travelDate.year}, ${widget.bus.departureTime}',
              quantity: widget.selectedSeats.length,
              seatOrRoomNumbers: widget.selectedSeats.map((s) => s.seatNumber).toList(),
              primaryContactName: _nameController.text.trim(),
              contactPhone: _mobileController.text.trim(),
              totalAmount: widget.totalFare,
              status: 'CONFIRMED',
              referenceCode: 'BUS-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
              transactionId: 'TXN-BUS-${DateTime.now().millisecondsSinceEpoch}',
              createdAt: 'Today',
            );

            final confirmed = await widget.travelRepository.createBooking(booking);

            if (mounted) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => TravelBookingSuccessScreen(booking: confirmed),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildReviewRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontFamily: 'Geist Sans', fontSize: isTotal ? 13.0 : 12.0, fontWeight: isTotal ? FontWeight.bold : FontWeight.normal, color: isTotal ? AppColors.textPrimary : AppColors.textSecondary)),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(fontFamily: 'Geist Sans', fontSize: isTotal ? 14.0 : 12.0, fontWeight: isTotal ? FontWeight.bold : FontWeight.w600, color: isTotal ? AppColors.primary : AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Passenger Details'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.s24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppCard(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.bus.operatorName, style: const TextStyle(fontFamily: 'Geist Sans', fontWeight: FontWeight.bold, fontSize: 14)),
                          const SizedBox(height: 2),
                          Text('Seat(s): ${widget.selectedSeats.map((s) => s.seatNumber).join(', ')}', style: const TextStyle(fontFamily: 'Geist Sans', fontSize: 12, color: AppColors.textSecondary)),
                        ],
                      ),
                      Text(
                        '₹${widget.totalFare.toStringAsFixed(2)}',
                        style: const TextStyle(fontFamily: 'Geist Sans', fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primary),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.s20),

                const Text('Passenger Information', style: TextStyle(fontFamily: 'Geist Sans', fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: AppSpacing.s12),

                AppTextField(
                  controller: _nameController,
                  labelText: 'Primary Passenger Name',
                  hintText: 'Full Name',
                  prefix: const Icon(Icons.person_outline_rounded, size: 20),
                  validator: (v) {
                    final res = TravelValidator.validatePassengerName(v ?? '');
                    return res.isValid ? null : res.errorMessage;
                  },
                ),
                const SizedBox(height: AppSpacing.s12),

                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        controller: _ageController,
                        labelText: 'Age (Years)',
                        hintText: 'e.g. 26',
                        keyboardType: TextInputType.number,
                        prefix: const Icon(Icons.cake_outlined, size: 18),
                        validator: (v) {
                          final res = TravelValidator.validateAge(v ?? '');
                          return res.isValid ? null : res.errorMessage;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: _gender,
                        items: const [
                          DropdownMenuItem(value: 'Male', child: Text('Male', style: TextStyle(fontFamily: 'Geist Sans', fontSize: 13))),
                          DropdownMenuItem(value: 'Female', child: Text('Female', style: TextStyle(fontFamily: 'Geist Sans', fontSize: 13))),
                          DropdownMenuItem(value: 'Other', child: Text('Other', style: TextStyle(fontFamily: 'Geist Sans', fontSize: 13))),
                        ],
                        onChanged: (val) => setState(() => _gender = val ?? 'Male'),
                        decoration: InputDecoration(
                          labelText: 'Gender',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.s12),

                AppTextField(
                  controller: _mobileController,
                  labelText: 'Contact Mobile Number',
                  hintText: '10-digit mobile number',
                  keyboardType: TextInputType.phone,
                  prefix: const Icon(Icons.phone_outlined, size: 20),
                  validator: (v) {
                    final res = TravelValidator.validateMobile(v ?? '');
                    return res.isValid ? null : res.errorMessage;
                  },
                ),
                const SizedBox(height: AppSpacing.s24),

                SizedBox(
                  width: double.infinity,
                  child: PrimaryButton(
                    text: 'Review Bus Ticket',
                    onPressed: _showReviewModal,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
