import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/widgets.dart';
import 'package:payout/features/payments/presentation/amount_entry_screen.dart';

class BankAccountsScreen extends StatefulWidget {
  const BankAccountsScreen({super.key});

  @override
  State<BankAccountsScreen> createState() => _BankAccountsScreenState();
}

class _BankAccountsScreenState extends State<BankAccountsScreen> {
  final List<Map<String, String>> _banks = [
    {'name': 'HDFC Bank', 'acc': 'Checking •••• 5849', 'icon': 'H', 'primary': 'true'},
    {'name': 'ICICI Bank', 'acc': 'Savings •••• 9201', 'icon': 'I', 'primary': 'false'},
  ];

  void _showAddBankSheet() {
    String? bankName;
    String? accountNumber;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xxl)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: AppSpacing.s24,
            left: AppSpacing.s24,
            right: AppSpacing.s24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Link Bank Account',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 20.0),
              ),
              const SizedBox(height: AppSpacing.s8),
              const Text(
                'Enter checking account credentials to connect your bank via Payout.',
                style: TextStyle(fontFamily: 'Inter', color: AppColors.textSecondary, fontSize: 13),
              ),
              const SizedBox(height: AppSpacing.s20),
              AppTextField(
                labelText: 'Bank Name',
                hintText: 'e.g. HDFC Bank',
                onChanged: (val) => bankName = val,
              ),
              const SizedBox(height: AppSpacing.s12),
              const AppTextField(
                keyboardType: TextInputType.number,
                labelText: 'IFSC Code',
                hintText: 'e.g. HDFC0000124',
              ),
              const SizedBox(height: AppSpacing.s12),
              AppTextField(
                onChanged: (val) => accountNumber = val,
                keyboardType: TextInputType.number,
                labelText: 'Account Number',
                hintText: 'e.g. 50100241258',
              ),
              const SizedBox(height: AppSpacing.s24),
              PrimaryButton(
                text: 'Link Account',
                onPressed: () {
                  if (bankName != null && bankName!.isNotEmpty) {
                    setState(() {
                      _banks.add({
                        'name': bankName!,
                        'acc': 'Savings •••• ${accountNumber != null && accountNumber!.length > 4 ? accountNumber!.substring(accountNumber!.length - 4) : '9999'}',
                        'icon': bankName![0].toUpperCase(),
                        'primary': 'false',
                      });
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('$bankName account linked successfully.'),
                        backgroundColor: AppColors.success,
                      ),
                    );
                  }
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
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Bank Accounts'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24, vertical: AppSpacing.s12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Linked Bank Accounts',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.s16),
            ..._banks.map((bank) {
              final isPrimary = bank['primary'] == 'true';
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.s12),
                child: AppCard(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AmountEntryScreen(
                          recipientName: bank['name']!,
                          recipientDetail: bank['acc']!,
                          recipientType: 'Bank',
                        ),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: const BoxDecoration(
                          color: AppColors.primaryContainer,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          bank['icon']!,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.s16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  bank['name']!,
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.0,
                                  ),
                                ),
                                if (isPrimary) ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: AppColors.success.withOpacity(0.08),
                                      borderRadius: BorderRadius.circular(AppRadius.xs),
                                    ),
                                    child: const Text(
                                      'PRIMARY',
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 8,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.success,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              bank['acc']!,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12.0,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline_rounded, color: AppColors.error, size: 20),
                        onPressed: () {
                          setState(() {
                            _banks.removeWhere((b) => b['name'] == bank['name']);
                          });
                        },
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
            const SizedBox(height: AppSpacing.s24),
            OutlinedButtonV2(
              text: 'Add New Bank Account',
              iconLeft: Icons.add_rounded,
              onPressed: _showAddBankSheet,
            ),
          ],
        ),
      ),
    );
  }
}
