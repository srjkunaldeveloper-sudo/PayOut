import 'package:flutter/material.dart';
import 'package:payout/core/widgets/widgets.dart';
import 'package:payout/core/di/app_dependencies.dart';
import 'package:payout/features/bills/models/bill_models.dart';
import 'package:payout/features/bills/repositories/bill_repository.dart';
import 'package:payout/features/bills/presentation/bill_details_screen.dart';

class ConsumerNumberScreen extends StatefulWidget {
  final String categoryName;
  final BillRepository? billRepository;

  const ConsumerNumberScreen({
    super.key,
    required this.categoryName,
    this.billRepository,
  });

  @override
  State<ConsumerNumberScreen> createState() => _ConsumerNumberScreenState();
}

class _ConsumerNumberScreenState extends State<ConsumerNumberScreen> {
  late final BillRepository _billRepository;
  final TextEditingController _consumerController = TextEditingController();

  List<BillerModel> _billers = [];
  BillerModel? _selectedBiller;
  bool _isLoadingBillers = true;
  bool _isFetchingBill = false;
  bool _isValidInput = false;

  @override
  void initState() {
    super.initState();
    _billRepository = widget.billRepository ?? AppDependencies.instance.billRepository;
    _loadBillers();
  }

  @override
  void dispose() {
    _consumerController.dispose();
    super.dispose();
  }

  Future<void> _loadBillers() async {
    final list = await _billRepository.getBillers();
    if (mounted) {
      setState(() {
        _billers = list.where((b) => b.category.toLowerCase() == widget.categoryName.toLowerCase()).toList();
        if (_billers.isNotEmpty) {
          _selectedBiller = _billers.first;
        }
        _isLoadingBillers = false;
      });
    }
  }

  void _validateInput(String val) {
    setState(() {
      _isValidInput = val.length >= 6 && _selectedBiller != null;
    });
  }

  String _getInputLabel() {
    final cat = widget.categoryName.toLowerCase();
    if (cat.contains('electricity') || cat.contains('water') || cat.contains('broadband')) {
      return 'Consumer Number';
    } else if (cat.contains('dth')) {
      return 'Subscriber ID';
    } else if (cat.contains('lpg')) {
      return 'LPG ID / Registered Mobile';
    } else {
      return 'Customer ID';
    }
  }

  String _getInputHint() {
    final cat = widget.categoryName.toLowerCase();
    if (cat.contains('electricity') || cat.contains('water') || cat.contains('broadband')) {
      return 'Enter 9-digit consumer number';
    } else if (cat.contains('dth')) {
      return 'Enter 10-digit subscriber ID';
    } else if (cat.contains('lpg')) {
      return 'Enter 10-digit registered number or LPG ID';
    } else {
      return 'Enter customer account number';
    }
  }

  void _fetchBill() async {
    if (_selectedBiller == null || _consumerController.text.isEmpty) return;

    setState(() {
      _isFetchingBill = true;
    });

    final bill = await _billRepository.fetchBill(_selectedBiller!.id, _consumerController.text);

    if (!mounted) return;
    setState(() {
      _isFetchingBill = false;
    });

    if (bill != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BillDetailsScreen(bill: bill),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Bill Not Found'),
          content: const Text('No active bill found for the provided details. Please verify and try again.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final label = _getInputLabel();
    final hint = _getInputHint();
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
                Expanded(
                  child: Center(
                    child: Text(
                      widget.categoryName,
                      style: const TextStyle(
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
        child: _isLoadingBillers
            ? const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF3F37C9))))
            : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Form Card
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF002E6E).withValues(alpha: 0.02),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Select Biller / Provider',
                            style: TextStyle(
                              fontFamily: 'Geist Sans',
                              fontSize: 14.5,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1F1F1F),
                            ),
                          ),
                          const SizedBox(height: 10),
                          DropdownButtonFormField<BillerModel>(
                            value: _selectedBiller,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0xFFF8FAFC),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                              ),
                            ),
                            items: _billers.map((biller) {
                              return DropdownMenuItem<BillerModel>(
                                value: biller,
                                child: Text(
                                  biller.name,
                                  style: const TextStyle(
                                    fontFamily: 'Geist Sans',
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF1F1F1F),
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (val) {
                              setState(() {
                                _selectedBiller = val;
                              });
                              _validateInput(_consumerController.text);
                            },
                          ),
                          const SizedBox(height: 18),
                          Text(
                            label,
                            style: const TextStyle(
                              fontFamily: 'Geist Sans',
                              fontSize: 14.5,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1F1F1F),
                            ),
                          ),
                          const SizedBox(height: 10),
                          AppTextField(
                            controller: _consumerController,
                            keyboardType: TextInputType.text,
                            onChanged: _validateInput,
                            labelText: label,
                            hintText: hint,
                            prefix: const Icon(Icons.receipt_long_rounded, color: Color(0xFF3F37C9)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),

                    PrimaryButton(
                      text: 'Fetch Bill',
                      height: 52,
                      isLoading: _isFetchingBill,
                      onPressed: _isValidInput ? _fetchBill : null,
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
      ),
    );
  }
}
