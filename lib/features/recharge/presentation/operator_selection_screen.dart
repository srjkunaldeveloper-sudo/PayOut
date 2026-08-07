import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/widgets.dart';
import 'package:payout/features/recharge/presentation/plan_selection_screen.dart';

class OperatorSelectionScreen extends StatelessWidget {
  final String mobileNumber;

  const OperatorSelectionScreen({
    super.key,
    required this.mobileNumber,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> operators = [
      {'name': 'Jio Prepaid', 'icon': Icons.flash_on_rounded, 'color': Colors.blue, 'badge': '5G Active'},
      {'name': 'Airtel Prepaid', 'icon': Icons.cell_tower_rounded, 'color': Colors.red, 'badge': 'Popular'},
      {'name': 'Vi Prepaid', 'icon': Icons.network_check_rounded, 'color': Colors.deepOrange, 'badge': 'Fastest'},
      {'name': 'BSNL Prepaid', 'icon': Icons.signal_cellular_alt_rounded, 'color': Colors.orange, 'badge': 'Eco Plan'},
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Select Operator'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24, vertical: AppSpacing.s12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Operator Search Input
            const CustomSearchBar(
              hintText: 'Search operators or circles...',
            ),
            const SizedBox(height: AppSpacing.s24),

            const Text(
              'Popular Operators',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.s16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: operators.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.15,
              ),
              itemBuilder: (context, index) {
                final op = operators[index];
                return AppCard(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlanSelectionScreen(
                          mobileNumber: mobileNumber,
                          operatorName: op['name']!,
                        ),
                      ),
                    );
                  },
                  child: Stack(
                    children: [
                      // Badge overlay
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: (op['color'] as Color).withOpacity(0.08),
                            borderRadius: BorderRadius.circular(AppRadius.xs),
                          ),
                          child: Text(
                            op['badge'] as String,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 8.0,
                              fontWeight: FontWeight.bold,
                              color: op['color'] as Color,
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(AppSpacing.s10),
                              decoration: BoxDecoration(
                                color: (op['color'] as Color).withOpacity(0.08),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(op['icon'] as IconData, color: op['color'] as Color, size: 24),
                            ),
                            const SizedBox(height: AppSpacing.s12),
                            Text(
                              op['name'] as String,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.bold,
                                fontSize: 13.0,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
