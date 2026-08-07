import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/app_card.dart';
import 'package:payout/features/bills/presentation/consumer_number_screen.dart';

class BillsScreen extends StatefulWidget {
  const BillsScreen({super.key});

  @override
  State<BillsScreen> createState() => _BillsScreenState();
}

class _BillsScreenState extends State<BillsScreen> {
  final List<Map<String, dynamic>> _categories = [
    {'name': 'Electricity', 'icon': Icons.lightbulb_rounded, 'color': AppColors.warning},
    {'name': 'Water', 'icon': Icons.water_drop_rounded, 'color': AppColors.primary},
    {'name': 'Gas', 'icon': Icons.local_fire_department_rounded, 'color': AppColors.error},
    {'name': 'Broadband', 'icon': Icons.wifi_rounded, 'color': AppColors.success},
    {'name': 'DTH', 'icon': Icons.tv_rounded, 'color': Colors.purple},
    {'name': 'FASTag', 'icon': Icons.tag_rounded, 'color': Colors.teal},
  ];

  final List<Map<String, dynamic>> _dueBills = [
    {'provider': 'PowerGrid Corp', 'type': 'Electricity', 'due': 'Aug 15, 2026', 'amount': 84.60, 'id': 'EL1098'},
    {'provider': 'Aqua Aqua water', 'type': 'Water', 'due': 'Aug 20, 2026', 'amount': 22.00, 'id': 'WA9821'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Pay Bills'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.s24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Due bills section
            if (_dueBills.isNotEmpty) ...[
              const Text(
                'Due Bills',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.s12),
              ..._dueBills.map((bill) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.s12),
                  child: AppCard(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              bill['provider'],
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0,
                              ),
                            ),
                            Text(
                              'Due by ${bill['due']}',
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12.0,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              '\$${bill['amount'].toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                                color: AppColors.error,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.s12),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ConsumerNumberScreen(
                                      categoryName: bill['type'],
                                    ),
                                  ),
                                );
                              },
                              style: TextButton.styleFrom(
                                backgroundColor: AppColors.primaryLight,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Pay',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
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
            ],
            const Text(
              'Select Bill Utility',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.s16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _categories.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.9,
              ),
              itemBuilder: (context, index) {
                final cat = _categories[index];
                return AppCard(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ConsumerNumberScreen(
                          categoryName: cat['name']!,
                        ),
                      ),
                    );
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(cat['icon'], color: cat['color'], size: 28),
                      const SizedBox(height: AppSpacing.s8),
                      Text(
                        cat['name'],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12.0,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: AppSpacing.s40),
          ],
        ),
      ),
    );
  }
}
