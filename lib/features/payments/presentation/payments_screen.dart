import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/widgets.dart';
import 'package:payout/features/bank_accounts/presentation/bank_accounts_screen.dart';
import 'package:payout/features/global_search/presentation/global_search_screen.dart';
import 'package:payout/features/scan_qr/presentation/scan_qr_screen.dart';
import 'package:payout/features/transaction_history/presentation/transaction_history_screen.dart';

class PaymentsScreen extends StatelessWidget {
  const PaymentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> shortcuts = [
      {'label': 'Scan QR', 'icon': AppIcons.scanQR, 'screen': const ScanQRScreen(), 'color': AppColors.primary},
      {'label': 'Contacts', 'icon': AppIcons.contact, 'screen': const GlobalSearchScreen(), 'color': AppColors.success},
      {'label': 'To Bank', 'icon': AppIcons.bank, 'screen': const BankAccountsScreen(), 'color': Colors.indigo},
      {'label': 'Self Trans', 'icon': Icons.swap_horiz_rounded, 'screen': null, 'color': Colors.purple},
    ];

    final List<Map<String, dynamic>> utilities = [
      {'label': 'Mobile', 'icon': Icons.phone_android_rounded, 'color': Colors.amber},
      {'label': 'DTH', 'icon': Icons.tv_rounded, 'color': Colors.redAccent},
      {'label': 'Electricity', 'icon': Icons.lightbulb_rounded, 'color': Colors.orange},
      {'label': 'Credit Card', 'icon': Icons.credit_card_rounded, 'color': Colors.teal},
    ];

    final List<Map<String, String>> recents = [
      {'name': 'Arjun Mehta', 'upi': 'arjun@okaxis', 'amt': '₹350'},
      {'name': 'Riya Sharma', 'upi': 'riya@okicici', 'amt': '₹1,200'},
      {'name': 'Karan Johar', 'upi': 'karan@okhdfc', 'amt': '₹500'},
      {'name': 'Nisha Goel', 'upi': 'nisha@okaxis', 'amt': '₹80'},
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Payments Hub', showLeading: false),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24, vertical: AppSpacing.s12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. UPI Lite Active Status Card
            AppCard(
              color: AppColors.primaryContainer,
              padding: const EdgeInsets.all(AppSpacing.s16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.s8),
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.flash_on_rounded, color: Colors.white, size: 16),
                  ),
                  const SizedBox(width: AppSpacing.s12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'UPI Lite Active',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.bold,
                            fontSize: 13.0,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          '₹150.00 balance • PIN-free small payments',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 11.0,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.circle),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    ),
                    child: const Text(
                      'Top Up',
                      style: TextStyle(fontFamily: 'Inter', fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.s24),

            // 2. Hero Scan Guide Banner
            AppCard(
              color: AppColors.primary,
              borderRadius: AppRadius.xxl,
              padding: const EdgeInsets.all(AppSpacing.s24),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ScanQRScreen()),
                );
              },
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.s16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                    ),
                    child: const Icon(
                      AppIcons.scanQR,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.s20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Scan any QR Code',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Instant scans for all merchant/user code types.',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12.0,
                            color: AppColors.primaryContainer,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    AppIcons.arrowForward,
                    color: Colors.white70,
                    size: 14,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.s32),

            // 3. Quick Circular Shortcuts
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: shortcuts.map((item) {
                return GestureDetector(
                  onTap: () {
                    if (item['screen'] != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => item['screen'] as Widget),
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
                        child: Icon(item['icon'] as IconData, color: item['color'] as Color, size: 24),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item['label'] as String,
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

            // 4. Recent Payees
            const Text(
              'Recent Payees',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.s16),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: recents.length,
                itemBuilder: (context, index) {
                  final person = recents[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: AppSpacing.s20),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const GlobalSearchScreen()),
                        );
                      },
                      child: Column(
                        children: [
                          Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              CustomAvatar(
                                name: person['name']!,
                                size: 48,
                                backgroundColor: AppColors.primaryContainer,
                                textColor: AppColors.primary,
                              ),
                              Container(
                                padding: const EdgeInsets.all(2),
                                decoration: const BoxDecoration(
                                  color: AppColors.success,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(AppIcons.verified, size: 8, color: Colors.white),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            person['name']!.split(' ')[0],
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 11.0,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            person['amt']!,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 10.0,
                              color: AppColors.textSecondary,
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

            // 5. Utility Bills Payment Categories
            const Text(
              'Utility Bills & Recharges',
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
              itemCount: utilities.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.9,
              ),
              itemBuilder: (context, index) {
                final item = utilities[index];
                return AppCard(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.s12, horizontal: AppSpacing.s4),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(item['icon'] as IconData, color: item['color'] as Color, size: 20),
                      const SizedBox(height: 8),
                      Text(
                        item['label'] as String,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 10.0,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: AppSpacing.s32),

            // 6. Payment History Shortcut Card
            AppCard(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TransactionHistoryScreen()),
                );
              },
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.s12),
                    decoration: const BoxDecoration(
                      color: AppColors.surface,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      AppIcons.history,
                      color: AppColors.primary,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.s16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Payment History',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'View and download transaction statements.',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12.0,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    AppIcons.chevronRight,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.s40),
          ],
        ),
      ),
    );
  }
}
