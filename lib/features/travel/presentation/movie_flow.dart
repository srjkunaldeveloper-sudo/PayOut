import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/widgets.dart';
import 'package:payout/features/travel/presentation/booking_success_screen.dart';
import 'package:payout/features/travel/shared/models/travel_models.dart';
import 'package:payout/features/travel/shared/repositories/travel_repository.dart';
import 'package:payout/features/travel/shared/services/travel_service.dart';

// 1. MOVIE SEARCH SCREEN
class MovieSearchScreen extends StatefulWidget {
  const MovieSearchScreen({super.key});

  @override
  State<MovieSearchScreen> createState() => _MovieSearchScreenState();
}

class _MovieSearchScreenState extends State<MovieSearchScreen> {
  final TravelRepository _travelRepository = MockTravelRepository();
  List<MovieModel> _movies = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMovies();
  }

  Future<void> _loadMovies() async {
    final list = await _travelRepository.getMovies();
    if (mounted) {
      setState(() {
        _movies = list;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Search Movies'),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary)))
          : ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.s24),
              itemCount: _movies.length,
              itemBuilder: (context, index) {
                final movie = _movies[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.s16),
                  child: AppCard(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MovieDetailsScreen(
                            movie: movie,
                          ),
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              movie.title,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                              ),
                            ),
                            Text(
                              '₹${movie.pricePerSeat.toStringAsFixed(0)}/seat',
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.s12),
                        Text(
                          movie.genre,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13.0,
                            color: AppColors.textSecondary,
                          ),
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

// 2. MOVIE DETAILS SCREEN
class MovieDetailsScreen extends StatelessWidget {
  final MovieModel movie;

  const MovieDetailsScreen({
    super.key,
    required this.movie,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Movie Details'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.s24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppCard(
                padding: const EdgeInsets.all(AppSpacing.s20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s12),
                    Text(
                      movie.genre,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13.0,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  text: 'Select Seat',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MovieSeatSelectionScreen(
                          movie: movie,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 3. SEAT SELECTION SCREEN
class MovieSeatSelectionScreen extends StatefulWidget {
  final MovieModel movie;

  const MovieSeatSelectionScreen({
    super.key,
    required this.movie,
  });

  @override
  State<MovieSeatSelectionScreen> createState() => _MovieSeatSelectionScreenState();
}

class _MovieSeatSelectionScreenState extends State<MovieSeatSelectionScreen> {
  String? _selectedSeat;

  Widget _buildSeat(String code) {
    final isSelected = _selectedSeat == code;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedSeat = code;
        });
      },
      child: Container(
        margin: const EdgeInsets.all(6.0),
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: isSelected ? AppColors.primary : AppColors.divider, width: 1.5),
        ),
        alignment: Alignment.center,
        child: Text(
          code,
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Choose Seat'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.s24),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildSeat('A1'),
                          _buildSeat('A2'),
                          _buildSeat('A3'),
                          _buildSeat('A4'),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildSeat('B1'),
                          _buildSeat('B2'),
                          _buildSeat('B3'),
                          _buildSeat('B4'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  text: _selectedSeat == null ? 'Select Seat' : 'Continue with $_selectedSeat',
                  onPressed: _selectedSeat == null
                      ? null
                      : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MovieFareSummaryScreen(
                                movie: widget.movie,
                                seatCode: _selectedSeat!,
                              ),
                            ),
                          );
                        },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 4. FARE SUMMARY SCREEN
class MovieFareSummaryScreen extends StatefulWidget {
  final MovieModel movie;
  final String seatCode;

  const MovieFareSummaryScreen({
    super.key,
    required this.movie,
    required this.seatCode,
  });

  @override
  State<MovieFareSummaryScreen> createState() => _MovieFareSummaryScreenState();
}

class _MovieFareSummaryScreenState extends State<MovieFareSummaryScreen> {
  final TravelRepository _travelRepository = MockTravelRepository();
  bool _isBooking = false;

  void _bookTicket() async {
    setState(() {
      _isBooking = true;
    });

    final totalCost = TravelService.calculateTotalCost(rate: widget.movie.pricePerSeat, quantity: 1);
    final success = await _travelRepository.bookTicket('Movie', widget.movie.id, totalCost);

    if (mounted) {
      setState(() {
        _isBooking = false;
      });

      if (success) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BookingSuccessScreen(
              serviceName: 'Movie Ticket: ${widget.movie.title}',
              details: 'Seat: ${widget.seatCode} • Show Class: IMAX 3D',
              amount: totalCost,
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalCost = TravelService.calculateTotalCost(rate: widget.movie.pricePerSeat, quantity: 1);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Fare Breakup'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.s24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Verify Pricing Breakup',
                style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: AppSpacing.s12),
              AppCard(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            widget.movie.title,
                            style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.s8),
                        Text(
                          '₹${totalCost.toStringAsFixed(0)}',
                          style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, color: AppColors.primary),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.s12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('1 Ticket Seat Rate', style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.textSecondary)),
                        Text('₹${widget.movie.pricePerSeat.toStringAsFixed(0)}', style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  text: 'Confirm & Book Movie Show',
                  isLoading: _isBooking,
                  onPressed: _isBooking ? null : _bookTicket,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
