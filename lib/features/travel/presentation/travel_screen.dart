import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/widgets.dart';
import 'package:payout/features/notifications/repositories/notification_repository.dart';
import 'package:payout/features/transactions/repositories/transaction_repository.dart';
import 'package:payout/features/travel/presentation/bus_flow.dart';
import 'package:payout/features/travel/presentation/flight_flow.dart';
import 'package:payout/features/travel/presentation/hotel_flow.dart';
import 'package:payout/features/travel/presentation/movie_flow.dart';
import 'package:payout/features/travel/presentation/my_bookings_screen.dart';
import 'package:payout/features/travel/presentation/train_flow.dart';
import 'package:payout/features/travel/shared/repositories/travel_repository.dart';

class TravelScreen extends StatelessWidget {
  final TravelRepository? travelRepository;

  const TravelScreen({super.key, this.travelRepository});

  @override
  Widget build(BuildContext context) {
    final repository = travelRepository ??
        MockTravelRepository(
          transactionRepository: MockTransactionRepository(),
          notificationRepository: MockNotificationRepository(),
        );

    final List<Map<String, dynamic>> categories = [
      {
        'name': 'Flights',
        'desc': 'Domestic & Int\'l',
        'icon': Icons.flight_takeoff_rounded,
        'color': AppColors.primary,
        'screen': FlightSearchScreen(travelRepository: repository),
      },
      {
        'name': 'Trains',
        'desc': 'IRCTC Booking',
        'icon': Icons.train_rounded,
        'color': Colors.indigo,
        'screen': TrainSearchScreen(travelRepository: repository),
      },
      {
        'name': 'Buses',
        'desc': 'AC & Sleeper',
        'icon': Icons.directions_bus_filled_rounded,
        'color': AppColors.success,
        'screen': BusSearchScreen(travelRepository: repository),
      },
      {
        'name': 'Hotels',
        'desc': 'Luxury & Stays',
        'icon': Icons.hotel_rounded,
        'color': Colors.orange,
        'screen': HotelSearchScreen(travelRepository: repository),
      },
      {
        'name': 'Movies',
        'desc': 'District Cinemas',
        'icon': Icons.movie_creation_rounded,
        'color': Colors.red,
        'screen': MovieHomeScreen(travelRepository: repository),
      },
      {
        'name': 'My Bookings',
        'desc': 'Tickets & PNR',
        'icon': Icons.airplane_ticket_rounded,
        'color': Colors.teal,
        'screen': MyBookingsScreen(travelRepository: repository),
      },
    ];

    final List<Map<String, String>> popularDestinations = [
      {'city': 'Goa', 'desc': 'Sun-kissed beaches & resorts', 'price': 'From ₹3,450'},
      {'city': 'Manali', 'desc': 'Scenic mountains & snow trails', 'price': 'From ₹1,250'},
      {'city': 'Jaipur', 'desc': 'Heritage forts & palaces', 'price': 'From ₹650'},
      {'city': 'Mumbai', 'desc': 'City of dreams & cinema', 'price': 'From ₹4,350'},
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Travel & Entertainment',
        actions: [
          IconButton(
            icon: const Icon(Icons.confirmation_number_outlined, color: AppColors.primary),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyBookingsScreen(travelRepository: repository)),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24, vertical: AppSpacing.s12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Visual Banner
              AppCard(
                color: AppColors.primary,
                borderRadius: AppRadius.xxl,
                padding: const EdgeInsets.all(AppSpacing.s20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Where are you traveling next?',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Search flights, IRCTC trains, buses, stays & cinema tickets',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12.0,
                        color: AppColors.primaryContainer,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s16),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => FlightSearchScreen(travelRepository: repository)),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16, vertical: AppSpacing.s12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(AppRadius.circle),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.search_rounded, color: AppColors.textSecondary, size: 20),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Search flights, trains, hotels, movies...',
                                style: TextStyle(fontFamily: 'Inter', color: AppColors.textSecondary, fontSize: 13.0),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.s24),

              // Categories Grid
              const Text(
                'Explore Categories',
                style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: AppSpacing.s12),

              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: categories.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.85,
                ),
                itemBuilder: (context, index) {
                  final cat = categories[index];
                  final color = cat['color'] as Color;

                  return InkWell(
                    onTap: () {
                      if (cat['screen'] != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => cat['screen'] as Widget),
                        );
                      }
                    },
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    child: AppCard(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s6, vertical: AppSpacing.s8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(AppSpacing.s8),
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(cat['icon'] as IconData, color: color, size: 22),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            cat['name'] as String,
                            style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 12),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            cat['desc'] as String,
                            style: const TextStyle(fontFamily: 'Inter', fontSize: 9, color: AppColors.textSecondary),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: AppSpacing.s24),

              // Offers & Deals Card
              AppCard(
                color: AppColors.primaryContainer.withValues(alpha: 0.4),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(8)),
                      child: const Icon(Icons.local_offer_rounded, color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Flat 12% OFF on Domestic Flights', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primary)),
                          SizedBox(height: 2),
                          Text('Use code PAYOUTFLY on checkout • Zero convenience fee', style: TextStyle(fontFamily: 'Inter', fontSize: 11, color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.s24),

              // Popular Destinations Section
              const Text(
                'Popular Getaways',
                style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: AppSpacing.s12),

              ...popularDestinations.map((dest) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.s12),
                  child: AppCard(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(alpha: 0.08),
                                  borderRadius: BorderRadius.circular(AppRadius.xs),
                                ),
                                child: const Icon(Icons.place_rounded, color: AppColors.primary, size: 20),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(dest['city']!, style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 14)),
                                    const SizedBox(height: 2),
                                    Text(dest['desc']!, style: const TextStyle(fontFamily: 'Inter', fontSize: 11, color: AppColors.textSecondary), maxLines: 1, overflow: TextOverflow.ellipsis),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          dest['price']!,
                          style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.primary),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: AppSpacing.s16),
            ],
          ),
        ),
      ),
    );
  }
}
