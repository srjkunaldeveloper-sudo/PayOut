import 'dart:async';
import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/widgets.dart';
import 'package:payout/features/bank_accounts/models/bank_account_models.dart';
import 'package:payout/features/bank_accounts/services/bank_account_service.dart';

class LinkBankFlow extends StatefulWidget {
  final BankAccountService? bankAccountService;

  const LinkBankFlow({super.key, this.bankAccountService});

  @override
  State<LinkBankFlow> createState() => _LinkBankFlowState();
}

class _LinkBankFlowState extends State<LinkBankFlow> {
  late final BankAccountService _bankAccountService;

  // Navigation step tracking
  int _currentStep = 0;

  // Selected Bank Data
  BankModel? _selectedBank;

  // Step 2 Form Controllers
  final _detailsFormKey = GlobalKey<FormState>();
  final _holderController = TextEditingController();
  final _numberController = TextEditingController();
  final _confirmNumberController = TextEditingController();
  final _ifscController = TextEditingController();

  // Step 4 OTP Tracking
  final TextEditingController _otpController = TextEditingController();
  int _resendTimerSeconds = 30;
  Timer? _timer;

  // Step 6 Debit Card Form Controllers
  final _cardFormKey = GlobalKey<FormState>();
  final _lastDigitsController = TextEditingController();
  final _expiryController = TextEditingController();

  // Search Bank state
  String _searchQuery = '';
  List<BankModel> _popularBanks = [];
  List<BankModel> _allBanks = [];
  bool _isLoadingBanks = true;

  @override
  void initState() {
    super.initState();
    _bankAccountService = widget.bankAccountService ?? BankAccountService();
    _loadBanks();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _holderController.dispose();
    _numberController.dispose();
    _confirmNumberController.dispose();
    _ifscController.dispose();
    _otpController.dispose();
    _lastDigitsController.dispose();
    _expiryController.dispose();
    super.dispose();
  }

  Future<void> _loadBanks() async {
    final banks = await _bankAccountService.getSupportedBanks();
    setState(() {
      _allBanks = banks;
      _popularBanks = banks.take(4).toList();
      _isLoadingBanks = false;
    });
  }

