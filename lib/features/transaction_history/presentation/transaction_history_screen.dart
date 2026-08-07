import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/app_card.dart';
import 'package:payout/core/widgets/search_bar.dart';
import 'package:payout/core/widgets/transaction_tile.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() => _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  String _selectedCategory = 'All';

  final List<Map<String, dynamic>> _transactions = [
    {
      'title': 'IndiGo Airlines',
      'sub': 'Flight Ticket DEL-BOM',
      'date': 'Aug 07, 2026',
      'amount': 4200.00,
      'isCredit': false,
      'cat': 'Travel',
      'status': 'Succeeded',
    },
    {
      'title': 'HDFC Power bill',
      'sub': 'Electricity bill utility sweep',
      'date': 'Aug 05, 2026',
      'amount': 84.60,
      'isCredit': false,
      'cat': 'Bills',
      'status': 'Succeeded',
    },
    {
      'title': 'Refund Received',
      'sub': 'Failed UPI transfer rollback',
      'date': 'Aug 04, 2026',
      'amount': 1500.00,
      'isCredit': true,
      'cat': 'Transfer',
      'status': 'Succeeded',
    },
    {
      'title': 'Starbucks Coffee',
      'sub': 'Scan QR retail checkout',
      'date': 'Aug 02, 2026',
      'amount': 380.00,
      'isCredit': false,
      'cat': 'Shopping',
      'status': 'Cleared',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showReceipt(Map<String, dynamic> txn) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadii.bottomSheet)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(AppSpacing.s24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.textSecondary.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: AppSpacing.s20),
              const Text(
                'Transaction Receipt',
                style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: AppSpacing.s20),
              AppCard(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(txn['title'], style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold)),
                        Text(
                          '${txn['isCredit'] ? '+' : '-'}₹${txn['amount']}',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.bold,
                            color: txn['isCredit'] ? AppColors.success : AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.s12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Date', style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.textSecondary)),
                        Text(txn['date'], style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.s8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Description', style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.textSecondary)),
                        Text(txn['sub'], style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.s8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Status', style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.textSecondary)),
                        Text(txn['status'], style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, color: AppColors.success, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.s24),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _transactions.where((txn) {
      final matchesSearch = txn['title'].toLowerCase().contains(_query.toLowerCase()) ||
          txn['sub'].toLowerCase().contains(_query.toLowerCase());
      final matchesCat = _selectedCategory == 'All' || txn['cat'] == _selectedCategory;
      return matchesSearch && matchesCat;
    }).toList();

    final categories = ['All', 'Travel', 'Bills', 'Transfer', 'Shopping'];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Transaction History'),
      body: Column(
        children: [
          // Search & Filter
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24, vertical: AppSpacing.s12),
            child: Column(
              children: [
                CustomSearchBar(
                  controller: _searchController,
                  hintText: 'Search transactions...',
                  onChanged: (val) {
                    setState(() {
                      _query = val;
                    });
                  },
                ),
                const SizedBox(height: AppSpacing.s12),
                SizedBox(
                  height: 32,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final cat = categories[index];
                      final isSelected = cat == _selectedCategory;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          label: Text(
                            cat,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              color: isSelected ? Colors.white : AppColors.textPrimary,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                          selected: isSelected,
                          selectedColor: AppColors.primary,
                          backgroundColor: AppColors.surface,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _selectedCategory = cat;
                              });
                            }
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.divider),
          // Transaction List
          Expanded(
            child: filtered.isEmpty
                ? const Center(
                    child: Text(
                      'No transactions found.',
                      style: TextStyle(fontFamily: 'Inter', color: AppColors.textSecondary),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16, vertical: AppSpacing.s12),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final txn = filtered[index];
                      bool showHeader = false;
                      String headerText = '';

                      if (index == 0) {
                        showHeader = true;
                        headerText = txn['date'] == 'Aug 07, 2026' ? 'Today' : 'Earlier';
                      } else {
                        final prevTxn = filtered[index - 1];
                        if (txn['date'] != prevTxn['date']) {
                          showHeader = true;
                          headerText = txn['date'] == 'Aug 07, 2026' ? 'Today' : 'Earlier';
                        }
                      }

                      final tile = TransactionTile(
                        title: txn['title'],
                        subtitle: txn['sub'],
                        date: txn['date'],
                        amount: txn['amount'],
                        isCredit: txn['isCredit'],
                        status: txn['status'],
                        onTap: () => _showReceipt(txn),
                      );

                      if (showHeader) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 12.0, top: 16.0, bottom: 8.0),
                              child: Text(
                                headerText,
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                            tile,
                          ],
                        );
                      }
                      return tile;
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
