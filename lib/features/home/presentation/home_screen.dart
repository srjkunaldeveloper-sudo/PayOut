import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/widgets.dart';
import 'package:payout/core/widgets/states.dart';

// Aggregation & Domain Imports
import 'package:payout/features/home/models/home_models.dart';
import 'package:payout/features/home/services/home_service.dart';
import 'package:payout/features/home/states/home_state.dart';
import 'package:payout/features/home/dummy/dummy_home_data.dart';

// Feature Redirect Screens
import 'package:payout/features/wallet/presentation/wallet_screen.dart';
import 'package:payout/features/recharge/presentation/recharge_screen.dart';
import 'package:payout/features/bills/presentation/bills_screen.dart';
import 'package:payout/features/travel/presentation/travel_screen.dart';
import 'package:payout/features/merchant/presentation/merchant_screen.dart';
import 'package:payout/features/financial/insurance/presentation/insurance_screen.dart';
import 'package:payout/features/financial/loans/presentation/loans_screen.dart';
import 'package:payout/features/financial/investments/presentation/investments_screen.dart';
import 'package:payout/features/rewards/presentation/rewards_screen.dart';
import 'package:payout/features/user/presentation/settings_screen.dart';
import 'package:payout/features/support/presentation/support_screen.dart';
import 'package:payout/features/notifications/presentation/notifications_screen.dart';
import 'package:payout/features/transactions/presentation/transaction_history_screen.dart';
import 'package:payout/features/qr/presentation/scan_qr_screen.dart';
import 'package:payout/features/qr/presentation/my_qr_screen.dart';
import 'package:payout/features/bank_accounts/presentation/bank_accounts_screen.dart';
import 'package:payout/features/global_search/presentation/global_search_screen.dart';
import 'package:payout/features/user/presentation/profile_screen.dart';
import 'package:payout/features/payments/presentation/payments_screen.dart';

