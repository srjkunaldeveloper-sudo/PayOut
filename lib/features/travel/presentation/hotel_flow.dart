import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/app_button.dart';
import 'package:payout/core/widgets/app_card.dart';
import 'package:payout/features/travel/presentation/booking_success_screen.dart';

// 1. SEARCH HOTELS SCREEN
class HotelSearchScreen extends StatefulWidget {
  const HotelSearchScreen({super.key});

  @override
  State<HotelSearchScreen> createState() => _HotelSearchScreenState();
}

class _HotelSearchScreenState extends State<HotelSearchScreen> {
  final TextEditingController _cityController = TextEditingController(text: 'Jaipur, RJ');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Search Hotels'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.s24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppCard(
                padding: const EdgeInsets.all(AppSpacing.s20),
                child: Column(
                  children: [
                    TextField(
                      controller: _cityController,
                      decoration: const InputDecoration(
                        labelText: 'Destination City',
                        prefixIcon: Icon(Icons.location_city_rounded),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s16),
                    Row(
                      children: const [
                        Expanded(
                          child: TextField(
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: 'Check-in',
                              hintText: 'Aug 28, 2026',
                              prefixIcon: Icon(Icons.date_range_rounded),
                            ),
                          ),
                        ),
                        SizedBox(width: AppSpacing.s16),
                        Expanded(
                          child: TextField(
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: 'Check-out',
                              hintText: 'Aug 30, 2026',
                              prefixIcon: Icon(Icons.date_range_rounded),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.s16),
                    const TextField(
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Rooms & Guests',
                        hintText: '1 Room, 2 Guests',
                        prefixIcon: Icon(Icons.group_rounded),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  text: 'Search Hotels',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HotelListScreen(
                          city: _cityController.text,
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

// 2. HOTEL LIST SCREEN
class HotelListScreen extends StatelessWidget {
  final String city;

  const HotelListScreen({super.key, required this.city});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> hotels = [
      {'name': 'Taj Rambagh Palace', 'rating': '4.9 ★', 'price': 18500.0, 'loc': 'Bhawani Singh Rd'},
      {'name': 'ITC Rajputana', 'rating': '4.7 ★', 'price': 8500.0, 'loc': 'Gopalbari'},
      {'name': 'Lemon Tree Premier', 'rating': '4.3 ★', 'price': 4200.0, 'loc': 'Bani Park'},
      {'name': 'Treebo Trend Heritage', 'rating': '4.1 ★', 'price': 2200.0, 'loc': 'Sindhi Camp'},
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: 'Hotels in $city'),
      body: ListView.builder(
        padding: const EdgeInsets.all(AppSpacing.s24),
        itemCount: hotels.length,
        itemBuilder: (context, index) {
          final hotel = hotels[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.s16),
            child: AppCard(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HotelDetailsScreen(
                      hotelData: hotel,
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
                      Expanded(
                        child: Text(
                          hotel['name'],
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.s8),
                      Text(
                        '₹${hotel['price']}/night',
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        hotel['loc'],
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12.0,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        hotel['rating'],
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12.0,
                          color: Colors.amber,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
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

// 3. HOTEL DETAILS SCREEN
class HotelDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> hotelData;

  const HotelDetailsScreen({super.key, required this.hotelData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Hotel Info'),
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
                      hotelData['name'],
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s8),
                    Text(
                      'Location: ${hotelData['loc']} • Rating: ${hotelData['rating']}',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13.0,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.s24),
              const Text(
                'Popular Amenities',
                style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: AppSpacing.s12),
              AppCard(
                child: Column(
                  children: const [
                    ListTile(
                      leading: Icon(Icons.wifi, color: AppColors.primary),
                      title: Text('Free High-Speed WiFi', style: TextStyle(fontFamily: 'Inter', fontSize: 13)),
                      contentPadding: EdgeInsets.zero,
                    ),
                    ListTile(
                      leading: Icon(Icons.pool_rounded, color: AppColors.primary),
                      title: Text('Swimming Pool & Spa', style: TextStyle(fontFamily: 'Inter', fontSize: 13)),
                      contentPadding: EdgeInsets.zero,
                    ),
                    ListTile(
                      leading: Icon(Icons.fitness_center_rounded, color: AppColors.primary),
                      title: Text('Fitness Gym Centre', style: TextStyle(fontFamily: 'Inter', fontSize: 13)),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  text: 'Select Room',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RoomSelectionScreen(
                          hotelData: hotelData,
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

// 4. ROOM SELECTION SCREEN
class RoomSelectionScreen extends StatelessWidget {
  final Map<String, dynamic> hotelData;

  const RoomSelectionScreen({super.key, required this.hotelData});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> rooms = [
      {'name': 'Deluxe Heritage Room', 'desc': '1 King Bed • Courtyard View • Free Breakfast', 'price': hotelData['price']},
      {'name': 'Luxury Royal Suite', 'desc': '1 Royal Bed • Palace View • Lounge Access', 'price': hotelData['price'] + 3500.0},
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Select Room'),
      body: ListView.builder(
        padding: const EdgeInsets.all(AppSpacing.s24),
        itemCount: rooms.length,
        itemBuilder: (context, index) {
          final room = rooms[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.s16),
            child: AppCard(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HotelReviewScreen(
                      hotelData: hotelData,
                      roomData: room,
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
                        room['name'],
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                        ),
                      ),
                      Text(
                        '₹${room['price']}',
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
                    room['desc'],
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12.0,
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

// 5. REVIEW SCREEN
class HotelReviewScreen extends StatefulWidget {
  final Map<String, dynamic> hotelData;
  final Map<String, dynamic> roomData;

  const HotelReviewScreen({
    super.key,
    required this.hotelData,
    required this.roomData,
  });

  @override
  State<HotelReviewScreen> createState() => _HotelReviewScreenState();
}

class _HotelReviewScreenState extends State<HotelReviewScreen> {
  bool _isProcessing = false;

  void _bookHotel() {
    setState(() {
      _isProcessing = true;
    });

    final totalPrice = widget.roomData['price'] * 2; // for 2 nights

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => BookingSuccessScreen(
              serviceName: 'Hotel Stay - ${widget.hotelData['name']}',
              details: '${widget.roomData['name']} • 2 Nights (Aug 28 - Aug 30)',
              amount: totalPrice,
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
    final double totalPrice = widget.roomData['price'] * 2;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Confirm Booking'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.s24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Review Stay',
                style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: AppSpacing.s12),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.hotelData['name'],
                      style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${widget.hotelData['loc']} Stay',
                      style: const TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.textSecondary),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.0),
                      child: Divider(color: AppColors.divider),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Room Type', style: TextStyle(fontFamily: 'Inter', fontSize: 13, color: AppColors.textSecondary)),
                        Text(widget.roomData['name'], style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 13)),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.s8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Duration', style: TextStyle(fontFamily: 'Inter', fontSize: 13, color: AppColors.textSecondary)),
                        const Text('2 Nights (Aug 28 - Aug 30)', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 13)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.s24),
              const Text(
                'Billing Details',
                style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: AppSpacing.s12),
              AppCard(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Rate (₹${widget.roomData['price']} x 2)', style: const TextStyle(fontFamily: 'Inter', fontSize: 13, color: AppColors.textSecondary)),
                        Text('₹$totalPrice', style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 13)),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  text: 'Pay ₹$totalPrice',
                  isLoading: _isProcessing,
                  onPressed: _isProcessing ? null : _bookHotel,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
