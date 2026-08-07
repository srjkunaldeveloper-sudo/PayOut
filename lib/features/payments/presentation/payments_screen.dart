import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/widgets.dart';
import 'package:payout/features/bank_accounts/presentation/bank_accounts_screen.dart';
import 'package:payout/features/scan_qr/presentation/scan_qr_screen.dart';
import 'package:payout/features/transaction_history/presentation/transaction_history_screen.dart';
import 'package:payout/features/payments/models/payments_models.dart';
import 'package:payout/features/payments/repositories/payments_repository.dart';
import 'package:payout/features/payments/presentation/amount_entry_screen.dart';
import 'package:payout/features/payments/presentation/receipt_screen.dart';
import 'package:payout/features/payments/services/payments_logger.dart';

class PaymentsScreen extends StatefulWidget {
  const PaymentsScreen({super.key});

  @override
  State<PaymentsScreen> createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends State<PaymentsScreen> {
  final PaymentsRepository _paymentsRepository = MockPaymentsRepository();

  List<BeneficiaryModel> _beneficiaries = [];
  List<RecentPaymentModel> _recentPayments = [];
  List<PaymentMethodModel> _paymentMethods = [];
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadData();
    PaymentsLogger.logPaymentOpened();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });
    final beneficiaries = await _paymentsRepository.getBeneficiaries();
    final recentPayments = await _paymentsRepository.getRecentPayments();
    final methods = await _paymentsRepository.getPaymentMethods();

    if (mounted) {
      setState(() {
        _beneficiaries = beneficiaries;
        _recentPayments = recentPayments;
        _paymentMethods = methods;
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

  void _showPaymentMethodSelector() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadii.bottomSheet)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: AppSpacing.s16,
            left: AppSpacing.s24,
            right: AppSpacing.s24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: const BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.all(Radius.circular(AppRadius.circle)),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.s16),
              Text(
                'Choose Payment Method',
                style: AppTypography.headlineSmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.s8),
              const Text(
                'Select your primary account for sending money.',
                style: TextStyle(fontFamily: 'Inter', color: AppColors.textSecondary, fontSize: 13),
              ),
              const SizedBox(height: AppSpacing.s20),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _paymentMethods.length,
                separatorBuilder: (context, index) => const Divider(color: AppColors.divider),
                itemBuilder: (context, index) {
                  final method = _paymentMethods[index];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        method.type == 'Wallet'
                            ? Icons.account_balance_wallet_rounded
                            : method.type == 'Bank Account'
                                ? Icons.account_balance_rounded
                                : Icons.payment_rounded,
                        color: AppColors.primary,
                      ),
                    ),
                    title: Text(
                      method.label,
                      style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    subtitle: Text(
                      method.isVerified ? 'Verified Account' : 'Unverified',
                      style: const TextStyle(fontFamily: 'Inter', fontSize: 11, color: AppColors.textSecondary),
                    ),
                    trailing: method.isDefault
                        ? const Icon(Icons.check_circle_rounded, color: AppColors.success)
                        : null,
                    onTap: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${method.label} set as primary method.'),
                          backgroundColor: AppColors.success,
                        ),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: AppSpacing.s24),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        appBar: CustomAppBar(title: 'Payments Hub', showLeading: false),
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        ),
      );
    }

    final List<Map<String, dynamic>> shortcuts = [
      {'label': 'Scan QR', 'icon': AppIcons.scanQR, 'screen': const ScanQRScreen(), 'color': AppColors.primary},
      {'label': 'Methods', 'icon': Icons.account_balance_wallet_rounded, 'action': _showPaymentMethodSelector, 'color': AppColors.success},
      {'label': 'To Bank', 'icon': AppIcons.bank, 'screen': const BankAccountsScreen(), 'color': Colors.indigo},
      {'label': 'Self Trans', 'icon': Icons.swap_horiz_rounded, 'action': () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Self-Transfer flow selected.')),
        );
      }, 'color': Colors.purple},
    ];

    final List<Map<String, dynamic>> utilities = [
      {'label': 'Mobile', 'icon': Icons.phone_android_rounded, 'color': Colors.amber},
      {'label': 'DTH', 'icon': Icons.tv_rounded, 'color': Colors.redAccent},
      {'label': 'Electricity', 'icon': Icons.lightbulb_rounded, 'color': Colors.orange},
      {'label': 'Credit Card', 'icon': Icons.credit_card_rounded, 'color': Colors.teal},
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Payments Hub', showLeading: false),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24, vertical: AppSpacing.s12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 0. Custom Pill Search Bar
            CustomSearchBar(
              hintText: 'Search contacts, UPI IDs, or numbers',
              onChanged: _handleSearch,
            ),
            const SizedBox(height: AppSpacing.s20),

            if (_searchQuery.isNotEmpty) ...[
              const Text(
                'Search Results',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.s12),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _beneficiaries.length,
                separatorBuilder: (context, index) => const Divider(color: AppColors.divider),
                itemBuilder: (context, index) {
                  final contact = _beneficiaries[index];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CustomAvatar(
                      name: contact.name,
                      size: 40,
                      backgroundColor: AppColors.primaryContainer,
                      textColor: AppColors.primary,
                    ),
                    title: Row(
                      children: [
                        Text(
                          contact.name,
                          style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        if (contact.isVerified) ...[
                          const SizedBox(width: 6),
                          const Icon(Icons.verified, size: 14, color: AppColors.success),
                        ],
                      ],
                    ),
                    subtitle: Text(
                      contact.upiId,
                      style: const TextStyle(fontFamily: 'Inter', fontSize: 11, color: AppColors.textSecondary),
                    ),
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
                  );
                },
              ),
              const SizedBox(height: AppSpacing.s32),
            ] else ...[
              // 1. UPI Lite Active Status Card
              AppCard(
                color: AppColors.primaryContainer,
                padding: const EdgeInsets.all(AppSpacing.s16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.s8),
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.flash_on_rounded, color: Colors.white, size: 16),
                    ),
                    const SizedBox(width: AppSpacing.s12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'UPI Lite Active',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.bold,
                              fontSize: 13.0,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            '₹150.00 balance • PIN-free small payments',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 11.0,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.circle),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      ),
                      child: const Text(
                        'Top Up',
                        style: TextStyle(fontFamily: 'Inter', fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.s24),

              // 2. Hero Scan Guide Banner
              AppCard(
                color: AppColors.primary,
                borderRadius: AppRadius.xxl,
                padding: const EdgeInsets.all(AppSpacing.s24),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ScanQRScreen()),
                  );
                },
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.s16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                      ),
                      child: const Icon(
                        AppIcons.scanQR,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.s20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Scan any QR Code',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Instant scans for all merchant/user code types.',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12.0,
                              color: AppColors.primaryContainer,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      AppIcons.arrowForward,
                      color: Colors.white70,
                      size: 14,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.s32),

              // 3. Quick Circular Shortcuts
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
                          width: 56,
                          height: 56,
                          decoration: const BoxDecoration(
                            color: AppColors.surface,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(item['icon'] as IconData, color: item['color'] as Color, size: 24),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item['label'] as String,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 11.0,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: AppSpacing.s32),

              // 4. Recent Payees
              const Text(
                'Recent Payees',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.s16),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _beneficiaries.length,
                  itemBuilder: (context, index) {
                    final contact = _beneficiaries[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: AppSpacing.s20),
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
                                CustomAvatar(
                                  name: contact.name,
                                  size: 48,
                                  backgroundColor: AppColors.primaryContainer,
                                  textColor: AppColors.primary,
                                ),
                                if (contact.isVerified)
                                  Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: const BoxDecoration(
                                      color: AppColors.success,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(AppIcons.verified, size: 8, color: Colors.white),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              contact.name.split(' ')[0],
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 11.0,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.s24),

              // 4.5 Payment Limits Card
              const Text(
                'Payment Limits',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.s12),
              AppCard(
                padding: const EdgeInsets.all(AppSpacing.s16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'Daily Transfer Limit Used',
                          style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.textSecondary),
                        ),
                        Text(
                          '₹2,000 / ₹1,00,000',
                          style: TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.s8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: const LinearProgressIndicator(
                        value: 0.02,
                        minHeight: 6,
                        backgroundColor: AppColors.divider,
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.success),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.s24),

              // 5. Utility Bills Payment Categories
              const Text(
                'Utility Bills & Recharges',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.s16),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: utilities.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.9,
                ),
                itemBuilder: (context, index) {
                  final item = utilities[index];
                  return AppCard(
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.s12, horizontal: AppSpacing.s4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(item['icon'] as IconData, color: item['color'] as Color, size: 20),
                        const SizedBox(height: 8),
                        Text(
                          item['label'] as String,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 10.0,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: AppSpacing.s24),

              const Text(
                'Recent Transfers',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.s12),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _recentPayments.length,
                separatorBuilder: (context, index) => const Divider(color: AppColors.divider),
                itemBuilder: (context, index) {
                  final tx = _recentPayments[index];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CustomAvatar(
                      name: tx.recipientName,
                      size: 40,
                      backgroundColor: AppColors.primaryContainer,
                      textColor: AppColors.primary,
                    ),
                    title: Text(
                      tx.recipientName,
                      style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    subtitle: Text(
                      '${tx.date} • ${tx.status}',
                      style: const TextStyle(fontFamily: 'Inter', fontSize: 11, color: AppColors.textSecondary),
                    ),
                    trailing: Text(
                      '₹${tx.amount.toStringAsFixed(2)}',
                      style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 14),
                    ),
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
                  );
                },
              ),
              const SizedBox(height: AppSpacing.s32),

              // 6. Payment History Shortcut Card
              AppCard(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TransactionHistoryScreen()),
                  );
                },
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.s12),
                      decoration: const BoxDecoration(
                        color: AppColors.surface,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        AppIcons.history,
                        color: AppColors.primary,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.s16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Payment History',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'View and download transaction statements.',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12.0,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      AppIcons.chevronRight,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.s40),
            ],
          ],
        ),
      ),
    );
  }
}
