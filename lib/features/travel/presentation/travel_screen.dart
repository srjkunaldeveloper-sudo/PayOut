import 'package:flutter/material.dart';
import 'package:payout/core/di/app_dependencies.dart';
import 'package:payout/features/travel/presentation/bus_flow.dart';
import 'package:payout/features/travel/presentation/flight_flow.dart';
import 'package:payout/features/travel/presentation/hotel_flow.dart';
import 'package:payout/features/travel/presentation/my_bookings_screen.dart';
import 'package:payout/features/travel/presentation/train_flow.dart';
import 'package:payout/features/travel/shared/repositories/travel_repository.dart';

class TravelScreen extends StatelessWidget {
  final TravelRepository? travelRepository;

  const TravelScreen({super.key, this.travelRepository});

  @override
  Widget build(BuildContext context) {
    final repository = travelRepository ?? AppDependencies.instance.travelRepository;
    final canPop = Navigator.of(context).canPop();

    final List<Map<String, dynamic>> popularDestinations = const [
      {'city': 'Goa', 'desc': 'Sun-kissed beaches & resorts', 'price': 'From ₹3,450'},
      {'city': 'Manali', 'desc': 'Scenic mountains & snow trails', 'price': 'From ₹1,250'},
      {'city': 'Jaipur', 'desc': 'Heritage forts & palaces', 'price': 'From ₹650'},
      {'city': 'Mumbai', 'desc': 'City of dreams & cinema', 'price': 'From ₹4,350'},
    ];

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
                      'Travel',
                      style: TextStyle(
                        fontFamily: 'Geist Sans',
                        fontSize: 18,
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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Travel Header / Intro
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Travel smarter',
                    style: TextStyle(
                      fontFamily: 'Geist Sans',
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF3F37C9),
                      letterSpacing: 1.0,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Book flights, trains, buses & hotels',
                    style: TextStyle(
                      fontFamily: 'Geist Sans',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F1F1F),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Booking Services Grouped Card
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
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
                    _buildTravelItem(
                      icon: Icons.flight_takeoff_rounded,
                      title: 'Flights',
                      subtitle: 'Book domestic & international',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FlightSearchScreen(travelRepository: repository),
                          ),
                        );
                      },
                    ),
                    const Divider(height: 1, color: Color(0xFFF1F5F9)),
                    _buildTravelItem(
                      icon: Icons.train_rounded,
                      title: 'Trains',
                      subtitle: 'Book train tickets',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TrainSearchScreen(travelRepository: repository),
                          ),
                        );
                      },
                    ),
                    const Divider(height: 1, color: Color(0xFFF1F5F9)),
                    _buildTravelItem(
                      icon: Icons.directions_bus_filled_rounded,
                      title: 'Bus',
                      subtitle: 'Book AC, Volvo & more',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BusSearchScreen(travelRepository: repository),
                          ),
                        );
                      },
                    ),
                    const Divider(height: 1, color: Color(0xFFF1F5F9)),
                    _buildTravelItem(
                      icon: Icons.hotel_rounded,
                      title: 'Hotels',
                      subtitle: 'Stay, offers & discounts',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HotelSearchScreen(travelRepository: repository),
                          ),
                        );
                      },
                    ),
                    const Divider(height: 1, color: Color(0xFFF1F5F9)),
                    _buildTravelItem(
                      icon: Icons.airplane_ticket_rounded,
                      title: 'My Bookings',
                      subtitle: 'Tickets & PNR Status',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyBookingsScreen(travelRepository: repository),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Offers & Deals Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.2)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.local_offer_rounded, color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Flat 12% OFF on Domestic Flights',
                            style: TextStyle(
                              fontFamily: 'Geist Sans',
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: Color(0xFF047857),
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Use code PAYOUTFLY on checkout • Zero convenience fee',
                            style: TextStyle(
                              fontFamily: 'Geist Sans',
                              fontSize: 11,
                              color: Color(0xFF047857),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Popular Getaways Section
              const Text(
                'Popular Getaways',
                style: TextStyle(
                  fontFamily: 'Geist Sans',
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F1F1F),
                ),
              ),
              const SizedBox(height: 12),

              ...popularDestinations.map((dest) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF3F37C9).withValues(alpha: 0.06),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(Icons.place_rounded, color: Color(0xFF3F37C9), size: 20),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      dest['city']!,
                                      style: const TextStyle(
                                        fontFamily: 'Geist Sans',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Color(0xFF1F1F1F),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      dest['desc']!,
                                      style: const TextStyle(
                                        fontFamily: 'Geist Sans',
                                        fontSize: 11.5,
                                        color: Color(0xFF64748B),
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          dest['price']!,
                          style: const TextStyle(
                            fontFamily: 'Geist Sans',
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Color(0xFF3F37C9),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTravelItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: const Color(0xFF3F37C9).withValues(alpha: 0.06),
              ),
              alignment: Alignment.center,
              child: Icon(icon, color: const Color(0xFF3F37C9), size: 26),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'Geist Sans',
                      fontSize: 14.5,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F1F1F),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontFamily: 'Geist Sans',
                      fontSize: 11.5,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Color(0xFF3F37C9),
              size: 13,
            ),
          ],
        ),
      ),
    );
  }
}
