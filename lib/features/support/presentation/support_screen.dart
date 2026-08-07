import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/app_button.dart';
import 'package:payout/core/widgets/app_card.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  final List<Map<String, String>> _faqs = [
    {
      'q': 'How long does a bank transfer take?',
      'a': 'Standard bank transfers typically settle within 1-2 business days. Real-time transfers are credited instantly.'
    },
    {
      'q': 'Are there any fees for loading my wallet?',
      'a': 'No. Payout does not charge any processing fees for loading cash balances from linked checking accounts.'
    },
    {
      'q': 'How do I upgrade my KYC limit?',
      'a': 'Go to your Profile page, click on KYC Status, and upload a valid government-issued ID card.'
    },
  ];

  void _showTicketSheet() {
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
                'Raise a Support Ticket',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 20.0),
              ),
              const SizedBox(height: AppSpacing.s8),
              const Text(
                'Describe your issue and our operations team will reach out within 24 hours.',
                style: TextStyle(fontFamily: 'Inter', color: AppColors.textSecondary, fontSize: 13),
              ),
              const SizedBox(height: AppSpacing.s20),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Subject',
                  hintText: 'e.g. Transaction failure',
                ),
              ),
              const SizedBox(height: AppSpacing.s12),
              const TextField(
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Description',
                  hintText: 'Enter details about your issue...',
                ),
              ),
              const SizedBox(height: AppSpacing.s24),
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  text: 'Submit Ticket',
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Support ticket submitted successfully.'),
                        backgroundColor: AppColors.success,
                      ),
                    );
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
      appBar: const CustomAppBar(title: 'Help & Support'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.s24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Get in touch',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.s12),
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.phone_in_talk_rounded, color: AppColors.primary),
                    title: const Text(
                      'Call Support Hotline',
                      style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                    subtitle: const Text('1-800-PAY-OUT (Mon-Fri)'),
                    onTap: () {},
                  ),
                  const Divider(height: 1, color: AppColors.divider),
                  ListTile(
                    leading: const Icon(Icons.mail_outline_rounded, color: AppColors.primary),
                    title: const Text(
                      'Email Customer Helpdesk',
                      style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                    subtitle: const Text('support@payout.app'),
                    onTap: () {},
                  ),
                  const Divider(height: 1, color: AppColors.divider),
                  ListTile(
                    leading: const Icon(Icons.chat_bubble_outline_rounded, color: AppColors.primary),
                    title: const Text(
                      'Chat on WhatsApp',
                      style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                    subtitle: const Text('Available 24/7 for urgent help'),
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.s32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Frequently Asked Questions',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                TextButton(
                  onPressed: _showTicketSheet,
                  child: const Text(
                    'Raise Ticket',
                    style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.s12),
            ..._faqs.map((faq) {
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.s12),
                child: AppCard(
                  child: ExpansionTile(
                    title: Text(
                      faq['q']!,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    tilePadding: EdgeInsets.zero,
                    childrenPadding: const EdgeInsets.only(top: 8.0),
                    shape: const Border(),
                    collapsedShape: const Border(),
                    children: [
                      Text(
                        faq['a']!,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13.0,
                          color: AppColors.textSecondary,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
            const SizedBox(height: AppSpacing.s40),
          ],
        ),
      ),
    );
  }
}
