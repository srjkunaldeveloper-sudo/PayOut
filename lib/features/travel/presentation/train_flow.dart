import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/widgets.dart';
import 'package:payout/features/notifications/repositories/notification_repository.dart';
import 'package:payout/features/payments/presentation/mpin_verification_screen.dart';
import 'package:payout/features/transactions/repositories/transaction_repository.dart';
import 'package:payout/features/travel/presentation/booking_success_screen.dart';
import 'package:payout/features/travel/shared/models/travel_models.dart';
import 'package:payout/features/travel/shared/repositories/travel_repository.dart';
import 'package:payout/features/travel/shared/services/travel_service.dart';
import 'package:payout/features/travel/shared/validators/travel_validator.dart';

// ==========================================
// 1. TRAIN SEARCH SCREEN
// ==========================================

class TrainSearchScreen extends StatefulWidget {
  final TravelRepository? travelRepository;

  const TrainSearchScreen({super.key, this.travelRepository});

  @override
  State<TrainSearchScreen> createState() => _TrainSearchScreenState();
}

class _TrainSearchScreenState extends State<TrainSearchScreen> {
  late final TravelRepository _travelRepository;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();
  DateTime _journeyDate = DateTime.now().add(const Duration(days: 5));
  int _passengers = 1;
  String _selectedClass = 'All Classes';

  final List<String> _classes = ['All Classes', '3A', '2A', '1A', 'SL', 'CC', 'EC'];