// Travel screen specific categories imports
import 'package:payout/features/travel/presentation/flight_flow.dart';
import 'package:payout/features/travel/presentation/train_flow.dart';
import 'package:payout/features/travel/presentation/bus_flow.dart';
import 'package:payout/features/travel/presentation/hotel_flow.dart';
import 'package:payout/features/travel/presentation/movie_flow.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeService _homeService = HomeService();
  HomeState _state = const HomeState(status: HomeStatus.idle);

  @override
  void initState() {
    super.initState();
    _loadDashboard();
  }

  Future<void> _loadDashboard() async {
    setState(() {
      _state = const HomeState(status: HomeStatus.loading);
    });

    try {
      final dashboard = await _homeService.getDashboardData();
      if (!mounted) return;
      setState(() {
        _state = HomeState(
          status: HomeStatus.success,
          dashboard: dashboard,
        );
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _state = HomeState(
          status: HomeStatus.failure,
          errorMessage: e.toString(),
        );
      });
    }
  }

  Widget _buildLoadingSkeleton() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24, vertical: AppSpacing.s16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const SkeletonLoader(width: 48, height: 48, borderRadius: 24),
                  const SizedBox(width: AppSpacing.s12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      SkeletonLoader(width: 80, height: 12),
                      SizedBox(height: 6),
                      SkeletonLoader(width: 120, height: 16),
                    ],
                  )
                ],
              ),
              const SkeletonLoader(width: 40, height: 40, borderRadius: 20),
            ],
          ),
          const SizedBox(height: AppSpacing.s24),
          const SkeletonLoader(width: double.infinity, height: 48, borderRadius: 8),
          const SizedBox(height: AppSpacing.s24),
          const SkeletonLoader(width: double.infinity, height: 140, borderRadius: 16),
          const SizedBox(height: AppSpacing.s24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(4, (index) => const SkeletonLoader(width: 64, height: 80, borderRadius: 8)),
          ),
          const SizedBox(height: AppSpacing.s32),
          const SkeletonLoader(width: 150, height: 18),
          const SizedBox(height: AppSpacing.s16),
          Column(
            children: List.generate(2, (index) => const Padding(
              padding: EdgeInsets.only(bottom: 12.0),
              child: SkeletonLoader(width: double.infinity, height: 60, borderRadius: 8),
            )),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_state.isLoading) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(child: _buildLoadingSkeleton()),
      );
    }

    if (_state.isFailure) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: ErrorState(
            description: _state.errorMessage ?? 'Unable to load your dashboard.',
            onRetry: _loadDashboard,
          ),
        ),
      );
    }

    final dashboard = _state.dashboard!;
    final user = dashboard.user;
    final wallet = dashboard.wallet;
    final topTransactions = _homeService.getTopTransactions(dashboard.recentTransactions);
    final hasUnread = _homeService.shouldShowNotificationBadge(dashboard.unreadNotificationCount);

    // Google Pay style 4 primary quick actions
    final List<Map<String, dynamic>> primaryQuickActions = [
      {'label': 'Scan any\nQR code', 'icon': Icons.qr_code_scanner_rounded, 'screen': const ScanQRScreen()},
      {'label': 'Pay\nanyone', 'icon': Icons.send_rounded, 'screen': const PaymentsScreen()},
      {'label': 'Bank\ntransfer', 'icon': Icons.account_balance_rounded, 'screen': const BankAccountsScreen()},
      {'label': 'Mobile\nrecharge', 'icon': Icons.phone_android_rounded, 'screen': const RechargeScreen()},
    ];

    // Google Pay style smaller secondary pill actions
    final List<Map<String, dynamic>> secondaryQuickActions = [
      {'label': 'Add Money', 'icon': Icons.add_rounded, 'screen': const WalletScreen()},
      {'label': 'Pay Bills', 'icon': Icons.receipt_long_rounded, 'screen': const BillsScreen()},
      {'label': 'Rewards', 'icon': Icons.stars_rounded, 'screen': const RewardsScreen()},
    ];

    final List<Map<String, dynamic>> services = [
      {'name': 'Wallet', 'icon': Icons.account_balance_wallet_rounded, 'screen': const WalletScreen(), 'color': Colors.amber},
      {'name': 'Payments', 'icon': Icons.swap_horiz_rounded, 'screen': const PaymentsScreen(), 'color': AppColors.primary},
      {'name': 'Recharge', 'icon': Icons.bolt_rounded, 'screen': const RechargeScreen(), 'color': AppColors.warning},
      {'name': 'Bills', 'icon': Icons.receipt_long_rounded, 'screen': const BillsScreen(), 'color': AppColors.error},
      {'name': 'Travel', 'icon': Icons.flight_takeoff_rounded, 'screen': const TravelScreen(), 'color': AppColors.success},
      {'name': 'Loans', 'icon': Icons.monetization_on_rounded, 'screen': const LoansScreen(), 'color': Colors.indigo},
      {'name': 'Insurance', 'icon': Icons.favorite_rounded, 'screen': const InsuranceScreen(), 'color': Colors.redAccent},
      {'name': 'Investments', 'icon': Icons.trending_up_rounded, 'screen': const InvestmentsScreen(), 'color': Colors.purple},
      {'name': 'Rewards', 'icon': Icons.stars_rounded, 'screen': const RewardsScreen(), 'color': Colors.orange},
      {'name': 'Merchant', 'icon': Icons.storefront_rounded, 'screen': const MerchantScreen(), 'color': Colors.teal},
    ];

    final List<Map<String, dynamic>> travelCategories = [
      {'name': 'Flights', 'icon': Icons.flight_takeoff_rounded, 'screen': const FlightSearchScreen(), 'color': AppColors.primary},
      {'name': 'Trains', 'icon': Icons.train_rounded, 'screen': const TrainSearchScreen(), 'color': Colors.indigo},
      {'name': 'Buses', 'icon': Icons.directions_bus_filled_rounded, 'screen': const BusSearchScreen(), 'color': AppColors.success},
      {'name': 'Hotels', 'icon': Icons.hotel_rounded, 'screen': const HotelSearchScreen(), 'color': Colors.orange},
      {'name': 'Movies', 'icon': Icons.movie_creation_rounded, 'screen': const MovieSearchScreen(), 'color': Colors.red},
    ];

    final List<String> recentContacts = ['Rahul Sharma', 'Priya Verma', 'Amit Kumar', 'Neha Singh'];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadDashboard,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.s16),
                
                // 1. Header Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ProfileScreen()),
                        );
                        _loadDashboard();
                      },
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primaryContainer,
                            ),
                            child: CustomAvatar(
                              name: user.name,
                              size: 48,
                              backgroundColor: AppColors.primaryContainer,
                              textColor: AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.s12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Good Morning,',
                                style: AppTypography.bodyMedium.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              Text(
                                user.name,
                                style: AppTypography.titleLarge.copyWith(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Stack(
                      alignment: Alignment.topRight,
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            color: AppColors.primaryContainer,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.notifications_none_rounded, color: AppColors.primary),
                            onPressed: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const NotificationsScreen()),
                              );
                              _loadDashboard();
                            },
                          ),
                        ),
                        if (hasUnread)
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              width: 10,
                              height: 10,
                              decoration: const BoxDecoration(
                                color: AppColors.error,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.s24),

                // 2. Search Box
                CustomSearchBar(
                  readOnly: true,
                  hintText: 'Search bills, merchants, contacts...',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const GlobalSearchScreen()),
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.s24),

                // 3. Wallet Summary Card
                Container(
                  padding: const EdgeInsets.all(AppSpacing.s20),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: const BorderRadius.all(Radius.circular(AppRadius.lg)),
                    boxShadow: AppShadow.medium,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Total Balance',
                                style: AppTypography.bodyMedium.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '₹${(wallet.balance + 2130.0).toStringAsFixed(2)}',
                                style: AppTypography.headlineLarge.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.primaryContainer,
                              borderRadius: const BorderRadius.all(Radius.circular(AppRadius.sm)),
                            ),
                            child: Text(
                              wallet.linkedBank.split('•').first.trim(),
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.s16),
                      const Divider(color: AppColors.divider),
                      const SizedBox(height: AppSpacing.s12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Available Balance',
                                style: AppTypography.bodySmall.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '₹${wallet.balance.toStringAsFixed(2)}',
                                style: AppTypography.bodyLarge.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Pending',
                                style: AppTypography.bodySmall.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '₹2,130.00',
                                style: AppTypography.bodyLarge.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.error,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.s20),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                side: const BorderSide(color: AppColors.primary),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(AppRadius.md)),
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const WalletScreen()),
                                );
                              },
                              child: Text(
                                'Add Money',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTypography.bodySmall.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11.0,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(AppRadius.md)),
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const PaymentsScreen()),
                                );
                              },
                              child: Text(
                                'Send Money',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTypography.bodySmall.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11.0,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                side: const BorderSide(color: AppColors.divider),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(AppRadius.md)),
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const WalletScreen()),
                                );
                              },
                              child: Text(
                                'Withdraw',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTypography.bodySmall.copyWith(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.s24),

                // 4. Primary Quick Actions (Google Pay style 4 columns)
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 4,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.65,
                  children: primaryQuickActions.map((act) {
                    return GestureDetector(
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => act['screen'] as Widget),
                        );
                        _loadDashboard();
                      },
                      child: Column(
                        children: [
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: const BorderRadius.all(Radius.circular(18)),
                              boxShadow: AppShadow.small,
                            ),
                            child: Icon(act['icon'] as IconData, color: Colors.white, size: 26),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            act['label'] as String,
                            style: AppTypography.bodySmall.copyWith(
                              fontSize: 11.0,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: AppSpacing.s20),

                // Secondary Quick Actions (Pills row)
                SizedBox(
                  height: 36,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: secondaryQuickActions.length,
                    itemBuilder: (context, index) {
                      final act = secondaryQuickActions[index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: ActionChip(
                          avatar: Icon(act['icon'] as IconData, size: 16, color: AppColors.primary),
                          label: Text(
                            act['label'] as String,
                            style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.bold),
                          ),
                          backgroundColor: AppColors.primaryLight.withOpacity(0.4),
                          shape: const StadiumBorder(),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => act['screen'] as Widget),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: AppSpacing.s32),

                // 5. People Section (Recent contacts)
                const Text(
                  'People',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.s12),
                SizedBox(
                  height: 92,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: recentContacts.length + 1,
                    itemBuilder: (context, index) {
                      if (index == recentContacts.length) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const GlobalSearchScreen()),
                              );
                            },
                            child: Column(
                              children: [
                                Container(
                                  width: 56,
                                  height: 56,
                                  decoration: BoxDecoration(
                                    color: AppColors.surface,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: AppColors.divider),
                                  ),
                                  child: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.primary, size: 28),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'More',
                                  style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      final name = recentContacts[index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const PaymentsScreen()),
                            );
                          },
                          child: Column(
                            children: [
                              CustomAvatar(
                                name: name,
                                size: 56,
                                backgroundColor: AppColors.primaryLight,
                                textColor: AppColors.primary,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                name.split(' ')[0],
                                style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: AppSpacing.s24),

                // 6. Ecosystem Services Grid
                const Text(
                  'Bills & recharges',
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
                  itemCount: services.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.74,
                  ),
                  itemBuilder: (context, index) {
                    final ser = services[index];
                    return GestureDetector(
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ser['screen'] as Widget),
                        );
                        _loadDashboard();
                      },
                      child: Column(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: (ser['color'] as Color).withOpacity(0.08),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(ser['icon'] as IconData, color: ser['color'] as Color, size: 20),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            ser['name'] as String,
                            textAlign: TextAlign.center,
                            style: AppTypography.bodySmall.copyWith(
                              fontSize: 10.0,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.s32),

                // 7. Travel Discovery Section
                const Text(
                  'Travel Discovery',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.s12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: travelCategories.map((t) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => t['screen'] as Widget),
                        );
                      },
                      child: Column(
                        children: [
                          Container(
                            width: 46,
                            height: 46,
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.divider),
                            ),
                            child: Icon(t['icon'] as IconData, color: t['color'] as Color, size: 20),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            t['name'] as String,
                            style: AppTypography.bodySmall.copyWith(fontSize: 10.0),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: AppSpacing.s16),
                SizedBox(
                  height: 112,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: DummyHomeData.popularDestinations.length,
                    itemBuilder: (context, index) {
                      final item = DummyHomeData.popularDestinations[index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const TravelScreen()),
                            );
                          },
                          child: Container(
                            width: 140,
                            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s12, vertical: AppSpacing.s8),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: const BorderRadius.all(Radius.circular(AppRadius.md)),
                              border: Border.all(color: AppColors.divider),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${item['from']} → ${item['to']}',
                                  style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item['desc']!,
                                  style: AppTypography.bodySmall.copyWith(
                                    fontSize: 10.0,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: AppSpacing.s32),

                // 8. Financial Promotions
                const Text(
                  'Financial Ecosystem Promotions',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.s12),
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: DummyHomeData.financialPromotions.length,
                    itemBuilder: (context, index) {
                      final promo = DummyHomeData.financialPromotions[index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: GestureDetector(
                          onTap: () {
                            Widget screen;
                            if (index == 0) {
                              screen = const LoansScreen();
                            } else if (index == 1) {
                              screen = const InsuranceScreen();
                            } else {
                              screen = const InvestmentsScreen();
                            }
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => screen),
                            );
                          },
                          child: Container(
                            width: 220,
                            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s12, vertical: AppSpacing.s8),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceVariant.withOpacity(0.4),
                              borderRadius: const BorderRadius.all(Radius.circular(AppRadius.md)),
                              border: Border.all(color: AppColors.divider),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  promo['title']!,
                                  style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  promo['subtitle']!,
                                  style: AppTypography.bodySmall.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  promo['desc']!,
                                  style: AppTypography.bodySmall.copyWith(
                                    fontSize: 10.0,
                                    color: AppColors.textSecondary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: AppSpacing.s32),

                // 9. Offers & Scratch Cards
                const Text(
                  'Rewards & Offers',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.s12),
                if (dashboard.offers.isEmpty)
                  const EmptyState(
                    title: 'No active offers',
                    description: 'Check back later for exciting rewards.',
                    icon: Icons.local_offer_rounded,
                  )
                else
                  SizedBox(
                    height: 112,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: dashboard.offers.length,
                      itemBuilder: (context, index) {
                        final coupon = dashboard.offers[index];
                        return Padding(
                          padding: const EdgeInsets.only(right: 12.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const RewardsScreen()),
                              );
                            },
                            child: Container(
                              width: 220,
                              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s12, vertical: AppSpacing.s8),
                              decoration: BoxDecoration(
                                color: AppColors.primaryLight.withOpacity(0.3),
                                borderRadius: const BorderRadius.all(Radius.circular(AppRadius.md)),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.stars_rounded, color: AppColors.primary, size: 28),
                                  const SizedBox(width: AppSpacing.s12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          coupon.merchantName,
                                          style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.bold),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          'Use code: ${coupon.discountCode}',
                                          style: AppTypography.bodySmall.copyWith(
                                            fontSize: 10.0,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                const SizedBox(height: AppSpacing.s32),

                // 10. Recent Activity / Transactions
                SectionHeader(
                  title: 'Recent Transactions',
                  actionText: 'View All',
                  onActionPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const TransactionHistoryScreen()),
                    );
                  },
                ),
                if (topTransactions.isEmpty)
                  const EmptyState(
                    title: 'No recent transactions',
                    description: 'Make your first payment to see activity here.',
                    icon: Icons.receipt_long_rounded,
                  )
                else
                  Column(
                    children: topTransactions.map((txn) {
                      final isCredit = txn.type.toUpperCase() == 'CREDIT';
                      Color statusColor = AppColors.success;
                      if (txn.status.toUpperCase() == 'PENDING') {
                        statusColor = AppColors.warning;
                      } else if (txn.status.toUpperCase() == 'FAILED') {
                        statusColor = AppColors.error;
                      }

                      return Column(
                        children: [
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              txn.title,
                              style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Row(
                              children: [
                                Text(
                                  txn.date,
                                  style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: statusColor.withOpacity(0.12),
                                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                                  ),
                                  child: Text(
                                    txn.status,
                                    style: AppTypography.bodySmall.copyWith(
                                      fontSize: 9.0,
                                      color: statusColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            trailing: Text(
                              '${isCredit ? "+" : "-"}₹${txn.amount.toStringAsFixed(2)}',
                              style: AppTypography.bodyLarge.copyWith(
                                fontWeight: FontWeight.bold,
                                color: isCredit ? AppColors.success : AppColors.textPrimary,
                              ),
                            ),
                          ),
                          const Divider(color: AppColors.divider),
                        ],
                      );
                    }).toList(),
                  ),
                const SizedBox(height: AppSpacing.s40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
