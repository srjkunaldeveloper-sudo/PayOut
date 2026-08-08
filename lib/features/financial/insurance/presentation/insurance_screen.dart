import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/widgets.dart';
import 'package:payout/features/financial/shared/models/financial_models.dart';
import 'package:payout/features/financial/shared/repositories/financial_repository.dart';
import 'package:payout/features/financial/shared/services/financial_service.dart';
import 'package:payout/features/financial/shared/validators/financial_validator.dart';
import 'package:payout/features/payments/presentation/mpin_verification_screen.dart';

class InsuranceScreen extends StatefulWidget {
  const InsuranceScreen({super.key});

  @override
  State<InsuranceScreen> createState() => _InsuranceScreenState();
}

class _InsuranceScreenState extends State<InsuranceScreen> {
  final FinancialRepository _financialRepository = MockFinancialRepository();

  List<InsurancePolicyModel> _policies = [];
  bool _isLoading = true;
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    _loadPolicies();
  }

  Future<void> _loadPolicies() async {
    final list = await _financialRepository.getPolicies();
    if (mounted) {
      setState(() {
        _policies = list;
        _isLoading = false;
      });
    }
  }

  List<InsurancePolicyModel> get _filteredPolicies {
    if (_selectedCategory == 'All') return _policies;
    return _policies.where((p) => p.type.toLowerCase() == _selectedCategory.toLowerCase()).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        appBar: CustomAppBar(title: 'Insurance Marketplace'),
        body: Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary))),
      );
    }

    final categories = ['All', 'Health', 'Life', 'Motor', 'Travel'];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Insurance Marketplace'),
      body: RefreshIndicator(
        onRefresh: _loadPolicies,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppSpacing.s24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Banner
              AppCard(
                color: const Color(0xFF0D47A1),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Comprehensive Protection', style: TextStyle(fontFamily: 'Inter', color: Colors.white70, fontSize: 12)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text('100% Paperless', style: TextStyle(fontFamily: 'Inter', color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Protect What Matters',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Health, Life, Vehicle & Travel insurance from India\'s top insurers with instant digital policies.',
                      style: TextStyle(fontFamily: 'Inter', color: Colors.white70, fontSize: 11),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.s20),

              // Categories Chips
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

              // Policy Catalog List
              const Text('Featured Policies', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: AppSpacing.s12),
              ..._filteredPolicies.map((policy) => _buildPolicyCard(policy)),
              const SizedBox(height: AppSpacing.s16),

              // Disclaimer
              Container(
                padding: const EdgeInsets.all(AppSpacing.s12),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(color: AppColors.divider),
                ),
                child: const Text(
                  'Disclaimer: Insurance policies are underwritten by IRDAI registered insurance partners. Premium and terms are simulated for demo and testing purposes.',
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

  Widget _buildPolicyCard(InsurancePolicyModel policy) {
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(policy.name, style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 15)),
                      Text(policy.providerName, style: const TextStyle(fontFamily: 'Inter', fontSize: 11, color: AppColors.textSecondary)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    policy.type,
                    style: const TextStyle(fontFamily: 'Inter', fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primary),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoCol('Sum Insured', '₹${(policy.coverage / 100000).toStringAsFixed(1)} Lakhs'),
                _buildInfoCol('Starting Premium', '₹${policy.premium.toInt()} / yr'),
                _buildInfoCol('Claim Ratio', '${policy.claimSettlementRatio}%'),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(color: AppColors.divider),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Duration: ${policy.duration}', style: const TextStyle(fontFamily: 'Inter', fontSize: 11, color: AppColors.textSecondary)),
                PrimaryButton(
                  text: 'Get Covered',
                  width: 130,
                  height: 38,
                  onPressed: () => _openPolicyDetails(policy),
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

  void _openPolicyDetails(InsurancePolicyModel policy) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InsuranceQuoteFlowScreen(
          policy: policy,
          financialRepository: _financialRepository,
        ),
      ),
    );
  }
}

