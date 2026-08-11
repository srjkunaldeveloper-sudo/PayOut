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
// 1. FLIGHT SEARCH SCREEN
// ==========================================

class FlightSearchScreen extends StatefulWidget {
  final TravelRepository? travelRepository;

  const FlightSearchScreen({super.key, this.travelRepository});

  @override
  State<FlightSearchScreen> createState() => _FlightSearchScreenState();
}

class _FlightSearchScreenState extends State<FlightSearchScreen> {
  late final TravelRepository _travelRepository;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();
  DateTime _departureDate = DateTime.now().add(const Duration(days: 7));
  DateTime? _returnDate;
  bool _isRoundTrip = false;
  int _passengers = 1;
  String _cabinClass = 'Economy';

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

  Future<void> _selectDate(BuildContext context, bool isDeparture) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isDeparture ? _departureDate : (_returnDate ?? _departureDate.add(const Duration(days: 3))),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        if (isDeparture) {
          _departureDate = picked;
          if (_returnDate != null && _returnDate!.isBefore(_departureDate)) {
            _returnDate = _departureDate.add(const Duration(days: 2));
          }
        } else {
          _returnDate = picked;
        }
      });
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

    final dateRes = TravelValidator.validateTravelDates(_departureDate, _isRoundTrip ? _returnDate : null);
    if (!dateRes.isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(dateRes.errorMessage!), backgroundColor: AppColors.error),
      );
      return;
    }

    final request = FlightSearchRequest(
      from: from,
      to: to,
      departureDate: _departureDate,
      returnDate: _isRoundTrip ? _returnDate : null,
      isRoundTrip: _isRoundTrip,
      passengers: _passengers,
      cabinClass: _cabinClass,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FlightResultsScreen(
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
                      'Book Flights',
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
                // Trip Type Selector (Segmented control style)
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _isRoundTrip = false),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          height: 44,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            gradient: !_isRoundTrip
                                ? const LinearGradient(
                                    colors: [Color(0xFF3F37C9), Color(0xFF2563EB)],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  )
                                : null,
                            color: _isRoundTrip ? Colors.white : null,
                            borderRadius: BorderRadius.circular(12),
                            border: _isRoundTrip
                                ? Border.all(color: const Color(0xFFE2E8F0))
                                : null,
                            boxShadow: !_isRoundTrip
                                ? [
                                    BoxShadow(
                                      color: const Color(0xFF3F37C9).withValues(alpha: 0.12),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Text(
                            'One Way',
                            style: TextStyle(
                              fontFamily: 'Geist Sans',
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: !_isRoundTrip ? Colors.white : const Color(0xFF1F1F1F),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _isRoundTrip = true),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          height: 44,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            gradient: _isRoundTrip
                                ? const LinearGradient(
                                    colors: [Color(0xFF3F37C9), Color(0xFF2563EB)],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  )
                                : null,
                            color: !_isRoundTrip ? Colors.white : null,
                            borderRadius: BorderRadius.circular(12),
                            border: !_isRoundTrip
                                ? Border.all(color: const Color(0xFFE2E8F0))
                                : null,
                            boxShadow: _isRoundTrip
                                ? [
                                    BoxShadow(
                                      color: const Color(0xFF3F37C9).withValues(alpha: 0.12),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Text(
                            'Round Trip',
                            style: TextStyle(
                              fontFamily: 'Geist Sans',
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: _isRoundTrip ? Colors.white : const Color(0xFF1F1F1F),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

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
                                labelText: 'From City / Airport',
                                hintText: 'e.g. Delhi (DEL)',
                                prefix: const Icon(Icons.flight_takeoff_rounded, color: Color(0xFF3F37C9), size: 20),
                                validator: (v) => (v == null || v.trim().isEmpty) ? 'Origin airport is required' : null,
                              ),
                              const SizedBox(height: 12),
                              AppTextField(
                                controller: _toController,
                                labelText: 'To City / Airport',
                                hintText: 'e.g. Mumbai (BOM)',
                                prefix: const Icon(Icons.flight_land_rounded, color: Color(0xFF3F37C9), size: 20),
                                validator: (v) => (v == null || v.trim().isEmpty) ? 'Destination airport is required' : null,
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

                      // Departure & Return Dates
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () => _selectDate(context, true),
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
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
                                      'Departure Date',
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
                                          '${_departureDate.day}/${_departureDate.month}/${_departureDate.year}',
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
                          ),
                          if (_isRoundTrip) ...[
                            const SizedBox(width: 12),
                            Expanded(
                              child: InkWell(
                                onTap: () => _selectDate(context, false),
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
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
                                        'Return Date',
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
                                            _returnDate != null
                                                ? '${_returnDate!.day}/${_returnDate!.month}/${_returnDate!.year}'
                                                : 'Select Date',
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
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Passengers & Class
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<int>(
                              initialValue: _passengers,
                              items: List.generate(
                                6,
                                (i) => DropdownMenuItem(
                                  value: i + 1,
                                  child: Text('${i + 1} Pax', style: const TextStyle(fontFamily: 'Geist Sans', fontSize: 13)),
                                ),
                              ),
                              onChanged: (val) => setState(() => _passengers = val ?? 1),
                              decoration: InputDecoration(
                                labelText: 'Passengers',
                                filled: true,
                                fillColor: const Color(0xFFF8FAFC),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              initialValue: _cabinClass,
                              items: const [
                                DropdownMenuItem(value: 'Economy', child: Text('Economy', style: TextStyle(fontFamily: 'Geist Sans', fontSize: 13))),
                                DropdownMenuItem(value: 'Premium', child: Text('Premium', style: TextStyle(fontFamily: 'Geist Sans', fontSize: 13))),
                                DropdownMenuItem(value: 'Business', child: Text('Business', style: TextStyle(fontFamily: 'Geist Sans', fontSize: 13))),
                              ],
                              onChanged: (val) => setState(() => _cabinClass = val ?? 'Economy'),
                              decoration: InputDecoration(
                                labelText: 'Cabin Class',
                                filled: true,
                                fillColor: const Color(0xFFF8FAFC),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // Submit CTA
                PrimaryButton(
                  text: 'Search Flights',
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
}

// ==========================================
// 2. FLIGHT RESULTS SCREEN
// ==========================================

class FlightResultsScreen extends StatefulWidget {
  final FlightSearchRequest request;
  final TravelRepository travelRepository;

  const FlightResultsScreen({
    super.key,
    required this.request,
    required this.travelRepository,
  });

  @override
  State<FlightResultsScreen> createState() => _FlightResultsScreenState();
}

class _FlightResultsScreenState extends State<FlightResultsScreen> {
  bool _isLoading = true;
  List<FlightModel> _flights = [];
  bool _nonStopOnly = false;
  String _selectedAirline = 'All Airlines';
  final String _sortBy = 'price';

  final List<String> _airlines = ['All Airlines', 'IndiGo', 'Air India', 'Vistara', 'Akasa'];

  @override
  void initState() {
    super.initState();
    _fetchFlights();
  }

  Future<void> _fetchFlights() async {
    setState(() => _isLoading = true);
    final results = await widget.travelRepository.searchFlights(widget.request);
    if (mounted) {
      setState(() {
        _flights = results;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = TravelService.filterFlights(
      _flights,
      nonStopOnly: _nonStopOnly,
      airline: _selectedAirline,
      sortBy: _sortBy,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: '${widget.request.from} → ${widget.request.to}',
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Filter Pills Bar
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s20, vertical: AppSpacing.s8),
              child: Row(
                children: [
                  FilterChip(
                    label: const Text('Non-Stop Only', style: TextStyle(fontFamily: 'Geist Sans', fontSize: 11)),
                    selected: _nonStopOnly,
                    selectedColor: AppColors.primaryContainer,
                    onSelected: (val) => setState(() => _nonStopOnly = val),
                  ),
                  const SizedBox(width: 8),
                  ..._airlines.map((a) => Padding(
                        padding: const EdgeInsets.only(right: 6.0),
                        child: ChoiceChip(
                          label: Text(a, style: const TextStyle(fontFamily: 'Geist Sans', fontSize: 11)),
                          selected: _selectedAirline == a,
                          selectedColor: AppColors.primaryContainer,
                          onSelected: (val) => setState(() => _selectedAirline = a),
                        ),
                      )),
                ],
              ),
            ),

            // Flight Results List
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : filtered.isEmpty
                      ? const Center(child: Text('No flights matching criteria', style: TextStyle(fontFamily: 'Geist Sans', color: AppColors.textSecondary)))
                      : ListView.builder(
                          padding: const EdgeInsets.all(AppSpacing.s20),
                          itemCount: filtered.length,
                          itemBuilder: (context, index) {
                            final flight = filtered[index];
                            final fare = TravelService.calculateFlightFare(
                              basePricePerPassenger: flight.price,
                              passengers: widget.request.passengers,
                            );

                            return Padding(
                              padding: const EdgeInsets.only(bottom: AppSpacing.s16),
                              child: AppCard(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(Icons.flight_rounded, color: AppColors.primary, size: 20),
                                            const SizedBox(width: 8),
                                            Text(
                                              flight.airline,
                                              style: const TextStyle(fontFamily: 'Geist Sans', fontWeight: FontWeight.bold, fontSize: 14),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          flight.flightNumber,
                                          style: const TextStyle(fontFamily: 'Geist Sans', fontSize: 11, color: AppColors.textSecondary),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(flight.departureTime, style: const TextStyle(fontFamily: 'Geist Sans', fontWeight: FontWeight.bold, fontSize: 16)),
                                            Text(flight.from, style: const TextStyle(fontFamily: 'Geist Sans', fontSize: 11, color: AppColors.textSecondary)),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Text(flight.duration, style: const TextStyle(fontFamily: 'Geist Sans', fontSize: 11, color: AppColors.textSecondary)),
                                            const SizedBox(height: 2),
                                            Container(
                                              width: 60,
                                              height: 2,
                                              color: AppColors.divider,
                                            ),
                                            const SizedBox(height: 2),
                                            Text(flight.stops == 0 ? 'Non-stop' : '${flight.stops} Stop', style: const TextStyle(fontFamily: 'Geist Sans', fontSize: 10, color: AppColors.success)),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Text(flight.arrivalTime, style: const TextStyle(fontFamily: 'Geist Sans', fontWeight: FontWeight.bold, fontSize: 16)),
                                            Text(flight.to, style: const TextStyle(fontFamily: 'Geist Sans', fontSize: 11, color: AppColors.textSecondary)),
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
                                            Text(
                                              '₹${fare.totalFare.toStringAsFixed(2)}',
                                              style: const TextStyle(fontFamily: 'Geist Sans', fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primary),
                                            ),
                                            Text('${widget.request.passengers} Pax • Inc. Taxes', style: const TextStyle(fontFamily: 'Geist Sans', fontSize: 10, color: AppColors.textSecondary)),
                                          ],
                                        ),
                                        PrimaryButton(
                                          text: 'Select Flight',
                                          width: 120,
                                          height: 38,
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => FlightPassengerAndReviewScreen(
                                                  flight: flight,
                                                  request: widget.request,
                                                  fare: fare,
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
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 3. FLIGHT PASSENGER & REVIEW SCREEN
// ==========================================

class FlightPassengerAndReviewScreen extends StatefulWidget {
  final FlightModel flight;
  final FlightSearchRequest request;
  final FlightFareModel fare;
  final TravelRepository travelRepository;

  const FlightPassengerAndReviewScreen({
    super.key,
    required this.flight,
    required this.request,
    required this.fare,
    required this.travelRepository,
  });

  @override
  State<FlightPassengerAndReviewScreen> createState() => _FlightPassengerAndReviewScreenState();
}

class _FlightPassengerAndReviewScreenState extends State<FlightPassengerAndReviewScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String _gender = 'Male';

  @override
  void dispose() {
    _nameController.dispose();
    _dobController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _showReviewModal() {
    if (!_formKey.currentState!.validate()) return;

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
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(color: AppColors.divider, borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: AppSpacing.s16),
              const Text('Review Flight Booking', style: TextStyle(fontFamily: 'Geist Sans', fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 4),
              const Text('Verify flight route, passenger details, and fare breakdown.', style: TextStyle(fontFamily: 'Geist Sans', fontSize: 12, color: AppColors.textSecondary)),
              const SizedBox(height: AppSpacing.s16),
              AppCard(
                child: Column(
                  children: [
                    _buildReviewRow('Airline', widget.flight.airline),
                    const Divider(color: AppColors.divider),
                    _buildReviewRow('Flight No', widget.flight.flightNumber),
                    const Divider(color: AppColors.divider),
                    _buildReviewRow('Route', '${widget.request.from} → ${widget.request.to}'),
                    const Divider(color: AppColors.divider),
                    _buildReviewRow('Departure', widget.flight.departureTime),
                    const Divider(color: AppColors.divider),
                    _buildReviewRow('Passenger', '${_nameController.text.trim()} ($_gender)'),
                    const Divider(color: AppColors.divider),
                    _buildReviewRow('Base Fare', '₹${widget.fare.baseFare.toStringAsFixed(2)}'),
                    const Divider(color: AppColors.divider),
                    _buildReviewRow('Taxes (12% GST)', '₹${widget.fare.taxes.toStringAsFixed(2)}'),
                    const Divider(color: AppColors.divider),
                    _buildReviewRow('Convenience Fee', '₹${widget.fare.convenienceFee.toStringAsFixed(2)}'),
                    const Divider(color: AppColors.divider),
                    _buildReviewRow('Total Amount', '₹${widget.fare.totalFare.toStringAsFixed(2)}', isTotal: true),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.s24),
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  text: 'Proceed to Pay ₹${widget.fare.totalFare.toStringAsFixed(2)}',
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
          recipientName: widget.flight.airline,
          recipientDetail: 'Flight ${widget.flight.flightNumber}',
          recipientType: 'Flight',
          amount: widget.fare.totalFare,
          note: 'Flight Booking ${widget.flight.flightNumber}',
          methodId: 'wallet',
          onSuccess: () async {
            final booking = TravelBookingModel(
              id: 'BKG-FLI-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
              category: 'Flight',
              title: widget.flight.airline,
              subtitle: 'Flight ${widget.flight.flightNumber} (${widget.request.cabinClass})',
              routeOrLocation: '${widget.request.from} → ${widget.request.to}',
              travelDate: '${widget.request.departureDate.day}/${widget.request.departureDate.month}/${widget.request.departureDate.year}, ${widget.flight.departureTime}',
              quantity: widget.request.passengers,
              seatOrRoomNumbers: const ['14A'],
              primaryContactName: _nameController.text.trim(),
              contactPhone: _mobileController.text.trim(),
              totalAmount: widget.fare.totalFare,
              convenienceFee: widget.fare.convenienceFee,
              taxes: widget.fare.taxes,
              status: 'CONFIRMED',
              referenceCode: 'PNR-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
              transactionId: 'TXN-FLI-${DateTime.now().millisecondsSinceEpoch}',
              createdAt: 'Today',
            );

            final confirmed = await widget.travelRepository.createBooking(booking);

            if (!context.mounted) return;

            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => TravelBookingSuccessScreen(booking: confirmed),
                ),
              );
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
        children: [
          Text(label, style: TextStyle(fontFamily: 'Geist Sans', fontSize: isTotal ? 13.0 : 12.0, fontWeight: isTotal ? FontWeight.bold : FontWeight.normal, color: isTotal ? AppColors.textPrimary : AppColors.textSecondary)),
          Text(value, style: TextStyle(fontFamily: 'Geist Sans', fontSize: isTotal ? 14.0 : 12.0, fontWeight: isTotal ? FontWeight.bold : FontWeight.w600, color: isTotal ? AppColors.primary : AppColors.textPrimary)),
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
                // Flight Summary Card
                AppCard(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.flight.airline, style: const TextStyle(fontFamily: 'Geist Sans', fontWeight: FontWeight.bold, fontSize: 14)),
                          const SizedBox(height: 2),
                          Text('${widget.request.from} → ${widget.request.to}', style: const TextStyle(fontFamily: 'Geist Sans', fontSize: 12, color: AppColors.textSecondary)),
                        ],
                      ),
                      Text(
                        '₹${widget.fare.totalFare.toStringAsFixed(2)}',
                        style: const TextStyle(fontFamily: 'Geist Sans', fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primary),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.s20),

                // Passenger Form
                const Text('Passenger Information', style: TextStyle(fontFamily: 'Geist Sans', fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: AppSpacing.s12),

                AppTextField(
                  controller: _nameController,
                  labelText: 'Full Name',
                  hintText: 'As per Govt ID proof',
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
                        controller: _dobController,
                        labelText: 'Date of Birth',
                        hintText: 'DD/MM/YYYY',
                        prefix: const Icon(Icons.cake_outlined, size: 18),
                        validator: (v) => (v == null || v.trim().isEmpty) ? 'DOB is required' : null,
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
                const SizedBox(height: AppSpacing.s12),

                AppTextField(
                  controller: _emailController,
                  labelText: 'Email Address',
                  hintText: 'E-ticket will be sent here',
                  keyboardType: TextInputType.emailAddress,
                  prefix: const Icon(Icons.email_outlined, size: 20),
                  validator: (v) {
                    final res = TravelValidator.validateEmail(v ?? '');
                    return res.isValid ? null : res.errorMessage;
                  },
                ),
                const SizedBox(height: AppSpacing.s24),

                // Review Button
                SizedBox(
                  width: double.infinity,
                  child: PrimaryButton(
                    text: 'Review Flight Booking',
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
