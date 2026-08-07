import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/app_button.dart';
import 'package:payout/core/widgets/app_card.dart';
import 'package:payout/core/widgets/avatar.dart';
import 'package:payout/features/recharge/presentation/operator_selection_screen.dart';

class RechargeScreen extends StatefulWidget {
  const RechargeScreen({super.key});

  @override
  State<RechargeScreen> createState() => _RechargeScreenState();
}

class _RechargeScreenState extends State<RechargeScreen> {
  final TextEditingController _phoneController = TextEditingController();
  bool _isValid = false;

  final List<Map<String, String>> _recentRecharges = [
    {'name': 'Mom Cell', 'num': '+1 (555) 012-3456', 'op': 'Verizon'},
    {'name': 'Alex Work', 'num': '+1 (555) 019-9888', 'op': 'AT&T'},
    {'name': 'John Doe', 'num': '+1 (555) 018-7766', 'op': 'T-Mobile'},
  ];

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _validateInput(String val) {
    setState(() {
      _isValid = val.length >= 10;
    });
  }

  void _proceedToOperator(String mobileNum) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OperatorSelectionScreen(mobileNumber: mobileNum),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Mobile Recharge'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.s12),
              const Text(
                'Enter Mobile Number',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.s12),
              // Number Input
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                onChanged: _validateInput,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
                decoration: const InputDecoration(
                  hintText: 'Enter 10-digit mobile number',
                  prefixIcon: Icon(Icons.phone_iphone_rounded, color: AppColors.textSecondary),
                ),
              ),
              const SizedBox(height: AppSpacing.s32),
              const Text(
                'Recent Recharges',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.s12),
              Expanded(
                child: ListView.builder(
                  itemCount: _recentRecharges.length,
                  itemBuilder: (context, index) {
                    final item = _recentRecharges[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.s12),
                      child: AppCard(
                        onTap: () => _proceedToOperator(item['num']!),
                        child: Row(
                          children: [
                            CustomAvatar(
                              name: item['name']!,
                              size: 40,
                              backgroundColor: AppColors.primaryLight,
                              textColor: AppColors.primary,
                            ),
                            const SizedBox(width: AppSpacing.s12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['name']!,
                                    style: const TextStyle(
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                  Text(
                                    '${item['num']} • ${item['op']}',
                                    style: const TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 12.0,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 12,
                              color: AppColors.textSecondary,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  text: 'Continue',
                  onPressed: _isValid ? () => _proceedToOperator(_phoneController.text) : null,
                ),
              ),
              const SizedBox(height: AppSpacing.s24),
            ],
          ),
        ),
      ),
    );
  }
}
