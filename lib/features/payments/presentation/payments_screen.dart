import 'package:flutter/material.dart';
import 'package:payout/core/widgets/widgets.dart';
import 'package:payout/core/di/app_dependencies.dart';
import 'package:payout/features/bank_accounts/presentation/bank_accounts_screen.dart';
import 'package:payout/features/qr/presentation/scan_qr_screen.dart';
import 'package:payout/features/transactions/presentation/transaction_history_screen.dart';
import 'package:payout/features/payments/models/payments_models.dart';
import 'package:payout/features/payments/repositories/payments_repository.dart';
import 'package:payout/features/payments/presentation/amount_entry_screen.dart';
import 'package:payout/features/payments/presentation/receipt_screen.dart';
import 'package:payout/features/payments/services/payments_logger.dart';
import 'package:payout/features/recharge/presentation/recharge_screen.dart';
import 'package:payout/features/bills/presentation/consumer_number_screen.dart';

class PaymentsScreen extends StatefulWidget {
  final PaymentsRepository? paymentsRepository;

  const PaymentsScreen({super.key, this.paymentsRepository});

  @override
  State<PaymentsScreen> createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends State<PaymentsScreen> {
  late final PaymentsRepository _paymentsRepository;

  List<BeneficiaryModel> _beneficiaries = [];
  List<RecentPaymentModel> _recentPayments = [];
  bool _isLoading = true;
  String _searchQuery = '';

  // Selector mode: 'contacts', 'upi', 'bank'
  String _payToMode = 'contacts';

  @override
  void initState() {
    super.initState();
    _paymentsRepository = widget.paymentsRepository ?? AppDependencies.instance.paymentsRepository;
    _loadData();
    PaymentsLogger.logPaymentOpened();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });
    final beneficiaries = await _paymentsRepository.getBeneficiaries();
    final recentPayments = await _paymentsRepository.getRecentPayments();

