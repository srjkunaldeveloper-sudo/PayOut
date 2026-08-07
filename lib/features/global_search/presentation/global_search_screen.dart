import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/app_button.dart';
import 'package:payout/core/widgets/search_bar.dart';
import 'package:payout/core/widgets/avatar.dart';

class GlobalSearchScreen extends StatefulWidget {
  const GlobalSearchScreen({super.key});

  @override
  State<GlobalSearchScreen> createState() => _GlobalSearchScreenState();
}

class _GlobalSearchScreenState extends State<GlobalSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  final List<Map<String, String>> _contacts = [
    {'name': 'John Doe', 'sub': 'john.doe@gmail.com'},
    {'name': 'Emma Watson', 'sub': 'emma.watson@yahoo.com'},
    {'name': 'Steve Rogers', 'sub': 'steve.cap@shield.gov'},
    {'name': 'Bruce Banner', 'sub': 'hulk@avengers.org'},
    {'name': 'Tony Stark', 'sub': 'tony@starkindustries.com'},
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _payContact(String name) {
    double? transferAmount;
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
                'Send to $name',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 20.0),
              ),
              const SizedBox(height: AppSpacing.s8),
              const Text(
                'Enter transfer amount to credit their Payout balance instantly.',
                style: TextStyle(fontFamily: 'Inter', color: AppColors.textSecondary, fontSize: 13),
              ),
              const SizedBox(height: AppSpacing.s24),
              TextField(
                keyboardType: TextInputType.number,
                autofocus: true,
                onChanged: (val) {
                  transferAmount = double.tryParse(val);
                },
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                decoration: const InputDecoration(
                  prefixText: '\$ ',
                  hintText: '0.00',
                ),
              ),
              const SizedBox(height: AppSpacing.s24),
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  text: 'Send Funds',
                  onPressed: () {
                    if (transferAmount != null && transferAmount! > 0) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('\$${transferAmount!.toStringAsFixed(2)} transferred to $name.'),
                          backgroundColor: AppColors.success,
                        ),
                      );
                      Navigator.pop(context);
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
    final filtered = _contacts.where((c) {
      return c['name']!.toLowerCase().contains(_query.toLowerCase()) ||
          c['sub']!.toLowerCase().contains(_query.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Find Contacts'),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.s24),
            child: CustomSearchBar(
              controller: _searchController,
              hintText: 'Search by name or email...',
              onChanged: (val) {
                setState(() {
                  _query = val;
                });
              },
            ),
          ),
          const Divider(height: 1, color: AppColors.divider),
          Expanded(
            child: filtered.isEmpty
                ? const Center(
                    child: Text(
                      'No matching contacts found.',
                      style: TextStyle(fontFamily: 'Inter', color: AppColors.textSecondary),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24, vertical: AppSpacing.s12),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final contact = filtered[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.s8),
                        child: ListTile(
                          onTap: () => _payContact(contact['name']!),
                          leading: CustomAvatar(
                            name: contact['name']!,
                            size: 40,
                            backgroundColor: AppColors.primaryLight,
                            textColor: AppColors.primary,
                          ),
                          title: Text(
                            contact['name']!,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                            ),
                          ),
                          subtitle: Text(
                            contact['sub']!,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12.0,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 12,
                            color: AppColors.textSecondary,
                          ),
                          contentPadding: EdgeInsets.zero,
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
