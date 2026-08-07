import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/app_card.dart';
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
      {'name': 'Verizon', 'icon': Icons.cell_tower_rounded, 'color': AppColors.error},
      {'name': 'AT&T', 'icon': Icons.settings_input_antenna_rounded, 'color': AppColors.primary},
      {'name': 'T-Mobile', 'icon': Icons.network_ping_rounded, 'color': Colors.pink},
      {'name': 'Vodafone', 'icon': Icons.rss_feed_rounded, 'color': Colors.red},
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Select Operator'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.s24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Popular Operators',
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
              itemCount: operators.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.2,
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
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
                          fontSize: 14.0,
                          color: AppColors.textPrimary,
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