    if (mounted) {
      setState(() {
        _beneficiaries = beneficiaries;
        _recentPayments = recentPayments;
        _isLoading = false;
      });
    }
  }

  Future<void> _handleSearch(String query) async {
    setState(() {
      _searchQuery = query;
    });
    final filtered = await _paymentsRepository.searchBeneficiaries(query);
    if (mounted) {
      setState(() {
        _beneficiaries = filtered;
      });
    }
  }

  // --- Dialog / Bottom Sheets ---

  // Pay via UPI ID Dialog
  void _showUpiPaymentSheet() {
    final formKey = GlobalKey<FormState>();
    final upiController = TextEditingController();
    bool isResolving = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF8FAFC),
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 20,
                top: 20,
                left: 20,
                right: 20,
              ),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: const Color(0xFFCBD5E1),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Pay via UPI ID',
                      style: TextStyle(
                        fontFamily: 'Geist Sans',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F1F1F),
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Enter payee VPA (UPI ID) e.g. rahul@upi',
                      style: TextStyle(fontFamily: 'Geist Sans', fontSize: 12, color: Color(0xFF64748B)),
                    ),
                    const SizedBox(height: 18),
                    AppTextField(
                      controller: upiController,
                      labelText: 'UPI ID',
                      hintText: 'e.g. username@upi',
                      prefix: const Icon(Icons.alternate_email_rounded, color: Color(0xFF3F37C9)),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) return 'UPI ID is required';
                        if (!value.contains('@') || value.length < 5) return 'Invalid VPA format';
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    PrimaryButton(
                      text: isResolving ? 'Resolving VPA...' : 'Verify & Continue',
                      isLoading: isResolving,
                      onPressed: isResolving
                          ? null
                          : () async {
                              if (formKey.currentState?.validate() ?? false) {
                                setSheetState(() {
                                  isResolving = true;
                                });
                                final upi = upiController.text.trim();
                                final isVerified = await _paymentsRepository.verifyUPI(upi);
                                setSheetState(() {
                                  isResolving = false;
                                });

                                if (!mounted) return;
                                if (isVerified) {
                                  Navigator.pop(sheetContext);
                                  Navigator.push(
                                    sheetContext,
                                    MaterialPageRoute(
                                      builder: (context) => AmountEntryScreen(
                                        recipientName: 'Verified Payee (${upi.split('@')[0]})',
                                        recipientDetail: upi,
                                        recipientType: 'UPI',
                                      ),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(sheetContext).showSnackBar(
                                    const SnackBar(
                                      content: Text('UPI ID resolution failed. Please try a different VPA.'),
                                      backgroundColor: Color(0xFFEF4444),
                                    ),
                                  );
                                }
                              }
                            },
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Pay via Bank Account Details Form
  void _showBankPaymentSheet() {
    final formKey = GlobalKey<FormState>();
    final holderController = TextEditingController();
    final numberController = TextEditingController();
    final confirmController = TextEditingController();
    final ifscController = TextEditingController();
    String selectedBank = 'HDFC Bank';
    bool isVerifying = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF8FAFC),
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 20,
                top: 20,
                left: 20,
                right: 20,
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: const Color(0xFFCBD5E1),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      const Text(
                        'Pay via Bank Account',
                        style: TextStyle(
                          fontFamily: 'Geist Sans',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F1F1F),
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Enter payee bank details to transfer funds directly.',
                        style: TextStyle(fontFamily: 'Geist Sans', fontSize: 12, color: Color(0xFF64748B)),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: DropdownButtonFormField<String>(
                          initialValue: selectedBank,
                          decoration: const InputDecoration(
                            labelText: 'Bank',
                            border: InputBorder.none,
                          ),
                          items: ['SBI', 'HDFC Bank', 'ICICI Bank', 'Axis Bank']
                              .map((b) => DropdownMenuItem(value: b, child: Text(b, style: const TextStyle(fontFamily: 'Geist Sans', fontSize: 14))))
                              .toList(),
                          onChanged: (val) {
                            if (val != null) selectedBank = val;
                          },
                        ),
                      ),
                      const SizedBox(height: 12),
                      AppTextField(
                        controller: holderController,
                        labelText: 'Account Holder Name',
                        hintText: 'Enter name',
                        prefix: const Icon(Icons.person_outline_rounded, color: Color(0xFF3F37C9)),
                        validator: (value) => value == null || value.trim().isEmpty ? 'Name is required' : null,
                      ),
                      const SizedBox(height: 12),
                      AppTextField(
                        controller: numberController,
                        keyboardType: TextInputType.number,
                        labelText: 'Account Number',
                        hintText: 'Enter number',
                        prefix: const Icon(Icons.pin_outlined, color: Color(0xFF3F37C9)),
                        validator: (value) => value == null || value.trim().isEmpty ? 'Number is required' : null,
                      ),
                      const SizedBox(height: 12),
                      AppTextField(
                        controller: confirmController,
                        keyboardType: TextInputType.number,
                        labelText: 'Confirm Account Number',
                        hintText: 'Re-enter number',
                        prefix: const Icon(Icons.check_circle_outline_rounded, color: Color(0xFF3F37C9)),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) return 'Confirmation is required';
                          if (value != numberController.text) return 'Account numbers do not match';
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      AppTextField(
                        controller: ifscController,
                        labelText: 'IFSC Code',
                        hintText: 'e.g. HDFC0000124',
                        prefix: const Icon(Icons.account_balance_rounded, color: Color(0xFF3F37C9)),
                        validator: (value) => value == null || value.trim().isEmpty ? 'IFSC is required' : null,
                      ),
                      const SizedBox(height: 22),
                      PrimaryButton(
                        text: isVerifying ? 'Verifying Account...' : 'Continue',
                        isLoading: isVerifying,
                        onPressed: isVerifying
                            ? null
                            : () async {
                                if (formKey.currentState?.validate() ?? false) {
                                  setSheetState(() {
                                    isVerifying = true;
                                  });
                                  await Future.delayed(const Duration(milliseconds: 1000));
                                  setSheetState(() {
                                    isVerifying = false;
                                  });

                                  if (!mounted) return;
                                  Navigator.pop(sheetContext);
                                  Navigator.push(
                                    sheetContext,
                                    MaterialPageRoute(
                                      builder: (context) => AmountEntryScreen(
                                        recipientName: holderController.text.trim(),
                                        recipientDetail: 'Savings •••• ${numberController.text.substring(numberController.text.length - 4)}',
                                        recipientType: 'Bank',
                                      ),
                                    ),
                                  );
                                }
                              },
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Add Beneficiary sheet
  void _showAddBeneficiarySheet() {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final upiController = TextEditingController();
    final phoneController = TextEditingController();
    bool isSaving = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF8FAFC),
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 20,
                top: 20,
                left: 20,
                right: 20,
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: const Color(0xFFCBD5E1),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      const Text(
                        'Add Beneficiary',
                        style: TextStyle(
                          fontFamily: 'Geist Sans',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F1F1F),
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Save new recipient credentials for direct future transfers.',
                        style: TextStyle(fontFamily: 'Geist Sans', fontSize: 12, color: Color(0xFF64748B)),
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        controller: nameController,
                        labelText: 'Full Name',
                        hintText: 'Enter name',
                        prefix: const Icon(Icons.person_outline_rounded, color: Color(0xFF3F37C9)),
                        validator: (value) => value == null || value.trim().isEmpty ? 'Name is required' : null,
                      ),
                      const SizedBox(height: 12),
                      AppTextField(
                        controller: upiController,
                        labelText: 'UPI ID',
                        hintText: 'username@upi',
                        prefix: const Icon(Icons.alternate_email_rounded, color: Color(0xFF3F37C9)),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) return 'UPI ID is required';
                          if (!value.contains('@')) return 'Invalid format';
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      AppTextField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        labelText: 'Phone Number',
                        hintText: 'e.g. 9999999999',
                        prefix: const Icon(Icons.phone_outlined, color: Color(0xFF3F37C9)),
                        validator: (value) => value == null || value.trim().length < 10 ? 'Enter valid phone number' : null,
                      ),
                      const SizedBox(height: 22),
                      PrimaryButton(
                        text: isSaving ? 'Saving...' : 'Add Recipient',
                        isLoading: isSaving,
                        onPressed: isSaving
                            ? null
                            : () async {
                                if (formKey.currentState?.validate() ?? false) {
                                  setSheetState(() {
                                    isSaving = true;
                                  });

                                  final b = BeneficiaryModel(
                                    id: 'B-NEW-${DateTime.now().millisecondsSinceEpoch}',
                                    name: nameController.text.trim(),
                                    upiId: upiController.text.trim(),
                                    phone: phoneController.text.trim(),
                                    isFavourite: false,
                                    isVerified: true,
                                  );

                                  final saved = await _paymentsRepository.addBeneficiary(b);
                                  setSheetState(() {
                                    isSaving = false;
                                  });

                                  if (!mounted) return;
                                  if (saved) {
                                    Navigator.pop(sheetContext);
                                    _loadData();
                                    ScaffoldMessenger.of(sheetContext).showSnackBar(
                                      SnackBar(
                                        content: Text('${b.name} added as beneficiary.'),
                                        backgroundColor: const Color(0xFF059669),
                                      ),
                                    );
                                  }
                                }
                              },
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPayToModeSelector() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildModeChip('contacts', 'Contacts', Icons.contacts_rounded),
          const SizedBox(width: 8),
          _buildModeChip('upi', 'UPI ID', Icons.alternate_email_rounded),
          const SizedBox(width: 8),
          _buildModeChip('bank', 'Bank Account', Icons.account_balance_rounded),
        ],
      ),
    );
  }

  Widget _buildModeChip(String id, String label, IconData icon) {
    final isSelected = _payToMode == id;
    return GestureDetector(
      onTap: () {
        setState(() {
          _payToMode = id;
        });
        if (id == 'upi') {
          _showUpiPaymentSheet();
          setState(() {
            _payToMode = 'contacts';
          });
        } else if (id == 'bank') {
          _showBankPaymentSheet();
          setState(() {
            _payToMode = 'contacts';
          });
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
                  colors: [Color(0xFF3F37C9), Color(0xFF2563EB)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: !isSelected ? Colors.white : null,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.transparent : const Color(0xFFE2E8F0),
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF3F37C9).withValues(alpha: 0.15),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: isSelected ? Colors.white : const Color(0xFF3F37C9),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Geist Sans',
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : const Color(0xFF1F1F1F),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.of(context).canPop();

    if (_isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Center(
                child: Text(
                  'Payments Hub',
                  style: const TextStyle(
                    fontFamily: 'Geist Sans',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F1F1F),
                  ),
                ),
              ),
            ),
          ),
        ),
        body: const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF3F37C9)),
          ),
        ),
      );
    }

    final List<Map<String, dynamic>> shortcuts = [
      {'label': 'Scan QR', 'icon': Icons.qr_code_scanner_rounded, 'screen': const ScanQRScreen(), 'color': const Color(0xFF3F37C9)},
      {'label': 'Link Bank', 'icon': Icons.account_balance_rounded, 'screen': const BankAccountsScreen(), 'color': const Color(0xFF2563EB)},
      {'label': 'Add Recipient', 'icon': Icons.person_add_rounded, 'action': _showAddBeneficiarySheet, 'color': const Color(0xFF059669)},
      {'label': 'Self Trans', 'icon': Icons.swap_horiz_rounded, 'action': () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Self-Transfer selected.')),
        );
      }, 'color': const Color(0xFF8B5CF6)},
    ];

    final List<Map<String, dynamic>> utilities = [
      {
        'label': 'Mobile',
        'icon': Icons.phone_android_rounded,
        'color': const Color(0xFF0056D2),
        'screen': const RechargeScreen(),
      },
      {
        'label': 'DTH',
        'icon': Icons.tv_rounded,
        'color': const Color(0xFF8B5CF6),
        'screen': const ConsumerNumberScreen(categoryName: 'DTH'),
      },
      {
        'label': 'Electricity',
        'icon': Icons.lightbulb_rounded,
        'color': const Color(0xFFEAB308),
        'screen': const ConsumerNumberScreen(categoryName: 'Electricity'),
      },
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
                  )
                else
                  const SizedBox(width: 38),
                const Expanded(
                  child: Center(
                    child: Text(
                      'Payments Hub',
                      style: TextStyle(
                        fontFamily: 'Geist Sans',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F1F1F),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 38),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 0. Search Bar
            CustomSearchBar(
              hintText: 'Search contacts or UPI IDs',
              onChanged: _handleSearch,
            ),
            const SizedBox(height: 16),

            // Mode Selector
            _buildPayToModeSelector(),
            const SizedBox(height: 18),

            if (_searchQuery.isNotEmpty) ...[
              const Text(
                'Search Results',
                style: TextStyle(
                  fontFamily: 'Geist Sans',
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F1F1F),
                ),
              ),
              const SizedBox(height: 10),
              Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                clipBehavior: Clip.antiAlias,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _beneficiaries.length,
                    separatorBuilder: (context, index) => const Divider(height: 1, color: Color(0xFFE2E8F0)),
                    itemBuilder: (context, index) {
                      final contact = _beneficiaries[index];
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AmountEntryScreen(
                                recipientName: contact.name,
                                recipientDetail: contact.upiId,
                                recipientType: 'UPI',
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color(0xFF3F37C9).withValues(alpha: 0.08),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  contact.name.isNotEmpty ? contact.name[0].toUpperCase() : 'U',
                                  style: const TextStyle(
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
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          contact.name,
                                          style: const TextStyle(
                                            fontFamily: 'Geist Sans',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            color: Color(0xFF1F1F1F),
                                          ),
                                        ),
                                        if (contact.isVerified) ...[
                                          const SizedBox(width: 6),
                                          const Icon(Icons.verified, size: 14, color: Color(0xFF059669)),
                                        ],
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      contact.upiId,
                                      style: const TextStyle(
                                        fontFamily: 'Geist Sans',
                                        fontSize: 11.5,
                                        color: Color(0xFF64748B),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.arrow_forward_ios_rounded, size: 13, color: Color(0xFF64748B)),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ] else ...[
              // 1. UPI Lite Active Status Card
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF3F37C9).withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFF3F37C9).withValues(alpha: 0.12)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Color(0xFF3F37C9),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.flash_on_rounded, color: Colors.white, size: 16),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'UPI Lite Active',
                            style: TextStyle(
                              fontFamily: 'Geist Sans',
                              fontWeight: FontWeight.bold,
                              fontSize: 13.5,
                              color: Color(0xFF1F1F1F),
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            '₹150.00 balance • PIN-free small payments',
                            style: TextStyle(
                              fontFamily: 'Geist Sans',
                              fontSize: 11.0,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // 2. Hero Scan Banner
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ScanQRScreen()),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
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
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.qr_code_scanner_rounded,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Scan any QR Code',
                              style: TextStyle(
                                fontFamily: 'Geist Sans',
                                fontWeight: FontWeight.bold,
                                fontSize: 17.5,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Instant scans for all merchant/user codes.',
                              style: TextStyle(
                                fontFamily: 'Geist Sans',
                                fontSize: 11.5,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.white70,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 22),

              // 3. Quick Payment Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: shortcuts.map((item) {
                  return GestureDetector(
                    onTap: () {
                      if (item['screen'] != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => item['screen'] as Widget),
                        );
                      } else if (item['action'] != null) {
                        (item['action'] as VoidCallback)();
                      }
                    },
                    child: Column(
                      children: [
                        Container(
                          width: 58,
                          height: 58,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF002E6E).withValues(alpha: 0.025),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(item['icon'] as IconData, color: item['color'] as Color, size: 26),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          item['label'] as String,
                          style: const TextStyle(
                            fontFamily: 'Geist Sans',
                            fontSize: 11.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1F1F1F),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 22),

              // 4. Saved Beneficiaries / Contacts list
              const Text(
                'Pay a Contact',
                style: TextStyle(
                  fontFamily: 'Geist Sans',
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F1F1F),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 96,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _beneficiaries.length,
                  itemBuilder: (context, index) {
                    final contact = _beneficiaries[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AmountEntryScreen(
                                recipientName: contact.name,
                                recipientDetail: contact.upiId,
                                recipientType: 'UPI',
                              ),
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF3F37C9),
                                        Color(0xFF4895EF),
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
                                  child: Text(
                                    contact.name.isNotEmpty ? contact.name[0].toUpperCase() : 'U',
                                    style: const TextStyle(
                                      fontFamily: 'Geist Sans',
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                if (contact.isVerified)
                                  Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF059669),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.check, size: 8, color: Colors.white),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              contact.name.split(' ')[0],
                              style: const TextStyle(
                                fontFamily: 'Geist Sans',
                                fontSize: 11.5,
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
              const SizedBox(height: 18),

              // 4.5 Payment Limits Card
              const Text(
                'Payment Limits',
                style: TextStyle(
                  fontFamily: 'Geist Sans',
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F1F1F),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
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
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'Daily Transfer Limit Used',
                          style: TextStyle(fontFamily: 'Geist Sans', fontSize: 12, color: Color(0xFF64748B)),
                        ),
                        Text(
                          '₹2,000 / ₹1,00,000',
                          style: TextStyle(fontFamily: 'Geist Sans', fontSize: 12.5, fontWeight: FontWeight.bold, color: Color(0xFF1F1F1F)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: const LinearProgressIndicator(
                        value: 0.02,
                        minHeight: 6,
                        backgroundColor: Color(0xFFE2E8F0),
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF059669)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 5. Utility categories
              const Text(
                'Utility Bills & Recharges',
                style: TextStyle(
                  fontFamily: 'Geist Sans',
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F1F1F),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: utilities.map((item) {
                  final color = item['color'] as Color;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Material(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        clipBehavior: Clip.antiAlias,
                        child: InkWell(
                          onTap: () {
                            if (item['screen'] != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => item['screen'] as Widget),
                              );
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
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
                                  child: Icon(item['icon'] as IconData, color: color, size: 28),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  item['label'] as String,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontFamily: 'Geist Sans',
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1F1F1F),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              // Recent Transfers
              const Text(
                'Recent Transfers',
                style: TextStyle(
                  fontFamily: 'Geist Sans',
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F1F1F),
                ),
              ),
              const SizedBox(height: 10),
              Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                clipBehavior: Clip.antiAlias,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _recentPayments.length,
                    separatorBuilder: (context, index) => const Divider(height: 1, color: Color(0xFFE2E8F0)),
                    itemBuilder: (context, index) {
                      final tx = _recentPayments[index];
                      return InkWell(
                        onTap: () async {
                          final receipt = await _paymentsRepository.getReceipt(tx.id);
                          if (context.mounted) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ReceiptScreen(receipt: receipt),
                              ),
                            );
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF3F37C9).withValues(alpha: 0.08),
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  tx.recipientName.isNotEmpty ? tx.recipientName[0].toUpperCase() : 'P',
                                  style: const TextStyle(
                                    fontFamily: 'Geist Sans',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Color(0xFF3F37C9),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      tx.recipientName,
                                      style: const TextStyle(
                                        fontFamily: 'Geist Sans',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Color(0xFF1F1F1F),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${tx.date} • ${tx.status}',
                                      style: const TextStyle(
                                        fontFamily: 'Geist Sans',
                                        fontSize: 11,
                                        color: Color(0xFF64748B),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                '₹${tx.amount.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontFamily: 'Geist Sans',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.5,
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
              ),
              const SizedBox(height: 20),

              // 6. Payment History Shortcut Card
              Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const TransactionHistoryScreen()),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
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
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF3F37C9).withValues(alpha: 0.08),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.history_rounded,
                            color: Color(0xFF3F37C9),
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Payment History',
                                style: TextStyle(
                                  fontFamily: 'Geist Sans',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0,
                                  color: Color(0xFF1F1F1F),
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'View and download transaction statements.',
                                style: TextStyle(
                                  fontFamily: 'Geist Sans',
                                  fontSize: 11.5,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Color(0xFF64748B),
                          size: 14,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 28),
            ],
          ],
        ),
      ),
    );
  }
}
