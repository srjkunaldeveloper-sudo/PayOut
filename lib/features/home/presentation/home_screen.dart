import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/widgets.dart';

// Service Screen Imports
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

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Quick Actions definition
    final List<Map<String, dynamic>> quickActions = [
      {'label': 'Scan QR', 'icon': Icons.qr_code_scanner_rounded, 'screen': const ScanQRScreen()},
      {'label': 'My QR', 'icon': Icons.qr_code_2_rounded, 'screen': const MyQRScreen()},
      {'label': 'Contact', 'icon': Icons.person_add_alt_1_rounded, 'screen': const GlobalSearchScreen()},
      {'label': 'To Bank', 'icon': Icons.account_balance_rounded, 'screen': const BankAccountsScreen()},
      {'label': 'Self Trans', 'icon': Icons.swap_horiz_rounded, 'screen': null},
    ];

    // Service Categories definition
    final List<Map<String, dynamic>> services = [
      {'name': 'Transfer', 'icon': Icons.swap_horiz_rounded, 'screen': const GlobalSearchScreen(), 'color': AppColors.primary},
      {'name': 'Wallet', 'icon': Icons.account_balance_wallet_rounded, 'screen': const WalletScreen(), 'color': Colors.amber},
      {'name': 'Recharge', 'icon': Icons.bolt_rounded, 'screen': const RechargeScreen(), 'color': AppColors.warning},
      {'name': 'Bills', 'icon': Icons.receipt_long_rounded, 'screen': const BillsScreen(), 'color': AppColors.error},
      {'name': 'Travel', 'icon': Icons.flight_takeoff_rounded, 'screen': const TravelScreen(), 'color': AppColors.success},
      {'name': 'Merchant', 'icon': Icons.storefront_rounded, 'screen': const MerchantScreen(), 'color': Colors.teal},
      {'name': 'Insurance', 'icon': Icons.favorite_rounded, 'screen': const InsuranceScreen(), 'color': Colors.redAccent},
      {'name': 'Loans', 'icon': Icons.monetization_on_rounded, 'screen': const LoansScreen(), 'color': Colors.indigo},
      {'name': 'Invest', 'icon': Icons.trending_up_rounded, 'screen': const InvestmentsScreen(), 'color': Colors.purple},
      {'name': 'Rewards', 'icon': Icons.stars_rounded, 'screen': const RewardsScreen(), 'color': Colors.orange},
      {'name': 'Settings', 'icon': Icons.settings_rounded, 'screen': const SettingsScreen(), 'color': AppColors.textSecondary},
      {'name': 'Support', 'icon': Icons.support_agent_rounded, 'screen': const SupportScreen(), 'color': Colors.blueGrey},
    ];

    // Contacts
    final List<String> recentContacts = ['Rahul Sharma', 'Aarav Gupta', 'Kunal Sharma', 'Pooja Patel', 'Amit Verma'];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.s16),
              // 1. Greeting Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ProfileScreen()),
                      );
                    },
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primaryContainer,
                          ),
                          child: const CustomAvatar(
                            name: 'Rahul Sharma',
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
                              'Good Afternoon,',
                              style: AppTypography.bodyMedium.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            Text(
                              'Rahul Sharma',
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
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const NotificationsScreen()),
                            );
                          },
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          width: 8,
                          height: 8,
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

              // 2. Search Bar
              CustomSearchBar(
                readOnly: true,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const GlobalSearchScreen()),
                  );
                },
              ),
              const SizedBox(height: AppSpacing.s24),

              // 3. Wallet Balance Card
              WalletCard(
                balance: 1250.75,
                linkedBankName: 'HDFC Bank •••• 9821',
                cashbackEarned: 1425.0,
                lastUpdated: 'Updated just now',
                onAddMoney: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const WalletScreen()),
                  );
                },
                onSendMoney: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const GlobalSearchScreen()),
                  );
                },
              ),
              const SizedBox(height: AppSpacing.s24),

              // 4. Quick Actions (Google Pay / phonepe style circles)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: quickActions.map((act) {
                  return GestureDetector(
                    onTap: () {
                      if (act['screen'] != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => act['screen'] as Widget),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Self-Transfer flow selected.')),
                        );
                      }
                    },
                    child: Column(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: const BoxDecoration(
                            color: AppColors.surface,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(act['icon'] as IconData, color: AppColors.primary, size: 24),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          act['label'] as String,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 11.0,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: AppSpacing.s32),

              // 5. Recent Contacts
              const Text(
                'Recent Contacts',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.s12),
              SizedBox(
                height: 76,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: recentContacts.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Padding(
                        padding: const EdgeInsets.only(right: AppSpacing.s16),
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
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: AppColors.primaryLight,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: AppColors.primary.withOpacity(0.15), width: 1.5),
                                ),
                                child: const Icon(Icons.add_rounded, color: AppColors.primary, size: 20),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Add',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 11.0,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    final name = recentContacts[index - 1];
                    return Padding(
                      padding: const EdgeInsets.only(right: AppSpacing.s16),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const GlobalSearchScreen()),
                          );
                        },
                        child: Column(
                          children: [
                            CustomAvatar(
                              name: name,
                              size: 44,
                              backgroundColor: AppColors.primaryLight,
                              textColor: AppColors.primary,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              name.split(' ')[0],
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 11.0,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.s24),

              // 6. Service Categories
              const Text(
                'Services Categories',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.s12),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: services.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.85,
                ),
                itemBuilder: (context, index) {
                  final ser = services[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ser['screen'] as Widget),
                      );
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: (ser['color'] as Color).withOpacity(0.08),
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Icon(ser['icon'] as IconData, color: ser['color'] as Color, size: 22),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          ser['name'] as String,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 11.0,
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

              // 7. Offers Banner
              const Text(
                'Offers & Perks',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.s12),
              SizedBox(
                height: 90,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    AppCard(
                      padding: const EdgeInsets.all(AppSpacing.s12),
                      color: AppColors.primaryLight.withOpacity(0.3),
                      child: Row(
                        children: [
                          const Icon(Icons.stars_rounded, color: AppColors.primary, size: 32),
                          const SizedBox(width: AppSpacing.s12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                'Referral Cashback',
                                style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                              Text(
                                'Get ₹150 for every friend you invite.',
                                style: TextStyle(fontFamily: 'Inter', color: AppColors.textSecondary, fontSize: 11),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.s16),
                    AppCard(
                      padding: const EdgeInsets.all(AppSpacing.s12),
                      color: AppColors.success.withOpacity(0.08),
                      child: Row(
                        children: [
                          const Icon(Icons.local_offer_rounded, color: AppColors.success, size: 32),
                          const SizedBox(width: AppSpacing.s12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                'Zero Processing Fees',
                                style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                              Text(
                                'Pay bills fee-free with Payout wallet.',
                                style: TextStyle(fontFamily: 'Inter', color: AppColors.textSecondary, fontSize: 11),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.s32),

              // 8. Recommended Services
              const Text(
                'Recommended Services',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.s12),
              Row(
                children: [
                  Expanded(
                    child: FeatureCard(
                      title: 'Check Loans',
                      description: 'Get credit limits up to ₹10 Lakhs instantly.',
                      icon: Icons.monetization_on_rounded,
                      bgColor: AppColors.surface,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const LoansScreen()),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: FeatureCard(
                      title: 'Buy Gold',
                      description: 'Start saving in 24K digital gold from ₹10.',
                      icon: Icons.workspace_premium_rounded,
                      iconColor: Colors.amber,
                      bgColor: AppColors.surface,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const InvestmentsScreen()),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.s32),

              // 9. Recent Transactions
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
              TransactionTile(
                title: 'Starbucks Coffee',
                subtitle: 'Food & Dining',
                date: 'Aug 07, 2026',
                amount: 380.00,
                isCredit: false,
              ),
              const Divider(color: AppColors.divider),
              TransactionTile(
                title: 'Bank Account Deposit',
                subtitle: 'Wallet Load',
                date: 'Aug 07, 2026',
                amount: 1500.00,
                isCredit: true,
              ),
              const SizedBox(height: AppSpacing.s40),
            ],
          ),
        ),
      ),
    );
  }
}
