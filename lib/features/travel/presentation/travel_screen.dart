import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/app_button.dart';
import 'package:payout/core/widgets/app_card.dart';

class TravelScreen extends StatefulWidget {
  const TravelScreen({super.key});

  @override
  State<TravelScreen> createState() => _TravelScreenState();
}

class _TravelScreenState extends State<TravelScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildTextField(String label, String hint, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 12.0,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          readOnly: true,
          onTap: () {},
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, size: 18, color: AppColors.textSecondary),
            contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.s12, vertical: AppSpacing.s12),
          ),
        ),
      ],
    );
  }

  Widget _buildFlightsTab() {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.s24),
      children: [
        AppCard(
          padding: const EdgeInsets.all(AppSpacing.s20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField('From', 'New York (JFK)', Icons.flight_takeoff_rounded),
              const SizedBox(height: AppSpacing.s16),
              _buildTextField('To', 'London (LHR)', Icons.flight_land_rounded),
              const SizedBox(height: AppSpacing.s16),
              Row(
                children: [
                  Expanded(child: _buildTextField('Departure', 'Aug 12, 2026', Icons.calendar_today_rounded)),
                  const SizedBox(width: AppSpacing.s12),
                  Expanded(child: _buildTextField('Passengers', '1 Adult, Economy', Icons.person_rounded)),
                ],
              ),
              const SizedBox(height: AppSpacing.s24),
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  text: 'Search Flights',
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Searching for flights...')),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTrainsTab() {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.s24),
      children: [
        AppCard(
          padding: const EdgeInsets.all(AppSpacing.s20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField('From Station', 'Grand Central', Icons.train_rounded),
              const SizedBox(height: AppSpacing.s16),
              _buildTextField('To Station', 'Boston South Station', Icons.train_rounded),
              const SizedBox(height: AppSpacing.s16),
              Row(
                children: [
                  Expanded(child: _buildTextField('Date', 'Aug 14, 2026', Icons.calendar_today_rounded)),
                  const SizedBox(width: AppSpacing.s12),
                  Expanded(child: _buildTextField('Class', 'AC Chair Car', Icons.style_rounded)),
                ],
              ),
              const SizedBox(height: AppSpacing.s24),
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  text: 'Search Trains',
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Searching for trains...')),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBusesTab() {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.s24),
      children: [
        AppCard(
          padding: const EdgeInsets.all(AppSpacing.s20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField('From City', 'Washington D.C.', Icons.directions_bus_rounded),
              const SizedBox(height: AppSpacing.s16),
              _buildTextField('To City', 'Philadelphia', Icons.directions_bus_rounded),
              const SizedBox(height: AppSpacing.s16),
              _buildTextField('Departure Date', 'Aug 16, 2026', Icons.calendar_today_rounded),
              const SizedBox(height: AppSpacing.s24),
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  text: 'Search Buses',
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Searching for buses...')),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHotelsTab() {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.s24),
      children: [
        AppCard(
          padding: const EdgeInsets.all(AppSpacing.s20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField('Destination / Hotel', 'Miami, Florida', Icons.apartment_rounded),
              const SizedBox(height: AppSpacing.s16),
              Row(
                children: [
                  Expanded(child: _buildTextField('Check In', 'Aug 20, 2026', Icons.calendar_today_rounded)),
                  const SizedBox(width: AppSpacing.s12),
                  Expanded(child: _buildTextField('Check Out', 'Aug 25, 2026', Icons.calendar_today_rounded)),
                ],
              ),
              const SizedBox(height: AppSpacing.s16),
              _buildTextField('Rooms & Guests', '1 Room, 2 Adults', Icons.group_rounded),
              const SizedBox(height: AppSpacing.s24),
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  text: 'Search Hotels',
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Searching for hotel deals...')),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMoviesTab() {
    return GridView.builder(
      padding: const EdgeInsets.all(AppSpacing.s24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.7,
      ),
      itemCount: 4,
      itemBuilder: (context, index) {
        final List<Map<String, String>> movies = [
          {'title': 'Oppenheimer', 'genre': 'Biography, Drama', 'rating': '8.9/10'},
          {'title': 'Barbie', 'genre': 'Adventure, Comedy', 'rating': '7.4/10'},
          {'title': 'Mission Impossible', 'genre': 'Action, Thriller', 'rating': '8.0/10'},
          {'title': 'Spider-Man', 'genre': 'Animation, Sci-Fi', 'rating': '8.7/10'},
        ];
        final movie = movies[index];
        return AppCard(
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight.withOpacity(0.3),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadii.card)),
                  ),
                  child: Center(
                    child: Icon(Icons.movie_rounded, color: AppColors.primary.withOpacity(0.5), size: 40),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie['title']!,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      movie['genre']!,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.star_rounded, color: Colors.amber, size: 14),
                            const SizedBox(width: 4),
                            Text(
                              movie['rating']!,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Booking tickets for ${movie['title']}')),
                            );
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: AppColors.primaryLight,
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                          ),
                          child: const Text(
                            'Book',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Travel & Leisure'),
      body: Column(
        children: [
          Container(
            color: AppColors.background,
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textSecondary,
              indicatorColor: AppColors.primary,
              indicatorWeight: 2,
              dividerColor: AppColors.divider,
              labelStyle: const TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
              ),
              unselectedLabelStyle: const TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
                fontSize: 14.0,
              ),
              tabs: const [
                Tab(text: 'Flights'),
                Tab(text: 'Trains'),
                Tab(text: 'Buses'),
                Tab(text: 'Hotels'),
                Tab(text: 'Movies'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildFlightsTab(),
                _buildTrainsTab(),
                _buildBusesTab(),
                _buildHotelsTab(),
                _buildMoviesTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
