import 'package:flutter/material.dart';
import 'package:payout/core/widgets/widgets.dart';
import 'package:payout/core/di/app_dependencies.dart';
import 'package:payout/features/recharge/presentation/review_recharge_screen.dart';
import 'package:payout/features/recharge/models/recharge_models.dart';
import 'package:payout/features/recharge/repositories/recharge_repository.dart';

class PlanSelectionScreen extends StatefulWidget {
  final String mobileNumber;
  final String operatorName;
  final RechargeRepository? rechargeRepository;

  const PlanSelectionScreen({
    super.key,
    required this.mobileNumber,
    required this.operatorName,
    this.rechargeRepository,
  });

  @override
  State<PlanSelectionScreen> createState() => _PlanSelectionScreenState();
}

class _PlanSelectionScreenState extends State<PlanSelectionScreen> {
  late final RechargeRepository _rechargeRepository;

  int _activeCategory = 0;
  final List<String> _categories = ['All', 'Popular', 'Unlimited', 'Data', 'Validity', 'Talktime', 'SMS'];

  List<RechargePlanModel> _plans = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _rechargeRepository = widget.rechargeRepository ?? AppDependencies.instance.rechargeRepository;
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
            color: Color(0xFFF8FAFC),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFCBD5E1),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '₹${plan.amount.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontFamily: 'Geist Sans',
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F1F1F),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3F37C9).withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      plan.category,
                      style: const TextStyle(
                        fontFamily: 'Geist Sans',
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3F37C9),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              const Text(
                'Plan Benefits',
                style: TextStyle(
                  fontFamily: 'Geist Sans',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 10),
              _buildBenefitRow(Icons.calendar_today_rounded, 'Validity', plan.validity),
              _buildBenefitRow(Icons.swap_vert_rounded, 'Data Allowance', plan.data),
              _buildBenefitRow(Icons.phone_rounded, 'Calls', plan.calls.isEmpty ? 'N/A' : plan.calls),
              _buildBenefitRow(Icons.sms_rounded, 'SMS Allowance', plan.sms.isEmpty ? 'N/A' : plan.sms),
              const SizedBox(height: 14),
              const Divider(color: Color(0xFFE2E8F0)),
              const SizedBox(height: 14),
              const Text(
                'Description',
                style: TextStyle(
                  fontFamily: 'Geist Sans',
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F1F1F),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                plan.description,
                style: const TextStyle(
                  fontFamily: 'Geist Sans',
                  fontSize: 12.5,
                  color: Color(0xFF64748B),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              PrimaryButton(
                text: 'Continue',
                height: 52,
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
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBenefitRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Icon(icon, size: 15, color: const Color(0xFF3F37C9)),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(fontFamily: 'Geist Sans', fontSize: 13, color: Color(0xFF64748B)),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(fontFamily: 'Geist Sans', fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1F1F1F)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.of(context).canPop();
    final activeCat = _categories[_activeCategory];
    final filteredPlans = _plans.where((p) {
      if (activeCat == 'All') return true;
      return p.category.toLowerCase() == activeCat.toLowerCase();
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                if (canPop)
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.arrow_back_rounded,
                        color: Color(0xFF3F37C9),
                        size: 20,
                      ),
                    ),
                  ),
                const Expanded(
                  child: Center(
                    child: Text(
                      'Select Plan',
                      style: TextStyle(
                        fontFamily: 'Geist Sans',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F1F1F),
                      ),
                    ),
                  ),
                ),
                if (canPop)
                  const SizedBox(width: 38)
                else
                  const SizedBox(width: 16),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Top Number Identity Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF002E6E).withValues(alpha: 0.02),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF3F37C9).withValues(alpha: 0.08),
                      ),
                      alignment: Alignment.center,
                      child: const Icon(Icons.phone_android_rounded, color: Color(0xFF3F37C9), size: 20),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.mobileNumber,
                          style: const TextStyle(
                            fontFamily: 'Geist Sans',
                            fontWeight: FontWeight.bold,
                            fontSize: 14.5,
                            color: Color(0xFF1F1F1F),
                          ),
                        ),
                        Text(
                          widget.operatorName,
                          style: const TextStyle(
                            fontFamily: 'Geist Sans',
                            fontSize: 12,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Category Filter Pills
            SizedBox(
              height: 36,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                padding: const EdgeInsets.only(left: 18),
                itemBuilder: (context, index) {
                  final isSelected = _activeCategory == index;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () => setState(() => _activeCategory = index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          gradient: isSelected
                              ? const LinearGradient(
                                  colors: [Color(0xFF3F37C9), Color(0xFF2563EB)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )
                              : null,
                          color: !isSelected ? Colors.white : null,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: isSelected ? Colors.transparent : const Color(0xFFE2E8F0),
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: const Color(0xFF3F37C9).withValues(alpha: 0.15),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                              : null,
                        ),
                        child: Text(
                          _categories[index],
                          style: TextStyle(
                            fontFamily: 'Geist Sans',
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : const Color(0xFF1F1F1F),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),

            // Plans List
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF3F37C9))))
                  : filteredPlans.isEmpty
                      ? const Center(child: Text('No plans found for this category.', style: TextStyle(fontFamily: 'Geist Sans', color: Color(0xFF64748B))))
                      : ListView.builder(
                          itemCount: filteredPlans.length,
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          itemBuilder: (context, index) {
                            final plan = filteredPlans[index];

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: GestureDetector(
                                onTap: () => _showPlanDetails(plan),
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: const Color(0xFFE2E8F0)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF002E6E).withValues(alpha: 0.02),
                                        blurRadius: 6,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '₹${plan.amount.toStringAsFixed(0)}',
                                            style: const TextStyle(
                                              fontFamily: 'Geist Sans',
                                              fontSize: 22.0,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF1F1F1F),
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF3F37C9).withValues(alpha: 0.08),
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              plan.category,
                                              style: const TextStyle(
                                                fontFamily: 'Geist Sans',
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF3F37C9),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        children: [
                                          Row(
                                            children: [
                                              const Icon(Icons.calendar_today_rounded, size: 13, color: Color(0xFF3F37C9)),
                                              const SizedBox(width: 4),
                                              Text(
                                                'Validity: ${plan.validity}',
                                                style: const TextStyle(fontFamily: 'Geist Sans', fontSize: 12, color: Color(0xFF64748B)),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(width: 20),
                                          Row(
                                            children: [
                                              const Icon(Icons.swap_vert_rounded, size: 14, color: Color(0xFF3F37C9)),
                                              const SizedBox(width: 4),
                                              Text(
                                                'Data: ${plan.data}',
                                                style: const TextStyle(fontFamily: 'Geist Sans', fontSize: 12, color: Color(0xFF64748B)),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        plan.description,
                                        style: const TextStyle(
                                          fontFamily: 'Geist Sans',
                                          fontSize: 12.0,
                                          color: Color(0xFF1F1F1F),
                                        ),
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
      ),
    );
  }
}
