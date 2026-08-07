import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/widgets.dart';
import 'package:payout/features/payments/presentation/review_payment_screen.dart';
import 'package:payout/features/payments/validators/payments_validator.dart';

class AmountEntryScreen extends StatefulWidget {
  final String recipientName;
  final String recipientDetail;
  final String recipientType;

  const AmountEntryScreen({
    super.key,
    required this.recipientName,
    required this.recipientDetail,
    required this.recipientType,
  });

  @override
  State<AmountEntryScreen> createState() => _AmountEntryScreenState();
}

class _AmountEntryScreenState extends State<AmountEntryScreen> {
  String _amountStr = '';
  final TextEditingController _noteController = TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _onKeyPress(String val) {
    if (val == '.') {
      if (_amountStr.contains('.')) return;
      if (_amountStr.isEmpty) {
        setState(() {
          _amountStr = '0.';
        });
        return;
      }
    }
    // limit decimal digits to 2
    if (_amountStr.contains('.')) {
      final decPart = _amountStr.split('.')[1];
      if (decPart.length >= 2) return;
    }
    // limit total characters
    if (_amountStr.length >= 8) return;

    setState(() {
      _amountStr += val;
    });
  }

  void _onBackspace() {
    if (_amountStr.isNotEmpty) {
      setState(() {
        _amountStr = _amountStr.substring(0, _amountStr.length - 1);
      });
    }
  }

  Widget _buildKey(String value) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(AppSpacing.s4),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _onKeyPress(value),
            borderRadius: BorderRadius.circular(16.0),
            child: Container(
              height: 54,
              alignment: Alignment.center,
              child: Text(
                value,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 22.0,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double parsedAmount = double.tryParse(_amountStr) ?? 0.0;
    final displayAmount = _amountStr.isEmpty ? '0.00' : _amountStr;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Enter Amount'),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24),
                child: Column(
                  children: [
                    const SizedBox(height: AppSpacing.s12),
                    // Recipient details header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomAvatar(
                          name: widget.recipientName,
                          size: 40,
                          backgroundColor: AppColors.primaryLight,
                          textColor: AppColors.primary,
                        ),
                        const SizedBox(width: AppSpacing.s12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.recipientName,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                              ),
                            ),
                            Text(
                              widget.recipientDetail,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 11.0,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.s32),
                    // Big Amount text
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 4.0),
                          child: Text(
                            '₹',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 28.0,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          displayAmount,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 48.0,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                            letterSpacing: -1.0,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.s24),
                    // Note Input field
                    SizedBox(
                      width: 260,
                      child: TextField(
                        controller: _noteController,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Add a payment note',
                          filled: true,
                          fillColor: AppColors.surface,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Custom Numeric Keypad & Proceed Button
            Container(
              padding: const EdgeInsets.all(AppSpacing.s16),
              decoration: const BoxDecoration(
                color: AppColors.background,
                border: Border(
                  top: BorderSide(color: AppColors.divider, width: 1.0),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [_buildKey('1'), _buildKey('2'), _buildKey('3')],
                  ),
                  Row(
                    children: [_buildKey('4'), _buildKey('5'), _buildKey('6')],
                  ),
                  Row(
                    children: [_buildKey('7'), _buildKey('8'), _buildKey('9')],
                  ),
                  Row(
                    children: [
                      _buildKey('.'),
                      _buildKey('0'),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.all(AppSpacing.s4),
                          child: InkWell(
                            onTap: _onBackspace,
                            borderRadius: BorderRadius.circular(16.0),
                            child: Container(
                              height: 54,
                              alignment: Alignment.center,
                              child: const Icon(
                                Icons.backspace_outlined,
                                color: AppColors.textSecondary,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.s12),
                  SizedBox(
                    width: double.infinity,
                    child: PrimaryButton(
                      text: 'Continue',
                      onPressed: parsedAmount > 0.0
                          ? () {
                              final validation = PaymentsValidator.validateAmount(parsedAmount);
                              if (!validation.isValid) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(validation.errorMessage ?? 'Invalid amount.'),
                                    backgroundColor: AppColors.error,
                                  ),
                                );
                                return;
                              }
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ReviewPaymentScreen(
                                    recipientName: widget.recipientName,
                                    recipientDetail: widget.recipientDetail,
                                    recipientType: widget.recipientType,
                                    amount: parsedAmount,
                                    note: _noteController.text,
                                  ),
                                ),
                              );
                            }
                          : null,
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
}
