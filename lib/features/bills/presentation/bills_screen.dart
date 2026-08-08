import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/widgets.dart';
import 'package:payout/features/bills/presentation/consumer_number_screen.dart';
import 'package:payout/features/bills/models/bill_models.dart';
import 'package:payout/features/bills/repositories/bill_repository.dart';
import 'package:payout/features/bills/services/bill_service.dart';

import 'package:payout/features/transactions/repositories/transaction_repository.dart';
import 'package:payout/features/bills/presentation/bill_details_screen.dart';

class BillsScreen extends StatefulWidget {
  const BillsScreen({super.key});

  @override
  State<BillsScreen> createState() => _BillsScreenState();
}

class _BillsScreenState extends State<BillsScreen> {
  final BillRepository _billRepository = MockBillRepository(MockTransactionRepository());

  List<BillModel> _dueBills = [];
  bool _isLoading = true;

  final List<Map<String, dynamic>> _categories = [
    {'name': 'Electricity', 'icon': Icons.lightbulb_rounded, 'color': AppColors.warning, 'status': 'Pending'},
    {'name': 'Water', 'icon': Icons.water_drop_rounded, 'color': AppColors.primary, 'status': 'No Due'},
    {'name': 'DTH', 'icon': Icons.tv_rounded, 'color': Colors.purple, 'status': 'Expiring soon'},
    {'name': 'LPG', 'icon': Icons.local_fire_department_rounded, 'color': AppColors.error, 'status': 'Book now'},
    {'name': 'Broadband', 'icon': Icons.wifi_rounded, 'color': AppColors.success, 'status': 'No Due'},
    {'name': 'Mobile Postpaid', 'icon': Icons.phone_android_rounded, 'color': Colors.indigo, 'status': 'View bill'},
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });
    final list = await _billRepository.getDueBills();
    if (mounted) {
      setState(() {
        _dueBills = list;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double totalOutstanding = BillService.calculateTotalOutstanding(_dueBills);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Bills & Utilities'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24, vertical: AppSpacing.s12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Total Outstanding Card
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
                  Text(
                    '₹${totalOutstanding.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${_dueBills.length} Bills Pending',
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 11,
                          color: AppColors.primaryContainer,
                        ),
                      ),
                      const Text(
                        'Next Due: Aug 18',
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
            if (_isLoading)
              const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary)))
            else if (_dueBills.isNotEmpty) ...[
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
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BillDetailsScreen(
                            bill: bill,
                          ),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              bill.billerName,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                              ),
                            ),
                            Text(
                              'Due by ${bill.dueDate}',
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
                              '₹${bill.amount.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.s16),
                            const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textSecondary),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ],
            const SizedBox(height: AppSpacing.s24),

            // 3. Saved Billers List
            const Text(
              'Saved Billers',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.s16),
            Column(
              children: [
                Padding(
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
                          child: const Text(
                            'B',
                            style: TextStyle(
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
                            children: const [
                              Text(
                                'BESCOM Electricity',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Cons. ID: 542019382',
                                style: TextStyle(
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
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.s24),

            // 4. Utility Categories Grid
            const Text(
              'Utility Categories',
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
                crossAxisSpacing: AppSpacing.s16,
                mainAxisSpacing: AppSpacing.s16,
                childAspectRatio: 0.85,
              ),
              itemBuilder: (context, index) {
                final cat = _categories[index];
                return AppCard(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ConsumerNumberScreen(categoryName: cat['name'] as String),
                      ),
                    );
                  },
                  padding: const EdgeInsets.all(AppSpacing.s8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.s12),
                        decoration: BoxDecoration(
                          color: (cat['color'] as Color).withOpacity(0.08),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(cat['icon'] as IconData, color: cat['color'] as Color, size: 24),
                      ),
                      const SizedBox(height: AppSpacing.s12),
                      Text(
                        cat['name'] as String,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 10.0,
                          fontWeight: FontWeight.bold,
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
