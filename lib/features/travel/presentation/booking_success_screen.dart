import 'dart:math';
import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/widgets.dart';

class BookingSuccessScreen extends StatelessWidget {
  final String serviceName;
  final String details;
  final double amount;

  const BookingSuccessScreen({
    super.key,
    required this.serviceName,
    required this.details,
    required this.amount,
  });

  String _generateBookingId() {
    final rand = Random();
    final buffer = StringBuffer('BK-');
    for (int i = 0; i < 6; i++) {
      buffer.write(rand.nextInt(10));
    }
    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    final bookingId = _generateBookingId();
    final now = DateTime.now();
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final dateStr = '${months[now.month - 1]} ${now.day.toString().padLeft(2, '0')}, ${now.year}';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Booking Confirmed', showLeading: false),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24),
          child: Column(
            children: [
              const Spacer(),
              Center(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.s24),
                      decoration: BoxDecoration(
                        color: AppColors.success.withOpacity(0.08),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_circle_rounded,
                        size: 64,
                        color: AppColors.success,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s20),
                    const Text(
                      'Booking Successful!',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s8),
                    Text(
                      serviceName,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14.0,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s12),
                    Text(
                      details,
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
              const Spacer(),
              AppCard(
                padding: const EdgeInsets.all(AppSpacing.s20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Booking ID',
                          style: TextStyle(fontFamily: 'Inter', color: AppColors.textSecondary, fontSize: 13),
                        ),
                        Text(
                          bookingId,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.s12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Date',
                          style: TextStyle(fontFamily: 'Inter', color: AppColors.textSecondary, fontSize: 13),
                        ),
                        Text(
                          dateStr,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.s12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Amount Paid',
                          style: TextStyle(fontFamily: 'Inter', color: AppColors.textSecondary, fontSize: 13),
                        ),
                        Text(
                          '₹${amount.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.s12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Payment Method',
                          style: TextStyle(fontFamily: 'Inter', color: AppColors.textSecondary, fontSize: 13),
                        ),
                        const Text(
                          'Payout Wallet Balance',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.s24),
              Row(
                children: [
                  Expanded(
                    child: TextButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Downloading Ticket PDF...')),
                        );
                      },
                      icon: const Icon(Icons.file_download_outlined, color: AppColors.primary, size: 18),
                      label: const Text(
                        'Download',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: AppColors.primaryLight,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.s16),
                  Expanded(
                    child: TextButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Sharing Booking Link...')),
                        );
                      },
                      icon: const Icon(Icons.share_outlined, color: AppColors.textPrimary, size: 18),
                      label: const Text(
                        'Share Ticket',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: AppColors.surface,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(color: AppColors.divider),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.s24),
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  text: 'Back to Home',
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.s24),
            ],
          ),
        ),
      ),
    );
  }
}
