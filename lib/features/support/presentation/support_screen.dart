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
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  bool _isSubmitting = false;

  final List<Map<String, String>> _faqs = [
    {
      'q': 'How do I complete my KYC verification?',
      'a': 'Go to Profile -> KYC Status, and upload your Aadhaar and PAN documents. Verification takes up to 24 hours.'
    },
    {
      'q': 'My transaction failed but money was deducted.',
      'a': 'UPI refunds are processed automatically by banking networks within 3 to 5 business days to your bank account.'
    },
    {
      'q': 'How do I sweep my store balance to my bank?',
      'a': 'Merchant sweeps are initiated instantly by clicking the "Instant Sweep to Bank" button on the Business Console page.'
    },
  ];

  void _submitTicket() {
    if (_subjectController.text.isEmpty) return;
    setState(() {
      _isSubmitting = true;
    });

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Support Ticket raised successfully! Code: TC-8092'),
            backgroundColor: AppColors.success,
          ),
        );
        _subjectController.clear();
        _descController.clear();
      }
    });
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Customer Support'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.s24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Instant Contact Options
            const Text(
              'Direct Helpdesk',
              style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: AppSpacing.s12),
            Row(
              children: [
                Expanded(
                  child: AppCard(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Opening WhatsApp Support chat...')),
                      );
                    },
                    child: Column(
                      children: const [
                        Icon(Icons.chat_bubble_outline_rounded, color: Colors.green, size: 28),
                        SizedBox(height: 8),
                        Text('WhatsApp', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 13)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.s12),
                Expanded(
                  child: AppCard(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Dialing Support hotline: 1800-PAYOUT...')),
                      );
                    },
                    child: Column(
                      children: const [
                        Icon(Icons.phone_in_talk_rounded, color: AppColors.primary, size: 28),
                        SizedBox(height: 8),
                        Text('Call Toll-Free', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 13)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.s32),
            // FAQs Expandable accordion list
            const Text(
              'Frequently Asked Questions',
              style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: AppSpacing.s12),
            AppCard(
              padding: EdgeInsets.zero,
              child: ExpansionPanelList.radio(
                elevation: 0,
                children: _faqs.map((faq) {
                  return ExpansionPanelRadio(
                    value: faq['q']!,
                    headerBuilder: (context, isExpanded) {
                      return ListTile(
                        title: Text(
                          faq['q']!,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13.0,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      );
                    },
                    body: Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                      child: Text(
                        faq['a']!,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12.0,
                          color: AppColors.textSecondary,
                          height: 1.4,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: AppSpacing.s32),
            // Raise Ticket Form
            const Text(
              'Raise Support Ticket',
              style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: AppSpacing.s12),
            AppCard(
              padding: const EdgeInsets.all(AppSpacing.s20),
              child: Column(
                children: [
                  TextField(
                    controller: _subjectController,
                    decoration: const InputDecoration(
                      labelText: 'Subject Issue',
                      prefixIcon: Icon(Icons.subject_rounded),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s16),
                  TextField(
                    controller: _descController,
                    decoration: const InputDecoration(
                      labelText: 'Elaborate details',
                      prefixIcon: Icon(Icons.edit_note_rounded),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: AppSpacing.s20),
                  SizedBox(
                    width: double.infinity,
                    child: AppButton(
                      text: 'Submit Ticket',
                      isLoading: _isSubmitting,
                      onPressed: _submitTicket,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.s16),
            // Track Complaint
            AppCard(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('No active complaints found.')),
                );
              },
              child: Row(
                children: const [
                  Icon(Icons.assignment_turned_in_rounded, color: AppColors.primary),
                  SizedBox(width: AppSpacing.s16),
                  Expanded(
                    child: Text(
                      'Track Complaint Status',
                      style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ),
                  Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.s40),
          ],
        ),
      ),
    );
  }
}
