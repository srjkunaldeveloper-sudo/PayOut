import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/chip.dart';
import 'package:payout/core/widgets/transaction_tile.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() => _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  String _activeFilter = 'All';

  final List<Map<String, dynamic>> _allTransactions = [
    {'title': 'Starbucks Coffee', 'sub': 'Food & Dining', 'date': 'Aug 07, 2026', 'amount': 12.45, 'credit': false, 'month': 'August 2026'},
    {'title': 'Bank Account Deposit', 'sub': 'Wallet Load', 'date': 'Aug 07, 2026', 'amount': 500.00, 'credit': true, 'month': 'August 2026'},
    {'title': 'John Doe', 'sub': 'Contact Transfer', 'date': 'Aug 05, 2026', 'amount': 45.00, 'credit': false, 'month': 'August 2026'},
    {'title': 'Cashback Bonus', 'sub': 'Rewards Credit', 'date': 'Jul 28, 2026', 'amount': 15.00, 'credit': true, 'month': 'July 2026'},
    {'title': 'Target Stores', 'sub': 'Shopping Debit', 'date': 'Jul 22, 2026', 'amount': 89.20, 'credit': false, 'month': 'July 2026'},
    {'title': 'Emma Watson', 'sub': 'Contact Transfer', 'date': 'Jul 15, 2026', 'amount': 120.00, 'credit': true, 'month': 'July 2026'},
  ];

  @override
  Widget build(BuildContext context) {
    // Filter transactions
    final filtered = _allTransactions.where((tx) {
      if (_activeFilter == 'Sent') return !tx['credit'];
      if (_activeFilter == 'Received') return tx['credit'];
      return true;
    }).toList();

    // Group by month
    final Map<String, List<Map<String, dynamic>>> groups = {};
    for (var tx in filtered) {
      final month = tx['month'] as String;
      if (!groups.containsKey(month)) {
        groups[month] = [];
      }
      groups[month]!.add(tx);
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Transaction History'),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24, vertical: AppSpacing.s12),
            child: Row(
              children: ['All', 'Sent', 'Received'].map((filter) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: CustomChip(
                    label: filter,
                    isSelected: _activeFilter == filter,
                    onSelected: (val) {
                      setState(() {
                        _activeFilter = filter;
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const Divider(height: 1, color: AppColors.divider),
          Expanded(
            child: filtered.isEmpty
                ? const Center(
                    child: Text(
                      'No transactions found.',
                      style: TextStyle(fontFamily: 'Inter', color: AppColors.textSecondary),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24, vertical: AppSpacing.s12),
                    itemCount: groups.keys.length,
                    itemBuilder: (context, groupIdx) {
                      final month = groups.keys.elementAt(groupIdx);
                      final txs = groups[month]!;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: AppSpacing.s12),
                            child: Text(
                              month,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13.0,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                          ...txs.map((tx) {
                            return TransactionTile(
                              title: tx['title'] as String,
                              subtitle: tx['sub'] as String,
                              date: tx['date'] as String,
                              amount: tx['amount'] as double,
                              isCredit: tx['credit'] as bool,
                            );
                          }).toList(),
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
