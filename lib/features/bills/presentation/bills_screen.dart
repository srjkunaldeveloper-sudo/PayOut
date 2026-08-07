import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/widgets.dart';
import 'package:payout/features/bills/presentation/consumer_number_screen.dart';

class BillsScreen extends StatefulWidget {
  const BillsScreen({super.key});

  @override
  State<BillsScreen> createState() => _BillsScreenState();
}

class _BillsScreenState extends State<BillsScreen> {
  final List<Map<String, dynamic>> _categories = [
    {'name': 'Electricity', 'icon': Icons.lightbulb_rounded, 'color': AppColors.warning, 'status': 'Pending'},
    {'name': 'Water', 'icon': Icons.water_drop_rounded, 'color': AppColors.primary, 'status': 'No Due'},
    {'name': 'Gas Cylinder', 'icon': Icons.local_fire_department_rounded, 'color': AppColors.error, 'status': 'Book now'},
    {'name': 'Broadband', 'icon': Icons.wifi_rounded, 'color': AppColors.success, 'status': 'No Due'},
    {'name': 'DTH Link', 'icon': Icons.tv_rounded, 'color': Colors.purple, 'status': 'Expiring soon'},
    {'name': 'FASTag Pay', 'icon': Icons.tag_rounded, 'color': Colors.teal, 'status': 'Low balance'},
  ];

  final List<Map<String, dynamic>> _dueBills = [
    {'provider': 'Tata Power-Delhi', 'type': 'Electricity', 'due': 'Aug 15', 'amount': 1840.00, 'id': 'EL1098'},
    {'provider': 'Delhi Jal Board', 'type': 'Water', 'due': 'Aug 20', 'amount': 420.00, 'id': 'WA9821'},
  ];

  final List<Map<String, dynamic>> _savedBillers = [
    {'provider': 'Tata Power-Delhi', 'type': 'Electricity', 'num': 'Cons. ID: 1024598124', 'icon': 'T'},
    {'provider': 'Jio Fiber Broadband', 'type': 'Broadband', 'num': 'Acc No: 8241098421', 'icon': 'J'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Bills & Utilities'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24, vertical: AppSpacing.s12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Top Hero Card: Total Outstanding Due
            AppCard(
              color: AppColors.primary,
              borderRadius: AppRadius.xxl,
              padding: const EdgeInsets.all(AppSpacing.s24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Outstanding Due',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13,
                          color: AppColors.primaryContainer,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white12,
                          borderRadius: BorderRadius.circular(AppRadius.xs),
                        ),
                        child: const Text(
                          'AutoPay Active',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '₹2,260.00',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        '2 Bills Pending',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 11,
                          color: AppColors.primaryContainer,
                        ),
                      ),
                      Text(
                        'Next Due: Aug 15',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 11,
                          color: AppColors.primaryContainer,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.s24),

            // 2. Due Bills Section
            if (_dueBills.isNotEmpty) ...[
              const Text(
                'Due Bills',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15.0,
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
                                fontSize: 14.0,
                              ),
                            ),
                            Text(
                              'Due by ${bill['due']}',
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 11.0,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              '₹${bill['amount'].toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0,
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
                                backgroundColor: AppColors.primaryContainer,
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(AppRadius.circle),
                                ),
                              ),
                              child: const Text(
                                'Pay',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 12.0,
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

            // 3. Saved Billers Section
            const Text(
              'Saved Billers',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.s12),
            ..._savedBillers.map((biller) {
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
                          biller['icon']!,
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
                            Row(
                              children: [
                                Text(
                                  biller['provider']!,
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                const Icon(Icons.verified_rounded, color: AppColors.success, size: 14),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${biller['type']} • ${biller['num']}',
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 11,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
            const SizedBox(height: AppSpacing.s24),

            // 4. Categories Grid Section
            const Text(
              'All Bill Categories',
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
              itemCount: _categories.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.9,
              ),
              itemBuilder: (context, index) {
                final cat = _categories[index];
                return AppCard(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ConsumerNumberScreen(categoryName: cat['name']!),
                      ),
                    );
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(cat['icon'] as IconData, color: cat['color'] as Color, size: 24),
                      const SizedBox(height: 8),
                      Text(
                        cat['name'] as String,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 11.0,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        cat['status'] as String,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 8.0,
                          fontWeight: FontWeight.bold,
                          color: cat['status'] == 'Pending' ? AppColors.error : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: AppSpacing.s32),
          ],
        ),
      ),
    );
  }
}
