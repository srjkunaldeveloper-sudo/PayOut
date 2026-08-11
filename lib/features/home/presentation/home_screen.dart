import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/widgets.dart';
import 'package:payout/core/error/error_message_mapper.dart';

// Aggregation & Domain Imports
import 'package:payout/features/home/services/home_service.dart';
import 'package:payout/features/home/states/home_state.dart';

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
import 'package:payout/features/rewards/models/reward_models.dart';
import 'package:payout/features/notifications/presentation/notifications_screen.dart';
import 'package:payout/features/transactions/presentation/transaction_history_screen.dart';
import 'package:payout/features/transactions/models/transaction_models.dart';
import 'package:payout/features/qr/presentation/scan_qr_screen.dart';
import 'package:payout/features/global_search/presentation/global_search_screen.dart';
import 'package:payout/features/user/presentation/profile_screen.dart';
import 'package:payout/features/payments/presentation/payments_screen.dart';

// Travel screen specific categories imports
import 'package:payout/features/travel/presentation/flight_flow.dart';
import 'package:payout/features/travel/presentation/train_flow.dart';
import 'package:payout/features/travel/presentation/bus_flow.dart';
import 'package:payout/features/travel/presentation/hotel_flow.dart';

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
          errorMessage: ErrorMessageMapper.map(e),
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


    // Google Pay style smaller secondary pill actions
    final List<Map<String, dynamic>> secondaryQuickActions = [
      {'label': 'Add Money', 'icon': Icons.add_rounded, 'screen': const WalletScreen()},
      {'label': 'Pay Bills', 'icon': Icons.receipt_long_rounded, 'screen': const BillsScreen()},
      {'label': 'Rewards', 'icon': Icons.stars_rounded, 'screen': const RewardsScreen()},
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
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFF00B9F1).withValues(alpha: 0.08),
                            ),
                            child: CustomAvatar(
                              name: user.name,
                              size: 48,
                              backgroundColor: const Color(0xFF00B9F1).withValues(alpha: 0.08),
                              textColor: const Color(0xFF3F37C9),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Good Morning,',
                                style: TextStyle(
                                  fontFamily: 'Geist Sans',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF1F1F1F).withValues(alpha: 0.5),
                                ),
                              ),
                              Text(
                                user.name,
                                style: const TextStyle(
                                  fontFamily: 'Geist Sans',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1F1F1F),
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
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFFE2E8F0),
                              width: 1.0,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF002E6E).withValues(alpha: 0.02),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            icon: const Icon(
                              Icons.notifications_none_rounded, 
                              color: Color(0xFF1F1F1F),
                              size: 22,
                            ),
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
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Color(0xFF2563EB),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // 2. Search Box
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const GlobalSearchScreen()),
                    );
                  },
                  child: Container(
                    height: 52,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFFE2E8F0),
                        width: 1.0,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF002E6E).withValues(alpha: 0.02),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.search_rounded,
                          color: Color(0xFF64748B),
                          size: 22,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Search payments, bills, contacts...',
                            style: TextStyle(
                              fontFamily: 'Geist Sans',
                              fontSize: 14,
                              color: const Color(0xFF1F1F1F).withValues(alpha: 0.4),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // 3. Wallet Summary Card
                Container(
                  width: double.infinity,
                  height: 180,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF1E1B4B), // Indigo-950
                        Color(0xFF3F37C9), // Purple
                        Color(0xFF2563EB), // Blue
                        Color(0xFF00B9F1), // Cyan
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF3F37C9).withValues(alpha: 0.18),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Decorative curves and glow
                        const Positioned.fill(
                          child: CustomPaint(
                            painter: CardBackgroundPainter(),
                          ),
                        ),
                        // Watermark in background layer
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 72,
                          child: Center(
                            child: Text(
                              'SRJ UPI — Payout',
                              style: TextStyle(
                                fontFamily: 'Geist Sans',
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: Colors.white.withValues(alpha: 0.05),
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                        ),
                        // Main Balance card contents
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Top section
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            'Total Balance',
                                            style: TextStyle(
                                              fontFamily: 'Geist Sans',
                                              fontSize: 13,
                                              color: Colors.white.withValues(alpha: 0.7),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Icon(
                                            Icons.visibility_outlined,
                                            color: Colors.white.withValues(alpha: 0.6),
                                            size: 16,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        '₹${(wallet.balance + 2130.0).toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          fontFamily: 'Geist Sans',
                                          fontSize: 32,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.12),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      wallet.linkedBank.split('•').first.trim(),
                                      style: const TextStyle(
                                        fontFamily: 'Geist Sans',
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              // Bottom section
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Available Balance',
                                        style: TextStyle(
                                          fontFamily: 'Geist Sans',
                                          fontSize: 11,
                                          color: Colors.white.withValues(alpha: 0.6),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '₹${wallet.balance.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          fontFamily: 'Geist Sans',
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        'Pending',
                                        style: TextStyle(
                                          fontFamily: 'Geist Sans',
                                          fontSize: 11,
                                          color: Colors.white.withValues(alpha: 0.6),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      const Text(
                                        '₹2,130.00',
                                        style: TextStyle(
                                          fontFamily: 'Geist Sans',
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFFE0F2FE),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // 3b. Money Actions horizontal action container
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFFE2E8F0),
                      width: 1.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF002E6E).withValues(alpha: 0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(
                    children: [
                      MoneyActionButton(
                        icon: Icons.add_rounded,
                        label: 'Add Money',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const WalletScreen()),
                          );
                        },
                      ),
                      Container(
                        height: 40,
                        width: 1,
                        color: const Color(0xFFE2E8F0),
                      ),
                      MoneyActionButton(
                        icon: Icons.send_rounded,
                        label: 'Send Money',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const PaymentsScreen()),
                          );
                        },
                      ),
                      Container(
                        height: 40,
                        width: 1,
                        color: const Color(0xFFE2E8F0),
                      ),
                      MoneyActionButton(
                        icon: Icons.file_download_outlined,
                        label: 'Withdraw',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const WalletScreen()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // 4a. Quick Actions Header Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Quick Actions',
                      style: TextStyle(
                        fontFamily: 'Geist Sans',
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F1F1F),
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(
                        'Edit',
                        style: TextStyle(
                          fontFamily: 'Geist Sans',
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2563EB),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // 4b. Refined Quick Actions Grid (4 columns)
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 4,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.78,
                  children: [
                    QuickActionCard(
                      icon: Icons.arrow_outward_rounded,
                      label: 'Send Money',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const PaymentsScreen()),
                        );
                      },
                    ),
                    QuickActionCard(
                      icon: Icons.qr_code_scanner_rounded,
                      label: 'Scan QR',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ScanQRScreen()),
                        );
                      },
                    ),
                    QuickActionCard(
                      icon: Icons.phone_android_rounded,
                      label: 'Recharge',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const RechargeScreen()),
                        );
                      },
                    ),
                    QuickActionCard(
                      icon: Icons.receipt_long_rounded,
                      label: 'Pay Bills',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const BillsScreen()),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),

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
                          backgroundColor: AppColors.primaryLight.withValues(alpha: 0.4),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'People',
                      style: TextStyle(
                        fontFamily: 'Geist Sans',
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F1F1F),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const GlobalSearchScreen()),
                        );
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(
                        'View all',
                        style: TextStyle(
                          fontFamily: 'Geist Sans',
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2563EB),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 92,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: recentContacts.length + 1,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      if (index == recentContacts.length) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: AddNewContactButton(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const GlobalSearchScreen()),
                              );
                            },
                          ),
                        );
                      }
                      final name = recentContacts[index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: ContactAvatarItem(
                          name: name,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const PaymentsScreen()),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Services',
                      style: TextStyle(
                        fontFamily: 'Geist Sans',
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F1F1F),
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(
                        'View all',
                        style: TextStyle(
                          fontFamily: 'Geist Sans',
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2563EB),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                
                // Money services card
                ServiceGroupCard(
                  headerIcon: Icons.account_balance_wallet_rounded,
                  headerTitle: 'Money',
                  accentColor: const Color(0xFF2563EB),
                  items: [
                    ServiceItem(
                      icon: Icons.account_balance_wallet_rounded,
                      label: 'Wallet',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const WalletScreen()),
                        );
                      },
                    ),
                    ServiceItem(
                      icon: Icons.swap_horiz_rounded,
                      label: 'Payments',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const PaymentsScreen()),
                        );
                      },
                    ),
                    ServiceItem(
                      icon: Icons.bolt_rounded,
                      label: 'Recharge',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const RechargeScreen()),
                        );
                      },
                    ),
                    ServiceItem(
                      icon: Icons.receipt_long_rounded,
                      label: 'Bills',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const BillsScreen()),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Travel services card
                ServiceGroupCard(
                  headerIcon: Icons.flight_takeoff_rounded,
                  headerTitle: 'Travel',
                  accentColor: const Color(0xFF00B9F1),
                  items: [
                    ServiceItem(
                      icon: Icons.flight_takeoff_rounded,
                      label: 'Flights',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const FlightSearchScreen()),
                        );
                      },
                    ),
                    ServiceItem(
                      icon: Icons.train_rounded,
                      label: 'Trains',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const TrainSearchScreen()),
                        );
                      },
                    ),
                    ServiceItem(
                      icon: Icons.directions_bus_filled_rounded,
                      label: 'Bus',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const BusSearchScreen()),
                        );
                      },
                    ),
                    ServiceItem(
                      icon: Icons.hotel_rounded,
                      label: 'Hotels',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const HotelSearchScreen()),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Finance services card
                ServiceGroupCard(
                  headerIcon: Icons.trending_up_rounded,
                  headerTitle: 'Finance',
                  accentColor: const Color(0xFF8B5CF6), // Purple accent
                  items: [
                    ServiceItem(
                      icon: Icons.monetization_on_rounded,
                      label: 'Loans',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const LoansScreen()),
                        );
                      },
                    ),
                    ServiceItem(
                      icon: Icons.favorite_rounded,
                      label: 'Insurance',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const InsuranceScreen()),
                        );
                      },
                    ),
                    ServiceItem(
                      icon: Icons.trending_up_rounded,
                      label: 'Investments',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const InvestmentsScreen()),
                        );
                      },
                    ),
                    ServiceItem(
                      icon: Icons.storefront_rounded,
                      label: 'Merchant',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const MerchantScreen()),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 112,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: dashboard.popularDestinations.length,
                    itemBuilder: (context, index) {
                      final item = dashboard.popularDestinations[index];
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
                    fontFamily: 'Geist Sans',
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
                    itemCount: dashboard.financialPromotions.length,
                    itemBuilder: (context, index) {
                      final promo = dashboard.financialPromotions[index];
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
                              color: AppColors.surfaceVariant.withValues(alpha: 0.4),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Offers',
                      style: TextStyle(
                        fontFamily: 'Geist Sans',
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F1F1F),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const RewardsScreen()),
                        );
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(
                        'View all',
                        style: TextStyle(
                          fontFamily: 'Geist Sans',
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2563EB),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (dashboard.offers.isEmpty)
                  const EmptyState(
                    title: 'No active offers',
                    description: 'Check back later for exciting rewards.',
                    icon: Icons.local_offer_rounded,
                  )
                else
                  SizedBox(
                    height: 155,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: dashboard.offers.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        final coupon = dashboard.offers[index];
                        final gradient = OfferCard.gradients[index % OfferCard.gradients.length];
                        return Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: OfferCard(
                            coupon: coupon,
                            gradient: gradient,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const RewardsScreen()),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                const SizedBox(height: 24),

                // 10. Recent Activity / Transactions
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Recent Transactions',
                      style: TextStyle(
                        fontFamily: 'Geist Sans',
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F1F1F),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const TransactionHistoryScreen()),
                        );
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(
                        'View all',
                        style: TextStyle(
                          fontFamily: 'Geist Sans',
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2563EB),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (topTransactions.isEmpty)
                  const EmptyState(
                    title: 'No recent transactions',
                    description: 'Make your first payment to see activity here.',
                    icon: Icons.receipt_long_rounded,
                  )
                else
                  Column(
                    children: topTransactions.map((txn) {
                      return TransactionRow(
                        txn: txn,
                        onTap: () {},
                      );
                    }).toList(),
                  ),
                const SizedBox(height: 96),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CardBackgroundPainter extends CustomPainter {
  const CardBackgroundPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill;

    // Subtle cyan/purple glow circle at top-right
    paint.shader = RadialGradient(
      colors: [
        const Color(0xFF00B9F1).withValues(alpha: 0.12),
        Colors.transparent,
      ],
    ).createShader(Rect.fromCircle(center: Offset(size.width * 0.8, size.height * 0.2), radius: 100));
    canvas.drawCircle(Offset(size.width * 0.8, size.height * 0.2), 100, paint);

    // Subtle wave at the bottom
    final wavePath = Path();
    wavePath.moveTo(0, size.height * 0.7);
    wavePath.quadraticBezierTo(
      size.width * 0.35,
      size.height * 0.6,
      size.width * 0.7,
      size.height * 0.8,
    );
    wavePath.quadraticBezierTo(
      size.width * 0.85,
      size.height * 0.9,
      size.width,
      size.height * 0.8,
    );
    wavePath.lineTo(size.width, size.height);
    wavePath.lineTo(0, size.height);
    wavePath.close();

    paint.shader = LinearGradient(
      colors: [
        Colors.white.withValues(alpha: 0.03),
        Colors.white.withValues(alpha: 0.08),
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ).createShader(Rect.fromLTWH(0, size.height * 0.6, size.width, size.height * 0.4));
    canvas.drawPath(wavePath, paint);
    
    // Wave 2
    final wavePath2 = Path();
    wavePath2.moveTo(0, size.height * 0.8);
    wavePath2.quadraticBezierTo(
      size.width * 0.4,
      size.height * 0.75,
      size.width * 0.75,
      size.height * 0.88);
    wavePath2.quadraticBezierTo(
      size.width * 0.9,
      size.height * 0.92,
      size.width,
      size.height * 0.85);
    wavePath2.lineTo(size.width, size.height);
    wavePath2.lineTo(0, size.height);
    wavePath2.close();

    paint.shader = LinearGradient(
      colors: [
        Colors.white.withValues(alpha: 0.04),
        Colors.white.withValues(alpha: 0.09),
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ).createShader(Rect.fromLTWH(0, size.height * 0.7, size.width, size.height * 0.3));
    canvas.drawPath(wavePath2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class MoneyActionButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const MoneyActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  State<MoneyActionButton> createState() => _MoneyActionButtonState();
}

class _MoneyActionButtonState extends State<MoneyActionButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedScale(
          scale: _isPressed ? 0.96 : 1.0,
          duration: const Duration(milliseconds: 100),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            padding: const EdgeInsets.symmetric(vertical: 14.0),
            decoration: BoxDecoration(
              color: _isPressed ? const Color(0xFFF1F5F9) : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF00B9F1).withValues(alpha: 0.08),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    widget.icon,
                    color: const Color(0xFF3F37C9),
                    size: 26,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.label,
                  style: const TextStyle(
                    fontFamily: 'Geist Sans',
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F1F1F),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class QuickActionCard extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const QuickActionCard({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  State<QuickActionCard> createState() => _QuickActionCardState();
}

class _QuickActionCardState extends State<QuickActionCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _isPressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFFE2E8F0),
                  width: 1.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF002E6E).withValues(alpha: 0.02),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF3F37C9).withValues(alpha: 0.06),
                ),
                alignment: Alignment.center,
                child: Icon(
                  widget.icon,
                  color: const Color(0xFF3F37C9),
                  size: 24,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Geist Sans',
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1F1F1F),
                height: 1.2,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class ContactAvatarItem extends StatefulWidget {
  final String name;
  final VoidCallback onTap;

  const ContactAvatarItem({
    super.key,
    required this.name,
    required this.onTap,
  });

  @override
  State<ContactAvatarItem> createState() => _ContactAvatarItemState();
}

class _ContactAvatarItemState extends State<ContactAvatarItem> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _isPressed ? 0.94 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _isPressed 
                    ? const Color(0xFFE2E8F0) 
                    : const Color(0xFF3F37C9).withValues(alpha: 0.06),
              ),
              alignment: Alignment.center,
              child: Text(
                _getInitials(widget.name),
                style: const TextStyle(
                  fontFamily: 'Geist Sans',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3F37C9),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.name.split(' ')[0],
              style: const TextStyle(
                fontFamily: 'Geist Sans',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1F1F1F),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}';
    }
    return name.isNotEmpty ? name[0] : '';
  }
}

