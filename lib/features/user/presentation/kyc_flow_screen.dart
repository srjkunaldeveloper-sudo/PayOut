import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/widgets.dart';
import 'package:payout/core/di/app_dependencies.dart';
import 'package:payout/features/bank_accounts/repositories/bank_account_repository.dart';
import 'package:payout/features/user/models/user_models.dart';
import 'package:payout/features/user/repositories/user_repository.dart';
import 'package:payout/features/user/validators/user_validator.dart';

class KYCFlowScreen extends StatefulWidget {
  final UserRepository? userRepository;
  final BankAccountRepository? bankAccountRepository;

  const KYCFlowScreen({
    super.key,
    this.userRepository,
    this.bankAccountRepository,
  });

  @override
  State<KYCFlowScreen> createState() => _KYCFlowScreenState();
}

class _KYCFlowScreenState extends State<KYCFlowScreen> {
  late final UserRepository _userRepository;
  late final BankAccountRepository _bankAccountRepository;

  int _currentStep = 0;
  bool _isSubmitting = false;

  // Step 1: Personal Details
  final _nameController = TextEditingController();
  final _dobController = TextEditingController();
  final _addressController = TextEditingController();

  // Step 2: PAN
  final _panController = TextEditingController();

  // Step 3: Document
  String _selectedDocType = 'Aadhaar Card';
  final _docNumberController = TextEditingController();
  bool _frontUploaded = true;
  bool _backUploaded = true;

  // Step 4: Bank
  String _verifiedBank = 'HDFC Bank (•••• 8901)';
  bool _isBankVerified = true;

