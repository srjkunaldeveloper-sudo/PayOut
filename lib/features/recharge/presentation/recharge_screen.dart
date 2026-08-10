import 'package:flutter/material.dart';
import 'package:payout/core/widgets/widgets.dart';
import 'package:payout/core/di/app_dependencies.dart';
import 'package:payout/features/recharge/presentation/operator_selection_screen.dart';
import 'package:payout/features/recharge/models/recharge_models.dart';
import 'package:payout/features/recharge/repositories/recharge_repository.dart';

class RechargeScreen extends StatefulWidget {
  final RechargeRepository? rechargeRepository;

  const RechargeScreen({super.key, this.rechargeRepository});

  @override
  State<RechargeScreen> createState() => _RechargeScreenState();
}

class _RechargeScreenState extends State<RechargeScreen> {
  late final RechargeRepository _rechargeRepository;
  final TextEditingController _phoneController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  bool _isValid = false;
  List<RecentRechargeModel> _recentRecharges = [];
  bool _isLoading = true;

  final List<Map<String, String>> _favorites = [
    {'name': 'Mom', 'num': '9876543210', 'label': 'Family'},
    {'name': 'Rahul', 'num': '8800122334', 'label': 'Friend'},
    {'name': 'Papa', 'num': '9810098100', 'label': 'Family'},
  ];

  @override
  void initState() {
    super.initState();
    _rechargeRepository = widget.rechargeRepository ?? AppDependencies.instance.rechargeRepository;
    _loadData();
    _focusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });
    final list = await _rechargeRepository.getRecentRecharges();
    if (mounted) {
      setState(() {
        _recentRecharges = list;
        _isLoading = false;
      });
    }
  }

  void _validateInput(String val) {
    setState(() {
      _isValid = val.length == 10 && RegExp(r'^[0-9]+$').hasMatch(val);
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
                      'Mobile Recharge',
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
              // 1. Mobile Number Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _focusNode.hasFocus
                        ? const Color(0xFF3F37C9).withValues(alpha: 0.4)
                        : const Color(0xFFE2E8F0),
                    width: _focusNode.hasFocus ? 1.5 : 1.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _focusNode.hasFocus
                          ? const Color(0xFF3F37C9).withValues(alpha: 0.08)
                          : const Color(0xFF002E6E).withValues(alpha: 0.02),
                      blurRadius: _focusNode.hasFocus ? 10 : 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF3F37C9),
                                Color(0xFF4895EF),
                                Color(0xFF4CC9F0),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF3F37C9).withValues(alpha: 0.2),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.phone_android_rounded,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Enter Mobile Number',
                          style: TextStyle(
                            fontFamily: 'Geist Sans',
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1F1F1F),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    AppTextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      onChanged: _validateInput,
                      labelText: 'Mobile Number',
                      hintText: 'Enter 10-digit mobile number',
                      prefix: const Padding(
                        padding: EdgeInsets.only(left: 12, right: 8),
                        child: Text(
                          '+91',
                          style: TextStyle(
                            fontFamily: 'Geist Sans',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF3F37C9),
                          ),
                        ),
                      ),
                    ),
                    if (_isValid) ...[
                      const SizedBox(height: 10),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF3F37C9).withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: const Color(0xFF3F37C9).withValues(alpha: 0.15),
                          ),
                        ),
                        child: Row(
                          children: const [
                            Icon(
                              Icons.check_circle_rounded,
                              size: 15,
                              color: Color(0xFF3F37C9),
                            ),
                            SizedBox(width: 6),
                            Text(
                              'Detected: Jio Prepaid • Delhi NCR',
                              style: TextStyle(
                                fontFamily: 'Geist Sans',
                                fontSize: 11.5,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF3F37C9),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // 2. Favourite Numbers
              const Text(
                'Favorites',
                style: TextStyle(
                  fontFamily: 'Geist Sans',
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F1F1F),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 78,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _favorites.length,
                  itemBuilder: (context, index) {
                    final person = _favorites[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 14),
                      child: GestureDetector(
                        onTap: () => _proceedToOperator(person['num']!),
                        child: Column(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [
                                    const Color(0xFF3F37C9).withValues(alpha: 0.12),
                                    const Color(0xFF4895EF).withValues(alpha: 0.08),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                border: Border.all(
                                  color: const Color(0xFF3F37C9).withValues(alpha: 0.2),
                                  width: 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF002E6E).withValues(alpha: 0.03),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                person['name']![0],
                                style: const TextStyle(
                                  fontFamily: 'Geist Sans',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF3F37C9),
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              person['name']!,
                              style: const TextStyle(
                                fontFamily: 'Geist Sans',
                                fontSize: 11.0,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1F1F1F),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 14),

              // 3. Recent Recharges list
              const Text(
                'Recent Recharges',
                style: TextStyle(
                  fontFamily: 'Geist Sans',
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F1F1F),
                ),
              ),
              const SizedBox(height: 8),
              _isLoading
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF3F37C9)),
                        ),
                      ),
                    )
                  : _recentRecharges.isEmpty
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              'No recent recharges.',
                              style: TextStyle(
                                fontFamily: 'Geist Sans',
                                color: Color(0xFF64748B),
                              ),
                            ),
                          ),
                        )
                      : Column(
                          children: _recentRecharges.map((item) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: GestureDetector(
                                onTap: () => _proceedToOperator(item.mobileNumber),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(14),
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
                                        child: Text(
                                          item.operatorName.isNotEmpty ? item.operatorName[0] : 'R',
                                          style: const TextStyle(
                                            fontFamily: 'Geist Sans',
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF3F37C9),
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item.mobileNumber,
                                              style: const TextStyle(
                                                fontFamily: 'Geist Sans',
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13.5,
                                                color: Color(0xFF1F1F1F),
                                              ),
                                            ),
                                            Text(
                                              '${item.operatorName} Prepaid • Paid ${item.date}',
                                              style: const TextStyle(
                                                fontFamily: 'Geist Sans',
                                                fontSize: 10.5,
                                                color: Color(0xFF64748B),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF10B981).withValues(alpha: 0.08),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          '₹${item.amount.toStringAsFixed(0)}',
                                          style: const TextStyle(
                                            fontFamily: 'Geist Sans',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12.5,
                                            color: Color(0xFF059669),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
              const SizedBox(height: 18),

              // Proceed action button
              PrimaryButton(
                text: 'Proceed to Operators',
                height: 52,
                iconRight: Icons.arrow_forward_rounded,
                onPressed: _isValid ? () => _proceedToOperator(_phoneController.text) : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
