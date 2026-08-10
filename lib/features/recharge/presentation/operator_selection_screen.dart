import 'package:flutter/material.dart';
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
    final canPop = Navigator.of(context).canPop();
    final List<Map<String, dynamic>> operators = [
      {'name': 'Jio Prepaid', 'icon': Icons.flash_on_rounded, 'color': const Color(0xFF0056D2), 'badge': '5G Active'},
      {'name': 'Airtel Prepaid', 'icon': Icons.cell_tower_rounded, 'color': const Color(0xFFE11D48), 'badge': 'Popular'},
      {'name': 'Vi Prepaid', 'icon': Icons.network_check_rounded, 'color': const Color(0xFFEA580C), 'badge': 'Fastest'},
      {'name': 'BSNL Prepaid', 'icon': Icons.signal_cellular_alt_rounded, 'color': const Color(0xFFD97706), 'badge': 'Eco Plan'},
    ];

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
                      'Select Operator',
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              const CustomSearchBar(
                hintText: 'Search operators or circles...',
              ),
              const SizedBox(height: 20),

              const Text(
                'Popular Operators',
                style: TextStyle(
                  fontFamily: 'Geist Sans',
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F1F1F),
                ),
              ),
              const SizedBox(height: 14),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: operators.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 1.15,
                ),
                itemBuilder: (context, index) {
                  final op = operators[index];
                  final color = op['color'] as Color;
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PlanSelectionScreen(
                            mobileNumber: mobileNumber,
                            operatorName: op['name'] as String,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF002E6E).withValues(alpha: 0.02),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(14),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                              decoration: BoxDecoration(
                                color: color.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                op['badge'] as String,
                                style: TextStyle(
                                  fontFamily: 'Geist Sans',
                                  fontSize: 9.0,
                                  fontWeight: FontWeight.bold,
                                  color: color,
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
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: color.withValues(alpha: 0.08),
                                    shape: BoxShape.circle,
                                  ),
                                  alignment: Alignment.center,
                                  child: Icon(
                                    op['icon'] as IconData,
                                    color: color,
                                    size: 22,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  op['name'] as String,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontFamily: 'Geist Sans',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13.5,
                                    color: Color(0xFF1F1F1F),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
