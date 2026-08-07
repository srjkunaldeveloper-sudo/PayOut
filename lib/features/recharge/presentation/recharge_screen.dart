import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/app_button.dart';
import 'package:payout/core/widgets/app_card.dart';

class RechargeScreen extends StatefulWidget {
  const RechargeScreen({super.key});

  @override
  State<RechargeScreen> createState() => _RechargeScreenState();
}

class _RechargeScreenState extends State<RechargeScreen> {
  final TextEditingController _numberController = TextEditingController();
  String? _selectedOperator;
  String? _selectedPlan;

  final List<String> _operators = ['Verizon', 'AT&T', 'T-Mobile', 'Vodafone'];
  final List<Map<String, String>> _plans = [
    {'price': '\$15.00', 'desc': 'Unlimited Talk & Text + 2GB High Speed Data. 30 Days.'},
    {'price': '\$35.00', 'desc': 'Unlimited Talk, Text & Data + 10GB Hotspot. 30 Days.'},
    {'price': '\$55.00', 'desc': 'Unlimited Premium Data + 50GB Hotspot + Roaming. 30 Days.'},
  ];

  @override
  void dispose() {
    _numberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Mobile Recharge'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.s24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Feature Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.s20),
              decoration: BoxDecoration(
                color: AppColors.primaryLight.withOpacity(0.5),
                borderRadius: BorderRadius.circular(AppRadii.card),
              ),
              child: Row(
                children: [
                  const Icon(Icons.bolt_rounded, color: AppColors.primary, size: 36),
                  const SizedBox(width: AppSpacing.s16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Zero Fees Recharge',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          'Recharge in seconds with direct wallet checkout.',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12.0,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.s32),
            const Text(
              'Mobile Number',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.s8),
            TextField(
              controller: _numberController,
              keyboardType: TextInputType.phone,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
              decoration: const InputDecoration(
                hintText: 'Enter phone number',
                prefixIcon: Icon(Icons.phone_iphone_rounded, color: AppColors.textSecondary),
              ),
            ),
            const SizedBox(height: AppSpacing.s24),
            const Text(
              'Select Operator',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.s12),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: _operators.map((op) {
                final isSel = _selectedOperator == op;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedOperator = op;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSel ? AppColors.primaryLight : AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSel ? AppColors.primary : AppColors.divider,
                        width: 1.0,
                      ),
                    ),
                    child: Text(
                      op,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                        color: isSel ? AppColors.primary : AppColors.textPrimary,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: AppSpacing.s32),
            const Text(
              'Select Plan',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.s12),
            ..._plans.map((plan) {
              final isSel = _selectedPlan == plan['price'];
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.s12),
                child: AppCard(
                  onTap: () {
                    setState(() {
                      _selectedPlan = plan['price']!;
                    });
                  },
                  color: isSel ? AppColors.primaryLight.withOpacity(0.3) : AppColors.surface,
                  border: Border.all(
                    color: isSel ? AppColors.primary : AppColors.divider,
                    width: 1.0,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              plan['price']!,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.s4),
                            Text(
                              plan['desc']!,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12.0,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Radio<String>(
                        value: plan['price']!,
                        groupValue: _selectedPlan,
                        onChanged: (val) {
                          setState(() {
                            _selectedPlan = val;
                          });
                        },
                        activeColor: AppColors.primary,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
            const SizedBox(height: AppSpacing.s32),
            SizedBox(
              width: double.infinity,
              child: AppButton(
                text: 'Proceed to Recharge',
                onPressed: _numberController.text.isNotEmpty && _selectedOperator != null && _selectedPlan != null
                    ? () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Recharge of ${_selectedPlan} successful for ${_numberController.text}.'),
                            backgroundColor: AppColors.success,
                          ),
                        );
                        Navigator.pop(context);
                      }
                    : null,
              ),
            ),
            const SizedBox(height: AppSpacing.s24),
          ],
        ),
      ),
    );
  }
}
