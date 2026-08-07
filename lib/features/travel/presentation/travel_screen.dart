import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/widgets.dart';
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
      {'name': 'Flights', 'icon': Icons.flight_takeoff_rounded, 'color': AppColors.primary, 'screen': const FlightSearchScreen()},
      {'name': 'Trains', 'icon': Icons.train_rounded, 'color': Colors.indigo, 'screen': const TrainSearchScreen()},
      {'name': 'Buses', 'icon': Icons.directions_bus_filled_rounded, 'color': AppColors.success, 'screen': const BusSearchScreen()},
      {'name': 'Hotels', 'icon': Icons.hotel_rounded, 'color': Colors.orange, 'screen': const HotelSearchScreen()},
      {'name': 'Movies', 'icon': Icons.movie_creation_rounded, 'color': Colors.red, 'screen': const MovieListScreen()},
      {'name': 'Insurance', 'icon': Icons.shield_rounded, 'color': Colors.teal, 'screen': null},
    ];

    final List<Map<String, String>> popularDestinations = [
      {'city': 'Goa', 'desc': 'Sun-kissed beaches', 'price': '₹4,200+'},
      {'city': 'Shimla', 'desc': 'Scenic mountains', 'price': '₹6,500+'},
      {'city': 'Jaipur', 'desc': 'Heritage & palaces', 'price': '₹3,800+'},
      {'city': 'Ooty', 'desc': 'Lush tea gardens', 'price': '₹5,100+'},
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Travel Ecosystem'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24, vertical: AppSpacing.s12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Hero visual search banner
            AppCard(
              color: AppColors.primary,
              borderRadius: AppRadius.xxl,
              padding: const EdgeInsets.all(AppSpacing.s24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Where to go next?',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Search domestic flights, trains, and stays',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12.0,
                      color: AppColors.primaryContainer,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s20),
                  // Flat mock search input bar
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16, vertical: AppSpacing.s12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppRadius.circle),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.search_rounded, color: AppColors.textSecondary, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Search destinations or hotels',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            color: AppColors.textSecondary,
                            fontSize: 13.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.s24),

            // 2. Categories Grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: categories.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.95,
              ),
              itemBuilder: (context, index) {
                final cat = categories[index];
                return AppCard(
                  onTap: () {
                    if (cat['screen'] != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => cat['screen'] as Widget),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Travel Insurance flows coming soon.')),
                      );
                    }
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.s8),
                        decoration: BoxDecoration(
                          color: (cat['color'] as Color).withOpacity(0.08),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(cat['icon'] as IconData, color: cat['color'] as Color, size: 22),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        cat['name'] as String,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: AppSpacing.s32),

            // 3. Upcoming Trips Boarding Pass Layout
            const Text(
              'Upcoming Trips',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.s16),
            AppCard(
              color: AppColors.primaryContainer,
              padding: const EdgeInsets.all(AppSpacing.s20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.flight_takeoff_rounded, color: AppColors.primary, size: 16),
                          SizedBox(width: 6),
                          Text(
                            'IndiGo • 6E-2041',
                            style: TextStyle(fontFamily: 'Inter', fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary),
                          ),
                        ],
                      ),
                      const Text(
                        '15 Aug • 08:30 AM',
                        style: TextStyle(fontFamily: 'Inter', fontSize: 11, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.s16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('DEL', style: TextStyle(fontFamily: 'Inter', fontSize: 24, fontWeight: FontWeight.bold)),
                          Text('New Delhi', style: TextStyle(fontFamily: 'Inter', fontSize: 11, color: AppColors.textSecondary)),
                        ],
                      ),
                      const Icon(Icons.arrow_forward_rounded, color: AppColors.textSecondary),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: const [
                          Text('BOM', style: TextStyle(fontFamily: 'Inter', fontSize: 24, fontWeight: FontWeight.bold)),
                          Text('Mumbai', style: TextStyle(fontFamily: 'Inter', fontSize: 11, color: AppColors.textSecondary)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.s32),

            // 4. Popular Destinations Grid
            const Text(
              'Popular Destinations',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.s16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: popularDestinations.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.3,
              ),
              itemBuilder: (context, index) {
                final dest = popularDestinations[index];
                return AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        dest['city']!,
                        style: const TextStyle(fontFamily: 'Inter', fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        dest['desc']!,
                        style: const TextStyle(fontFamily: 'Inter', fontSize: 11, color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Stays from ${dest['price']}',
                        style: const TextStyle(fontFamily: 'Inter', fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: AppSpacing.s24),
          ],
        ),
      ),
    );
  }
}
