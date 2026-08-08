import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/widgets.dart';
import 'package:payout/features/bills/models/bill_models.dart';
import 'package:payout/features/bills/repositories/bill_repository.dart';
import 'package:payout/features/bills/presentation/bill_details_screen.dart';
import 'package:payout/features/transactions/repositories/transaction_repository.dart';

class ConsumerNumberScreen extends StatefulWidget {
  final String categoryName;

  const ConsumerNumberScreen({
    super.key,
    required this.categoryName,
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
    _billRepository = MockBillRepository(MockTransactionRepository());
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
      // Validate input - must be at least 6 digits/characters
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

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: widget.categoryName),
      body: SafeArea(
        child: _isLoadingBillers
            ? const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary)))
            : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppSpacing.s12),
                    const Text(
                      'Select Biller / Provider',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s12),
                    AppCard(
                      padding: EdgeInsets.zero,
                      child: DropdownButtonFormField<BillerModel>(
                        value: _selectedBiller,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          border: InputBorder.none,
                        ),
                        items: _billers.map((biller) {
                          return DropdownMenuItem<BillerModel>(
                            value: biller,
                            child: Text(
                              biller.name,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textPrimary,
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
                    ),
                    const SizedBox(height: AppSpacing.s24),
                    Text(
                      label,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s12),
                    AppTextField(
                      controller: _consumerController,
                      keyboardType: TextInputType.text,
                      onChanged: _validateInput,
                      labelText: label,
                      hintText: hint,
                      prefix: const Icon(Icons.receipt_long_rounded, color: AppColors.primary),
                    ),
                    const SizedBox(height: AppSpacing.s40),
                    SizedBox(
                      width: double.infinity,
                      child: PrimaryButton(
                        text: 'Fetch Bill',
                        isLoading: _isFetchingBill,
                        onPressed: _isValidInput ? _fetchBill : null,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
