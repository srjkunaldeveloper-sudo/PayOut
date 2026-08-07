import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/widgets.dart';
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
    {'name': 'Mom Cell', 'num': '+91 98765 43210', 'op': 'Jio Prepaid', 'icon': 'J', 'amt': '₹299', 'date': '12 Jul'},
    {'name': 'Sister', 'num': '+91 99112 23344', 'op': 'Airtel Prepaid', 'icon': 'A', 'amt': '₹719', 'date': '08 Jul'},
    {'name': 'Father', 'num': '+91 98100 98100', 'op': 'Vi Prepaid', 'icon': 'V', 'amt': '₹479', 'date': '28 Jun'},
  ];

  final List<Map<String, String>> _favorites = [
    {'name': 'Mom', 'num': '+91 98765 43210', 'label': 'Family'},
    {'name': 'Rahul', 'num': '+91 88001 22334', 'label': 'Friend'},
    {'name': 'Papa', 'num': '+91 98100 98100', 'label': 'Family'},
    {'name': 'Me (Self)', 'num': '+91 70425 98124', 'label': 'Self'},
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24, vertical: AppSpacing.s12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Recharge Hero / Entry Box
            AppCard(
              padding: const EdgeInsets.all(AppSpacing.s20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Enter Mobile Number',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s12),
                  AppTextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    onChanged: _validateInput,
                    labelText: 'Mobile Number',
                    hintText: 'Enter 10-digit mobile number',
                    prefix: const Icon(Icons.phone_iphone_rounded, color: AppColors.primary),
                  ),
                  if (_isValid) ...[
                    const SizedBox(height: AppSpacing.s12),
                    // SIM Auto-detection placeholder
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.primaryContainer,
                        borderRadius: BorderRadius.circular(AppRadius.xs),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.wifi_tethering_rounded, size: 14, color: AppColors.primary),
                          SizedBox(width: 8),
                          Text(
                            'Detected: Jio Prepaid • Delhi NCR',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.s24),

            // 2. Favourite Numbers Horizontal circle avatar lists
            const Text(
              'Favorites',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.s16),
            SizedBox(
              height: 90,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _favorites.length,
                itemBuilder: (context, index) {
                  final person = _favorites[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: AppSpacing.s20),
                    child: GestureDetector(
                      onTap: () => _proceedToOperator(person['num']!),
                      child: Column(
                        children: [
                          CustomAvatar(
                            name: person['name']!,
                            size: 48,
                            backgroundColor: AppColors.surface,
                            textColor: AppColors.primary,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            person['name']!,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 11.0,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            person['label']!,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 9.0,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: AppSpacing.s24),

            // 3. Recent Recharges list
            const Text(
              'Recent Recharges',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.s16),
            ..._recentRecharges.map((item) {
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.s12),
                child: AppCard(
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: AppColors.primaryContainer,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          item['icon']!,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.s16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['name']!,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${item['num']} • ${item['op']}',
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 11,
                                color: AppColors.textSecondary,
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
                            item['amt']!,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            'Paid ${item['date']}',
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 10,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
            const SizedBox(height: AppSpacing.s24),

            // Proceed action button
            PrimaryButton(
              text: 'Proceed to Operators',
              onPressed: _isValid ? () => _proceedToOperator(_phoneController.text) : null,
            ),
          ],
        ),
      ),
    );
  }
}
