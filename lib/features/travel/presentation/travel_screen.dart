import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/app_card.dart';
import 'package:payout/features/travel/presentation/bus_flow.dart';
import 'package:payout/features/travel/presentation/flight_flow.dart';
import 'package:payout/features/travel/presentation/hotel_flow.dart';
import 'package:payout/features/travel/presentation/movie_flow.dart';
import 'package:payout/features/travel/presentation/train_flow.dart';

class TravelScreen extends StatelessWidget {
  const TravelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> categories = [
      {
        'name': 'Flights',
        'desc': 'Book domestic & international flights',
        'icon': Icons.flight_takeoff_rounded,
        'color': AppColors.primary,
        'screen': const FlightSearchScreen(),
      },
      {
        'name': 'Trains',
        'desc': 'Check schedules & book berths',
        'icon': Icons.train_rounded,
        'color': Colors.indigo,
        'screen': const TrainSearchScreen(),
      },
      {
        'name': 'Bus',
        'desc': 'Reserve premium intercity bus seats',
        'icon': Icons.directions_bus_filled_rounded,
        'color': AppColors.success,
        'screen': const BusSearchScreen(),
      },
      {
        'name': 'Hotels',
        'desc': 'Stay at luxury rooms & resorts',
        'icon': Icons.hotel_rounded,
        'color': Colors.orange,
        'screen': const HotelSearchScreen(),
      },
      {
        'name': 'Movies',
        'desc': 'Reserve seat layouts at top cinemas',
        'icon': Icons.movie_creation_rounded,
        'color': Colors.red,
        'screen': const MovieListScreen(),
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Travel & Leisure'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.s24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Service',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.s16),
            ...categories.map((cat) {
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.s16),
                child: AppCard(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => cat['screen'] as Widget),
                    );
                  },
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.s12),
                        decoration: BoxDecoration(
                          color: (cat['color'] as Color).withOpacity(0.08),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(cat['icon'] as IconData, color: cat['color'] as Color, size: 24),
                      ),
                      const SizedBox(width: AppSpacing.s16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cat['name'] as String,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              cat['desc'] as String,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12.0,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 12,
                        color: AppColors.textSecondary,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
            const SizedBox(height: AppSpacing.s40),
          ],
        ),
      ),
    );
  }
}
