import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/app_button.dart';
import 'package:payout/core/widgets/app_card.dart';

class BankAccountsScreen extends StatefulWidget {
  const BankAccountsScreen({super.key});

  @override
  State<BankAccountsScreen> createState() => _BankAccountsScreenState();
}

class _BankAccountsScreenState extends State<BankAccountsScreen> {
  final List<Map<String, String>> _banks = [
    {'name': 'Chase Bank', 'acc': 'Checking •••• 5849', 'icon': 'C'},
    {'name': 'Bank of America', 'acc': 'Savings •••• 9201', 'icon': 'B'},
  ];

  void _showAddBankSheet() {
    String? bankName;
    String? accountNumber;

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
              TextField(
                onChanged: (val) => bankName = val,
                decoration: const InputDecoration(
                  labelText: 'Bank Name',
                  hintText: 'e.g. Chase Bank',
                ),
              ),
              const SizedBox(height: AppSpacing.s12),
              TextField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Routing Number',
                  hintText: '9 Digits',
                ),
              ),
              const SizedBox(height: AppSpacing.s12),
              TextField(
                onChanged: (val) => accountNumber = val,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Account Number',
                  hintText: '8-12 Digits',
                ),
              ),
              const SizedBox(height: AppSpacing.s24),
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  text: 'Link Account',
                  onPressed: () {
                    if (bankName != null && bankName!.isNotEmpty) {
                      setState(() {
                        _banks.add({
                          'name': bankName!,
                          'acc': 'Checking •••• ${accountNumber != null && accountNumber!.length > 4 ? accountNumber!.substring(accountNumber!.length - 4) : '9999'}',
                          'icon': bankName![0].toUpperCase(),
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
        padding: const EdgeInsets.all(AppSpacing.s24),
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
            const SizedBox(height: AppSpacing.s12),
            ..._banks.map((bank) {
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.s12),
                child: AppCard(
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          bank['icon']!,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.s16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              bank['name']!,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                              ),
                            ),
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
            SizedBox(
              width: double.infinity,
              child: AppButton(
                text: 'Add New Bank Account',
                type: AppButtonType.outline,
                onPressed: _showAddBankSheet,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
