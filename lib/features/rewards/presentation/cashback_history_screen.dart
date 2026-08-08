import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/app_card.dart';
import 'package:payout/features/rewards/models/reward_models.dart';
import 'package:payout/features/rewards/repositories/reward_repository.dart';
import 'package:payout/features/rewards/services/reward_service.dart';

class CashbackHistoryScreen extends StatefulWidget {
  final RewardRepository? rewardRepository;

  const CashbackHistoryScreen({
    super.key,
    this.rewardRepository,
  });

  @override
  State<CashbackHistoryScreen> createState() => _CashbackHistoryScreenState();
}

class _CashbackHistoryScreenState extends State<CashbackHistoryScreen> {
  late final RewardRepository _rewardRepo;
  List<CashbackModel> _allCashbacks = [];
  List<CashbackModel> _filteredCashbacks = [];
  bool _isLoading = true;
  String _selectedStatus = 'All';

  final List<String> _statusFilters = ['All', 'AVAILABLE', 'PENDING', 'EXPIRED'];

  @override
  void initState() {
    super.initState();
    _rewardRepo = widget.rewardRepository ?? MockRewardRepository();
    _loadCashbacks();
  }

  Future<void> _loadCashbacks() async {
    final list = await _rewardRepo.getCashbackHistory();
    if (mounted) {
      setState(() {
        _allCashbacks = list;
        _isLoading = false;
        _applyFilter();
      });
    }
  }

  void _applyFilter() {
    setState(() {
      _filteredCashbacks = RewardService.filterCashbacks(
        _allCashbacks,
        status: _selectedStatus,
      );
    });
  }

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'AVAILABLE':
        return AppColors.success;
      case 'PENDING':
        return Colors.orange;
      case 'EXPIRED':
        return AppColors.textSecondary;
      default:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Cashback History'),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary)))
          : Column(
              children: [
                // Filter Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.fromLTRB(AppSpacing.s24, AppSpacing.s16, AppSpacing.s24, AppSpacing.s12),
                  child: Row(
                    children: _statusFilters.map((st) {
                      final isSelected = _selectedStatus == st;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(st, style: TextStyle(fontFamily: 'Inter', fontSize: 11, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                          selected: isSelected,
                          selectedColor: AppColors.primary,
                          labelStyle: TextStyle(color: isSelected ? Colors.white : AppColors.textPrimary),
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _selectedStatus = st;
                                _applyFilter();
                              });
                            }
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),

                // List of Cashbacks
                Expanded(
                  child: _filteredCashbacks.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.stars_rounded, size: 48, color: AppColors.textSecondary),
                              SizedBox(height: 12),
                              Text('No cashbacks found', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 14)),
                              SizedBox(height: 4),
                              Text('Cashbacks earned from payments will appear here', style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.textSecondary)),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24, vertical: 8),
                          itemCount: _filteredCashbacks.length,
                          itemBuilder: (context, index) {
                            final rew = _filteredCashbacks[index];
                            final statusColor = _getStatusColor(rew.status);

                            return Padding(
                              padding: const EdgeInsets.only(bottom: AppSpacing.s12),
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
                                              color: statusColor.withValues(alpha: 0.1),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(Icons.stars_rounded, color: statusColor, size: 22),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  rew.source,
                                                  style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 13),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                const SizedBox(height: 2),
                                                Text(
                                                  'Earned on ${rew.earnedAt}',
                                                  style: const TextStyle(fontFamily: 'Inter', fontSize: 11, color: AppColors.textSecondary),
                                                ),
                                                if (rew.transactionId != null) ...[
                                                  const SizedBox(height: 2),
                                                  Text(
                                                    'Ref: ${rew.transactionId}',
                                                    style: const TextStyle(fontFamily: 'Inter', fontSize: 10, color: AppColors.textSecondary),
                                                  ),
                                                ],
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
                                          '+₹${rew.amount.toStringAsFixed(2)}',
                                          style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 15, color: statusColor),
                                        ),
                                        const SizedBox(height: 4),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: statusColor.withValues(alpha: 0.1),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            rew.status,
                                            style: TextStyle(fontFamily: 'Inter', fontSize: 9, fontWeight: FontWeight.bold, color: statusColor),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
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
