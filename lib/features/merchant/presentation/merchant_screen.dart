import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/app_button.dart';
import 'package:payout/core/widgets/app_card.dart';
import 'package:payout/core/widgets/avatar.dart';

// 1. MERCHANT LANDING DASHBOARD
class MerchantScreen extends StatelessWidget {
  const MerchantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Business Console'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.s24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Business Sales Card
            AppCard(
              color: AppColors.primary,
              borderRadius: AppRadii.cardHero,
              padding: const EdgeInsets.all(AppSpacing.s24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Today\'s Business Sales',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12.0,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryLight,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '₹42,560.80',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 34.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Next automatic settlement at 06:00 AM tomorrow.',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11.0,
                      color: AppColors.primaryLight,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.s32),
            const Text(
              'Merchant Actions',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.s16),
            // Merchant static QR
            AppCard(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MerchantQRScreen()),
                );
              },
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.s12),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: const Icon(Icons.qr_code_2_rounded, color: AppColors.primary),
                  ),
                  const SizedBox(width: AppSpacing.s16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Store QR Code', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 14)),
                        Text('Display static UPI QR to accept customer cash', style: TextStyle(fontFamily: 'Inter', fontSize: 11, color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.s16),
            // Settlement info settings
            AppCard(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MerchantSettlementScreen()),
                );
              },
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.s12),
                    decoration: BoxDecoration(
                      color: Colors.indigo.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: const Icon(Icons.swap_horizontal_circle_rounded, color: Colors.indigo),
                  ),
                  const SizedBox(width: AppSpacing.s16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Settlements & Sweep', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 14)),
                        Text('Configure bank deposit & trigger manual sweeps', style: TextStyle(fontFamily: 'Inter', fontSize: 11, color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.s16),
            // Business Profile
            AppCard(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MerchantProfileScreen()),
                );
              },
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.s12),
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: const Icon(Icons.storefront_rounded, color: AppColors.success),
                  ),
                  const SizedBox(width: AppSpacing.s16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Business Profile', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 14)),
                        Text('GSTIN, KYC status, bank account & category', style: TextStyle(fontFamily: 'Inter', fontSize: 11, color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.s16),
            // Payout History
            AppCard(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MerchantSettlementHistoryScreen()),
                );
              },
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.s12),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: const Icon(Icons.history_rounded, color: Colors.orange),
                  ),
                  const SizedBox(width: AppSpacing.s16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Settlement History', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 14)),
                        Text('Review details of funds swept to bank accounts', style: TextStyle(fontFamily: 'Inter', fontSize: 11, color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.s32),
          ],
        ),
      ),
    );
  }
}

// 2. MERCHANT QR SCREEN
class MerchantQRScreen extends StatelessWidget {
  const MerchantQRScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Business QR'),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.s24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppCard(
                color: AppColors.surface,
                padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
                child: Column(
                  children: [
                    const CustomAvatar(
                      name: 'Organic Organics',
                      size: 56,
                      backgroundColor: AppColors.primaryLight,
                      textColor: AppColors.primary,
                    ),
                    const SizedBox(height: AppSpacing.s12),
                    const Text(
                      'Organic Organics Retailers',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 6.0),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Merchant ID: organic@payout',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s32),
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.s16),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.divider, width: 1.5),
                      ),
                      child: const Icon(
                        Icons.qr_code_2_rounded,
                        size: 220,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s24),
                    const Text(
                      'Accepts all UPI Apps (Google Pay, PhonePe, Paytm, BHIM)',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.s32),
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  text: 'Download Poster QR',
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Downloading High-Res Poster...')),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 3. MERCHANT SETTLEMENT SCREEN
class MerchantSettlementScreen extends StatefulWidget {
  const MerchantSettlementScreen({super.key});

  @override
  State<MerchantSettlementScreen> createState() => _MerchantSettlementScreenState();
}

class _MerchantSettlementScreenState extends State<MerchantSettlementScreen> {
  bool _isSweeping = false;

