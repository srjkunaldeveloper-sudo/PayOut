import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/widgets.dart';
import 'package:payout/core/di/app_dependencies.dart';
import 'package:payout/features/user/models/user_models.dart';
import 'package:payout/features/user/repositories/user_repository.dart';
import 'package:payout/features/user/validators/user_validator.dart';

class EditProfileScreen extends StatefulWidget {
  final UserProfileModel profile;
  final UserRepository? userRepository;

  const EditProfileScreen({
    super.key,
    required this.profile,
    this.userRepository,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final UserRepository _userRepository;
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _dobController;
  late TextEditingController _addressController;

  late String _currentPhone;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _userRepository = widget.userRepository ?? AppDependencies.instance.userRepository;
    _nameController = TextEditingController(text: widget.profile.name);
    _emailController = TextEditingController(text: widget.profile.email);
    _dobController = TextEditingController(text: widget.profile.dob ?? '15/08/1995');
    _addressController = TextEditingController(text: widget.profile.address);
    _currentPhone = widget.profile.phone;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _dobController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
    });

    final updated = widget.profile.copyWith(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      dob: _dobController.text.trim(),
      address: _addressController.text.trim(),
      phone: _currentPhone,
    );

    await _userRepository.updateProfile(updated);

    if (!mounted) return;
    setState(() {
      _isSaving = false;
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
                child: const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 48),
              ),
              const SizedBox(height: AppSpacing.s16),
              const Text(
                'Profile Updated',
                style: TextStyle(
                  fontFamily: 'Geist Sans',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.s8),
              const Text(
                'Your profile changes have been saved successfully.',
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
                    Navigator.pop(context, true); // return to Profile
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showChangeMobileSheet() {
    final phoneController = TextEditingController();
    final otpController = TextEditingController();
    bool otpSent = false;
    bool isVerifying = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              decoration: const BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: EdgeInsets.only(
                top: AppSpacing.s24,
                left: AppSpacing.s24,
                right: AppSpacing.s24,
                bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.s24,
              ),
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
                  Text(
                    otpSent ? 'Enter Verification Code' : 'Change Mobile Number',
                    style: const TextStyle(fontFamily: 'Geist Sans', fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: AppSpacing.s8),
                  Text(
                    otpSent
                        ? 'Enter the 6-digit OTP sent to +91 ${phoneController.text}'
                        : 'A 6-digit OTP will be sent to verify your new mobile number.',
                    style: const TextStyle(fontFamily: 'Geist Sans', fontSize: 12, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: AppSpacing.s16),
                  if (!otpSent) ...[
                    AppTextField(
                      controller: phoneController,
                      labelText: 'New Mobile Number',
                      hintText: 'Enter 10-digit mobile number',
                      keyboardType: TextInputType.phone,
                      prefix: const Icon(Icons.phone_android_rounded, size: 20),
                    ),
                    const SizedBox(height: AppSpacing.s16),
                    SizedBox(
                      width: double.infinity,
                      child: PrimaryButton(
                        text: 'Send OTP',
                        onPressed: () {
                          final res = UserValidator.validatePhone(phoneController.text);
                          if (!res.isValid) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(res.errorMessage ?? 'Invalid number'), backgroundColor: AppColors.error),
                            );
                            return;
                          }
                          setModalState(() {
                            otpSent = true;
                          });
                        },
                      ),
                    ),
                  ] else ...[
                    AppTextField(
                      controller: otpController,
                      labelText: '6-Digit OTP',
                      hintText: 'Enter 6-digit OTP',
                      keyboardType: TextInputType.number,
                      prefix: const Icon(Icons.lock_clock_rounded, size: 20),
                    ),
                    const SizedBox(height: AppSpacing.s16),
                    SizedBox(
                      width: double.infinity,
                      child: PrimaryButton(
                        text: isVerifying ? 'Verifying...' : 'Verify & Update',
                        isLoading: isVerifying,
                        onPressed: isVerifying
                            ? null
                            : () async {
                                final res = UserValidator.validateOTP(otpController.text);
                                if (!res.isValid) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(res.errorMessage ?? 'Invalid OTP'), backgroundColor: AppColors.error),
                                  );
                                  return;
                                }

                                setModalState(() {
                                  isVerifying = true;
                                });

                                await _userRepository.changeMobile(phoneController.text.trim(), otpController.text.trim());

                                if (!mounted) return;
                                setState(() {
                                  _currentPhone = phoneController.text.trim();
                                });
                                if (context.mounted) {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Mobile number updated successfully!'), backgroundColor: AppColors.success),
                                  );
                                }
                              },
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Edit Profile'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.s24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Stack(
                    children: [
                      CustomAvatar(
                        name: _nameController.text.isNotEmpty ? _nameController.text : 'User',
                        size: 80,
                        backgroundColor: AppColors.primaryContainer,
                        textColor: AppColors.primary,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 16),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.s24),

                // Name
                AppTextField(
                  controller: _nameController,
                  labelText: 'Full Name',
                  hintText: 'Enter your full name',
                  prefix: const Icon(Icons.person_outline_rounded, size: 20),
                  validator: (val) {
                    final res = UserValidator.validateName(val ?? '');
                    return res.isValid ? null : res.errorMessage;
                  },
                ),
                const SizedBox(height: AppSpacing.s16),

                // Email
                AppTextField(
                  controller: _emailController,
                  labelText: 'Email Address',
                  hintText: 'Enter your email address',
                  keyboardType: TextInputType.emailAddress,
                  prefix: const Icon(Icons.mail_outline_rounded, size: 20),
                  validator: (val) {
                    final res = UserValidator.validateEmail(val ?? '');
                    return res.isValid ? null : res.errorMessage;
                  },
                ),
                const SizedBox(height: AppSpacing.s16),

                // Date of Birth
                AppTextField(
                  controller: _dobController,
                  labelText: 'Date of Birth (DD/MM/YYYY)',
                  hintText: '15/08/1995',
                  keyboardType: TextInputType.datetime,
                  prefix: const Icon(Icons.cake_outlined, size: 20),
                  validator: (val) {
                    final res = UserValidator.validateDOB(val ?? '');
                    return res.isValid ? null : res.errorMessage;
                  },
                ),
                const SizedBox(height: AppSpacing.s16),

                // Address
                AppTextField(
                  controller: _addressController,
                  labelText: 'Address',
                  hintText: 'Enter your residential address',
                  prefix: const Icon(Icons.home_outlined, size: 20),
                ),
                const SizedBox(height: AppSpacing.s16),

                // Mobile Number (Identity Protected)
                AppCard(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16, vertical: AppSpacing.s12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Mobile Number (Verified)', style: TextStyle(fontFamily: 'Geist Sans', fontSize: 11, color: AppColors.textSecondary)),
                          const SizedBox(height: 2),
                          Text('+91 $_currentPhone', style: const TextStyle(fontFamily: 'Geist Sans', fontWeight: FontWeight.bold, fontSize: 14)),
                        ],
                      ),
                      TextButton(
                        onPressed: _showChangeMobileSheet,
                        child: const Text('Change', style: TextStyle(fontFamily: 'Geist Sans', fontWeight: FontWeight.bold, color: AppColors.primary)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.s32),

                // Save CTA
                SizedBox(
                  width: double.infinity,
                  child: PrimaryButton(
                    text: 'Save Changes',
                    isLoading: _isSaving,
                    onPressed: _isSaving ? null : _saveProfile,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