  @override
  void initState() {
    super.initState();
    _userRepository = widget.userRepository ?? AppDependencies.instance.userRepository;
    _bankAccountRepository = widget.bankAccountRepository ?? AppDependencies.instance.bankAccountRepository;
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    final profile = await _userRepository.getProfile();
    final banks = await _bankAccountRepository.getLinkedAccounts();
    if (mounted) {
      setState(() {
        _nameController.text = profile.name;
        _dobController.text = profile.dob ?? '15/08/1995';
        _addressController.text = profile.address;
        if (banks.isNotEmpty) {
          _verifiedBank = '${banks.first.bankName} (${banks.first.maskedAccountNumber})';
          _isBankVerified = true;
        }
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dobController.dispose();
    _addressController.dispose();
    _panController.dispose();
    _docNumberController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep == 0) {
      final nameRes = UserValidator.validateName(_nameController.text);
      if (!nameRes.isValid) {
        _showError(nameRes.errorMessage ?? 'Invalid name');
        return;
      }
      final dobRes = UserValidator.validateDOB(_dobController.text);
      if (!dobRes.isValid) {
        _showError(dobRes.errorMessage ?? 'Invalid date of birth');
        return;
      }
    } else if (_currentStep == 1) {
      final panRes = UserValidator.validatePAN(_panController.text);
      if (!panRes.isValid) {
        _showError(panRes.errorMessage ?? 'Invalid PAN');
        return;
      }
    } else if (_currentStep == 2) {
      if (_docNumberController.text.trim().isEmpty) {
        _showError('Document number is required.');
        return;
      }
    }

    if (_currentStep < 4) {
      setState(() {
        _currentStep++;
      });
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    } else {
      Navigator.pop(context);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.error),
    );
  }

  Future<void> _submitKYC() async {
    setState(() {
      _isSubmitting = true;
    });

    final submission = KYCModel(
      status: 'VERIFIED',
      documentType: _selectedDocType,
      documentNumber: _docNumberController.text.trim(),
      personalDetailsSubmitted: true,
      panVerified: true,
      documentUploaded: true,
      bankVerified: true,
      panNumber: _panController.text.toUpperCase().trim(),
      verifiedDate: 'Today, Just Now',
    );

    await _userRepository.submitKYC(submission);

    if (!mounted) return;
    setState(() {
      _isSubmitting = false;
    });

    _showSuccessDialog();
  }

  void _showSuccessDialog() {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
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
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.verified_rounded, color: AppColors.success, size: 48),
              ),
              const SizedBox(height: AppSpacing.s16),
              const Text(
                'KYC Verified Successfully!',
                style: TextStyle(
                  fontFamily: 'Geist Sans',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.s8),
              const Text(
                'Your identity has been authenticated. You now have full access to higher transaction limits and withdrawal services.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Geist Sans',
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.s24),
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  text: 'Done',
                  onPressed: () {
                    Navigator.pop(context); // close modal
                    Navigator.pop(context, true); // return to KYC dashboard
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final stepTitles = ['Personal Details', 'PAN Verification', 'Identity Document', 'Bank Verification', 'Review & Submit'];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Complete KYC',
        onLeadingPressed: _previousStep,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Stepper Indicator
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24, vertical: AppSpacing.s16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Step ${_currentStep + 1} of 5: ${stepTitles[_currentStep]}',
                        style: const TextStyle(fontFamily: 'Geist Sans', fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primary),
                      ),
                      Text('${((_currentStep + 1) / 5 * 100).toInt()}%', style: const TextStyle(fontFamily: 'Geist Sans', fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.textSecondary)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: (_currentStep + 1) / 5,
                    backgroundColor: AppColors.divider,
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: AppColors.divider),

            // Step Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.s24),
                child: _buildCurrentStepContent(),
              ),
            ),

            // Bottom CTAs
            Padding(
              padding: const EdgeInsets.all(AppSpacing.s24),
              child: Row(
                children: [
                  if (_currentStep > 0) ...[
                    Expanded(
                      child: OutlinedButtonV2(
                        text: 'Back',
                        onPressed: _previousStep,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.s16),
                  ],
                  Expanded(
                    flex: 2,
                    child: PrimaryButton(
                      text: _currentStep == 4
                          ? (_isSubmitting ? 'Verifying...' : 'Submit KYC')
                          : 'Continue',
                      isLoading: _isSubmitting,
                      onPressed: _isSubmitting
                          ? null
                          : (_currentStep == 4 ? _submitKYC : _nextStep),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildStep1Personal();
      case 1:
        return _buildStep2PAN();
      case 2:
        return _buildStep3Document();
      case 3:
        return _buildStep4Bank();
      case 4:
        return _buildStep5Review();
      default:
        return const SizedBox.shrink();
    }
  }

  // Step 1: Personal Details
  Widget _buildStep1Personal() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Enter Personal Information', style: TextStyle(fontFamily: 'Geist Sans', fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 4),
        const Text('As per official government identification records.', style: TextStyle(fontFamily: 'Geist Sans', fontSize: 12, color: AppColors.textSecondary)),
        const SizedBox(height: AppSpacing.s20),
        AppTextField(
          controller: _nameController,
          labelText: 'Full Name',
          hintText: 'e.g. Rahul Sharma',
          prefix: const Icon(Icons.person_outline_rounded, size: 20),
        ),
        const SizedBox(height: AppSpacing.s16),
        AppTextField(
          controller: _dobController,
          labelText: 'Date of Birth (DD/MM/YYYY)',
          hintText: '15/08/1995',
          keyboardType: TextInputType.datetime,
          prefix: const Icon(Icons.cake_outlined, size: 20),
        ),
        const SizedBox(height: AppSpacing.s16),
        AppTextField(
          controller: _addressController,
          labelText: 'Residential Address',
          hintText: 'Street, City, State, PIN',
          prefix: const Icon(Icons.home_outlined, size: 20),
        ),
      ],
    );
  }

  // Step 2: PAN Verification
  Widget _buildStep2PAN() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Permanent Account Number (PAN)', style: TextStyle(fontFamily: 'Geist Sans', fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 4),
        const Text('Mandatory for all financial and banking operations in India.', style: TextStyle(fontFamily: 'Geist Sans', fontSize: 12, color: AppColors.textSecondary)),
        const SizedBox(height: AppSpacing.s20),
        AppTextField(
          controller: _panController,
          labelText: '10-Digit PAN Number',
          hintText: 'e.g. ABCDE1234F',
          prefix: const Icon(Icons.credit_card_rounded, size: 20),
        ),
        const SizedBox(height: AppSpacing.s16),
        AppCard(
          color: AppColors.primaryContainer.withOpacity(0.4),
          child: const Row(
            children: [
              Icon(Icons.info_outline_rounded, color: AppColors.primary, size: 20),
              SizedBox(width: AppSpacing.s12),
              Expanded(
                child: Text(
                  'Your PAN card will be verified against the Income Tax database instantly.',
                  style: TextStyle(fontFamily: 'Geist Sans', fontSize: 12, color: AppColors.textPrimary),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Step 3: Identity Document
  Widget _buildStep3Document() {
    final docs = ['Aadhaar Card', 'Passport', 'Driving Licence', 'Voter ID'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Select Proof of Identity', style: TextStyle(fontFamily: 'Geist Sans', fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 4),
        const Text('Choose one valid government issued identity proof.', style: TextStyle(fontFamily: 'Geist Sans', fontSize: 12, color: AppColors.textSecondary)),
        const SizedBox(height: AppSpacing.s16),
        DropdownButtonFormField<String>(
          value: _selectedDocType,
          items: docs.map((d) => DropdownMenuItem(value: d, child: Text(d, style: const TextStyle(fontFamily: 'Geist Sans', fontSize: 13)))).toList(),
          onChanged: (val) {
            if (val != null) {
              setState(() {
                _selectedDocType = val;
              });
            }
          },
          decoration: InputDecoration(
            labelText: 'Document Type',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
          ),
        ),
        const SizedBox(height: AppSpacing.s16),
        AppTextField(
          controller: _docNumberController,
          labelText: '$_selectedDocType Number',
          hintText: _selectedDocType == 'Aadhaar Card' ? '12-digit Aadhaar number' : 'Enter document ID',
          prefix: const Icon(Icons.badge_outlined, size: 20),
        ),
        const SizedBox(height: AppSpacing.s20),
        const Text('Document Photos (Demo Simulation)', style: TextStyle(fontFamily: 'Geist Sans', fontWeight: FontWeight.bold, fontSize: 13)),
        const SizedBox(height: AppSpacing.s12),
        Row(
          children: [
            Expanded(
              child: _buildDocUploadSlot('Front Side', _frontUploaded, () {
                setState(() => _frontUploaded = !_frontUploaded);
              }),
            ),
            const SizedBox(width: AppSpacing.s12),
            Expanded(
              child: _buildDocUploadSlot('Back Side', _backUploaded, () {
                setState(() => _backUploaded = !_backUploaded);
              }),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDocUploadSlot(String label, bool isSelected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.s16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.success.withOpacity(0.06) : AppColors.surface,
          border: Border.all(color: isSelected ? AppColors.success : AppColors.divider),
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Column(
          children: [
            Icon(isSelected ? Icons.check_circle_rounded : Icons.upload_file_rounded, color: isSelected ? AppColors.success : AppColors.textSecondary, size: 28),
            const SizedBox(height: 6),
            Text(label, style: const TextStyle(fontFamily: 'Geist Sans', fontSize: 12, fontWeight: FontWeight.bold)),
            Text(isSelected ? 'Uploaded ✓' : 'Tap to select', style: TextStyle(fontFamily: 'Geist Sans', fontSize: 10, color: isSelected ? AppColors.success : AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }

  // Step 4: Bank Verification
  Widget _buildStep4Bank() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Bank Account Verification', style: TextStyle(fontFamily: 'Geist Sans', fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 4),
        const Text('Penny drop verification ensures seamless wallet withdrawals.', style: TextStyle(fontFamily: 'Geist Sans', fontSize: 12, color: AppColors.textSecondary)),
        const SizedBox(height: AppSpacing.s20),
        AppCard(
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: AppColors.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.account_balance_rounded, color: AppColors.primary, size: 24),
              ),
              const SizedBox(width: AppSpacing.s16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_verifiedBank, style: const TextStyle(fontFamily: 'Geist Sans', fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 2),
                    const Text('Penny Drop Verified ✓', style: TextStyle(fontFamily: 'Geist Sans', fontSize: 11, color: AppColors.success, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              if (_isBankVerified)
                const Icon(Icons.verified_rounded, color: AppColors.success, size: 20),
            ],
          ),
        ),
      ],
    );
  }

  // Step 5: Review & Submit
  Widget _buildStep5Review() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Review Information', style: TextStyle(fontFamily: 'Geist Sans', fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 4),
        const Text('Please check your details carefully before final submission.', style: TextStyle(fontFamily: 'Geist Sans', fontSize: 12, color: AppColors.textSecondary)),
        const SizedBox(height: AppSpacing.s20),
        AppCard(
          child: Column(
            children: [
              _buildReviewRow('Full Name', _nameController.text.isNotEmpty ? _nameController.text : 'Rahul Sharma'),
              const Divider(color: AppColors.divider),
              _buildReviewRow('Date of Birth', _dobController.text.isNotEmpty ? _dobController.text : '15/08/1995'),
              const Divider(color: AppColors.divider),
              _buildReviewRow('PAN Number', _panController.text.isNotEmpty ? _panController.text.toUpperCase() : 'ABCDE1234F'),
              const Divider(color: AppColors.divider),
              _buildReviewRow('Document Proof', '$_selectedDocType (${_docNumberController.text.isNotEmpty ? _docNumberController.text : 'Verified'})'),
              const Divider(color: AppColors.divider),
              _buildReviewRow('Bank Account', _verifiedBank),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReviewRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontFamily: 'Geist Sans', color: AppColors.textSecondary, fontSize: 12)),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontFamily: 'Geist Sans', fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
