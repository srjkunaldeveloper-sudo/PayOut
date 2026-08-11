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
// 1. HOTEL SEARCH SCREEN
// ==========================================

class HotelSearchScreen extends StatefulWidget {
  final TravelRepository? travelRepository;

  const HotelSearchScreen({super.key, this.travelRepository});

  @override
  State<HotelSearchScreen> createState() => _HotelSearchScreenState();
}

class _HotelSearchScreenState extends State<HotelSearchScreen> {
  late final TravelRepository _travelRepository;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _cityController = TextEditingController();
  DateTime _checkIn = DateTime.now().add(const Duration(days: 7));
  DateTime _checkOut = DateTime.now().add(const Duration(days: 9));
  int _guests = 2;
  int _rooms = 1;

  @override
  void initState() {
    super.initState();
    _travelRepository = widget.travelRepository ?? AppDependencies.instance.travelRepository;
  }

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isCheckIn) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isCheckIn ? _checkIn : _checkOut,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        if (isCheckIn) {
          _checkIn = picked;
          if (_checkOut.isBefore(_checkIn) || _checkOut.isAtSameMomentAs(_checkIn)) {
            _checkOut = _checkIn.add(const Duration(days: 1));
          }
        } else {
          _checkOut = picked;
        }
      });
    }
  }

  void _submitSearch() {
    if (!_formKey.currentState!.validate()) return;

    final city = _cityController.text.trim();
    if (city.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter city or destination.'), backgroundColor: AppColors.error),
      );
      return;
    }

    final dateRes = TravelValidator.validateTravelDates(_checkIn, _checkOut);
    if (!dateRes.isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(dateRes.errorMessage!), backgroundColor: AppColors.error),
      );
      return;
    }

    final request = HotelSearchRequest(
      city: city,
      checkIn: _checkIn,
      checkOut: _checkOut,
      guests: _guests,
      rooms: _rooms,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HotelResultsScreen(
          request: request,
          travelRepository: _travelRepository,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final nights = TravelService.calculateStayNights(_checkIn, _checkOut);
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
                      'Hotel Stays & Resorts',
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
                      AppTextField(
                        controller: _cityController,
                        labelText: 'City / Destination / Area',
                        hintText: 'e.g. New Delhi, Mumbai, Goa',
                        prefix: const Icon(Icons.location_city_rounded, color: Color(0xFF3F37C9), size: 20),
                        validator: (v) => (v == null || v.trim().isEmpty) ? 'City name is required' : null,
                      ),
                      const SizedBox(height: 16),

                      // Check-in and Check-out Row
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
                                      'Check-in',
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
                                          '${_checkIn.day}/${_checkIn.month}/${_checkIn.year}',
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
                                      'Check-out',
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
                                          '${_checkOut.day}/${_checkOut.month}/${_checkOut.year}',
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
                      ),
                      const SizedBox(height: 12),

                      // Nights Stay Pill
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF3F37C9).withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '$nights Night(s) Stay',
                          style: const TextStyle(
                            fontFamily: 'Geist Sans',
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF3F37C9),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Guests & Rooms
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<int>(
                              initialValue: _guests,
                              items: List.generate(
                                8,
                                (i) => DropdownMenuItem(
                                  value: i + 1,
                                  child: Text('${i + 1} Guests', style: const TextStyle(fontFamily: 'Geist Sans', fontSize: 13)),
                                ),
                              ),
                              onChanged: (val) => setState(() => _guests = val ?? 2),
                              decoration: InputDecoration(
                                labelText: 'Guests',
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
                            child: DropdownButtonFormField<int>(
                              initialValue: _rooms,
                              items: List.generate(
                                4,
                                (i) => DropdownMenuItem(
                                  value: i + 1,
                                  child: Text('${i + 1} Room(s)', style: const TextStyle(fontFamily: 'Geist Sans', fontSize: 13)),
                                ),
                              ),
                              onChanged: (val) => setState(() => _rooms = val ?? 1),
                              decoration: InputDecoration(
                                labelText: 'Rooms',
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

                // Search CTA
                PrimaryButton(
                  text: 'Search Hotels',
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
// 2. HOTEL RESULTS SCREEN
// ==========================================

class HotelResultsScreen extends StatefulWidget {
  final HotelSearchRequest request;
  final TravelRepository travelRepository;

  const HotelResultsScreen({
    super.key,
    required this.request,
    required this.travelRepository,
  });

  @override
  State<HotelResultsScreen> createState() => _HotelResultsScreenState();
}

class _HotelResultsScreenState extends State<HotelResultsScreen> {
  bool _isLoading = true;
  List<HotelModel> _hotels = [];
  double _minRating = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchHotels();
  }

  Future<void> _fetchHotels() async {
    setState(() => _isLoading = true);
    final results = await widget.travelRepository.searchHotels(widget.request);
    if (mounted) {
      setState(() {
        _hotels = results;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = TravelService.filterHotels(_hotels, minRating: _minRating);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: 'Hotels in ${widget.request.city}'),
      body: SafeArea(
        child: Column(
          children: [
            // Rating Filters
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s20, vertical: AppSpacing.s8),
              child: Row(
                children: [
                  ChoiceChip(
                    label: const Text('All Ratings', style: TextStyle(fontFamily: 'Geist Sans', fontSize: 11)),
                    selected: _minRating == 0.0,
                    selectedColor: AppColors.primaryContainer,
                    onSelected: (val) => setState(() => _minRating = 0.0),
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('4.5+ ★ Star Rating', style: TextStyle(fontFamily: 'Geist Sans', fontSize: 11)),
                    selected: _minRating == 4.5,
                    selectedColor: AppColors.primaryContainer,
                    onSelected: (val) => setState(() => _minRating = 4.5),
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('4.8+ ★ Luxury Choice', style: TextStyle(fontFamily: 'Geist Sans', fontSize: 11)),
                    selected: _minRating == 4.8,
                    selectedColor: AppColors.primaryContainer,
                    onSelected: (val) => setState(() => _minRating = 4.8),
                  ),
                ],
              ),
            ),

            // Hotel Results List
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : filtered.isEmpty
                      ? const Center(child: Text('No hotels found matching criteria', style: TextStyle(fontFamily: 'Geist Sans', color: AppColors.textSecondary)))
                      : ListView.builder(
                          padding: const EdgeInsets.all(AppSpacing.s20),
                          itemCount: filtered.length,
                          itemBuilder: (context, index) {
                            final hotel = filtered[index];
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
                                            hotel.name,
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
                                                hotel.rating.toString(),
                                                style: const TextStyle(fontFamily: 'Geist Sans', fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.success),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Text(hotel.location, style: const TextStyle(fontFamily: 'Geist Sans', fontSize: 11, color: AppColors.textSecondary)),
                                    const SizedBox(height: 8),

                                    // Amenities chips
                                    Wrap(
                                      spacing: 6,
                                      runSpacing: 6,
                                      children: hotel.amenities
                                          .take(4)
                                          .map((a) => Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                                decoration: BoxDecoration(
                                                  color: AppColors.primaryContainer.withValues(alpha: 0.3),
                                                  borderRadius: BorderRadius.circular(4),
                                                ),
                                                child: Text(a, style: const TextStyle(fontFamily: 'Geist Sans', fontSize: 10, color: AppColors.primary)),
                                              ))
                                          .toList(),
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
                                              '₹${hotel.pricePerNight.toInt()} / night',
                                              style: const TextStyle(fontFamily: 'Geist Sans', fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primary),
                                            ),
                                            const Text('+ 18% GST', style: TextStyle(fontFamily: 'Geist Sans', fontSize: 10, color: AppColors.textSecondary)),
                                          ],
                                        ),
                                        PrimaryButton(
                                          text: 'Select Room',
                                          width: 120,
                                          height: 38,
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => HotelGuestAndReviewScreen(
                                                  hotel: hotel,
                                                  selectedRoom: hotel.rooms.isNotEmpty
                                                      ? hotel.rooms.first
                                                      : HotelRoomModel(
                                                          id: 'RM-DEF',
                                                          roomType: 'Deluxe Room',
                                                          bedType: '1 King Bed',
                                                          amenities: hotel.amenities,
                                                          pricePerNight: hotel.pricePerNight,
                                                        ),
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
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 3. HOTEL GUEST & REVIEW SCREEN
// ==========================================

class HotelGuestAndReviewScreen extends StatefulWidget {
  final HotelModel hotel;
  final HotelRoomModel selectedRoom;
  final HotelSearchRequest request;
  final TravelRepository travelRepository;

  const HotelGuestAndReviewScreen({
    super.key,
    required this.hotel,
    required this.selectedRoom,
    required this.request,
    required this.travelRepository,
  });

  @override
  State<HotelGuestAndReviewScreen> createState() => _HotelGuestAndReviewScreenState();
}

class _HotelGuestAndReviewScreenState extends State<HotelGuestAndReviewScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _showReviewModal() {
    if (!_formKey.currentState!.validate()) return;

    final nights = TravelService.calculateStayNights(widget.request.checkIn, widget.request.checkOut);
    final pricing = TravelService.calculateHotelPricing(
      pricePerNight: widget.selectedRoom.pricePerNight,
      nights: nights,
      rooms: widget.request.rooms,
    );
    final total = pricing['total'] ?? 0.0;

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
              const Text('Review Hotel Reservation', style: TextStyle(fontFamily: 'Geist Sans', fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 4),
              const Text('Authorize hotel booking via 6-digit MPIN payment.', style: TextStyle(fontFamily: 'Geist Sans', fontSize: 12, color: AppColors.textSecondary)),
              const SizedBox(height: AppSpacing.s16),
              AppCard(
                child: Column(
                  children: [
                    _buildReviewRow('Hotel', widget.hotel.name),
                    const Divider(color: AppColors.divider),
                    _buildReviewRow('Room Type', widget.selectedRoom.roomType),
                    const Divider(color: AppColors.divider),
                    _buildReviewRow('Stay Dates', '${widget.request.checkIn.day}/${widget.request.checkIn.month} → ${widget.request.checkOut.day}/${widget.request.checkOut.month} ($nights Nights)'),
                    const Divider(color: AppColors.divider),
                    _buildReviewRow('Guests / Rooms', '${widget.request.guests} Guests • ${widget.request.rooms} Room'),
                    const Divider(color: AppColors.divider),
                    _buildReviewRow('Lead Guest', _nameController.text.trim()),
                    const Divider(color: AppColors.divider),
                    _buildReviewRow('Room Charges', '₹${(pricing['roomCharges'] ?? 0).toStringAsFixed(2)}'),
                    const Divider(color: AppColors.divider),
                    _buildReviewRow('Taxes (18% GST)', '₹${(pricing['taxes'] ?? 0).toStringAsFixed(2)}'),
                    const Divider(color: AppColors.divider),
                    _buildReviewRow('Total Amount', '₹${total.toStringAsFixed(2)}', isTotal: true),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.s24),
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  text: 'Proceed to Pay ₹${total.toStringAsFixed(2)}',
                  onPressed: () {
                    Navigator.pop(modalContext);
                    _navigateToMPINPayment(total);
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

  void _navigateToMPINPayment(double totalAmount) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentMPINVerificationScreen(
          recipientName: widget.hotel.name,
          recipientDetail: widget.selectedRoom.roomType,
          recipientType: 'Hotel',
          amount: totalAmount,
          note: 'Hotel Stay ${widget.hotel.name}',
          methodId: 'wallet',
          onSuccess: () async {
            final booking = TravelBookingModel(
              id: 'BKG-HTL-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
              category: 'Hotel',
              title: widget.hotel.name,
              subtitle: widget.selectedRoom.roomType,
              routeOrLocation: widget.hotel.location,
              travelDate: '${widget.request.checkIn.day}/${widget.request.checkIn.month}/${widget.request.checkIn.year}',
              returnOrCheckOutDate: '${widget.request.checkOut.day}/${widget.request.checkOut.month}/${widget.request.checkOut.year}',
              quantity: widget.request.guests,
              seatOrRoomNumbers: const ['Room 208'],
              primaryContactName: _nameController.text.trim(),
              contactPhone: _mobileController.text.trim(),
              totalAmount: totalAmount,
              status: 'CONFIRMED',
              referenceCode: 'VCH-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
              transactionId: 'TXN-HTL-${DateTime.now().millisecondsSinceEpoch}',
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
    final nights = TravelService.calculateStayNights(widget.request.checkIn, widget.request.checkOut);
    final pricing = TravelService.calculateHotelPricing(
      pricePerNight: widget.selectedRoom.pricePerNight,
      nights: nights,
      rooms: widget.request.rooms,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Guest Details'),
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
                          Text(widget.hotel.name, style: const TextStyle(fontFamily: 'Geist Sans', fontWeight: FontWeight.bold, fontSize: 14)),
                          const SizedBox(height: 2),
                          Text('${widget.selectedRoom.roomType} • $nights Night(s)', style: const TextStyle(fontFamily: 'Geist Sans', fontSize: 12, color: AppColors.textSecondary)),
                        ],
                      ),
                      Text(
                        '₹${(pricing['total'] ?? 0).toStringAsFixed(2)}',
                        style: const TextStyle(fontFamily: 'Geist Sans', fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primary),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.s20),

                const Text('Lead Guest Information', style: TextStyle(fontFamily: 'Geist Sans', fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: AppSpacing.s12),

                AppTextField(
                  controller: _nameController,
                  labelText: 'Primary Guest Name',
                  hintText: 'As per Govt Photo ID proof',
                  prefix: const Icon(Icons.person_outline_rounded, size: 20),
                  validator: (v) {
                    final res = TravelValidator.validatePassengerName(v ?? '');
                    return res.isValid ? null : res.errorMessage;
                  },
                ),
                const SizedBox(height: AppSpacing.s12),

                AppTextField(
                  controller: _mobileController,
                  labelText: 'Mobile Number',
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
                  hintText: 'Hotel voucher will be sent here',
                  keyboardType: TextInputType.emailAddress,
                  prefix: const Icon(Icons.email_outlined, size: 20),
                  validator: (v) {
                    final res = TravelValidator.validateEmail(v ?? '');
                    return res.isValid ? null : res.errorMessage;
                  },
                ),
                const SizedBox(height: AppSpacing.s24),

                SizedBox(
                  width: double.infinity,
                  child: PrimaryButton(
                    text: 'Review Hotel Reservation',
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
