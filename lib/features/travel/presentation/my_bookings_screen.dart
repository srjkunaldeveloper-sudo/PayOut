import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/widgets.dart';
import 'package:payout/core/di/app_dependencies.dart';
import 'package:payout/features/travel/shared/models/travel_models.dart';
import 'package:payout/features/travel/shared/repositories/travel_repository.dart';
import 'package:payout/features/travel/shared/services/travel_service.dart';

class MyBookingsScreen extends StatefulWidget {
  final TravelRepository? travelRepository;

  const MyBookingsScreen({
    super.key,
    this.travelRepository,
  });

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> with SingleTickerProviderStateMixin {
  late final TravelRepository _travelRepository;
  late final TabController _tabController;

  bool _isLoading = true;
  List<TravelBookingModel> _allBookings = [];
  String _selectedCategory = 'All';

  final List<String> _categories = ['All', 'Flight', 'Train', 'Bus', 'Hotel', 'Movie'];

  @override
  void initState() {
    super.initState();
    _travelRepository = widget.travelRepository ?? AppDependencies.instance.travelRepository;
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) setState(() {});
    });
    _loadBookings();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadBookings() async {
    setState(() => _isLoading = true);
    final bookings = await _travelRepository.getBookings();
    if (mounted) {
      setState(() {
        _allBookings = bookings;
        _isLoading = false;
      });
    }
  }

  List<TravelBookingModel> _getFilteredBookings(int tabIndex) {
    var list = _allBookings;

    if (_selectedCategory != 'All') {
      list = list.where((b) => b.category.toLowerCase() == _selectedCategory.toLowerCase()).toList();
    }

    if (tabIndex == 0) {
      // Upcoming (CONFIRMED or PAYMENT_PENDING)
      return list.where((b) => b.status == 'CONFIRMED' || b.status == 'PAYMENT_PENDING').toList();
    } else if (tabIndex == 1) {
      // Completed
      return list.where((b) => b.status == 'COMPLETED').toList();
    } else {
      // Cancelled
      return list.where((b) => b.status == 'CANCELLED').toList();
    }
  }

  void _showBookingDetails(TravelBookingModel booking) {
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
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.s16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${booking.category} Booking Details',
                    style: const TextStyle(fontFamily: 'Geist Sans', fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: (booking.status == 'CONFIRMED' ? AppColors.success : AppColors.error).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      booking.status,
                      style: TextStyle(
                        fontFamily: 'Geist Sans',
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: booking.status == 'CONFIRMED' ? AppColors.success : AppColors.error,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.s16),
              AppCard(
                child: Column(
                  children: [
                    _buildDetailRow('Service / Provider', booking.title),
                    const Divider(color: AppColors.divider),
                    _buildDetailRow('Details', booking.subtitle),
                    const Divider(color: AppColors.divider),
                    _buildDetailRow('Route / Location', booking.routeOrLocation),
                    const Divider(color: AppColors.divider),
                    _buildDetailRow('Travel Date', booking.travelDate),
                    if (booking.returnOrCheckOutDate.isNotEmpty) ...[
                      const Divider(color: AppColors.divider),
                      _buildDetailRow('Check-out Date', booking.returnOrCheckOutDate),
                    ],
                    if (booking.seatOrRoomNumbers.isNotEmpty) ...[
                      const Divider(color: AppColors.divider),
                      _buildDetailRow(booking.category == 'Hotel' ? 'Rooms' : 'Seat(s)', booking.seatOrRoomNumbers.join(', ')),
                    ],
                    const Divider(color: AppColors.divider),
                    _buildDetailRow('Reference / PNR', booking.referenceCode),
                    const Divider(color: AppColors.divider),
                    _buildDetailRow('Booked On', booking.createdAt),
                    const Divider(color: AppColors.divider),
                    _buildDetailRow('Total Paid', '₹${booking.totalAmount.toStringAsFixed(2)}', isTotal: true),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.s16),
              if (booking.status == 'CONFIRMED') ...[
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(modalContext);
                      _showCancelBookingDialog(booking);
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: AppColors.error),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
                    ),
                    child: const Text('Cancel Booking', style: TextStyle(fontFamily: 'Geist Sans', fontWeight: FontWeight.bold, color: AppColors.error)),
                  ),
                ),
              ],
              const SizedBox(height: AppSpacing.s12),
            ],
          ),
        );
      },
    );
  }

  void _showCancelBookingDialog(TravelBookingModel booking) {
    final refundInfo = TravelService.calculateRefundEstimate(booking);
    final cancellationFee = refundInfo['cancellationFee'] ?? 0.0;
    final refundEstimate = refundInfo['estimatedRefund'] ?? 0.0;

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
              const Row(
                children: [
                  Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 22),
                  SizedBox(width: 8),
                  Text('Confirm Cancellation', style: TextStyle(fontFamily: 'Geist Sans', fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
              const SizedBox(height: 6),
              const Text(
                'Review cancellation fee and estimated refund before confirming.',
                style: TextStyle(fontFamily: 'Geist Sans', fontSize: 12, color: AppColors.textSecondary),
              ),
              const SizedBox(height: AppSpacing.s16),
              AppCard(
                child: Column(
                  children: [
                    _buildDetailRow('Original Booking Amount', '₹${booking.totalAmount.toStringAsFixed(2)}'),
                    const Divider(color: AppColors.divider),
                    _buildDetailRow('Cancellation Charges', '- ₹${cancellationFee.toStringAsFixed(2)}'),
                    const Divider(color: AppColors.divider),
                    _buildDetailRow('Demo Refund Estimate', '₹${refundEstimate.toStringAsFixed(2)}', isTotal: true),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.s12),
              Container(
                padding: const EdgeInsets.all(AppSpacing.s12),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(AppRadius.xs),
                ),
                child: const Text(
                  'Note: This is a demo refund estimate. In production, eligible refunds are credited to the original payment source within 3-5 business days.',
                  style: TextStyle(fontFamily: 'Geist Sans', fontSize: 11, color: AppColors.textSecondary),
                ),
              ),
              const SizedBox(height: AppSpacing.s20),
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  text: 'Confirm Cancellation',
                  onPressed: () async {
                    Navigator.pop(modalContext);
                    await _travelRepository.cancelBooking(booking.id);
                    await _loadBookings();
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Booking cancelled successfully. Demo refund initiated.'),
                          backgroundColor: AppColors.success,
                        ),
                      );
                    }
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

  Widget _buildDetailRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Geist Sans',
              fontSize: isTotal ? 13.0 : 12.0,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? AppColors.textPrimary : AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Geist Sans',
              fontSize: isTotal ? 14.0 : 12.0,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
              color: isTotal ? AppColors.primary : AppColors.textPrimary,
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
      appBar: const CustomAppBar(title: 'My Bookings'),
      body: SafeArea(
        child: Column(
          children: [
            // Category Filter Pills
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s20, vertical: AppSpacing.s12),
              child: Row(
                children: _categories.map((cat) {
                  final isSelected = _selectedCategory == cat;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: FilterChip(
                      selected: isSelected,
                      label: Text(cat, style: TextStyle(fontFamily: 'Geist Sans', fontSize: 12, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                      selectedColor: AppColors.primaryContainer,
                      onSelected: (val) => setState(() => _selectedCategory = cat),
                    ),
                  );
                }).toList(),
              ),
            ),

            // Tab Bar
            TabBar(
              controller: _tabController,
              indicatorColor: AppColors.primary,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textSecondary,
              tabs: const [
                Tab(text: 'Upcoming'),
                Tab(text: 'Completed'),
                Tab(text: 'Cancelled'),
              ],
            ),

            // Tab View
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : TabBarView(
                      controller: _tabController,
                      children: [
                        _buildBookingsList(0),
                        _buildBookingsList(1),
                        _buildBookingsList(2),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingsList(int tabIndex) {
    final list = _getFilteredBookings(tabIndex);

    if (list.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.airplane_ticket_outlined, size: 54, color: AppColors.textSecondary.withValues(alpha: 0.5)),
            const SizedBox(height: 12),
            Text(
              'No ${tabIndex == 0 ? 'upcoming' : tabIndex == 1 ? 'completed' : 'cancelled'} bookings found',
              style: const TextStyle(fontFamily: 'Geist Sans', fontSize: 14, color: AppColors.textSecondary),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.s20),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final booking = list[index];
        final isConfirmed = booking.status == 'CONFIRMED';
        final statusColor = isConfirmed ? AppColors.success : AppColors.error;

        IconData catIcon = Icons.flight_takeoff_rounded;
        if (booking.category == 'Train') catIcon = Icons.train_rounded;
        if (booking.category == 'Bus') catIcon = Icons.directions_bus_filled_rounded;
        if (booking.category == 'Hotel') catIcon = Icons.hotel_rounded;
        if (booking.category == 'Movie') catIcon = Icons.movie_creation_rounded;

        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.s12),
          child: AppCard(
            child: InkWell(
              onTap: () => _showBookingDetails(booking),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(catIcon, color: AppColors.primary, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            booking.category.toUpperCase(),
                            style: const TextStyle(fontFamily: 'Geist Sans', fontWeight: FontWeight.bold, fontSize: 11, color: AppColors.primary),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          booking.status,
                          style: TextStyle(fontFamily: 'Geist Sans', fontSize: 10, fontWeight: FontWeight.bold, color: statusColor),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    booking.title,
                    style: const TextStyle(fontFamily: 'Geist Sans', fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    booking.subtitle,
                    style: const TextStyle(fontFamily: 'Geist Sans', fontSize: 11, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        booking.travelDate,
                        style: const TextStyle(fontFamily: 'Geist Sans', fontSize: 11, color: AppColors.textSecondary),
                      ),
                      Text(
                        '₹${booking.totalAmount.toStringAsFixed(2)}',
                        style: const TextStyle(fontFamily: 'Geist Sans', fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primary),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
