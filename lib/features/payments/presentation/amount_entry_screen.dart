import 'package:flutter/material.dart';
import 'package:payout/core/widgets/widgets.dart';
import 'package:payout/features/bank_accounts/services/bank_account_service.dart';
import 'package:payout/features/bank_accounts/models/bank_account_models.dart';
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
  final BankAccountService _bankAccountService = BankAccountService();

  String _amountStr = '';
  final TextEditingController _noteController = TextEditingController();

  // Payment Method Selection State
  String _methodId = 'wallet';
  String _methodLabel = 'Payout Wallet';
  List<LinkedBankAccountModel> _linkedBanks = [];
  bool _isLoadingBanks = true;

  @override
  void initState() {
    super.initState();
    _loadBanks();
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _loadBanks() async {
    final banks = await _bankAccountService.getLinkedAccounts();
    if (mounted) {
      setState(() {
        _linkedBanks = banks;
        _isLoadingBanks = false;
      });
    }
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

  void _showPaymentMethodSelector() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
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
                'Choose Payment Method',
                style: TextStyle(
                  fontFamily: 'Geist Sans',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F1F1F),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Select the source account for this transaction.',
                style: TextStyle(fontFamily: 'Geist Sans', fontSize: 12, color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 18),
              // Payout Wallet option
              Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _methodId = 'wallet';
                      _methodLabel = 'Payout Wallet';
                    });
                    Navigator.pop(sheetContext);
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
                          child: const Icon(Icons.account_balance_wallet_rounded, color: Color(0xFF3F37C9), size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Payout Wallet',
                                style: TextStyle(fontFamily: 'Geist Sans', fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1F1F1F)),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Available Balance: ₹5,000.00',
                                style: TextStyle(fontFamily: 'Geist Sans', fontSize: 11.5, color: Color(0xFF64748B)),
                              ),
                            ],
                          ),
                        ),
                        if (_methodId == 'wallet')
                          const Icon(Icons.check_circle_rounded, color: Color(0xFF3F37C9), size: 20),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Linked Bank options
              if (_isLoadingBanks)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(12.0),
                    child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF3F37C9))),
                  ),
                )
              else
                ..._linkedBanks.map((bank) {
                  final isSelected = _methodId == bank.id;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Material(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _methodId = bank.id;
                            _methodLabel = '${bank.bankName} ${bank.maskedAccountNumber}';
                          });
                          Navigator.pop(sheetContext);
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
                                child: const Icon(Icons.account_balance_rounded, color: Color(0xFF3F37C9), size: 20),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      bank.bankName,
                                      style: const TextStyle(fontFamily: 'Geist Sans', fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1F1F1F)),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Savings ${bank.maskedAccountNumber}',
                                      style: const TextStyle(fontFamily: 'Geist Sans', fontSize: 11.5, color: Color(0xFF64748B)),
                                    ),
                                  ],
                                ),
                              ),
                              if (isSelected)
                                const Icon(Icons.check_circle_rounded, color: Color(0xFF3F37C9), size: 20),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  Widget _buildKey(String value) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(4),
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18.0),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => _onKeyPress(value),
            child: Container(
              height: 52,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18.0),
                border: Border.all(color: const Color(0xFFE2E8F0)),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF002E6E).withValues(alpha: 0.015),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                value,
                style: const TextStyle(
                  fontFamily: 'Geist Sans',
                  fontSize: 22.0,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1F1F1F),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    } else if (parts.isNotEmpty && parts[0].isNotEmpty) {
      return parts[0][0].toUpperCase();
    }
    return 'U';
  }

  @override
  Widget build(BuildContext context) {
    final double parsedAmount = double.tryParse(_amountStr) ?? 0.0;
    final displayAmount = _amountStr.isEmpty ? '0.00' : _amountStr;
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
                  )
                else
                  const SizedBox(width: 38),
                const Expanded(
                  child: Center(
                    child: Text(
                      'Enter Amount',
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
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                child: Column(
                  children: [
                    // 1. Premium Recipient Card
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF002E6E).withValues(alpha: 0.025),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
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
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              _getInitials(widget.recipientName),
                              style: const TextStyle(
                                fontFamily: 'Geist Sans',
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.recipientName,
                                  style: const TextStyle(
                                    fontFamily: 'Geist Sans',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.0,
                                    color: Color(0xFF1F1F1F),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  widget.recipientDetail,
                                  style: const TextStyle(
                                    fontFamily: 'Geist Sans',
                                    fontSize: 12.0,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFF059669).withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(Icons.check, size: 11, color: Color(0xFF059669)),
                                SizedBox(width: 3),
                                Text(
                                  'Verified',
                                  style: TextStyle(
                                    fontFamily: 'Geist Sans',
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF059669),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 2. Big Amount text with gradient accent
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 6.0),
                              child: Text(
                                '₹',
                                style: TextStyle(
                                  fontFamily: 'Geist Sans',
                                  fontSize: 28.0,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1F1F1F),
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              displayAmount,
                              style: const TextStyle(
                                fontFamily: 'Geist Sans',
                                fontSize: 46.0,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1F1F1F),
                                letterSpacing: -1.0,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Container(
                          width: 48,
                          height: 3.5,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF3F37C9),
                                Color(0xFF2563EB),
                                Color(0xFF00B9F1),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),

                    // 3. Note Input field Card
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF002E6E).withValues(alpha: 0.015),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.edit_note_rounded, color: Color(0xFF3F37C9), size: 22),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: _noteController,
                              style: const TextStyle(
                                fontFamily: 'Geist Sans',
                                fontSize: 13.5,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF1F1F1F),
                              ),
                              decoration: const InputDecoration(
                                hintText: 'Add a payment note (optional)',
                                hintStyle: TextStyle(fontFamily: 'Geist Sans', fontSize: 13, color: Color(0xFF64748B)),
                                border: InputBorder.none,
                                isDense: true,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // 4. Payment Method selector Card
                    GestureDetector(
                      onTap: _showPaymentMethodSelector,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF002E6E).withValues(alpha: 0.015),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: const Color(0xFF3F37C9).withValues(alpha: 0.08),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.account_balance_wallet_rounded, size: 18, color: Color(0xFF3F37C9)),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _methodLabel,
                                    style: const TextStyle(
                                      fontFamily: 'Geist Sans',
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1F1F1F),
                                    ),
                                  ),
                                  const Text(
                                    'Available Balance ₹5,000.00',
                                    style: TextStyle(
                                      fontFamily: 'Geist Sans',
                                      fontSize: 11,
                                      color: Color(0xFF64748B),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: Color(0xFF64748B)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 5. Custom Numeric Keypad & Proceed Button
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              decoration: const BoxDecoration(
                color: Color(0xFFF8FAFC),
                border: Border(
                  top: BorderSide(color: Color(0xFFE2E8F0), width: 1.0),
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
                          margin: const EdgeInsets.all(4),
                          child: Material(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18.0),
                            clipBehavior: Clip.antiAlias,
                            child: InkWell(
                              onTap: _onBackspace,
                              child: Container(
                                height: 52,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(18.0),
                                  border: Border.all(color: const Color(0xFFE2E8F0)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF002E6E).withValues(alpha: 0.015),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.backspace_outlined,
                                  color: Color(0xFF3F37C9),
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  PrimaryButton(
                    text: 'Continue',
                    height: 52,
                    onPressed: parsedAmount > 0.0
                        ? () {
                            final validation = PaymentsValidator.validateAmount(parsedAmount);
                            if (!validation.isValid) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(validation.errorMessage ?? 'Invalid amount.'),
                                  backgroundColor: const Color(0xFFEF4444),
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
                                  methodId: _methodId,
                                  methodLabel: _methodLabel,
                                ),
                              ),
                            );
                          }
                        : null,
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