  void _startOtpTimer() {
    setState(() {
      _resendTimerSeconds = 30;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendTimerSeconds > 0) {
        setState(() {
          _resendTimerSeconds--;
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  // --- Step navigation widgets ---

  // STEP 0: Select Bank
  Widget _buildSelectBankStep() {
    final filteredBanks = _allBanks
        .where((b) => b.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select your bank',
            style: TextStyle(fontFamily: 'Geist Sans', fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          const SizedBox(height: AppSpacing.s16),
          CustomSearchBar(
            hintText: 'Search for banks...',
            onChanged: (val) {
              setState(() {
                _searchQuery = val;
              });
            },
          ),
          const SizedBox(height: AppSpacing.s20),
          if (_searchQuery.isEmpty) ...[
            const Text(
              'Popular Banks',
              style: TextStyle(fontFamily: 'Geist Sans', fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.s12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _popularBanks.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 2.2,
              ),
              itemBuilder: (context, index) {
                final bank = _popularBanks[index];
                return OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.divider),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                  onPressed: () {
                    setState(() {
                      _selectedBank = bank;
                      _currentStep = 1;
                    });
                  },
                  child: Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(color: AppColors.primaryContainer, shape: BoxShape.circle),
                        alignment: Alignment.center,
                        child: Text(
                          bank.logoCode.substring(0, 1),
                          style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          bank.name,
                          style: const TextStyle(fontFamily: 'Geist Sans', fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: AppSpacing.s24),
          ],
          const Text(
            'All Banks',
            style: TextStyle(fontFamily: 'Geist Sans', fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.s12),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filteredBanks.length,
            separatorBuilder: (context, index) => const Divider(color: AppColors.divider),
            itemBuilder: (context, index) {
              final bank = filteredBanks[index];
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(color: AppColors.primaryContainer, shape: BoxShape.circle),
                  alignment: Alignment.center,
                  child: Text(
                    bank.logoCode.substring(0, 1),
                    style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                  ),
                ),
                title: Text(
                  bank.name,
                  style: const TextStyle(fontFamily: 'Geist Sans', fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
                onTap: () {
                  setState(() {
                    _selectedBank = bank;
                    _currentStep = 1;
                  });
                },
              );
            },
          ),
        ],
      ),
    );
  }

  // STEP 1: Account Details Form
  Widget _buildAccountDetailsStep() {
    return Form(
      key: _detailsFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(color: AppColors.primaryContainer, shape: BoxShape.circle),
                alignment: Alignment.center,
                child: Text(
                  _selectedBank?.logoCode.substring(0, 1) ?? 'B',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                ),
              ),
              const SizedBox(width: AppSpacing.s12),
              Text(
                _selectedBank?.name ?? 'Bank Details',
                style: const TextStyle(fontFamily: 'Geist Sans', fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s24),
          TextFormField(
            controller: _holderController,
            decoration: const InputDecoration(labelText: 'Account Holder Name', hintText: 'Enter name as in bank records'),
            validator: (value) => value == null || value.trim().isEmpty ? 'Holder name is required' : null,
          ),
          const SizedBox(height: AppSpacing.s16),
          TextFormField(
            controller: _numberController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Account Number', hintText: 'e.g. 5010024125849'),
            validator: (value) {
              if (value == null || value.trim().isEmpty) return 'Account number is required';
              if (value.length < 8) return 'Enter a valid account number';
              return null;
            },
          ),
          const SizedBox(height: AppSpacing.s16),
          TextFormField(
            controller: _confirmNumberController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Confirm Account Number', hintText: 'Re-enter account number'),
            validator: (value) {
              if (value == null || value.trim().isEmpty) return 'Please confirm account number';
              if (value != _numberController.text) return 'Account numbers do not match';
              return null;
            },
          ),
          const SizedBox(height: AppSpacing.s16),
          TextFormField(
            controller: _ifscController,
            textCapitalization: TextCapitalization.characters,
            decoration: const InputDecoration(labelText: 'IFSC Code (Optional)', hintText: 'e.g. HDFC0000124'),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: PrimaryButton(
              text: 'Continue',
              onPressed: () {
                if (_detailsFormKey.currentState?.validate() ?? false) {
                  setState(() {
                    _currentStep = 2; // SIM verification
                  });
                }
              },
            ),
          ),
          const SizedBox(height: AppSpacing.s16),
        ],
      ),
    );
  }

  // STEP 2: SIM Verification
  Widget _buildSIMVerificationStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'SIM Mobile Verification',
          style: TextStyle(fontFamily: 'Geist Sans', fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
        const SizedBox(height: AppSpacing.s8),
        const Text(
          'We need to verify the mobile number linked with your bank account.',
          style: TextStyle(fontFamily: 'Geist Sans', fontSize: 13, color: AppColors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.s32),
        Center(
          child: Column(
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.sim_card_rounded, color: AppColors.primary, size: 36),
              ),
              const SizedBox(height: AppSpacing.s20),
              const Text(
                'Registered Mobile Number',
                style: TextStyle(fontFamily: 'Geist Sans', fontSize: 13, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 4),
              const Text(
                '+91 ******5821',
                style: TextStyle(fontFamily: 'Geist Sans', fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
            ],
          ),
        ),
        const Spacer(),
        SizedBox(
          width: double.infinity,
          child: PrimaryButton(
            text: 'Send Verification OTP',
            onPressed: () async {
              await _bankAccountService.sendOTP('+919999995821');
              _startOtpTimer();
              setState(() {
                _currentStep = 3; // OTP verification
              });
            },
          ),
        ),
        const SizedBox(height: AppSpacing.s16),
      ],
    );
  }

  // STEP 3: OTP Verification
  Widget _buildOTPVerificationStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Enter Verification OTP',
          style: TextStyle(fontFamily: 'Geist Sans', fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
        const SizedBox(height: AppSpacing.s8),
        const Text(
          'Enter the 6-digit OTP code sent to your linked mobile number.',
          style: TextStyle(fontFamily: 'Geist Sans', fontSize: 13, color: AppColors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.s32),
        TextField(
          controller: _otpController,
          keyboardType: TextInputType.number,
          maxLength: 6,
          decoration: const InputDecoration(
            labelText: '6-Digit OTP',
            hintText: 'Enter code',
            counterText: '',
          ),
        ),
        const SizedBox(height: AppSpacing.s16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _resendTimerSeconds > 0
                  ? 'Resend OTP in ${_resendTimerSeconds}s'
                  : 'Didn\'t receive the code?',
              style: const TextStyle(fontFamily: 'Geist Sans', fontSize: 12, color: AppColors.textSecondary),
            ),
            if (_resendTimerSeconds == 0)
              TextButton(
                onPressed: () {
                  _startOtpTimer();
                  _bankAccountService.sendOTP('+919999995821');
                },
                child: const Text('Resend Code', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
          ],
        ),
        const Spacer(),
        SizedBox(
          width: double.infinity,
          child: PrimaryButton(
            text: 'Verify OTP',
            onPressed: () async {
              final code = _otpController.text.trim();
              final isOk = await _bankAccountService.verifyOTP(code);
              if (!mounted) return;
              if (isOk) {
                setState(() {
                  _currentStep = 4; // Verification Method Selection
                });
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please enter a valid 6-digit numeric OTP code.'),
                    backgroundColor: AppColors.error,
                  ),
                );
              }
            },
          ),
        ),
        const SizedBox(height: AppSpacing.s16),
      ],
    );
  }

