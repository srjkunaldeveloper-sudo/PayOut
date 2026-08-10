import 'package:flutter/material.dart';
import 'package:payout/core/di/app_dependencies.dart';
import 'package:payout/features/bills/presentation/consumer_number_screen.dart';
import 'package:payout/features/bills/models/bill_models.dart';
import 'package:payout/features/bills/repositories/bill_repository.dart';
import 'package:payout/features/bills/services/bill_service.dart';
import 'package:payout/features/bills/presentation/bill_details_screen.dart';

class BillsScreen extends StatefulWidget {
  final BillRepository? billRepository;

  const BillsScreen({super.key, this.billRepository});

  @override
  State<BillsScreen> createState() => _BillsScreenState();
}

class _BillsScreenState extends State<BillsScreen> {
  late final BillRepository _billRepository;

  List<BillModel> _dueBills = [];
  bool _isLoading = true;

  final List<Map<String, dynamic>> _categories = [
    {'name': 'Electricity', 'icon': Icons.lightbulb_rounded, 'color': const Color(0xFFEAB308), 'status': 'Pending'},
    {'name': 'Water', 'icon': Icons.water_drop_rounded, 'color': const Color(0xFF00B9F1), 'status': 'No Due'},
    {'name': 'DTH', 'icon': Icons.tv_rounded, 'color': const Color(0xFF8B5CF6), 'status': 'Expiring soon'},
    {'name': 'LPG', 'icon': Icons.local_fire_department_rounded, 'color': const Color(0xFFEF4444), 'status': 'Book now'},
    {'name': 'Broadband', 'icon': Icons.wifi_rounded, 'color': const Color(0xFF10B981), 'status': 'No Due'},
    {'name': 'Mobile Postpaid', 'icon': Icons.phone_android_rounded, 'color': const Color(0xFF3F37C9), 'status': 'View bill'},
  ];

  @override
  void initState() {
    super.initState();
    _billRepository = widget.billRepository ?? AppDependencies.instance.billRepository;
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
    final canPop = Navigator.of(context).canPop();

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
                      'Bills & Utilities',
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
              // 1. Total Outstanding Due Gradient Card
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF3F37C9),
                      Color(0xFF2563EB),
                      Color(0xFF00B9F1),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF3F37C9).withValues(alpha: 0.25),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Outstanding Due',
                          style: TextStyle(
                            fontFamily: 'Geist Sans',
                            fontSize: 13,
                            color: Colors.white70,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'AutoPay Active',
                            style: TextStyle(
                              fontFamily: 'Geist Sans',
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
                        fontFamily: 'Geist Sans',
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${_dueBills.length} Bills Pending',
                          style: const TextStyle(
                            fontFamily: 'Geist Sans',
                            fontSize: 11,
                            color: Colors.white70,
                          ),
                        ),
                        const Text(
                          'Next Due: Aug 18',
                          style: TextStyle(
                            fontFamily: 'Geist Sans',
                            fontSize: 11,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 2. Due Bills Section
              if (_isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF3F37C9))),
                  ),
                )
              else if (_dueBills.isNotEmpty) ...[
                const Text(
                  'Due Bills',
                  style: TextStyle(
                    fontFamily: 'Geist Sans',
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F1F1F),
                  ),
                ),
                const SizedBox(height: 10),
                ..._dueBills.map((bill) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: GestureDetector(
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
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF002E6E).withValues(alpha: 0.02),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  bill.billerName,
                                  style: const TextStyle(
                                    fontFamily: 'Geist Sans',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.0,
                                    color: Color(0xFF1F1F1F),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Due by ${bill.dueDate}',
                                  style: const TextStyle(
                                    fontFamily: 'Geist Sans',
                                    fontSize: 11.0,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  '₹${bill.amount.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                    fontFamily: 'Geist Sans',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.0,
                                    color: Color(0xFF1F1F1F),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                const Icon(Icons.arrow_forward_ios_rounded, size: 13, color: Color(0xFF64748B)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ],
              const SizedBox(height: 18),

              // 3. Saved Billers List
              const Text(
                'Saved Billers',
                style: TextStyle(
                  fontFamily: 'Geist Sans',
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F1F1F),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF002E6E).withValues(alpha: 0.02),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: const Color(0xFF3F37C9).withValues(alpha: 0.08),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'B',
                        style: TextStyle(
                          fontFamily: 'Geist Sans',
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF3F37C9),
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'BESCOM Electricity',
                            style: TextStyle(
                              fontFamily: 'Geist Sans',
                              fontWeight: FontWeight.bold,
                              fontSize: 13.5,
                              color: Color(0xFF1F1F1F),
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Cons. ID: 542019382',
                            style: TextStyle(
                              fontFamily: 'Geist Sans',
                              fontSize: 11,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 4. Utility Categories Grid
              const Text(
                'Utility Categories',
                style: TextStyle(
                  fontFamily: 'Geist Sans',
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F1F1F),
                ),
              ),
              const SizedBox(height: 12),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _categories.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.95,
                ),
                itemBuilder: (context, index) {
                  final cat = _categories[index];
                  final color = cat['color'] as Color;
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ConsumerNumberScreen(categoryName: cat['name'] as String),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF002E6E).withValues(alpha: 0.02),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.08),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(cat['icon'] as IconData, color: color, size: 28),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            cat['name'] as String,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontFamily: 'Geist Sans',
                              fontSize: 11.5,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1F1F1F),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
