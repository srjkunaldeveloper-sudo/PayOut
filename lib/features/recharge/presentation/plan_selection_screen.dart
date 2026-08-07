import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/widgets.dart';
import 'package:payout/features/recharge/presentation/review_recharge_screen.dart';

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
  int _activeCategory = 0;
  final List<String> _categories = ['Recommended', 'Unlimited Pack', 'Data Booster', 'OTT Benefits'];

  final List<Map<String, dynamic>> _plans = [
    {
      'price': 299.00,
      'validity': '28 Days',
      'data': '2.0 GB/day',
      'desc': 'Unlimited Voice Calls + 100 SMS/day + Free JioCinema access.',
      'tag': 'Recommended'
    },
    {
      'price': 719.00,
      'validity': '84 Days',
      'data': '2.0 GB/day',
      'desc': 'Unlimited Calls + 100 SMS/day + Disney+ Hotstar subscription.',
      'tag': 'Best Seller'
    },
    {
      'price': 239.00,
      'validity': '28 Days',
      'data': '1.5 GB/day',
      'desc': 'Unlimited Calls + 100 SMS/day. Standard validity pack.',
      'tag': 'Saver pack'
    },
    {
      'price': 15.00,
      'validity': 'Active Plan',
      'data': '1.0 GB Pack',
      'desc': 'High-speed data booster. Valid until existing plan duration.',
      'tag': 'Data Addon'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Select Plan'),
      body: Column(
        children: [
          // 1. Mobile & Operator header
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

          // 2. Category selection filters
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

          // 3. Recommended plans list
          Expanded(
            child: ListView.builder(
              itemCount: _plans.length,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24),
              itemBuilder: (context, index) {
                final plan = _plans[index];
                final double price = plan['price'];
                final String validity = plan['validity'];
                final String data = plan['data'];
                final String desc = plan['desc'];
                final String tag = plan['tag'];

                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.s16),
                  child: AppCard(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReviewRechargeScreen(
                            mobileNumber: widget.mobileNumber,
                            operatorName: widget.operatorName,
                            planPrice: price,
                            planDescription: desc,
                          ),
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '₹${price.toStringAsFixed(0)}',
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
                                tag,
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
                                  'Validity: $validity',
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
                                  'Data: $data',
                                  style: const TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.s12),
                        Text(
                          desc,
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