  void _triggerSweep() {
    setState(() {
      _isSweeping = true;
    });

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _isSweeping = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Instant sweep triggered! ₹42,560 will be credited to HDFC Bank.'),
            backgroundColor: AppColors.success,
          ),
        );
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Settlement Settings'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.s24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Settlement Destination Bank',
                style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: AppSpacing.s12),
              AppCard(
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryLight,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'H',
                        style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, color: AppColors.primary),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.s16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('HDFC Bank Ltd', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold)),
                          Text('Current A/c: •••• 9832', style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                    const Icon(Icons.check_circle_rounded, color: AppColors.success),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.s32),
              const Text(
                'Instant Settlement (Sweep)',
                style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: AppSpacing.s12),
              AppCard(
                padding: const EdgeInsets.all(AppSpacing.s20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Pending Balance: ₹42,560.80', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 15)),
                    SizedBox(height: 4),
                    Text('Transfer outstanding store balance to your bank account instantly. Standard sweeps are processed daily at 06:00 AM for free.',
                        style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.textSecondary, height: 1.4)),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  text: 'Instant Sweep to Bank',
                  isLoading: _isSweeping,
                  onPressed: _isSweeping ? null : _triggerSweep,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 4. BUSINESS PROFILE SCREEN
class MerchantProfileScreen extends StatelessWidget {
  const MerchantProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Business Profile'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.s24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Store Information',
              style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: AppSpacing.s12),
            AppCard(
              padding: const EdgeInsets.all(AppSpacing.s20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Legal Name', style: TextStyle(fontFamily: 'Inter', color: AppColors.textSecondary, fontSize: 12)),
                      SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          'Organic Organics Retailers Pvt Ltd',
                          textAlign: TextAlign.right,
                          style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.s12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Display Name', style: TextStyle(fontFamily: 'Inter', color: AppColors.textSecondary, fontSize: 12)),
                      Text('Organic Organics', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.s12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Category', style: TextStyle(fontFamily: 'Inter', color: AppColors.textSecondary, fontSize: 12)),
                      Text('Grocery & Retail Stores', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.s32),
            const Text(
              'Tax & Compliance',
              style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: AppSpacing.s12),
            AppCard(
              padding: const EdgeInsets.all(AppSpacing.s20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('GSTIN Number', style: TextStyle(fontFamily: 'Inter', color: AppColors.textSecondary, fontSize: 12)),
                      Text('07AAAAA1111A1Z1', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.s12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('PAN Number', style: TextStyle(fontFamily: 'Inter', color: AppColors.textSecondary, fontSize: 12)),
                      Text('AABCP8832K', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.s12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('KYC Verification', style: TextStyle(fontFamily: 'Inter', color: AppColors.textSecondary, fontSize: 12)),
                      Text('COMPLETED', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, color: AppColors.success, fontSize: 12)),
                    ],
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

// 5. SETTLEMENT HISTORY SCREEN
class MerchantSettlementHistoryScreen extends StatelessWidget {
  const MerchantSettlementHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> sweepLogs = [
      {'date': 'Aug 07, 2026', 'amount': 38240.00, 'ref': 'SETL908122', 'status': 'SETTLED'},
      {'date': 'Aug 06, 2026', 'amount': 45190.00, 'ref': 'SETL907765', 'status': 'SETTLED'},
      {'date': 'Aug 05, 2026', 'amount': 29870.00, 'ref': 'SETL906321', 'status': 'SETTLED'},
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Settlement History'),
      body: ListView.builder(
        padding: const EdgeInsets.all(AppSpacing.s24),
        itemCount: sweepLogs.length,
        itemBuilder: (context, index) {
          final log = sweepLogs[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.s12),
            child: AppCard(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Settled on ${log['date']}',
                        style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Ref: ${log['ref']}',
                        style: const TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '₹${(log['amount'] as double).toStringAsFixed(2)}',
                        style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.success.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          log['status'] as String,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: AppColors.success,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