class AddNewContactButton extends StatefulWidget {
  final VoidCallback onTap;

  const AddNewContactButton({
    super.key,
    required this.onTap,
  });

  @override
  State<AddNewContactButton> createState() => _AddNewContactButtonState();
}

class _AddNewContactButtonState extends State<AddNewContactButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _isPressed ? 0.94 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _isPressed 
                    ? const Color(0xFFE2E8F0) 
                    : const Color(0xFFF8FAFC),
                border: Border.all(
                  color: const Color(0xFF3F37C9).withValues(alpha: 0.2),
                  width: 1.0,
                  style: BorderStyle.solid,
                ),
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.add_rounded,
                color: Color(0xFF3F37C9),
                size: 24,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Add New',
              style: TextStyle(
                fontFamily: 'Geist Sans',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1F1F1F),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ServiceItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const ServiceItem({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  State<ServiceItem> createState() => _ServiceItemState();
}

class _ServiceItemState extends State<ServiceItem> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedScale(
          scale: _isPressed ? 0.94 : 1.0,
          duration: const Duration(milliseconds: 100),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _isPressed 
                      ? const Color(0xFFE2E8F0) 
                      : const Color(0xFF3F37C9).withValues(alpha: 0.06),
                ),
                alignment: Alignment.center,
                child: Icon(
                  widget.icon,
                  color: const Color(0xFF3F37C9),
                  size: 28,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                widget.label,
                style: const TextStyle(
                  fontFamily: 'Geist Sans',
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1F1F1F),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ServiceGroupCard extends StatelessWidget {
  final IconData headerIcon;
  final String headerTitle;
  final Color accentColor;
  final List<ServiceItem> items;

  const ServiceGroupCard({
    super.key,
    required this.headerIcon,
    required this.headerTitle,
    required this.accentColor,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF002E6E).withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: accentColor.withValues(alpha: 0.08),
                ),
                alignment: Alignment.center,
                child: Icon(
                  headerIcon,
                  color: accentColor,
                  size: 18,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                headerTitle,
                style: const TextStyle(
                  fontFamily: 'Geist Sans',
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F1F1F),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: items,
          ),
        ],
      ),
    );
  }
}