  @override
  void initState() {
    super.initState();
    _travelRepository = widget.travelRepository ??
        MockTravelRepository(
          transactionRepository: MockTransactionRepository(),
          notificationRepository: MockNotificationRepository(),
        );
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
      initialDate: _journeyDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 120)),
    );
    if (picked != null) {
      setState(() => _journeyDate = picked);
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

    final request = TrainSearchRequest(
      from: from,
      to: to,
      journeyDate: _journeyDate,
      passengers: _passengers,
      selectedClass: _selectedClass,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TrainResultsScreen(
          request: request,
          travelRepository: _travelRepository,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Train Reservation'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.s24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppCard(
                  child: Column(
                    children: [
                      AppTextField(
                        controller: _fromController,
                        labelText: 'From Station',
                        hintText: 'e.g. New Delhi (NDLS)',
                        prefix: const Icon(Icons.train_rounded, size: 20),
                        validator: (v) => (v == null || v.trim().isEmpty) ? 'Origin station is required' : null,
                      ),
                      const SizedBox(height: AppSpacing.s12),
                      AppTextField(
                        controller: _toController,
                        labelText: 'To Station',
                        hintText: 'e.g. Mumbai Central (MMCT)',
                        prefix: const Icon(Icons.location_on_outlined, size: 20),
                        validator: (v) => (v == null || v.trim().isEmpty) ? 'Destination station is required' : null,
                      ),
                      const SizedBox(height: AppSpacing.s16),

                      // Journey Date
                      InkWell(
                        onTap: () => _selectDate(context),
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: 'Date of Journey',
                            prefixIcon: const Icon(Icons.calendar_today_rounded, size: 18),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
                          ),
                          child: Text(
                            '${_journeyDate.day}/${_journeyDate.month}/${_journeyDate.year}',
                            style: const TextStyle(fontFamily: 'Inter', fontSize: 13),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.s16),

                      // Passengers & Class
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<int>(
                              initialValue: _passengers,
                              items: List.generate(
                                6,
                                (i) => DropdownMenuItem(value: i + 1, child: Text('${i + 1} Pax', style: const TextStyle(fontFamily: 'Inter', fontSize: 13))),
                              ),
                              onChanged: (val) => setState(() => _passengers = val ?? 1),
                              decoration: InputDecoration(
                                labelText: 'Passengers',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              initialValue: _selectedClass,
                              items: _classes
                                  .map((c) => DropdownMenuItem(value: c, child: Text(c, style: const TextStyle(fontFamily: 'Inter', fontSize: 13))))
                                  .toList(),
                              onChanged: (val) => setState(() => _selectedClass = val ?? 'All Classes'),
                              decoration: InputDecoration(
                                labelText: 'Quota / Class',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.s24),

                // Search CTA
                SizedBox(
                  width: double.infinity,
                  child: PrimaryButton(
                    text: 'Search Trains',
                    onPressed: _submitSearch,
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

// ==========================================
// 2. TRAIN RESULTS SCREEN
// ==========================================

class TrainResultsScreen extends StatefulWidget {
  final TrainSearchRequest request;
  final TravelRepository travelRepository;

  const TrainResultsScreen({
    super.key,
    required this.request,
    required this.travelRepository,
  });

  @override
  State<TrainResultsScreen> createState() => _TrainResultsScreenState();
}

class _TrainResultsScreenState extends State<TrainResultsScreen> {
  bool _isLoading = true;
  List<TrainModel> _trains = [];
  String _selectedClassFilter = 'All Classes';

  final List<String> _classes = ['All Classes', '3A', '2A', '1A', 'SL', 'CC', 'EC'];

  @override
  void initState() {
    super.initState();
    _selectedClassFilter = widget.request.selectedClass;
    _fetchTrains();
  }

  Future<void> _fetchTrains() async {
    setState(() => _isLoading = true);
    final results = await widget.travelRepository.searchTrains(widget.request);
    if (mounted) {
      setState(() {
        _trains = results;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = TravelService.filterTrains(_trains, selectedClass: _selectedClassFilter);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: '${widget.request.from} → ${widget.request.to}',
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Class Filter Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s20, vertical: AppSpacing.s8),
              child: Row(
                children: _classes.map((c) {
                  final isSelected = _selectedClassFilter == c;
                  return Padding(
                    padding: const EdgeInsets.only(right: 6.0),
                    child: ChoiceChip(
                      label: Text(c, style: TextStyle(fontFamily: 'Inter', fontSize: 11, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                      selected: isSelected,
                      selectedColor: AppColors.primaryContainer,
                      onSelected: (val) => setState(() => _selectedClassFilter = c),
                    ),
                  );
                }).toList(),
              ),
            ),

            // Train List
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : filtered.isEmpty
                      ? const Center(child: Text('No trains found on this route', style: TextStyle(fontFamily: 'Inter', color: AppColors.textSecondary)))
                      : ListView.builder(
                          padding: const EdgeInsets.all(AppSpacing.s20),
                          itemCount: filtered.length,
                          itemBuilder: (context, index) {
                            final train = filtered[index];
                            return _buildTrainCard(train);
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrainCard(TrainModel train) {
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(train.trainName, style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 14)),
                      const SizedBox(height: 2),
                      Text('Train #${train.trainNumber} • Runs: ${train.runningDays.join(', ')}', style: const TextStyle(fontFamily: 'Inter', fontSize: 11, color: AppColors.textSecondary)),
                    ],
                  ),
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
                    Text(train.departureTime, style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(train.from, style: const TextStyle(fontFamily: 'Inter', fontSize: 11, color: AppColors.textSecondary)),
                  ],
                ),
                Text(train.duration, style: const TextStyle(fontFamily: 'Inter', fontSize: 11, color: AppColors.textSecondary)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(train.arrivalTime, style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(train.to, style: const TextStyle(fontFamily: 'Inter', fontSize: 11, color: AppColors.textSecondary)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(color: AppColors.divider),
            const SizedBox(height: 8),

            // Class Cards / Availability
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: train.classes.map((cls) {
                final isAvailable = cls.status.contains('AVAILABLE');
                final statusColor = isAvailable ? AppColors.success : Colors.orange;

                return InkWell(
                  onTap: () {
                    final totalFare = TravelService.calculateTrainFare(
                      classFare: cls.fare,
                      passengers: widget.request.passengers,
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TrainPassengerAndReviewScreen(
                          train: train,
                          selectedClass: cls,
                          request: widget.request,
                          totalFare: totalFare,
                          travelRepository: widget.travelRepository,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.divider),
                      borderRadius: BorderRadius.circular(AppRadius.xs),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(cls.className, style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 12)),
                            const SizedBox(width: 6),
                            Text('₹${cls.fare.toInt()}', style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.primary)),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          cls.status,
                          style: TextStyle(fontFamily: 'Inter', fontSize: 10, fontWeight: FontWeight.bold, color: statusColor),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 3. TRAIN PASSENGER & REVIEW SCREEN
// ==========================================

class TrainPassengerAndReviewScreen extends StatefulWidget {
  final TrainModel train;
  final TrainClassAvailability selectedClass;
  final TrainSearchRequest request;
  final double totalFare;
  final TravelRepository travelRepository;

  const TrainPassengerAndReviewScreen({
    super.key,
    required this.train,
    required this.selectedClass,
    required this.request,
    required this.totalFare,
    required this.travelRepository,
  });

  @override
  State<TrainPassengerAndReviewScreen> createState() => _TrainPassengerAndReviewScreenState();
}

class _TrainPassengerAndReviewScreenState extends State<TrainPassengerAndReviewScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  String _gender = 'Male';
  String _berthPreference = 'No Preference';

  final List<String> _berths = ['No Preference', 'Lower Berth', 'Middle Berth', 'Upper Berth', 'Side Lower', 'Side Upper'];

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _mobileController.dispose();
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
              const Text('Review Train Reservation', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 4),
              const Text('Authorize train reservation via 6-digit MPIN payment.', style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.textSecondary)),
              const SizedBox(height: AppSpacing.s16),
              AppCard(
                child: Column(
                  children: [
                    _buildReviewRow('Train', '${widget.train.trainName} (#${widget.train.trainNumber})'),
                    const Divider(color: AppColors.divider),
                    _buildReviewRow('Route', '${widget.request.from} → ${widget.request.to}'),
                    const Divider(color: AppColors.divider),
                    _buildReviewRow('Class & Quota', '${widget.selectedClass.className} (${widget.selectedClass.status})'),
                    const Divider(color: AppColors.divider),
                    _buildReviewRow('Passenger', '${_nameController.text.trim()} (${_ageController.text.trim()} Yrs, $_gender)'),
                    const Divider(color: AppColors.divider),
                    _buildReviewRow('Berth Choice', _berthPreference),
                    const Divider(color: AppColors.divider),
                    _buildReviewRow('Base Fare', '₹${(widget.selectedClass.fare * widget.request.passengers).toStringAsFixed(2)}'),
                    const Divider(color: AppColors.divider),
                    _buildReviewRow('IRCTC Service Charge', '₹35.40'),
                    const Divider(color: AppColors.divider),
                    _buildReviewRow('Total Amount', '₹${widget.totalFare.toStringAsFixed(2)}', isTotal: true),
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
          recipientName: widget.train.trainName,
          recipientDetail: 'Train #${widget.train.trainNumber}',
          recipientType: 'Train',
          amount: widget.totalFare,
          note: 'IRCTC Reservation #${widget.train.trainNumber}',
          methodId: 'wallet',
          onSuccess: () async {
            final booking = TravelBookingModel(
              id: 'BKG-TRN-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
              category: 'Train',
              title: widget.train.trainName,
              subtitle: 'Train #${widget.train.trainNumber} (Class ${widget.selectedClass.className})',
              routeOrLocation: '${widget.request.from} → ${widget.request.to}',
              travelDate: '${widget.request.journeyDate.day}/${widget.request.journeyDate.month}/${widget.request.journeyDate.year}, ${widget.train.departureTime}',
              quantity: widget.request.passengers,
              seatOrRoomNumbers: const ['Coach B2 - Berth 24 (Lower)'],
              primaryContactName: _nameController.text.trim(),
              contactPhone: _mobileController.text.trim(),
              totalAmount: widget.totalFare,
              convenienceFee: 35.40,
              status: 'CONFIRMED',
              referenceCode: 'PNR-${DateTime.now().millisecondsSinceEpoch.toString().substring(3)}',
              transactionId: 'TXN-TRN-${DateTime.now().millisecondsSinceEpoch}',
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
          Text(label, style: TextStyle(fontFamily: 'Inter', fontSize: isTotal ? 13.0 : 12.0, fontWeight: isTotal ? FontWeight.bold : FontWeight.normal, color: isTotal ? AppColors.textPrimary : AppColors.textSecondary)),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(fontFamily: 'Inter', fontSize: isTotal ? 14.0 : 12.0, fontWeight: isTotal ? FontWeight.bold : FontWeight.w600, color: isTotal ? AppColors.primary : AppColors.textPrimary),
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
                // Train Summary
                AppCard(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.train.trainName, style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 14)),
                          const SizedBox(height: 2),
                          Text('Class ${widget.selectedClass.className} • ${widget.selectedClass.status}', style: const TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.textSecondary)),
                        ],
                      ),
                      Text(
                        '₹${widget.totalFare.toStringAsFixed(2)}',
                        style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primary),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.s20),

                // Passenger Form
                const Text('Passenger Information', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: AppSpacing.s12),

                AppTextField(
                  controller: _nameController,
                  labelText: 'Passenger Full Name',
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
                        controller: _ageController,
                        labelText: 'Age (Years)',
                        hintText: 'e.g. 29',
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
                          DropdownMenuItem(value: 'Male', child: Text('Male', style: TextStyle(fontFamily: 'Inter', fontSize: 13))),
                          DropdownMenuItem(value: 'Female', child: Text('Female', style: TextStyle(fontFamily: 'Inter', fontSize: 13))),
                          DropdownMenuItem(value: 'Other', child: Text('Other', style: TextStyle(fontFamily: 'Inter', fontSize: 13))),
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

                DropdownButtonFormField<String>(
                  initialValue: _berthPreference,
                  items: _berths.map((b) => DropdownMenuItem(value: b, child: Text(b, style: const TextStyle(fontFamily: 'Inter', fontSize: 13)))).toList(),
                  onChanged: (val) => setState(() => _berthPreference = val ?? 'No Preference'),
                  decoration: InputDecoration(
                    labelText: 'Berth Preference',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
                  ),
                ),
                const SizedBox(height: AppSpacing.s12),

                AppTextField(
                  controller: _mobileController,
                  labelText: 'IRCTC SMS Mobile Number',
                  hintText: '10-digit mobile number',
                  keyboardType: TextInputType.phone,
                  prefix: const Icon(Icons.phone_outlined, size: 20),
                  validator: (v) {
                    final res = TravelValidator.validateMobile(v ?? '');
                    return res.isValid ? null : res.errorMessage;
                  },
                ),
                const SizedBox(height: AppSpacing.s24),

                // Review CTA
                SizedBox(
                  width: double.infinity,
                  child: PrimaryButton(
                    text: 'Review Train Reservation',
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
