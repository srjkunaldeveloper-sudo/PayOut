import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/widgets.dart';
import 'package:payout/core/di/app_dependencies.dart';
import 'package:payout/features/payments/presentation/mpin_verification_screen.dart';
import 'package:payout/features/travel/presentation/booking_success_screen.dart';
import 'package:payout/features/travel/shared/models/travel_models.dart';
import 'package:payout/features/travel/shared/repositories/travel_repository.dart';
import 'package:payout/features/travel/shared/services/travel_service.dart';
import 'package:payout/features/travel/shared/validators/travel_validator.dart';

// ==========================================
// 1. MOVIE DISCOVERY HOME (ZOMATO / DISTRICT STYLE)
// ==========================================

class MovieHomeScreen extends StatefulWidget {
  final TravelRepository? travelRepository;

  const MovieHomeScreen({super.key, this.travelRepository});

  @override
  State<MovieHomeScreen> createState() => _MovieHomeScreenState();
}

class _MovieHomeScreenState extends State<MovieHomeScreen> {
  late final TravelRepository _travelRepository;

  String _selectedCity = 'Delhi';
  bool _nowShowing = true;
  String _selectedLanguage = 'All';
  String _selectedGenre = 'All';
  bool _isLoading = true;
  List<MovieModel> _movies = [];

  final List<String> _cities = ['Delhi', 'Mumbai', 'Bengaluru', 'Hyderabad', 'Chennai', 'Pune', 'Jaipur', 'Lucknow'];
  final List<String> _languages = ['All', 'English', 'Hindi', 'Tamil', 'Telugu'];
  final List<String> _genres = ['All', 'Action', 'Sci-Fi', 'Drama', 'Biography', 'Thriller'];

  @override
  void initState() {
    super.initState();
    _travelRepository = widget.travelRepository ?? AppDependencies.instance.travelRepository;
    _fetchMovies();
  }

  Future<void> _fetchMovies() async {
    setState(() => _isLoading = true);
    final results = await _travelRepository.getMovies(city: _selectedCity);
    if (mounted) {
      setState(() {
        _movies = results;
        _isLoading = false;
      });
    }
  }

