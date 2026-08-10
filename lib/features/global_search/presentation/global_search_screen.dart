import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/search_bar.dart';
import 'package:payout/core/widgets/avatar.dart';
import 'package:payout/features/payments/presentation/amount_entry_screen.dart';

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
                      style: TextStyle(fontFamily: 'Geist Sans', color: AppColors.textSecondary),
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
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AmountEntryScreen(
                                  recipientName: contact['name']!,
                                  recipientDetail: contact['sub']!,
                                  recipientType: 'Contact',
                                ),
                              ),
                            );
                          },
                          leading: CustomAvatar(
                            name: contact['name']!,
                            size: 40,
                            backgroundColor: AppColors.primaryLight,
                            textColor: AppColors.primary,
                          ),
                          title: Text(
                            contact['name']!,
                            style: const TextStyle(
                              fontFamily: 'Geist Sans',
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                            ),
                          ),
                          subtitle: Text(
                            contact['sub']!,
                            style: const TextStyle(
                              fontFamily: 'Geist Sans',
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
