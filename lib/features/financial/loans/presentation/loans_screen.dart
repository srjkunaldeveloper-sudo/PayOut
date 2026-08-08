import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/widgets.dart';
import 'package:payout/features/financial/loans/presentation/financial_success_screen.dart';
import 'package:payout/features/financial/shared/models/financial_models.dart';
import 'package:payout/features/financial/shared/repositories/financial_repository.dart';
import 'package:payout/features/financial/shared/services/financial_service.dart';
import 'package:payout/features/financial/shared/validators/financial_validator.dart';
import 'package:payout/features/user/presentation/kyc_flow_screen.dart';
import 'package:payout/features/user/repositories/user_repository.dart';

class LoansScreen extends StatefulWidget {
  const LoansScreen({super.key});

  @override
  State<LoansScreen> createState() => _LoansScreenState();
}

class _LoansScreenState extends State<LoansScreen> {
  final FinancialRepository _financialRepository = MockFinancialRepository();
  final UserRepository _userRepository = MockUserRepository();

  List<LoanModel> _loans = [];
  bool _isLoading = true;
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    _loadLoans();
  }

  Future<void> _loadLoans() async {
    final list = await _financialRepository.getLoans();
    if (mounted) {
      setState(() {
        _loans = list;
        _isLoading = false;
      });
    }
  }

  List<LoanModel> get _filteredLoans {
    if (_selectedCategory == 'All') return _loans;
    return _loans.where((l) => l.category.toLowerCase() == _selectedCategory.toLowerCase()).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        appBar: CustomAppBar(title: 'Loans & Credit'),
        body: Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary))),
      );
    }

    final categories = ['All', 'Personal', 'Business', 'Education', 'Emergency'];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Loans & Credit'),
      body: RefreshIndicator(
        onRefresh: _loadLoans,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppSpacing.s24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Banner
              AppCard(
                color: AppColors.primary,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Pre-Approved Credit Line',
                          style: TextStyle(fontFamily: 'Inter', color: Colors.white70, fontSize: 12),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text('Instant Disbursal', style: TextStyle(fontFamily: 'Inter', color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '₹5,00,000',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Low interest rates starting from 8.95% p.a. • Zero paperwork',
                      style: TextStyle(fontFamily: 'Inter', color: Colors.white70, fontSize: 11),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.s20),

              // Categories Selector
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: categories.map((cat) {
                  final isSelected = _selectedCategory == cat;
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _selectedCategory = cat;
                      });
                    },
                    borderRadius: BorderRadius.circular(AppRadius.circle),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primaryContainer : AppColors.surface,
                        borderRadius: BorderRadius.circular(AppRadius.circle),
                        border: Border.all(color: isSelected ? AppColors.primary : AppColors.divider),
                      ),
                      child: Text(
                        cat,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? AppColors.primary : AppColors.textPrimary,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: AppSpacing.s20),

              // Product Catalog
              const Text('Available Loan Products', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: AppSpacing.s12),
              ..._filteredLoans.map((loan) => _buildLoanCard(loan)),
              const SizedBox(height: AppSpacing.s16),

              // Loan Disclaimer
              Container(
                padding: const EdgeInsets.all(AppSpacing.s12),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(color: AppColors.divider),
                ),
                child: const Text(
                  'Disclaimer: Loan approvals, interest rates, and final sanctioned amounts are simulated for demo purposes based on applicant profile and KYC validation.',
                  style: TextStyle(fontFamily: 'Inter', fontSize: 10, color: AppColors.textSecondary),
                ),
              ),
              const SizedBox(height: AppSpacing.s24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoanCard(LoanModel loan) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.s16),
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    loan.title,
                    style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    loan.category,
                    style: const TextStyle(fontFamily: 'Inter', fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primary),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoCol('Interest Rate', '${loan.interestRate}% p.a.'),
                _buildInfoCol('Max Limit', '₹${(loan.maxAmount / 100000).toStringAsFixed(1)} Lakhs'),
                _buildInfoCol('Max Tenure', '${loan.maxTenureMonths} Months'),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(color: AppColors.divider),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.flash_on_rounded, color: Colors.orange, size: 16),
                    const SizedBox(width: 4),
                    Text(loan.approvalTime, style: const TextStyle(fontFamily: 'Inter', fontSize: 11, color: AppColors.textSecondary)),
                  ],
                ),
                PrimaryButton(
                  text: 'Check Eligibility',
                  width: 140,
                  height: 38,
                  onPressed: () => _openLoanDetailsSheet(loan),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCol(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontFamily: 'Inter', fontSize: 10, color: AppColors.textSecondary)),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 12)),
      ],
    );
  }

  void _openLoanDetailsSheet(LoanModel loan) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoanApplicationFlowScreen(
          loan: loan,
          financialRepository: _financialRepository,
          userRepository: _userRepository,
        ),
      ),
    );
  }
}

