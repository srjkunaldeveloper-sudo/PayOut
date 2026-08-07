import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/app_card.dart';
import 'package:payout/features/bank_accounts/presentation/bank_accounts_screen.dart';
import 'package:payout/features/global_search/presentation/global_search_screen.dart';
import 'package:payout/features/my_qr/presentation/my_qr_screen.dart';
import 'package:payout/features/scan_qr/presentation/scan_qr_screen.dart';
import 'package:payout/features/transaction_history/presentation/transaction_history_screen.dart';

class PaymentsScreen extends StatelessWidget {
  const PaymentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> menu = [
      {'title': 'Scan QR Code', 'subtitle': 'Pay at any merchant desk', 'icon': Icons.qr_code_scanner_rounded, 'screen': const ScanQRScreen()},
      {'title': 'My QR Code', 'subtitle': 'Show code to receive payments', 'icon': Icons.qr_code_2_rounded, 'screen': const MyQRScreen()},
      {'title': 'Send to Contact', 'subtitle': 'Pay friends using email or phone', 'icon': Icons.person_add_alt_1_rounded, 'screen': const GlobalSearchScreen()},
      {'title': 'Send to Bank', 'subtitle': 'Wire funds to a checking account', 'icon': Icons.account_balance_rounded, 'screen': const BankAccountsScreen()},
      {'title': 'Self Transfer', 'subtitle': 'Move cash between linked cards', 'icon': Icons.swap_horiz_rounded, 'screen': null},
      {'title': 'Payment History', 'subtitle': 'Review past transactions ledger', 'icon': Icons.history_rounded, 'screen': const TransactionHistoryScreen()},
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Payments Hub', showLeading: false),
      body: ListView.builder(
        padding: const EdgeInsets.all(AppSpacing.s24),
        itemCount: menu.length,
        itemBuilder: (context, index) {
          final item = menu[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.s12),
            child: AppCard(
              onTap: () {
                if (item['screen'] != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => item['screen'] as Widget),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Self-Transfer flow triggered.')),
                  );
                }
              },
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.s12),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(item['icon'] as IconData, color: AppColors.primary, size: 24),
                  ),
                  const SizedBox(width: AppSpacing.s16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['title'] as String,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item['subtitle'] as String,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12.0,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
