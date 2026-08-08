import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/widgets.dart';
import 'package:payout/features/financial/shared/models/financial_models.dart';
import 'package:payout/features/financial/shared/repositories/financial_repository.dart';
import 'package:payout/features/financial/shared/validators/financial_validator.dart';
import 'package:payout/features/payments/presentation/mpin_verification_screen.dart';

class InvestmentsScreen extends StatefulWidget {
  const InvestmentsScreen({super.key});

  @override
  State<InvestmentsScreen> createState() => _InvestmentsScreenState();
}

class _InvestmentsScreenState extends State<InvestmentsScreen> {
  final FinancialRepository _financialRepository = MockFinancialRepository();

  PortfolioModel? _portfolio;
  List<InvestmentModel> _investments = [];
  bool _isLoading = true;
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final port = await _financialRepository.getPortfolio();
    final funds = await _financialRepository.getInvestments();
    if (mounted) {
      setState(() {
        _portfolio = port;
        _investments = funds;
        _isLoading = false;
      });
    }
  }

  List<InvestmentModel> get _filteredInvestments {
    if (_selectedCategory == 'All') return _investments;
    return _investments.where((i) => i.category.toLowerCase() == _selectedCategory.toLowerCase() || i.type.toLowerCase() == _selectedCategory.toLowerCase()).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _portfolio == null) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        appBar: CustomAppBar(title: 'Wealth & Investments'),
        body: Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary))),
      );
    }

    final port = _portfolio!;
    final categories = ['All', 'Large Cap', 'Small Cap', 'Gold', 'Debt'];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Wealth & Investments'),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppSpacing.s24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Portfolio Card
              AppCard(
                color: AppColors.primary,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total Portfolio Value', style: TextStyle(fontFamily: 'Inter', color: Colors.white70, fontSize: 12)),
                        Text('Live Holdings', style: TextStyle(fontFamily: 'Inter', color: Colors.white70, fontSize: 10)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '₹${port.currentValue.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Invested', style: TextStyle(fontFamily: 'Inter', color: Colors.white70, fontSize: 10)),
                            const SizedBox(height: 2),
                            Text('₹${port.totalInvested.toStringAsFixed(0)}', style: const TextStyle(fontFamily: 'Inter', color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Total Returns', style: TextStyle(fontFamily: 'Inter', color: Colors.white70, fontSize: 10)),
                            const SizedBox(height: 2),
                            Text('+₹${port.returnsValue.toStringAsFixed(0)} (${port.returnPercentage.toStringAsFixed(1)}%)', style: const TextStyle(fontFamily: 'Inter', color: Color(0xFF69F0AE), fontWeight: FontWeight.bold, fontSize: 13)),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Holdings', style: TextStyle(fontFamily: 'Inter', color: Colors.white70, fontSize: 10)),
                            const SizedBox(height: 2),
                            Text('${port.holdings.length} Funds', style: const TextStyle(fontFamily: 'Inter', color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.s20),

              // 2. Active Holdings List
              if (port.holdings.isNotEmpty) ...[
                const Text('My Active Holdings', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: AppSpacing.s12),
                ...port.holdings.map((h) => Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: AppCard(
                        padding: const EdgeInsets.all(AppSpacing.s12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(h.fundName, style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 13)),
                                  const SizedBox(height: 2),
                                  Text('${h.category} • Invested: ₹${h.investedAmount.toStringAsFixed(0)}', style: const TextStyle(fontFamily: 'Inter', fontSize: 11, color: AppColors.textSecondary)),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('₹${h.currentValue.toStringAsFixed(0)}', style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 13)),
                                Text('+${h.returnPercentage.toStringAsFixed(1)}%', style: const TextStyle(fontFamily: 'Inter', fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.success)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )),
                const SizedBox(height: AppSpacing.s20),
              ],

              // 3. Category Filter
              const Text('Explore Funds & Assets', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: AppSpacing.s12),
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
              const SizedBox(height: AppSpacing.s16),

              // 4. Fund Catalog List
              ..._filteredInvestments.map((fund) => _buildFundCard(fund)),
              const SizedBox(height: AppSpacing.s16),

              // Regulatory Risk Disclaimer
              Container(
                padding: const EdgeInsets.all(AppSpacing.s12),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(color: AppColors.divider),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline_rounded, size: 16, color: AppColors.textSecondary),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Important: Mutual fund investments are subject to market risks. 3Y returns shown are indicative and historical. Read all scheme related documents carefully before investing.',
                        style: TextStyle(fontFamily: 'Inter', fontSize: 10, color: AppColors.textSecondary),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.s24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFundCard(InvestmentModel fund) {
    Color riskColor = Colors.green;
    if (fund.riskLevel == 'High' || fund.riskLevel == 'Very High') {
      riskColor = AppColors.error;
    } else if (fund.riskLevel == 'Moderate') {
      riskColor = Colors.orange;
    }

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
                      Text(fund.fundName, style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 14)),
                      Text('${fund.type} • ${fund.category}', style: const TextStyle(fontFamily: 'Inter', fontSize: 11, color: AppColors.textSecondary)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: riskColor.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '${fund.riskLevel} Risk',
                    style: TextStyle(fontFamily: 'Inter', fontSize: 10, fontWeight: FontWeight.bold, color: riskColor),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoCol('NAV', '₹${fund.nav.toStringAsFixed(2)}'),
                _buildInfoCol('3Y Return (Indicative)', '+${fund.returnPercentage}% p.a.'),
                _buildInfoCol('Min. Investment', '₹${fund.minInvestment.toInt()}'),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(color: AppColors.divider),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('SIP Min: ₹${fund.minSip.toInt()} / mo', style: const TextStyle(fontFamily: 'Inter', fontSize: 11, color: AppColors.textSecondary)),
                PrimaryButton(
                  text: 'Invest Now',
                  width: 120,
                  height: 38,
                  onPressed: () => _openFundDetails(fund),
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

  void _openFundDetails(InvestmentModel fund) async {
    final updated = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => InvestmentOrderFlowScreen(
          fund: fund,
          financialRepository: _financialRepository,
        ),
      ),
    );
    if (updated == true) {
      _loadData();
    }
  }
}

// 2. INVESTMENT ORDER & RISK DISCLOSURE FLOW
class InvestmentOrderFlowScreen extends StatefulWidget {
  final InvestmentModel fund;
  final FinancialRepository financialRepository;

  const InvestmentOrderFlowScreen({
    super.key,
    required this.fund,
    required this.financialRepository,
  });

  @override
  State<InvestmentOrderFlowScreen> createState() => _InvestmentOrderFlowScreenState();
}

class _InvestmentOrderFlowScreenState extends State<InvestmentOrderFlowScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();

  String _orderType = 'One-Time'; // One-Time vs Monthly SIP
  int _sipDate = 5;
  bool _riskAcknowledged = false;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _showRiskDisclosureModal() {
    if (!_formKey.currentState!.validate()) return;

    final amount = double.tryParse(_amountController.text.trim()) ?? 0.0;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) {
        return StatefulBuilder(
          builder: (modalContext, setModalState) {
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
                  const Row(
                    children: [
                      Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 22),
                      SizedBox(width: 8),
                      Text('Market Risk Disclosure', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Investments are subject to market volatility. Mutual fund schemes and digital assets do not offer guaranteed returns.',
                    style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: AppSpacing.s16),
                  AppCard(
                    child: Column(
                      children: [
                        _buildReviewRow('Fund Name', widget.fund.fundName),
                        const Divider(color: AppColors.divider),
                        _buildReviewRow('Order Type', _orderType == 'Monthly SIP' ? 'Monthly SIP (Day $_sipDate)' : 'One-Time Lumpsum'),
                        const Divider(color: AppColors.divider),
                        _buildReviewRow('Investment Amount', '₹${amount.toStringAsFixed(2)}', isTotal: true),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s16),
                  Material(
                    color: Colors.transparent,
                    child: CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      activeColor: AppColors.primary,
                      value: _riskAcknowledged,
                      title: const Text(
                        'I understand that investments are subject to market risks and returns shown are illustrative and not guaranteed.',
                        style: TextStyle(fontFamily: 'Inter', fontSize: 11, color: AppColors.textPrimary),
                      ),
                      onChanged: (val) {
                        setModalState(() {
                          _riskAcknowledged = val ?? false;
                        });
                        setState(() {
                          _riskAcknowledged = val ?? false;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s16),
                  SizedBox(
                    width: double.infinity,
                    child: PrimaryButton(
                      text: 'Authorize Payment (6-Digit MPIN)',
                      onPressed: _riskAcknowledged
                          ? () {
                              Navigator.pop(modalContext); // close sheet
                              _navigateToMPINCheckout(amount);
                            }
                          : null,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s12),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _navigateToMPINCheckout(double amount) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentMPINVerificationScreen(
          recipientName: widget.fund.fundName,
          recipientDetail: '$_orderType Investment',
          recipientType: 'Investment',
          amount: amount,
          note: 'Fund Investment ${widget.fund.id}',
          methodId: 'upi_default',
          onSuccess: () async {
            await widget.financialRepository.createInvestmentOrder(
              InvestmentOrderModel(
                id: 'ORD-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
                fundId: widget.fund.id,
                fundName: widget.fund.fundName,
                orderType: _orderType,
                amount: amount,
                sipDate: _orderType == 'Monthly SIP' ? 'Day $_sipDate of every month' : null,
                unitsAllocated: amount / widget.fund.nav,
                transactionId: 'TXN-INV-${DateTime.now().millisecondsSinceEpoch}',
                status: 'CONFIRMED',
                orderedAt: 'Today',
              ),
            );
            if (context.mounted) {
              Navigator.pop(context, true); // return with portfolio update signal
            }
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
          Text(label, style: TextStyle(fontFamily: 'Inter', color: isTotal ? AppColors.textPrimary : AppColors.textSecondary, fontWeight: isTotal ? FontWeight.bold : FontWeight.normal, fontSize: isTotal ? 13 : 12)),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: isTotal ? 14 : 12, color: isTotal ? AppColors.primary : AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final minAmount = _orderType == 'Monthly SIP' ? widget.fund.minSip : widget.fund.minInvestment;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: widget.fund.fundName),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.s24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Fund Details Card
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.fund.fundName, style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 4),
                      Text('${widget.fund.type} • ${widget.fund.category}', style: const TextStyle(fontFamily: 'Inter', fontSize: 11, color: AppColors.textSecondary)),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildDetailCol('NAV', '₹${widget.fund.nav.toStringAsFixed(2)}'),
                          _buildDetailCol('3Y Return', '+${widget.fund.returnPercentage}%'),
                          _buildDetailCol('Expense Ratio', '${widget.fund.expenseRatio}%'),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Divider(color: AppColors.divider),
                      const SizedBox(height: 4),
                      Text('Exit Load: ${widget.fund.exitLoad}', style: const TextStyle(fontFamily: 'Inter', fontSize: 11, color: AppColors.textSecondary)),
                      Text('Lock-in Period: ${widget.fund.lockInPeriod}', style: const TextStyle(fontFamily: 'Inter', fontSize: 11, color: AppColors.textSecondary)),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.s20),

                // Order Type Selector
                const Text('Investment Mode', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: AppSpacing.s8),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => setState(() => _orderType = 'One-Time'),
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: _orderType == 'One-Time' ? AppColors.primaryContainer : AppColors.surface,
                            borderRadius: BorderRadius.circular(AppRadius.md),
                            border: Border.all(color: _orderType == 'One-Time' ? AppColors.primary : AppColors.divider),
                          ),
                          child: Center(
                            child: Text(
                              'One-Time (Lumpsum)',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12,
                                fontWeight: _orderType == 'One-Time' ? FontWeight.bold : FontWeight.normal,
                                color: _orderType == 'One-Time' ? AppColors.primary : AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.s12),
                    Expanded(
                      child: InkWell(
                        onTap: () => setState(() => _orderType = 'Monthly SIP'),
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: _orderType == 'Monthly SIP' ? AppColors.primaryContainer : AppColors.surface,
                            borderRadius: BorderRadius.circular(AppRadius.md),
                            border: Border.all(color: _orderType == 'Monthly SIP' ? AppColors.primary : AppColors.divider),
                          ),
                          child: Center(
                            child: Text(
                              'Monthly SIP',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12,
                                fontWeight: _orderType == 'Monthly SIP' ? FontWeight.bold : FontWeight.normal,
                                color: _orderType == 'Monthly SIP' ? AppColors.primary : AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.s16),

                // SIP Date (if SIP selected)
                if (_orderType == 'Monthly SIP') ...[
                  DropdownButtonFormField<int>(
                    initialValue: _sipDate,
                    items: const [
                      DropdownMenuItem(value: 1, child: Text('1st of every month', style: TextStyle(fontFamily: 'Inter', fontSize: 13))),
                      DropdownMenuItem(value: 5, child: Text('5th of every month', style: TextStyle(fontFamily: 'Inter', fontSize: 13))),
                      DropdownMenuItem(value: 10, child: Text('10th of every month', style: TextStyle(fontFamily: 'Inter', fontSize: 13))),
                      DropdownMenuItem(value: 15, child: Text('15th of every month', style: TextStyle(fontFamily: 'Inter', fontSize: 13))),
                      DropdownMenuItem(value: 20, child: Text('20th of every month', style: TextStyle(fontFamily: 'Inter', fontSize: 13))),
                    ],
                    onChanged: (val) {
                      if (val != null) setState(() => _sipDate = val);
                    },
                    decoration: InputDecoration(
                      labelText: 'Monthly SIP Date',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s16),
                ],

                // Investment Amount Input (Starts Empty)
                AppTextField(
                  controller: _amountController,
                  labelText: _orderType == 'Monthly SIP' ? 'Monthly SIP Amount (₹)' : 'Investment Amount (₹)',
                  hintText: 'Min. ₹${minAmount.toInt()}',
                  keyboardType: TextInputType.number,
                  prefix: const Icon(Icons.currency_rupee_rounded, size: 20),
                  validator: (v) {
                    final amount = double.tryParse(v ?? '') ?? 0.0;
                    final res = FinancialValidator.validateInvestmentAmount(amount, min: minAmount);
                    return res.isValid ? null : res.errorMessage;
                  },
                ),
                const SizedBox(height: AppSpacing.s28),

                // Continue CTA
                SizedBox(
                  width: double.infinity,
                  child: PrimaryButton(
                    text: 'Continue to Risk Acknowledgement',
                    onPressed: _showRiskDisclosureModal,
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

  Widget _buildDetailCol(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontFamily: 'Inter', fontSize: 10, color: AppColors.textSecondary)),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 12)),
      ],
    );
  }
}
