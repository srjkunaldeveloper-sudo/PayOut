import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/widgets.dart';
import 'package:payout/features/recharge/presentation/review_recharge_screen.dart';
import 'package:payout/features/recharge/models/recharge_models.dart';
import 'package:payout/features/recharge/repositories/recharge_repository.dart';
import 'package:payout/features/transactions/repositories/transaction_repository.dart';

class PlanSelectionScreen extends StatefulWidget {
  final String mobileNumber;
  final String operatorName;

  const PlanSelectionScreen({
    super.key,
    required this.mobileNumber,
    required this.operatorName,
  });

  @override
  State<PlanSelectionScreen> createState() => _PlanSelectionScreenState();
}

class _PlanSelectionScreenState extends State<PlanSelectionScreen> {
  final RechargeRepository _rechargeRepository = MockRechargeRepository(MockTransactionRepository());

  int _activeCategory = 0;
  final List<String> _categories = ['All', 'Popular', 'Unlimited', 'Data', 'Validity', 'Talktime', 'SMS'];

  List<RechargePlanModel> _plans = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPlans();
  }

  Future<void> _loadPlans() async {
    setState(() {
      _isLoading = true;
    });
    final list = await _rechargeRepository.getPlans(widget.operatorName);
    if (mounted) {
      setState(() {
        _plans = list;
        _isLoading = false;
      });
    }
  }

  void _showPlanDetails(RechargePlanModel plan) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
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
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.s24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '₹${plan.amount.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      plan.category,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.s24),
              const Text(
                'Plan Benefits',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.s12),
              _buildBenefitRow(Icons.date_range_rounded, 'Validity', plan.validity),
              _buildBenefitRow(Icons.swap_vert_rounded, 'Data Allowance', plan.data),
              _buildBenefitRow(Icons.phone_rounded, 'Calls', plan.calls.isEmpty ? 'N/A' : plan.calls),
              _buildBenefitRow(Icons.sms_rounded, 'SMS Allowance', plan.sms.isEmpty ? 'N/A' : plan.sms),
              const SizedBox(height: AppSpacing.s16),
              const Divider(color: AppColors.divider),
              const SizedBox(height: AppSpacing.s16),
              const Text(
                'Description',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.s8),
              Text(
                plan.description,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: AppSpacing.s32),
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  text: 'Continue',
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReviewRechargeScreen(
                          mobileNumber: widget.mobileNumber,
                          operatorName: widget.operatorName,
                          plan: plan,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.s12),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBenefitRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.textSecondary),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(fontFamily: 'Inter', fontSize: 13, color: AppColors.textSecondary),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final activeCat = _categories[_activeCategory];
    final filteredPlans = _plans.where((p) {
      if (activeCat == 'All') return true;
      return p.category.toLowerCase() == activeCat.toLowerCase();
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Select Plan'),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.s24),
            child: AppCard(
              child: Row(
                children: [
                  const Icon(Icons.phone_android_rounded, color: AppColors.primary),
                  const SizedBox(width: AppSpacing.s12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.mobileNumber,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        widget.operatorName,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          SizedBox(
            height: 36,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              padding: const EdgeInsets.only(left: AppSpacing.s24),
              itemBuilder: (context, index) {
                final isSelected = _activeCategory == index;
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: ChoiceChip(
                    label: Text(
                      _categories[index],
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : AppColors.textPrimary,
                      ),
                    ),
                    selected: isSelected,
                    onSelected: (val) {
                      setState(() {
                        _activeCategory = index;
                      });
                    },
                    selectedColor: AppColors.primary,
                    backgroundColor: AppColors.surface,
                    checkmarkColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: AppSpacing.s20),

          Expanded(
            child: _isLoading? const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary)))
                : filteredPlans.isEmpty
                    ? const Center(child: Text('No plans found for this category.', style: TextStyle(fontFamily: 'Inter', color: AppColors.textSecondary)))
                    : ListView.builder(
                        itemCount: filteredPlans.length,
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24),
                        itemBuilder: (context, index) {
                          final plan = filteredPlans[index];

                          return Padding(
                            padding: const EdgeInsets.only(bottom: AppSpacing.s16),
                            child: AppCard(
                              onTap: () => _showPlanDetails(plan),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '₹${plan.amount.toStringAsFixed(0)}',
                                        style: const TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 24.0,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: AppColors.primaryContainer,
                                          borderRadius: BorderRadius.circular(AppRadius.xs),
                                        ),
                                        child: Text(
                                          plan.category,
                                          style: const TextStyle(
                                            fontFamily: 'Inter',
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: AppSpacing.s12),
                                  Row(
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(Icons.date_range_rounded, size: 14, color: AppColors.textSecondary),
                                          const SizedBox(width: 4),
                                          Text(
                                            'Validity: ${plan.validity}',
                                            style: const TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.textSecondary),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(width: 24),
                                      Row(
                                        children: [
                                          const Icon(Icons.swap_vert_rounded, size: 14, color: AppColors.textSecondary),
                                          const SizedBox(width: 4),
                                          Text(
                                            'Data: ${plan.data}',
                                            style: const TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.textSecondary),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: AppSpacing.s12),
                                  Text(
                                    plan.description,
                                    style: const TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 12.0,
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
        ],
      ),
    );
  }
}