  void _showCitySelector() {
    showModalBottomSheet(
      context: context,
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
                child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.divider, borderRadius: BorderRadius.circular(2))),
              ),
              const SizedBox(height: AppSpacing.s16),
              const Text('Select Your City', style: TextStyle(fontFamily: 'Geist Sans', fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 4),
              const Text('Theatres and showtimes will be customized for your city.', style: TextStyle(fontFamily: 'Geist Sans', fontSize: 12, color: AppColors.textSecondary)),
              const SizedBox(height: AppSpacing.s16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _cities.map((city) {
                  final isSelected = _selectedCity == city;
                  return ChoiceChip(
                    label: Text(city, style: TextStyle(fontFamily: 'Geist Sans', fontSize: 12, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                    selected: isSelected,
                    selectedColor: AppColors.primaryContainer,
                    onSelected: (val) {
                      Navigator.pop(modalContext);
                      setState(() => _selectedCity = city);
                      _fetchMovies();
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: AppSpacing.s16),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = TravelService.filterMovies(
      _movies,
      language: _selectedLanguage,
      genre: _selectedGenre,
      nowShowingOnly: _nowShowing,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'District Movies',
        actions: [
          TextButton.icon(
            onPressed: _showCitySelector,
            icon: const Icon(Icons.location_on_rounded, size: 16, color: AppColors.primary),
            label: Text(
              _selectedCity,
              style: const TextStyle(fontFamily: 'Geist Sans', fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primary),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Tabs: Now Showing vs Coming Soon
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s20, vertical: AppSpacing.s8),
              child: Row(
                children: [
                  ChoiceChip(
                    label: const Text('Now Showing', style: TextStyle(fontFamily: 'Geist Sans', fontSize: 12, fontWeight: FontWeight.bold)),
                    selected: _nowShowing,
                    selectedColor: AppColors.primaryContainer,
                    onSelected: (val) => setState(() => _nowShowing = true),
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('Coming Soon', style: TextStyle(fontFamily: 'Geist Sans', fontSize: 12, fontWeight: FontWeight.bold)),
                    selected: !_nowShowing,
                    selectedColor: AppColors.primaryContainer,
                    onSelected: (val) => setState(() => _nowShowing = false),
                  ),
                ],
              ),
            ),

            // Language & Genre Filter Pills
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s20, vertical: AppSpacing.s4),
              child: Row(
                children: [
                  ..._languages.map((l) => Padding(
                        padding: const EdgeInsets.only(right: 6.0),
                        child: FilterChip(
                          label: Text(l, style: const TextStyle(fontFamily: 'Geist Sans', fontSize: 11)),
                          selected: _selectedLanguage == l,
                          selectedColor: AppColors.primaryContainer,
                          onSelected: (val) => setState(() => _selectedLanguage = l),
                        ),
                      )),
                  const SizedBox(width: 8),
                  ..._genres.map((g) => Padding(
                        padding: const EdgeInsets.only(right: 6.0),
                        child: FilterChip(
                          label: Text(g, style: const TextStyle(fontFamily: 'Geist Sans', fontSize: 11)),
                          selected: _selectedGenre == g,
                          selectedColor: AppColors.primaryContainer,
                          onSelected: (val) => setState(() => _selectedGenre = g),
                        ),
                      )),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.s8),

            // Movies Grid / List
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : filtered.isEmpty
                      ? const Center(child: Text('No movies matching criteria', style: TextStyle(fontFamily: 'Geist Sans', color: AppColors.textSecondary)))
                      : ListView.builder(
                          padding: const EdgeInsets.all(AppSpacing.s20),
                          itemCount: filtered.length,
                          itemBuilder: (context, index) {
                            final movie = filtered[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: AppSpacing.s16),
                              child: AppCard(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MovieDetailScreen(
                                          movie: movie,
                                          city: _selectedCity,
                                          travelRepository: _travelRepository,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // Movie Poster placeholder thumbnail
                                          Container(
                                            width: 70,
                                            height: 95,
                                            decoration: BoxDecoration(
                                              color: AppColors.primary.withValues(alpha: 0.1),
                                              borderRadius: BorderRadius.circular(AppRadius.xs),
                                            ),
                                            child: const Icon(Icons.movie_creation_outlined, color: AppColors.primary, size: 36),
                                          ),
                                          const SizedBox(width: 14),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  movie.title,
                                                  style: const TextStyle(fontFamily: 'Geist Sans', fontWeight: FontWeight.bold, fontSize: 15),
                                                ),
                                                const SizedBox(height: 3),
                                                Text(
                                                  '${movie.language} • ${movie.genre}',
                                                  style: const TextStyle(fontFamily: 'Geist Sans', fontSize: 11, color: AppColors.textSecondary),
                                                ),
                                                const SizedBox(height: 4),
                                                Row(
                                                  children: [
                                                    const Icon(Icons.star_rounded, size: 16, color: Colors.amber),
                                                    const SizedBox(width: 3),
                                                    Text(
                                                      '${movie.rating} / 10',
                                                      style: const TextStyle(fontFamily: 'Geist Sans', fontWeight: FontWeight.bold, fontSize: 12),
                                                    ),
                                                    const SizedBox(width: 6),
                                                    Text(
                                                      '(${movie.votes} votes)',
                                                      style: const TextStyle(fontFamily: 'Geist Sans', fontSize: 10, color: AppColors.textSecondary),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 6),
                                                Text(
                                                  '${movie.duration} • Released: ${movie.releaseDate}',
                                                  style: const TextStyle(fontFamily: 'Geist Sans', fontSize: 10, color: AppColors.textSecondary),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      const Divider(color: AppColors.divider),
                                      const SizedBox(height: 8),

                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Wrap(
                                            spacing: 6,
                                            children: movie.formats
                                                .take(3)
                                                .map((fmt) => Container(
                                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                      decoration: BoxDecoration(
                                                        color: AppColors.divider.withValues(alpha: 0.5),
                                                        borderRadius: BorderRadius.circular(4),
                                                      ),
                                                      child: Text(fmt, style: const TextStyle(fontFamily: 'Geist Sans', fontSize: 9, fontWeight: FontWeight.bold)),
                                                    ))
                                                .toList(),
                                          ),
                                          PrimaryButton(
                                            text: movie.isNowShowing ? 'Book Tickets' : 'View Details',
                                            width: 120,
                                            height: 36,
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => MovieDetailScreen(
                                                    movie: movie,
                                                    city: _selectedCity,
                                                    travelRepository: _travelRepository,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 2. MOVIE DETAIL SCREEN
// ==========================================

class MovieDetailScreen extends StatelessWidget {
  final MovieModel movie;
  final String city;
  final TravelRepository travelRepository;

  const MovieDetailScreen({
    super.key,
    required this.movie,
    required this.city,
    required this.travelRepository,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: movie.title),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.s24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Movie Hero Banner
              AppCard(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 80,
                      height: 110,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppRadius.xs),
                      ),
                      child: const Icon(Icons.movie_filter_rounded, color: AppColors.primary, size: 40),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(movie.title, style: const TextStyle(fontFamily: 'Geist Sans', fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(height: 4),
                          Text('${movie.language} • ${movie.genre}', style: const TextStyle(fontFamily: 'Geist Sans', fontSize: 11, color: AppColors.textSecondary)),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.star_rounded, size: 18, color: Colors.amber),
                              const SizedBox(width: 4),
                              Text('${movie.rating}/10', style: const TextStyle(fontFamily: 'Geist Sans', fontWeight: FontWeight.bold, fontSize: 13)),
                              const SizedBox(width: 6),
                              Text('(${movie.votes} votes)', style: const TextStyle(fontFamily: 'Geist Sans', fontSize: 11, color: AppColors.textSecondary)),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text('${movie.duration} • ${movie.releaseDate}', style: const TextStyle(fontFamily: 'Geist Sans', fontSize: 11, color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.s20),

              // Available Formats
              const Text('Available Formats', style: TextStyle(fontFamily: 'Geist Sans', fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: AppSpacing.s8),
              Wrap(
                spacing: 8,
                children: movie.formats
                    .map((f) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primaryContainer,
                            borderRadius: BorderRadius.circular(AppRadius.xs),
                          ),
                          child: Text(f, style: const TextStyle(fontFamily: 'Geist Sans', fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary)),
                        ))
                    .toList(),
              ),
              const SizedBox(height: AppSpacing.s20),

              // Synopsis
              const Text('Synopsis', style: TextStyle(fontFamily: 'Geist Sans', fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: AppSpacing.s6),
              Text(
                movie.synopsis.isNotEmpty ? movie.synopsis : 'Experience the cinematic spectacle on the grand screen with enhanced IMAX laser projection and immersive Dolby Atmos spatial acoustics.',
                style: const TextStyle(fontFamily: 'Geist Sans', fontSize: 12, height: 1.5, color: AppColors.textSecondary),
              ),
              const SizedBox(height: AppSpacing.s20),

              // Cast
              const Text('Starring Cast', style: TextStyle(fontFamily: 'Geist Sans', fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: AppSpacing.s8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: movie.cast
                    .map((actor) => Chip(
                          label: Text(actor, style: const TextStyle(fontFamily: 'Geist Sans', fontSize: 11)),
                          backgroundColor: Colors.white,
                          side: const BorderSide(color: AppColors.divider),
                        ))
                    .toList(),
              ),
              const SizedBox(height: AppSpacing.s24),

              // Book Tickets CTA
              if (movie.isNowShowing) ...[
                SizedBox(
                  width: double.infinity,
                  child: PrimaryButton(
                    text: 'Select Theatre & Showtimes ($city)',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MovieShowtimeSelectionScreen(
                            movie: movie,
                            city: city,
                            travelRepository: travelRepository,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// 3. MOVIE SHOWTIME SELECTION SCREEN
// ==========================================

class MovieShowtimeSelectionScreen extends StatefulWidget {
  final MovieModel movie;
  final String city;
  final TravelRepository travelRepository;

  const MovieShowtimeSelectionScreen({
    super.key,
    required this.movie,
    required this.city,
    required this.travelRepository,
  });

  @override
  State<MovieShowtimeSelectionScreen> createState() => _MovieShowtimeSelectionScreenState();
}

class _MovieShowtimeSelectionScreenState extends State<MovieShowtimeSelectionScreen> {
  String _selectedDate = 'Today';
  bool _isLoading = true;
  List<MovieTheatreModel> _theatres = [];
  List<MovieShowModel> _shows = [];

  final List<String> _dates = ['Today', 'Tomorrow', 'Sun, 10 Aug', 'Mon, 11 Aug'];

  @override
  void initState() {
    super.initState();
    _fetchTheatresAndShows();
  }

  Future<void> _fetchTheatresAndShows() async {
    setState(() => _isLoading = true);
    final theatres = await widget.travelRepository.getMovieTheatres(
      widget.movie.id,
      city: widget.city,
      date: _selectedDate,
    );
    final shows = await widget.travelRepository.getMovieShows(
      widget.movie.id,
      theatres.isNotEmpty ? theatres.first.id : 'THTR-01',
      date: _selectedDate,
    );
    if (mounted) {
      setState(() {
        _theatres = theatres;
        _shows = shows;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: '${widget.movie.title} • ${widget.city}',
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Horizontal Date Selector
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s20, vertical: AppSpacing.s12),
              child: Row(
                children: _dates.map((d) {
                  final isSelected = _selectedDate == d;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(d, style: TextStyle(fontFamily: 'Geist Sans', fontSize: 12, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                      selected: isSelected,
                      selectedColor: AppColors.primaryContainer,
                      onSelected: (val) {
                        setState(() => _selectedDate = d);
                        _fetchTheatresAndShows();
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            const Divider(color: AppColors.divider),

            // Theatres and Showtimes List
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _theatres.isEmpty
                      ? const Center(child: Text('No theatres available in this city', style: TextStyle(fontFamily: 'Geist Sans', color: AppColors.textSecondary)))
                      : ListView.builder(
                          padding: const EdgeInsets.all(AppSpacing.s20),
                          itemCount: _theatres.length,
                          itemBuilder: (context, index) {
                            final theatre = _theatres[index];

                            return Padding(
                              padding: const EdgeInsets.only(bottom: AppSpacing.s16),
                              child: AppCard(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(theatre.name, style: const TextStyle(fontFamily: 'Geist Sans', fontWeight: FontWeight.bold, fontSize: 14)),
                                        ),
                                        Text(theatre.distance, style: const TextStyle(fontFamily: 'Geist Sans', fontSize: 11, color: AppColors.textSecondary)),
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Text(theatre.location, style: const TextStyle(fontFamily: 'Geist Sans', fontSize: 11, color: AppColors.textSecondary)),
                                    const SizedBox(height: 12),

                                    // Showtimes Chips
                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      children: _shows.map((show) {
                                        return InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => CinemaSeatSelectionScreen(
                                                  movie: widget.movie,
                                                  theatre: theatre,
                                                  show: show,
                                                  date: _selectedDate,
                                                  travelRepository: widget.travelRepository,
                                                ),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                            decoration: BoxDecoration(
                                              border: Border.all(color: AppColors.primary),
                                              borderRadius: BorderRadius.circular(AppRadius.xs),
                                            ),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(show.time, style: const TextStyle(fontFamily: 'Geist Sans', fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.primary)),
                                                const SizedBox(height: 2),
                                                Text('${show.format} • ₹${show.pricePerSeat.toInt()}', style: const TextStyle(fontFamily: 'Geist Sans', fontSize: 9, color: AppColors.textSecondary)),
                                              ],
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
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 4. CINEMA SEAT SELECTION SCREEN
// ==========================================

class CinemaSeatSelectionScreen extends StatefulWidget {
  final MovieModel movie;
  final MovieTheatreModel theatre;
  final MovieShowModel show;
  final String date;
  final TravelRepository travelRepository;

  const CinemaSeatSelectionScreen({
    super.key,
    required this.movie,
    required this.theatre,
    required this.show,
    required this.date,
    required this.travelRepository,
  });

  @override
  State<CinemaSeatSelectionScreen> createState() => _CinemaSeatSelectionScreenState();
}

class _CinemaSeatSelectionScreenState extends State<CinemaSeatSelectionScreen> {
  bool _isLoading = true;
  List<MovieSeatModel> _seats = [];
  final List<MovieSeatModel> _selectedSeats = [];

  @override
  void initState() {
    super.initState();
    _fetchSeats();
  }

  Future<void> _fetchSeats() async {
    setState(() => _isLoading = true);
    final results = await widget.travelRepository.getMovieSeats(
      widget.show.id,
      basePrice: widget.show.pricePerSeat,
    );
    if (mounted) {
      setState(() {
        _seats = results;
        _isLoading = false;
      });
    }
  }

  void _toggleSeat(MovieSeatModel seat) {
    if (!seat.isAvailable) return;

    setState(() {
      if (_selectedSeats.any((s) => s.id == seat.id)) {
        _selectedSeats.removeWhere((s) => s.id == seat.id);
      } else {
        if (_selectedSeats.length >= 6) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Maximum 6 movie tickets allowed per transaction.')),
          );
          return;
        }
        _selectedSeats.add(seat);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final pricing = TravelService.calculateMoviePricing(selectedSeats: _selectedSeats);
    final total = pricing['total'] ?? 0.0;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: '${widget.movie.title} (${widget.show.format})',
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Theatre & Time Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s20, vertical: AppSpacing.s8),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.theatre.name, style: const TextStyle(fontFamily: 'Geist Sans', fontWeight: FontWeight.bold, fontSize: 12)),
                  Text('${widget.date}, ${widget.show.time}', style: const TextStyle(fontFamily: 'Geist Sans', fontSize: 11, color: AppColors.textSecondary)),
                ],
              ),
            ),
            const Divider(color: AppColors.divider, height: 1),

            // Screen & Interactive Seat Map
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(AppSpacing.s20),
                      child: Column(
                        children: [
                          // Cinema Curved Screen Graphic
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            height: 6,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.4),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'SCREEN THIS WAY',
                            style: TextStyle(fontFamily: 'Geist Sans', fontSize: 9, letterSpacing: 2, color: AppColors.textSecondary),
                          ),
                          const SizedBox(height: AppSpacing.s24),

                          // Seat rows
                          ...['A', 'B', 'C', 'D', 'E', 'F'].map((rowLetter) {
                            final rowSeats = _seats.where((s) => s.row == rowLetter).toList();
                            if (rowSeats.isEmpty) return const SizedBox.shrink();

                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 20,
                                    child: Text(
                                      rowLetter,
                                      style: const TextStyle(fontFamily: 'Geist Sans', fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
                                    ),
                                  ),
                                  ...rowSeats.map((seat) {
                                    final isSelected = _selectedSeats.any((s) => s.id == seat.id);
                                    Color bg = Colors.white;
                                    Border? border = Border.all(color: AppColors.divider);

                                    if (isSelected) {
                                      bg = AppColors.primary;
                                      border = null;
                                    } else if (!seat.isAvailable) {
                                      bg = Colors.grey.shade300;
                                      border = null;
                                    }

                                    return Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 3.0),
                                      child: InkWell(
                                        onTap: () => _toggleSeat(seat),
                                        borderRadius: BorderRadius.circular(4),
                                        child: Container(
                                          width: 32,
                                          height: 32,
                                          decoration: BoxDecoration(
                                            color: bg,
                                            border: border,
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            seat.number.toString(),
                                            style: TextStyle(
                                              fontFamily: 'Geist Sans',
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: isSelected ? Colors.white : (seat.isAvailable ? AppColors.textPrimary : Colors.grey.shade600),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
            ),

            // Bottom Sticky Ticket Summary
            Container(
              padding: const EdgeInsets.all(AppSpacing.s20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -4)),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _selectedSeats.isEmpty ? 'Select Seats' : 'Seats: ${_selectedSeats.map((s) => s.id).join(', ')}',
                        style: const TextStyle(fontFamily: 'Geist Sans', fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      Text(
                        '₹${total.toStringAsFixed(2)}',
                        style: const TextStyle(fontFamily: 'Geist Sans', fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.primary),
                      ),
                    ],
                  ),
                  PrimaryButton(
                    text: 'Pay ₹${total.toStringAsFixed(2)}',
                    width: 140,
                    height: 44,
                    onPressed: _selectedSeats.isNotEmpty
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MovieTicketReviewScreen(
                                  movie: widget.movie,
                                  theatre: widget.theatre,
                                  show: widget.show,
                                  date: widget.date,
                                  selectedSeats: _selectedSeats,
                                  pricing: pricing,
                                  travelRepository: widget.travelRepository,
                                ),
                              ),
                            );
                          }
                        : null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 5. MOVIE TICKET REVIEW & PAYMENT
// ==========================================

class MovieTicketReviewScreen extends StatefulWidget {
  final MovieModel movie;
  final MovieTheatreModel theatre;
  final MovieShowModel show;
  final String date;
  final List<MovieSeatModel> selectedSeats;
  final Map<String, double> pricing;
  final TravelRepository travelRepository;

  const MovieTicketReviewScreen({
    super.key,
    required this.movie,
    required this.theatre,
    required this.show,
    required this.date,
    required this.selectedSeats,
    required this.pricing,
    required this.travelRepository,
  });

  @override
  State<MovieTicketReviewScreen> createState() => _MovieTicketReviewScreenState();
}

class _MovieTicketReviewScreenState extends State<MovieTicketReviewScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _proceedToPayment() {
    if (!_formKey.currentState!.validate()) return;

    final total = widget.pricing['total'] ?? 0.0;
    final seatIds = widget.selectedSeats.map((s) => s.id).join(', ');

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentMPINVerificationScreen(
          recipientName: widget.theatre.name,
          recipientDetail: '${widget.movie.title} ($seatIds)',
          recipientType: 'Movie',
          amount: total,
          note: 'Movie Tickets ${widget.movie.title}',
          methodId: 'wallet',
          onSuccess: () async {
            final booking = TravelBookingModel(
              id: 'BKG-MOV-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
              category: 'Movie',
              title: widget.movie.title,
              subtitle: '${widget.theatre.name} (${widget.show.format})',
              routeOrLocation: 'Audi 2 • ${widget.theatre.location}',
              travelDate: '${widget.date}, ${widget.show.time}',
              quantity: widget.selectedSeats.length,
              seatOrRoomNumbers: widget.selectedSeats.map((s) => s.id).toList(),
              primaryContactName: _nameController.text.trim(),
              contactPhone: _mobileController.text.trim(),
              totalAmount: total,
              convenienceFee: widget.pricing['convenienceFee'] ?? 0.0,
              taxes: widget.pricing['taxes'] ?? 0.0,
              status: 'CONFIRMED',
              referenceCode: 'TKT-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
              transactionId: 'TXN-MOV-${DateTime.now().millisecondsSinceEpoch}',
              createdAt: 'Today',
            );

            final confirmed = await widget.travelRepository.createBooking(booking);

            if (!context.mounted) return;

            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => TravelBookingSuccessScreen(booking: confirmed),
                ),
              );
          },
        ),
      ),
    );
  }

  Widget _buildReviewRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontFamily: 'Geist Sans', fontSize: isTotal ? 13.0 : 12.0, fontWeight: isTotal ? FontWeight.bold : FontWeight.normal, color: isTotal ? AppColors.textPrimary : AppColors.textSecondary)),
          Text(value, style: TextStyle(fontFamily: 'Geist Sans', fontSize: isTotal ? 14.0 : 12.0, fontWeight: isTotal ? FontWeight.bold : FontWeight.w600, color: isTotal ? AppColors.primary : AppColors.textPrimary)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final seatIds = widget.selectedSeats.map((s) => s.id).join(', ');
    final total = widget.pricing['total'] ?? 0.0;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Review Movie Tickets'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.s24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Order Summary Card
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.movie.title, style: const TextStyle(fontFamily: 'Geist Sans', fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 2),
                      Text('${widget.theatre.name} • ${widget.show.format}', style: const TextStyle(fontFamily: 'Geist Sans', fontSize: 12, color: AppColors.textSecondary)),
                      const SizedBox(height: 2),
                      Text('${widget.date}, ${widget.show.time} • Seats: $seatIds', style: const TextStyle(fontFamily: 'Geist Sans', fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      const Divider(color: AppColors.divider),
                      const SizedBox(height: 8),
                      _buildReviewRow('Ticket Subtotal (${widget.selectedSeats.length} Seats)', '₹${(widget.pricing['subtotal'] ?? 0).toStringAsFixed(2)}'),
                      const Divider(color: AppColors.divider),
                      _buildReviewRow('Convenience Fee', '₹${(widget.pricing['convenienceFee'] ?? 0).toStringAsFixed(2)}'),
                      const Divider(color: AppColors.divider),
                      _buildReviewRow('GST on Convenience Fee', '₹${(widget.pricing['taxes'] ?? 0).toStringAsFixed(2)}'),
                      const Divider(color: AppColors.divider),
                      _buildReviewRow('Total Amount', '₹${total.toStringAsFixed(2)}', isTotal: true),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.s20),

                // Contact Details Form
                const Text('Contact Information', style: TextStyle(fontFamily: 'Geist Sans', fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: AppSpacing.s12),

                AppTextField(
                  controller: _nameController,
                  labelText: 'Primary Contact Name',
                  hintText: 'Full Name',
                  prefix: const Icon(Icons.person_outline_rounded, size: 20),
                  validator: (v) {
                    final res = TravelValidator.validatePassengerName(v ?? '');
                    return res.isValid ? null : res.errorMessage;
                  },
                ),
                const SizedBox(height: AppSpacing.s12),

                AppTextField(
                  controller: _mobileController,
                  labelText: 'Mobile Number for SMS Ticket',
                  hintText: '10-digit mobile number',
                  keyboardType: TextInputType.phone,
                  prefix: const Icon(Icons.phone_outlined, size: 20),
                  validator: (v) {
                    final res = TravelValidator.validateMobile(v ?? '');
                    return res.isValid ? null : res.errorMessage;
                  },
                ),
                const SizedBox(height: AppSpacing.s12),

                AppTextField(
                  controller: _emailController,
                  labelText: 'Email for E-Ticket',
                  hintText: 'Email address',
                  keyboardType: TextInputType.emailAddress,
                  prefix: const Icon(Icons.email_outlined, size: 20),
                  validator: (v) {
                    final res = TravelValidator.validateEmail(v ?? '');
                    return res.isValid ? null : res.errorMessage;
                  },
                ),
                const SizedBox(height: AppSpacing.s24),

                SizedBox(
                  width: double.infinity,
                  child: PrimaryButton(
                    text: 'Authorize Payment (6-Digit MPIN)',
                    onPressed: _proceedToPayment,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