  // STEP 4: Choose Verification Method
  Widget _buildChooseMethodStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select account verification method',
          style: TextStyle(fontFamily: 'Geist Sans', fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
        const SizedBox(height: AppSpacing.s8),
        const Text(
          'Complete verification to link this bank account for transactions.',
          style: TextStyle(fontFamily: 'Geist Sans', fontSize: 13, color: AppColors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.s24),
        ListTile(
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: AppColors.primary, width: 1.5),
            borderRadius: BorderRadius.circular(12),
          ),
          leading: const Icon(Icons.credit_card_rounded, color: AppColors.primary),
          title: const Text(
            'Debit Card',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: const Text('Verify using card credentials'),
          trailing: const Icon(Icons.check_circle_rounded, color: AppColors.primary),
          onTap: () {
            setState(() {
              _currentStep = 5; // Card entry screen
            });
          },
        ),
        const SizedBox(height: AppSpacing.s16),
        ListTile(
          enabled: false,
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: AppColors.divider),
            borderRadius: BorderRadius.circular(12),
          ),
          leading: const Icon(Icons.star_outline_rounded, color: AppColors.textSecondary),
          title: const Text('Aadhaar OTP'),
          subtitle: const Text('Not supported in demo mode'),
          trailing: const Icon(Icons.lock_rounded, size: 16),
        ),
        const Spacer(),
      ],
    );
  }

  // STEP 5: Card details verification form
  Widget _buildCardVerificationStep() {
    return Form(
      key: _cardFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Verify Debit Card Details',
            style: TextStyle(fontFamily: 'Geist Sans', fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          const SizedBox(height: AppSpacing.s8),
          const Text(
            'DEMO ONLY: Enter mock numbers. Do NOT enter sensitive live bank cards.',
            style: TextStyle(fontFamily: 'Geist Sans', fontSize: 13, color: AppColors.error, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppSpacing.s24),
          TextFormField(
            controller: _lastDigitsController,
            keyboardType: TextInputType.number,
            maxLength: 6,
            decoration: const InputDecoration(
              labelText: 'Last 6 Digits of Debit Card',
              hintText: 'e.g. 123456',
              counterText: '',
            ),
            validator: (value) {
              if (value == null || value.trim().length != 6 || int.tryParse(value) == null) {
                return 'Enter exactly 6 digits';
              }
              return null;
            },
          ),
          const SizedBox(height: AppSpacing.s16),
          TextFormField(
            controller: _expiryController,
            keyboardType: TextInputType.number,
            maxLength: 5,
            decoration: const InputDecoration(
              labelText: 'Expiry Date (MM/YY)',
              hintText: 'e.g. 12/29',
              counterText: '',
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty || !value.contains('/')) {
                return 'Format MM/YY required';
              }
              return null;
            },
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: PrimaryButton(
              text: 'Verify Card & Link Account',
              onPressed: () async {
                if (_cardFormKey.currentState?.validate() ?? false) {
                  final accNo = _numberController.text;
                  final suffix = accNo.length >= 4 ? accNo.substring(accNo.length - 4) : '9999';
                  final acc = LinkedBankAccountModel(
                    id: 'ACC-${_selectedBank?.id ?? 'BANK'}-$suffix',
                    bankName: _selectedBank?.name ?? 'Bank',
                    accountHolderName: _holderController.text,
                    accountNumber: _numberController.text,
                    ifsc: _ifscController.text.isEmpty ? 'IFSC0000000' : _ifscController.text.toUpperCase(),
                    isVerified: true,
                    isDefault: false,
                  );

                  final linkedOk = await _bankAccountService.linkAccount(acc);
                  if (linkedOk) {
                    setState(() {
                      _currentStep = 6; // Success Page
                    });
                  }
                }
              },
            ),
          ),
          const SizedBox(height: AppSpacing.s16),
        ],
      ),
    );
  }

  // STEP 6: Linked Success Page
  Widget _buildSuccessStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: AppSpacing.s40),
        Container(
          width: 80,
          height: 80,
          decoration: const BoxDecoration(
            color: AppColors.success,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check_circle_outline_rounded, color: Colors.white, size: 48),
        ),
        const SizedBox(height: AppSpacing.s24),
        const Text(
          'Bank Account Linked!',
          style: TextStyle(fontFamily: 'Geist Sans', fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
        const SizedBox(height: AppSpacing.s8),
        const Text(
          'Your bank account is verified and ready for payments.',
          style: TextStyle(fontFamily: 'Geist Sans', fontSize: 13, color: AppColors.textSecondary),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.s32),
        AppCard(
          padding: const EdgeInsets.all(AppSpacing.s20),
          child: Column(
            children: [
              _buildSummaryRow('Bank Name', _selectedBank?.name ?? 'Bank'),
              const Divider(color: AppColors.divider),
              _buildSummaryRow('Account Suffix', _numberController.text.length >= 4 ? _numberController.text.substring(_numberController.text.length - 4) : '9999'),
              const Divider(color: AppColors.divider),
              _buildSummaryRow('Holder Name', _holderController.text),
              const Divider(color: AppColors.divider),
              _buildSummaryRow('Status', 'Verified & Active'),
            ],
          ),
        ),
        const Spacer(),
        SizedBox(
          width: double.infinity,
          child: PrimaryButton(
            text: 'Done',
            onPressed: () {
              Navigator.pop(context, true); // Returns true to trigger state reload on screen pop
            },
          ),
        ),
        const SizedBox(height: AppSpacing.s16),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String val) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontFamily: 'Geist Sans', color: AppColors.textSecondary, fontSize: 13)),
          Text(val, style: const TextStyle(fontFamily: 'Geist Sans', fontWeight: FontWeight.bold, fontSize: 13)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String stepTitle = 'Link Bank Account';
    if (_currentStep == 0) stepTitle = 'Select Bank';
    if (_currentStep == 1) stepTitle = 'Account Details';
    if (_currentStep == 2) stepTitle = 'SIM Verification';
    if (_currentStep == 3) stepTitle = 'Verify OTP';
    if (_currentStep == 4) stepTitle = 'Verification Method';
    if (_currentStep == 5) stepTitle = 'Verify Card';
    if (_currentStep == 6) stepTitle = 'Account Summary';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: stepTitle,
        showLeading: _currentStep < 6, // Don't show back button on success page
        onLeadingPressed: () {
          if (_currentStep > 0) {
            setState(() {
              _currentStep--;
            });
          } else {
            Navigator.pop(context);
          }
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24, vertical: AppSpacing.s12),
          child: _isLoadingBanks
              ? const Center(child: CircularProgressIndicator())
              : IndexedStack(
                  index: _currentStep,
                  children: [
                    _buildSelectBankStep(),
                    _buildAccountDetailsStep(),
                    _buildSIMVerificationStep(),
                    _buildOTPVerificationStep(),
                    _buildChooseMethodStep(),
                    _buildCardVerificationStep(),
                    _buildSuccessStep(),
                  ],
                ),
        ),
      ),
    );
  }
}