// 2. INSURANCE DETAILS & QUOTE FLOW
class InsuranceQuoteFlowScreen extends StatefulWidget {
  final InsurancePolicyModel policy;
  final FinancialRepository financialRepository;

  const InsuranceQuoteFlowScreen({
    super.key,
    required this.policy,
    required this.financialRepository,
  });

  @override
  State<InsuranceQuoteFlowScreen> createState() => _InsuranceQuoteFlowScreenState();
}

class _InsuranceQuoteFlowScreenState extends State<InsuranceQuoteFlowScreen> {
  final _formKey = GlobalKey<FormState>();

  // Empty input fields
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  int _memberCount = 1;

  late InsuranceQuoteModel _quote;

  @override
  void initState() {
    super.initState();
    _quote = FinancialService.calculateInsurancePremium(
      policyId: widget.policy.id,
      basePremium: widget.policy.premium,
      age: 28,
      memberCount: _memberCount,
    );
  }

  void _recalculateQuote() {
    final age = int.tryParse(_ageController.text.trim()) ?? 28;
    setState(() {
      _quote = FinancialService.calculateInsurancePremium(
        policyId: widget.policy.id,
        basePremium: widget.policy.premium,
        age: age,
        memberCount: _memberCount,
      );
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _showCheckoutReview() {
    if (!_formKey.currentState!.validate()) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) {
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
              const Text('Review Policy Checkout', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 4),
              const Text('Authorize policy issuance via secure 6-digit MPIN payment.', style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.textSecondary)),
              const SizedBox(height: AppSpacing.s16),
              AppCard(
                child: Column(
                  children: [
                    _buildReviewRow('Insurer', widget.policy.providerName),
                    const Divider(color: AppColors.divider),
                    _buildReviewRow('Policy', widget.policy.name),
                    const Divider(color: AppColors.divider),
                    _buildReviewRow('Proposer Name', _nameController.text.trim()),
                    const Divider(color: AppColors.divider),
                    _buildReviewRow('Age / Members', '${_ageController.text.trim()} Yrs / $_memberCount Covered'),
                    const Divider(color: AppColors.divider),
                    _buildReviewRow('Coverage Amount', '₹${(widget.policy.coverage / 100000).toStringAsFixed(1)} Lakhs'),
                    const Divider(color: AppColors.divider),
                    _buildReviewRow('Duration', widget.policy.duration),
                    const Divider(color: AppColors.divider),
                    _buildReviewRow('Base Premium', '₹${_quote.basePremium.toStringAsFixed(2)}'),
                    const Divider(color: AppColors.divider),
                    _buildReviewRow('GST Tax (18%)', '₹${_quote.taxAmount.toStringAsFixed(2)}'),
                    const Divider(color: AppColors.divider),
                    _buildReviewRow('Total Premium', '₹${_quote.finalPremium.toStringAsFixed(2)}', isTotal: true),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.s24),
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  text: 'Proceed to Pay ₹${_quote.finalPremium.toStringAsFixed(2)}',
                  onPressed: () {
                    Navigator.pop(modalContext); // close sheet
                    _navigateToMPINVerification();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _navigateToMPINVerification() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentMPINVerificationScreen(
          recipientName: widget.policy.providerName,
          recipientDetail: widget.policy.name,
          recipientType: 'Insurance',
          amount: _quote.finalPremium,
          note: 'Insurance Policy ${widget.policy.id}',
          methodId: 'upi_default',
          onSuccess: () async {
            await widget.financialRepository.purchaseInsurance(
              InsurancePurchaseModel(
                id: 'POL-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
                policyId: widget.policy.id,
                policyName: widget.policy.name,
                providerName: widget.policy.providerName,
                applicantName: _nameController.text.trim(),
                age: int.tryParse(_ageController.text.trim()) ?? 28,
                coverageAmount: widget.policy.coverage,
                premiumAmount: _quote.finalPremium,
                duration: widget.policy.duration,
                transactionId: 'TXN-INS-${DateTime.now().millisecondsSinceEpoch}',
                status: 'ACTIVE',
                purchasedAt: 'Today',
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildReviewRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Inter',
              color: isTotal ? AppColors.textPrimary : AppColors.textSecondary,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 13 : 12,
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.bold,
                fontSize: isTotal ? 14 : 12,
                color: isTotal ? AppColors.primary : AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: widget.policy.name),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.s24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Live Premium Summary Card
                AppCard(
                  color: AppColors.primaryContainer.withValues(alpha: 0.4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Estimated Annual Premium', style: TextStyle(fontFamily: 'Inter', fontSize: 11, color: AppColors.textSecondary)),
                          const SizedBox(height: 2),
                          Text('₹${_quote.finalPremium.toStringAsFixed(2)}', style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 20, color: AppColors.primary)),
                          const Text('Includes 18% GST', style: TextStyle(fontFamily: 'Inter', fontSize: 10, color: AppColors.textSecondary)),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.success.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text('Instant Cover', style: TextStyle(fontFamily: 'Inter', fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.success)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.s20),

                // Policy Benefits
                const Text('Key Benefits', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: AppSpacing.s8),
                ...widget.policy.benefits.map((b) => Padding(
                      padding: const EdgeInsets.only(bottom: 6.0),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 16),
                          const SizedBox(width: 8),
                          Expanded(child: Text(b, style: const TextStyle(fontFamily: 'Inter', fontSize: 12))),
                        ],
                      ),
                    )),
                const SizedBox(height: AppSpacing.s20),

                // Applicant Details Form
                const Text('Applicant Information', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: AppSpacing.s12),

                AppTextField(
                  controller: _nameController,
                  labelText: 'Proposer Full Name',
                  hintText: 'Enter name as per Aadhaar / PAN',
                  prefix: const Icon(Icons.person_outline_rounded, size: 20),
                  validator: (v) {
                    final res = FinancialValidator.validateName(v ?? '');
                    return res.isValid ? null : res.errorMessage;
                  },
                ),
                const SizedBox(height: AppSpacing.s12),

                AppTextField(
                  controller: _ageController,
                  labelText: 'Age (Years)',
                  hintText: 'e.g. 28',
                  keyboardType: TextInputType.number,
                  prefix: const Icon(Icons.cake_outlined, size: 20),
                  onChanged: (_) => _recalculateQuote(),
                  validator: (v) {
                    final res = FinancialValidator.validateAge(v ?? '');
                    return res.isValid ? null : res.errorMessage;
                  },
                ),
                const SizedBox(height: AppSpacing.s12),

                if (widget.policy.type == 'Health') ...[
                  DropdownButtonFormField<int>(
                    initialValue: _memberCount,
                    items: const [
                      DropdownMenuItem(value: 1, child: Text('Individual (1 Member)', style: TextStyle(fontFamily: 'Inter', fontSize: 13))),
                      DropdownMenuItem(value: 2, child: Text('Couple (2 Members)', style: TextStyle(fontFamily: 'Inter', fontSize: 13))),
                      DropdownMenuItem(value: 3, child: Text('Family (2 Adults + 1 Child)', style: TextStyle(fontFamily: 'Inter', fontSize: 13))),
                      DropdownMenuItem(value: 4, child: Text('Family (2 Adults + 2 Children)', style: TextStyle(fontFamily: 'Inter', fontSize: 13))),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => _memberCount = val);
                        _recalculateQuote();
                      }
                    },
                    decoration: InputDecoration(
                      labelText: 'Members to Cover',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s12),
                ],
                const SizedBox(height: AppSpacing.s20),

                // Review CTA
                SizedBox(
                  width: double.infinity,
                  child: PrimaryButton(
                    text: 'Review Policy & Continue',
                    onPressed: _showCheckoutReview,
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