// 2. LOAN APPLICATION & ELIGIBILITY FLOW
class LoanApplicationFlowScreen extends StatefulWidget {
  final LoanModel loan;
  final FinancialRepository financialRepository;
  final UserRepository userRepository;

  const LoanApplicationFlowScreen({
    super.key,
    required this.loan,
    required this.financialRepository,
    required this.userRepository,
  });

  @override
  State<LoanApplicationFlowScreen> createState() => _LoanApplicationFlowScreenState();
}

class _LoanApplicationFlowScreenState extends State<LoanApplicationFlowScreen> {
  final _formKey = GlobalKey<FormState>();

  // Form Fields (Empty - No fake prefill)
  final _nameController = TextEditingController();
  final _dobController = TextEditingController();
  final _incomeController = TextEditingController();
  final _panController = TextEditingController();
  final _amountController = TextEditingController();

  String _employmentType = 'Salaried';
  late double _selectedAmount;
  late int _selectedTenure;
  late LoanEmiCalculation _emiCalc;

  bool _isCheckingKyc = true;
  bool _isKycVerified = false;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _selectedAmount = widget.loan.minAmount;
    _selectedTenure = widget.loan.tenureMonths;
    _amountController.text = _selectedAmount.toInt().toString();
    _emiCalc = FinancialService.calculateEMI(
      _selectedAmount,
      widget.loan.interestRate,
      _selectedTenure,
      processingFeePercent: widget.loan.processingFeePercent,
    );
    _checkKYCStatus();
  }

  Future<void> _checkKYCStatus() async {
    final kyc = await widget.userRepository.getKYC();
    if (mounted) {
      setState(() {
        _isKycVerified = kyc.status.toUpperCase() == 'VERIFIED';
        _isCheckingKyc = false;
      });
    }
  }

  void _recalculateEMI() {
    setState(() {
      _emiCalc = FinancialService.calculateEMI(
        _selectedAmount,
        widget.loan.interestRate,
        _selectedTenure,
        processingFeePercent: widget.loan.processingFeePercent,
      );
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dobController.dispose();
    _incomeController.dispose();
    _panController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _onAmountChanged(double val) {
    setState(() {
      _selectedAmount = val;
      _amountController.text = val.toInt().toString();
    });
    _recalculateEMI();
  }

  void _submitApplication() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_isKycVerified) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete your KYC verification first.'), backgroundColor: AppColors.error),
      );
      return;
    }

    _showReviewSheet();
  }

  void _showReviewSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(AppSpacing.s24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.s16),
              const Text('Review Loan Application', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 4),
              const Text('Verify your loan and repayment terms before final submission.', style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.textSecondary)),
              const SizedBox(height: AppSpacing.s16),
              AppCard(
                child: Column(
                  children: [
                    _buildReviewRow('Applicant Name', _nameController.text.trim()),
                    const Divider(color: AppColors.divider),
                    _buildReviewRow('Employment', '$_employmentType (₹${_incomeController.text}/mo)'),
                    const Divider(color: AppColors.divider),
                    _buildReviewRow('PAN Card', _panController.text.toUpperCase().trim()),
                    const Divider(color: AppColors.divider),
                    _buildReviewRow('Loan Amount', '₹${_selectedAmount.toStringAsFixed(2)}'),
                    const Divider(color: AppColors.divider),
                    _buildReviewRow('Tenure', '$_selectedTenure Months'),
                    const Divider(color: AppColors.divider),
                    _buildReviewRow('Interest Rate', '${widget.loan.interestRate}% p.a.'),
                    const Divider(color: AppColors.divider),
                    _buildReviewRow('Monthly EMI', '₹${_emiCalc.monthlyEmi.toStringAsFixed(2)}'),
                    const Divider(color: AppColors.divider),
                    _buildReviewRow('Processing Fee', '₹${_emiCalc.processingFee.toStringAsFixed(2)}'),
                    const Divider(color: AppColors.divider),
                    _buildReviewRow('Total Repayment', '₹${_emiCalc.totalRepayment.toStringAsFixed(2)}'),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.s24),
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  text: _isSubmitting ? 'Submitting...' : 'Confirm & Submit Application',
                  isLoading: _isSubmitting,
                  onPressed: _isSubmitting ? null : () => _executeSubmission(context),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildReviewRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontFamily: 'Inter', color: AppColors.textSecondary, fontSize: 12)),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }

  void _executeSubmission(BuildContext modalContext) async {
    Navigator.pop(modalContext); // close modal

    setState(() {
      _isSubmitting = true;
    });

    final app = LoanApplicationModel(
      id: 'APP-PENDING',
      loanId: widget.loan.id,
      loanTitle: widget.loan.title,
      applicantName: _nameController.text.trim(),
      dob: _dobController.text.trim(),
      employmentType: _employmentType,
      monthlyIncome: double.tryParse(_incomeController.text.trim()) ?? 50000.0,
      panNumber: _panController.text.toUpperCase().trim(),
      requestedAmount: _selectedAmount,
      tenureMonths: _selectedTenure,
      monthlyEmi: _emiCalc.monthlyEmi,
      processingFee: _emiCalc.processingFee,
      totalRepayment: _emiCalc.totalRepayment,
      status: 'PENDING',
      submittedAt: 'Today',
    );

    final result = await widget.financialRepository.submitLoanApplication(app);

    if (!mounted) return;
    setState(() {
      _isSubmitting = false;
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => FinancialSuccessScreen(application: result),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isCheckingKyc) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        appBar: CustomAppBar(title: 'Loan Application'),
        body: Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary))),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: widget.loan.title),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.s24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // KYC Gating Banner
                if (!_isKycVerified) ...[
                  AppCard(
                    color: Colors.orange.withValues(alpha: 0.08),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 20),
                            SizedBox(width: 8),
                            Text('KYC Verification Required', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 13, color: Colors.orange)),
                          ],
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'You must complete your KYC verification before applying for credit.',
                          style: TextStyle(fontFamily: 'Inter', fontSize: 11, color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 12),
                        PrimaryButton(
                          text: 'Complete KYC',
                          onPressed: () async {
                            await Navigator.push(context, MaterialPageRoute(builder: (context) => const KYCFlowScreen()));
                            _checkKYCStatus();
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s20),
                ] else ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(AppRadius.xs),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.verified_rounded, color: AppColors.success, size: 16),
                        SizedBox(width: 6),
                        Text('KYC Authenticated ✓', style: TextStyle(fontFamily: 'Inter', fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.success)),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s16),
                ],

                // Live EMI Calculator Card
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Estimated Monthly EMI', style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.textSecondary)),
                          Text('₹${_emiCalc.monthlyEmi.toStringAsFixed(0)} / mo', style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primary)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Interest: ₹${_emiCalc.totalInterest.toStringAsFixed(0)}', style: const TextStyle(fontFamily: 'Inter', fontSize: 11, color: AppColors.textSecondary)),
                          Text('Total: ₹${_emiCalc.totalRepayment.toStringAsFixed(0)}', style: const TextStyle(fontFamily: 'Inter', fontSize: 11, color: AppColors.textSecondary)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.s24),

                // Amount Slider
                Text('Loan Amount: ₹${_selectedAmount.toInt()}', style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 13)),
                Slider(
                  value: _selectedAmount,
                  min: widget.loan.minAmount,
                  max: widget.loan.maxAmount,
                  divisions: ((widget.loan.maxAmount - widget.loan.minAmount) / 5000).toInt().clamp(1, 100),
                  activeColor: AppColors.primary,
                  onChanged: _onAmountChanged,
                ),
                const SizedBox(height: AppSpacing.s12),

                // Tenure Slider
                Text('Repayment Tenure: $_selectedTenure Months', style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 13)),
                Slider(
                  value: _selectedTenure.toDouble(),
                  min: widget.loan.minTenureMonths.toDouble(),
                  max: widget.loan.maxTenureMonths.toDouble(),
                  divisions: (widget.loan.maxTenureMonths - widget.loan.minTenureMonths),
                  activeColor: AppColors.primary,
                  onChanged: (val) {
                    setState(() {
                      _selectedTenure = val.toInt();
                    });
                    _recalculateEMI();
                  },
                ),
                const SizedBox(height: AppSpacing.s20),

                // Applicant Form
                const Text('Applicant Details', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: AppSpacing.s12),

                AppTextField(
                  controller: _nameController,
                  labelText: 'Full Name',
                  hintText: 'Enter your name as per PAN',
                  prefix: const Icon(Icons.person_outline_rounded, size: 20),
                  validator: (v) {
                    final res = FinancialValidator.validateName(v ?? '');
                    return res.isValid ? null : res.errorMessage;
                  },
                ),
                const SizedBox(height: AppSpacing.s12),

                AppTextField(
                  controller: _dobController,
                  labelText: 'Date of Birth (DD/MM/YYYY)',
                  hintText: '15/08/1995',
                  prefix: const Icon(Icons.cake_outlined, size: 20),
                  validator: (v) {
                    final res = FinancialValidator.validateDOB(v ?? '');
                    return res.isValid ? null : res.errorMessage;
                  },
                ),
                const SizedBox(height: AppSpacing.s12),

                DropdownButtonFormField<String>(
                  initialValue: _employmentType,
                  items: const [
                    DropdownMenuItem(value: 'Salaried', child: Text('Salaried Employee', style: TextStyle(fontFamily: 'Inter', fontSize: 13))),
                    DropdownMenuItem(value: 'Self-Employed', child: Text('Self-Employed Professional', style: TextStyle(fontFamily: 'Inter', fontSize: 13))),
                    DropdownMenuItem(value: 'Business', child: Text('Business Owner / MSME', style: TextStyle(fontFamily: 'Inter', fontSize: 13))),
                  ],
                  onChanged: (val) {
                    if (val != null) setState(() => _employmentType = val);
                  },
                  decoration: InputDecoration(
                    labelText: 'Employment Type',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
                  ),
                ),
                const SizedBox(height: AppSpacing.s12),

                AppTextField(
                  controller: _incomeController,
                  labelText: 'Monthly Income (₹)',
                  hintText: 'e.g. 50000',
                  keyboardType: TextInputType.number,
                  prefix: const Icon(Icons.currency_rupee_rounded, size: 20),
                  validator: (v) {
                    final res = FinancialValidator.validateMonthlyIncome(v ?? '');
                    return res.isValid ? null : res.errorMessage;
                  },
                ),
                const SizedBox(height: AppSpacing.s12),

                AppTextField(
                  controller: _panController,
                  labelText: 'PAN Card Number',
                  hintText: 'e.g. ABCDE1234F',
                  prefix: const Icon(Icons.credit_card_rounded, size: 20),
                  validator: (v) {
                    final res = FinancialValidator.validatePAN(v ?? '');
                    return res.isValid ? null : res.errorMessage;
                  },
                ),
                const SizedBox(height: AppSpacing.s28),

                // Submit CTA
                SizedBox(
                  width: double.infinity,
                  child: PrimaryButton(
                    text: 'Review Application',
                    isLoading: _isSubmitting,
                    onPressed: _isSubmitting ? null : _submitApplication,
                  ),
                ),
                const SizedBox(height: AppSpacing.s24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
