import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/app_button.dart';
import 'package:payout/core/widgets/app_card.dart';
import 'package:payout/features/travel/presentation/booking_success_screen.dart';

// 1. MOVIE LIST SCREEN
class MovieListScreen extends StatelessWidget {
  const MovieListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> movies = [
      {'title': 'Kalki 2898 AD', 'genre': 'Sci-Fi / Action / Epic', 'rating': '8.8 ★', 'price': 380.0},
      {'title': 'Jawan', 'genre': 'Action / Thriller', 'rating': '8.2 ★', 'price': 250.0},
      {'title': 'Animal', 'genre': 'Action / Drama', 'rating': '8.0 ★', 'price': 280.0},
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Now Showing'),
      body: ListView.builder(
        padding: const EdgeInsets.all(AppSpacing.s24),
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.s16),
            child: AppCard(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SelectCinemaScreen(
                      movieData: movie,
                    ),
                  ),
                );
              },
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(Icons.movie_creation_rounded, color: AppColors.primary, size: 28),
                  ),
                  const SizedBox(width: AppSpacing.s16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          movie['title'],
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.bold,
                            fontSize: 15.0,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          movie['genre'],
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12.0,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          movie['rating'],
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 11.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// 2. SELECT CINEMA SCREEN
class SelectCinemaScreen extends StatelessWidget {
  final Map<String, dynamic> movieData;

  const SelectCinemaScreen({super.key, required this.movieData});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> cinemas = [
      {
        'name': 'PVR Directors Cut',
        'shows': ['02:00 PM', '05:30 PM', '08:45 PM']
      },
      {
        'name': 'INOX Insignia',
        'shows': ['03:15 PM', '06:30 PM', '09:45 PM']
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: movieData['title']),
      body: ListView.builder(
        padding: const EdgeInsets.all(AppSpacing.s24),
        itemCount: cinemas.length,
        itemBuilder: (context, index) {
          final cinema = cinemas[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.s20),
            child: AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cinema['name'],
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s12),
                  Wrap(
                    spacing: 8.0,
                    children: (cinema['shows'] as List<String>).map((show) {
                      return OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MovieSeatLayoutScreen(
                                movieData: movieData,
                                cinemaName: cinema['name'],
                                showTime: show,
                              ),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.divider),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: Text(
                          show,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// 3. SEAT LAYOUT SCREEN
class MovieSeatLayoutScreen extends StatefulWidget {
  final Map<String, dynamic> movieData;
  final String cinemaName;
  final String showTime;

  const MovieSeatLayoutScreen({
    super.key,
    required this.movieData,
    required this.cinemaName,
    required this.showTime,
  });

  @override
  State<MovieSeatLayoutScreen> createState() => _MovieSeatLayoutScreenState();
}

class _MovieSeatLayoutScreenState extends State<MovieSeatLayoutScreen> {
  String? _selectedSeat;

  Widget _buildSeat(String seatName) {
    final isSelected = _selectedSeat == seatName;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedSeat = seatName;
        });
      },
      child: Container(
        margin: const EdgeInsets.all(AppSpacing.s4),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.primaryLight.withOpacity(0.4),
          borderRadius: BorderRadius.circular(6.0),
        ),
        alignment: Alignment.center,
        child: Text(
          seatName,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 11.0,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : AppColors.primary,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Choose Seats'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.s24),
          child: Column(
            children: [
              // Screen layout guide
              Center(
                child: Container(
                  width: 200,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: AppSpacing.s12),
                  decoration: BoxDecoration(
                    color: AppColors.textSecondary.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const Center(
                child: Text(
                  'SCREEN',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 10.0,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.s24),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 6,
                  children: [
                    _buildSeat('A-01'),
                    _buildSeat('A-02'),
                    _buildSeat('A-03'),
                    _buildSeat('A-04'),
                    _buildSeat('A-05'),
                    _buildSeat('A-06'),
                    _buildSeat('B-01'),
                    _buildSeat('B-02'),
                    _buildSeat('B-03'),
                    _buildSeat('B-04'),
                    _buildSeat('B-05'),
                    _buildSeat('B-06'),
                    _buildSeat('C-01'),
                    _buildSeat('C-02'),
                    _buildSeat('C-03'),
                    _buildSeat('C-04'),
                    _buildSeat('C-05'),
                    _buildSeat('C-06'),
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  text: 'Confirm Seat Selection',
                  onPressed: _selectedSeat != null
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MovieReviewScreen(
                                movieData: widget.movieData,
                                cinemaName: widget.cinemaName,
                                showTime: widget.showTime,
                                selectedSeat: _selectedSeat!,
                              ),
                            ),
                          );
                        }
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 4. REVIEW SCREEN
class MovieReviewScreen extends StatefulWidget {
  final Map<String, dynamic> movieData;
  final String cinemaName;
  final String showTime;
  final String selectedSeat;

  const MovieReviewScreen({
    super.key,
    required this.movieData,
    required this.cinemaName,
    required this.showTime,
    required this.selectedSeat,
  });

  @override
  State<MovieReviewScreen> createState() => _MovieReviewScreenState();
}

class _MovieReviewScreenState extends State<MovieReviewScreen> {
  bool _isProcessing = false;

  void _bookMovie() {
    setState(() {
      _isProcessing = true;
    });

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => BookingSuccessScreen(
              serviceName: 'Movie Ticket - ${widget.movieData['title']}',
              details: '${widget.cinemaName} • Showtime ${widget.showTime} • Seat ${widget.selectedSeat}',
              amount: widget.movieData['price'],
            ),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Review Booking'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.s24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Review Cinema Ticket',
                style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: AppSpacing.s12),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.movieData['title'],
                      style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.movieData['genre'],
                      style: const TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.textSecondary),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.0),
                      child: Divider(color: AppColors.divider),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Cinema', style: TextStyle(fontFamily: 'Inter', fontSize: 13, color: AppColors.textSecondary)),
                        Text(widget.cinemaName, style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 13)),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.s8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Showtime', style: TextStyle(fontFamily: 'Inter', fontSize: 13, color: AppColors.textSecondary)),
                        Text(widget.showTime, style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 13)),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.s8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Seat ID', style: TextStyle(fontFamily: 'Inter', fontSize: 13, color: AppColors.textSecondary)),
                        Text(widget.selectedSeat, style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 13)),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  text: 'Pay ₹${widget.movieData['price']}',
                  isLoading: _isProcessing,
                  onPressed: _isProcessing ? null : _bookMovie,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
