import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/widgets.dart';
import 'package:payout/core/di/app_dependencies.dart';
import 'package:payout/features/merchant/models/merchant_models.dart';
import 'package:payout/features/merchant/repositories/merchant_repository.dart';
import 'package:payout/features/merchant/services/merchant_service.dart';

class MerchantTransactionsScreen extends StatefulWidget {
  final MerchantRepository? merchantRepository;

  const MerchantTransactionsScreen({
    super.key,
    this.merchantRepository,
  });

  @override
  State<MerchantTransactionsScreen> createState() => _MerchantTransactionsScreenState();
}

class _MerchantTransactionsScreenState extends State<MerchantTransactionsScreen> {
  late final MerchantRepository _merchantRepo;
  final TextEditingController _searchController = TextEditingController();
  List<MerchantTransactionModel> _allTransactions = [];
  List<MerchantTransactionModel> _filteredTransactions = [];
  bool _isLoading = true;
  String _selectedStatus = 'All';
  String _selectedMethod = 'All';

  final List<String> _statusFilters = ['All', 'SUCCESS', 'PENDING', 'FAILED'];
  final List<String> _methodFilters = ['All', 'UPI', 'CARD', 'WALLET'];

  @override
  void initState() {
    super.initState();
    _merchantRepo = widget.merchantRepository ?? AppDependencies.instance.merchantRepository;
    _loadTransactions();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadTransactions() async {
    final list = await _merchantRepo.getTransactions();
    if (mounted) {
      setState(() {
        _allTransactions = list;
        _isLoading = false;
        _applyFilters();
      });
    }
  }

  void _applyFilters() {
    setState(() {
      _filteredTransactions = MerchantService.filterTransactions(
        _allTransactions,
        query: _searchController.text,
        status: _selectedStatus,
        paymentMethod: _selectedMethod,
      );
    });
  }

  void _showTransactionDetails(MerchantTransactionModel txn) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(AppSpacing.s24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(color: AppColors.divider, borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: AppSpacing.s16),
              const Text('Transaction Details', style: TextStyle(fontFamily: 'Geist Sans', fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 4),
              Text('Customer payment record #${txn.id}', style: const TextStyle(fontFamily: 'Geist Sans', fontSize: 12, color: AppColors.textSecondary)),
              const SizedBox(height: AppSpacing.s16),
              AppCard(
                padding: const EdgeInsets.all(AppSpacing.s16),
                child: Column(
                  children: [
                    _buildDetailRow('Customer Name', txn.customerName),
                    const Divider(color: AppColors.divider),
                    _buildDetailRow('Amount Received', '₹${txn.amount.toStringAsFixed(2)}', isAmount: true),
                    const Divider(color: AppColors.divider),
                    _buildDetailRow('Payment Mode', txn.paymentMethod),
                    const Divider(color: AppColors.divider),
                    _buildDetailRow('Transaction ID', txn.transactionId),
                    const Divider(color: AppColors.divider),
                    _buildDetailRow('Bank UTR Number', txn.utr),
                    const Divider(color: AppColors.divider),
                    _buildDetailRow('Date & Time', txn.dateTime),
                    const Divider(color: AppColors.divider),
                    _buildDetailRow('Status', txn.status, statusColor: _getStatusColor(txn.status)),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.s20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isAmount = false, Color? statusColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontFamily: 'Geist Sans', fontSize: 12, color: AppColors.textSecondary)),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontFamily: 'Geist Sans',
                fontSize: isAmount ? 14 : 12,
                fontWeight: isAmount ? FontWeight.bold : FontWeight.w600,
                color: statusColor ?? (isAmount ? AppColors.primary : AppColors.textPrimary),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'SUCCESS':
        return AppColors.success;
      case 'PENDING':
        return Colors.orange;
      case 'FAILED':
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Store Transactions'),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary)))
          : Column(
              children: [
                // Search Bar
                Padding(
                  padding: const EdgeInsets.fromLTRB(AppSpacing.s24, AppSpacing.s16, AppSpacing.s24, AppSpacing.s8),
                  child: TextFormField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search by customer, Txn ID, or UTR',
                      prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textSecondary),
                      filled: true,
                      fillColor: AppColors.surface,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.circle),
                        borderSide: const BorderSide(color: AppColors.divider),
                      ),
                    ),
                    onChanged: (_) => _applyFilters(),
                  ),
                ),

                // Status Filter Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24, vertical: 4),
                  child: Row(
                    children: _statusFilters.map((st) {
                      final isSelected = _selectedStatus == st;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(st, style: TextStyle(fontFamily: 'Geist Sans', fontSize: 11, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                          selected: isSelected,
                          selectedColor: AppColors.primary,
                          labelStyle: TextStyle(color: isSelected ? Colors.white : AppColors.textPrimary),
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _selectedStatus = st;
                                _applyFilters();
                              });
                            }
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),

                // Payment Method Filter Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24, vertical: 4),
                  child: Row(
                    children: _methodFilters.map((method) {
                      final isSelected = _selectedMethod == method;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(method, style: TextStyle(fontFamily: 'Geist Sans', fontSize: 11, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                          selected: isSelected,
                          selectedColor: AppColors.primaryLight,
                          labelStyle: TextStyle(color: isSelected ? AppColors.primary : AppColors.textSecondary),
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _selectedMethod = method;
                                _applyFilters();
                              });
                            }
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 8),

                // Transactions List
                Expanded(
                  child: _filteredTransactions.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.receipt_long_rounded, size: 48, color: AppColors.textSecondary),
                              SizedBox(height: 12),
                              Text('No transactions found', style: TextStyle(fontFamily: 'Geist Sans', fontWeight: FontWeight.bold, fontSize: 14)),
                              SizedBox(height: 4),
                              Text('Try adjusting your search or filters', style: TextStyle(fontFamily: 'Geist Sans', fontSize: 12, color: AppColors.textSecondary)),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24, vertical: 8),
                          itemCount: _filteredTransactions.length,
                          itemBuilder: (context, index) {
                            final txn = _filteredTransactions[index];
                            final statusColor = _getStatusColor(txn.status);

                            return Padding(
                              padding: const EdgeInsets.only(bottom: AppSpacing.s12),
                              child: InkWell(
                                onTap: () => _showTransactionDetails(txn),
                                borderRadius: BorderRadius.circular(AppRadius.md),
                                child: AppCard(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                color: AppColors.primary.withValues(alpha: 0.08),
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: const Icon(Icons.payment_rounded, color: AppColors.primary, size: 20),
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    txn.customerName,
                                                    style: const TextStyle(fontFamily: 'Geist Sans', fontWeight: FontWeight.bold, fontSize: 13),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                  const SizedBox(height: 2),
                                                  Text(
                                                    '${txn.paymentMethod} • ${txn.dateTime}',
                                                    style: const TextStyle(fontFamily: 'Geist Sans', fontSize: 11, color: AppColors.textSecondary),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                  const SizedBox(height: 2),
                                                  Text(
                                                    'UTR: ${txn.utr}',
                                                    style: const TextStyle(fontFamily: 'Geist Sans', fontSize: 10, color: AppColors.textSecondary),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            '+₹${txn.amount.toStringAsFixed(2)}',
                                            style: const TextStyle(fontFamily: 'Geist Sans', fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.success),
                                          ),
                                          const SizedBox(height: 4),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: statusColor.withValues(alpha: 0.1),
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              txn.status,
                                              style: TextStyle(fontFamily: 'Geist Sans', fontSize: 9, fontWeight: FontWeight.bold, color: statusColor),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
