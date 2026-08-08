import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/widgets.dart';
import 'package:payout/features/home/presentation/home_screen.dart';
import 'package:payout/features/travel/presentation/my_bookings_screen.dart';
import 'package:payout/features/travel/shared/models/travel_models.dart';

class TravelBookingSuccessScreen extends StatelessWidget {
  final TravelBookingModel booking;

  const TravelBookingSuccessScreen({
    super.key,
    required this.booking,
  });

  @override
  Widget build(BuildContext context) {
    final isConfirmed = booking.status == 'CONFIRMED';
    final isPending = booking.status == 'PAYMENT_PENDING';
    final statusColor = isConfirmed
        ? AppColors.success
        : isPending
            ? Colors.orange
            : AppColors.error;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: '${booking.category} Booking',
        onLeadingPressed: () => Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.s24),
          child: Column(
            children: [
              // Status Header Icon
              Center(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.s20),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.08),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isConfirmed
                            ? Icons.check_circle_rounded
                            : isPending
                                ? Icons.hourglass_top_rounded
                                : Icons.cancel_rounded,
                        size: 56,
                        color: statusColor,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s16),
                    Text(
                      isConfirmed
                          ? '${booking.category} Booking Confirmed!'
                          : isPending
                              ? 'Booking Payment Pending'
                              : 'Booking Failed',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isConfirmed
                          ? 'Your booking is successful. Ref: ${booking.referenceCode}'
                          : isPending
                              ? 'Payment is being processed by the bank. Ref: ${booking.referenceCode}'
                              : 'Payment could not be completed. Please try again.',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12.0,
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.s24),

              // Booking Ticket / Voucher Card
              AppCard(
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
                              Text(
                                booking.title,
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                booking.subtitle,
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 12.0,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: statusColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(AppRadius.xs),
                          ),
                          child: Text(
                            booking.status,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 11.0,
                              fontWeight: FontWeight.bold,
                              color: statusColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.s16),
                    const Divider(color: AppColors.divider),
                    const SizedBox(height: AppSpacing.s12),

                    _buildInfoRow('Route / Location', booking.routeOrLocation),
                    _buildInfoRow('Date & Time', booking.travelDate),
                    if (booking.returnOrCheckOutDate.isNotEmpty)
                      _buildInfoRow('Check-out Date', booking.returnOrCheckOutDate),
                    if (booking.seatOrRoomNumbers.isNotEmpty)
                      _buildInfoRow(
                        booking.category == 'Hotel' ? 'Rooms' : 'Seat Number(s)',
                        booking.seatOrRoomNumbers.join(', '),
                      ),
                    _buildInfoRow('Primary Guest/Pax', booking.primaryContactName),
                    _buildInfoRow('Contact Mobile', booking.contactPhone),
                    _buildInfoRow('Reference / PNR', booking.referenceCode),
                    _buildInfoRow('Transaction ID', booking.transactionId),
                    const SizedBox(height: AppSpacing.s8),
                    const Divider(color: AppColors.divider),
                    const SizedBox(height: AppSpacing.s8),
                    _buildInfoRow(
                      'Total Paid',
                      '₹${booking.totalAmount.toStringAsFixed(2)}',
                      isTotal: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.s24),

              // Action Buttons
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  text: 'View in My Bookings',
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const MyBookingsScreen()),
                    );
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.s12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const HomeScreen()),
                      (route) => false,
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
                  ),
                  child: const Text('Back to Home', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w600, color: AppColors.primary)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: isTotal ? 14.0 : 12.0,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? AppColors.textPrimary : AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: isTotal ? 16.0 : 12.0,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
              color: isTotal ? AppColors.primary : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
