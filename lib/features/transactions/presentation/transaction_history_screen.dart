import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/search_bar.dart';
import 'package:payout/core/widgets/transaction_tile.dart';
import 'package:payout/features/transactions/models/transaction_models.dart';
import 'package:payout/features/transactions/repositories/transaction_repository.dart';
import 'package:payout/features/transactions/services/transaction_service.dart';
import 'package:payout/features/transactions/presentation/transaction_detail_screen.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() => _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  final TransactionRepository _transactionRepository = MockTransactionRepository();
  final TextEditingController _searchController = TextEditingController();

  List<TransactionModel> _transactions = [];
  bool _isLoading = true;
  String _selectedCategory = 'All';
  String _searchQuery = '';

  final List<String> _categories = [
    'All',
    'Sent',
    'Received',
    'Recharge',
    'Bills',
    'QR Payments',
    'Bank Transfer',
    'Wallet',
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });
    final txs = await _transactionRepository.getTransactions();
    if (mounted) {
      setState(() {
        _transactions = txs;
        _isLoading = false;
      });
    }
  }

  List<TransactionModel> _getFilteredTransactions() {
    return _transactions.where((tx) {
      // 1. Search Query Filter
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final matches = tx.title.toLowerCase().contains(query) ||
            tx.upiId.toLowerCase().contains(query) ||
            tx.id.toLowerCase().contains(query) ||
            tx.category.toLowerCase().contains(query) ||
            tx.amount.toString().contains(query);
        if (!matches) return false;
      }

      // 2. Category Filter
      switch (_selectedCategory) {
        case 'Sent':
          return tx.type.toUpperCase() == 'DEBIT';
        case 'Received':
          return tx.type.toUpperCase() == 'CREDIT';
        case 'Recharge':
          return tx.category.toLowerCase().contains('recharge');
        case 'Bills':
          return tx.category.toLowerCase().contains('bill');
        case 'QR Payments':
          return tx.category.toLowerCase().contains('qr');
        case 'Bank Transfer':
          return tx.category.toLowerCase().contains('bank') ||
              tx.category.toLowerCase().contains('transfer') ||
              tx.category.toLowerCase().contains('upi');
        case 'Wallet':
          return tx.paymentMethod.toLowerCase().contains('wallet');
        case 'All':
        default:
          return true;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _getFilteredTransactions();
    final grouped = TransactionService.groupTransactionsByDate(filtered);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Transaction History'),
      body: Column(
        children: [
          // Search & Filter Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24, vertical: AppSpacing.s12),
            child: CustomSearchBar(
              controller: _searchController,
              hintText: 'Search by name, UPI ID, or amount...',
              onChanged: (val) {
                setState(() {
                  _searchQuery = val.trim();
                });
              },
            ),
          ),

          // Categories Filter Chips
          SizedBox(
            height: 36,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24),
              itemBuilder: (context, index) {
                final cat = _categories[index];
                final isSelected = cat == _selectedCategory;

                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(
                      cat,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : AppColors.textPrimary,
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: AppColors.primary,
                    backgroundColor: AppColors.surface,
                    checkmarkColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    onSelected: (val) {
                      if (val) {
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
          const SizedBox(height: AppSpacing.s12),
          const Divider(height: 1, color: AppColors.divider),

          // Transactions List grouped by date
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary)))
                : filtered.isEmpty
                    ? const Center(
                        child: Text(
                          'No transactions found.',
                          style: TextStyle(fontFamily: 'Inter', color: AppColors.textSecondary),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24, vertical: AppSpacing.s16),
                        itemCount: grouped.keys.length,
                        itemBuilder: (context, groupIndex) {
                          final header = grouped.keys.elementAt(groupIndex);
                          final items = grouped[header]!;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: AppSpacing.s8),
                                child: Text(
                                  header,
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13.0,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ),
                              ...items.map((tx) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: AppSpacing.s8),
                                  child: TransactionTile(
                                    title: tx.title,
                                    subtitle: tx.paymentMethod,
                                    date: tx.date,
                                    amount: tx.amount,
                                    isCredit: tx.type.toUpperCase() == 'CREDIT',
                                    status: tx.status,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => TransactionDetailScreen(transaction: tx),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              }),
                              const SizedBox(height: AppSpacing.s12),
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
