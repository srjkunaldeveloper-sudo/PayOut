import 'package:flutter/material.dart';
import 'package:payout/core/di/app_dependencies.dart';
import 'package:payout/core/error/error_message_mapper.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/widgets.dart';
import 'package:payout/core/widgets/states.dart';
import 'package:payout/features/transactions/models/transaction_models.dart';
import 'package:payout/features/transactions/repositories/transaction_repository.dart';
import 'package:payout/features/transactions/services/transaction_service.dart';
import 'package:payout/features/transactions/presentation/transaction_detail_screen.dart';

class TransactionHistoryScreen extends StatefulWidget {
  final TransactionRepository? transactionRepository;

  const TransactionHistoryScreen({super.key, this.transactionRepository});

  @override
  State<TransactionHistoryScreen> createState() => _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  late final TransactionRepository _transactionRepository;
  final TextEditingController _searchController = TextEditingController();

  List<TransactionModel> _transactions = [];
  bool _isLoading = true;
  String? _errorMessage;
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
    _transactionRepository = widget.transactionRepository ?? AppDependencies.instance.transactionRepository;
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
      _errorMessage = null;
    });
    try {
      final txs = await _transactionRepository.getTransactions();
      if (mounted) {
        setState(() {
          _transactions = txs;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = ErrorMessageMapper.map(e, fallback: 'Unable to load transaction history.');
          _isLoading = false;
        });
      }
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
          return tx.category.toLowerCase() == 'recharge';
        case 'Bills':
          return tx.category.toLowerCase() == 'bills' || tx.category.toLowerCase() == 'utilities';
        case 'QR Payments':
          return tx.category.toLowerCase() == 'qr' || tx.category.toLowerCase() == 'merchant';
        case 'Bank Transfer':
          return tx.category.toLowerCase() == 'bank' || tx.category.toLowerCase() == 'transfer';
        case 'Wallet':
          return tx.category.toLowerCase() == 'wallet';
        default:
          return true;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: const CustomAppBar(title: 'Transaction History'),
        body: const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        ),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: const CustomAppBar(title: 'Transaction History'),
        body: SafeArea(
          child: ErrorState(
            description: _errorMessage!,
            onRetry: _loadData,
          ),
        ),
      );
    }

    final filtered = _getFilteredTransactions();
    final grouped = TransactionService.groupTransactionsByDate(filtered);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Transaction History'),
      body: Column(
        children: [
          // 1. Search Box
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24, vertical: AppSpacing.s12),
            child: CustomSearchBar(
              controller: _searchController,
              hintText: 'Search by contact, UPI ID, or amount',
              onChanged: (val) {
                setState(() {
                  _searchQuery = val;
                });
              },
            ),
          ),

          // 2. Category Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: AppSpacing.s24, right: AppSpacing.s24, bottom: AppSpacing.s12),
            child: Row(
              children: _categories.map((cat) {
                final isSelected = _selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.s8),
                  child: ChoiceChip(
                    label: Text(cat),
                    selected: isSelected,
                    onSelected: (val) {
                      setState(() {
                        _selectedCategory = cat;
                      });
                    },
                    selectedColor: AppColors.primary.withValues(alpha: 0.1),
                    labelStyle: TextStyle(
                      fontFamily: 'Geist Sans',
                      color: isSelected ? AppColors.primary : AppColors.textPrimary,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const Divider(height: 1, color: AppColors.divider),

          // 3. Transactions List
          Expanded(
            child: filtered.isEmpty
                ? const EmptyState(
                    title: 'No Transactions Found',
                    description: 'Try adjusting your filters or search query.',
                    icon: Icons.search_off_rounded,
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
                                fontFamily: 'Geist Sans',
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