class OfferCard extends StatefulWidget {
  final CouponModel coupon;
  final LinearGradient gradient;
  final VoidCallback onTap;

  const OfferCard({
    super.key,
    required this.coupon,
    required this.gradient,
    required this.onTap,
  });

  static final List<LinearGradient> gradients = [
    const LinearGradient(
      colors: [Color(0xFF3F37C9), Color(0xFF2563EB)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    const LinearGradient(
      colors: [Color(0xFF2563EB), Color(0xFF00B9F1)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    const LinearGradient(
      colors: [Color(0xFF4361EE), Color(0xFF3F37C9)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  ];

  @override
  State<OfferCard> createState() => _OfferCardState();
}

class _OfferCardState extends State<OfferCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _isPressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.84,
          height: 155,
          decoration: BoxDecoration(
            gradient: widget.gradient,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: widget.gradient.colors.first.withValues(alpha: 0.15),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: Stack(
              children: [
                const Positioned.fill(
                  child: CustomPaint(
                    painter: OfferBackgroundPainter(),
                  ),
                ),
                Positioned(
                  bottom: 40,
                  left: 18,
                  child: Text(
                    'SRJ UPI — Payout',
                    style: TextStyle(
                      fontFamily: 'Geist Sans',
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                      color: Colors.white.withValues(alpha: 0.12),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.16),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              widget.coupon.category.toUpperCase(),
                              style: const TextStyle(
                                fontFamily: 'Geist Sans',
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          if (widget.coupon.expiryDate.isNotEmpty)
                            Text(
                              'Exp: ${widget.coupon.expiryDate}',
                              style: TextStyle(
                                fontFamily: 'Geist Sans',
                                fontSize: 9.5,
                                fontWeight: FontWeight.w500,
                                color: Colors.white.withValues(alpha: 0.8),
                              ),
                            ),
                        ],
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.coupon.title,
                              style: const TextStyle(
                                fontFamily: 'Geist Sans',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.coupon.description,
                              style: TextStyle(
                                fontFamily: 'Geist Sans',
                                fontSize: 11.5,
                                color: Colors.white.withValues(alpha: 0.85),
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'CODE: ${widget.coupon.discountCode}',
                            style: const TextStyle(
                              fontFamily: 'Geist Sans',
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.0,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Explore',
                                  style: TextStyle(
                                    fontFamily: 'Geist Sans',
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1F1F1F),
                                  ),
                                ),
                                SizedBox(width: 4),
                                Icon(
                                  Icons.arrow_forward_rounded,
                                  size: 11,
                                  color: Color(0xFF1F1F1F),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
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

class OfferBackgroundPainter extends CustomPainter {
  const OfferBackgroundPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.white.withValues(alpha: 0.05);

    // Draw some subtle curved waves or circles
    final path = Path();
    path.moveTo(0, size.height * 0.8);
    path.quadraticBezierTo(
      size.width * 0.3,
      size.height * 0.65,
      size.width * 0.7,
      size.height * 0.85,
    );
    path.quadraticBezierTo(
      size.width * 0.85,
      size.height * 0.95,
      size.width,
      size.height * 0.78,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, paint);

    final path2 = Path();
    path2.moveTo(0, size.height * 0.9);
    path2.quadraticBezierTo(
      size.width * 0.4,
      size.height * 0.8,
      size.width * 0.8,
      size.height * 0.95,
    );
    path2.lineTo(size.width, size.height);
    path2.lineTo(0, size.height);
    path2.close();
    paint.color = Colors.white.withValues(alpha: 0.03);
    canvas.drawPath(path2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class TransactionRow extends StatefulWidget {
  final TransactionModel txn;
  final VoidCallback onTap;

  const TransactionRow({
    super.key,
    required this.txn,
    required this.onTap,
  });

  @override
  State<TransactionRow> createState() => _TransactionRowState();
}

class _TransactionRowState extends State<TransactionRow> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isCredit = widget.txn.type.toUpperCase() == 'CREDIT';
    
    Color statusColor;
    Color statusBgColor;
    switch (widget.txn.status.toUpperCase()) {
      case 'SUCCESS':
        statusColor = const Color(0xFF10B981);
        statusBgColor = const Color(0xFF10B981).withValues(alpha: 0.08);
        break;
      case 'PENDING':
        statusColor = const Color(0xFFF59E0B);
        statusBgColor = const Color(0xFFF59E0B).withValues(alpha: 0.08);
        break;
      case 'FAILED':
      default:
        statusColor = const Color(0xFFEF4444);
        statusBgColor = const Color(0xFFEF4444).withValues(alpha: 0.08);
        break;
    }

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _isPressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: _isPressed ? const Color(0xFFF8FAFC) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFE2E8F0),
              width: 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF002E6E).withValues(alpha: 0.015),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF3F37C9).withValues(alpha: 0.06),
                ),
                alignment: Alignment.center,
                child: Icon(
                  _getTransactionIcon(widget.txn.category, widget.txn.type),
                  color: const Color(0xFF3F37C9),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.txn.title,
                      style: const TextStyle(
                        fontFamily: 'Geist Sans',
                        fontSize: 14.5,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F1F1F),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${widget.txn.category} • ${widget.txn.date}',
                      style: const TextStyle(
                        fontFamily: 'Geist Sans',
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF64748B),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${isCredit ? "+" : "-"}₹${widget.txn.amount.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontFamily: 'Geist Sans',
                      fontSize: 14.5,
                      fontWeight: FontWeight.bold,
                      color: isCredit ? const Color(0xFF10B981) : const Color(0xFF1F1F1F),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: statusBgColor,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      widget.txn.status.toUpperCase(),
                      style: TextStyle(
                        fontFamily: 'Geist Sans',
                        fontSize: 8.5,
                        fontWeight: FontWeight.w800,
                        color: statusColor,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getTransactionIcon(String category, String type) {
    final cat = category.toLowerCase();
    if (cat.contains('recharge')) return Icons.phone_android_rounded;
    if (cat.contains('bill')) return Icons.receipt_long_rounded;
    if (cat.contains('travel') || cat.contains('flight') || cat.contains('train') || cat.contains('bus') || cat.contains('hotel')) {
      return Icons.flight_takeoff_rounded;
    }
    if (cat.contains('insurance')) return Icons.shield_rounded;
    if (cat.contains('invest')) return Icons.trending_up_rounded;
    if (cat.contains('loan')) return Icons.credit_card_rounded;
    if (cat.contains('merchant')) return Icons.storefront_rounded;
    if (cat.contains('qr')) return Icons.qr_code_scanner_rounded;
    
    if (type.toUpperCase() == 'CREDIT') {
      return Icons.south_west_rounded;
    }
    return Icons.arrow_outward_rounded;
  }
}
