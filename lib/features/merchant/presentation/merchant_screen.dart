import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/widgets.dart';
import 'package:payout/core/error/error_message_mapper.dart';
import 'package:payout/core/di/app_dependencies.dart';
import 'package:payout/features/bank_accounts/repositories/bank_account_repository.dart';
import 'package:payout/features/merchant/models/merchant_models.dart';
import 'package:payout/features/merchant/repositories/merchant_repository.dart';
import 'package:payout/features/merchant/presentation/merchant_profile_screen.dart';
import 'package:payout/features/merchant/presentation/merchant_transactions_screen.dart';
import 'package:payout/features/merchant/presentation/merchant_settlement_screen.dart';

class MerchantScreen extends StatefulWidget {
  final MerchantRepository? merchantRepository;
  final BankAccountRepository? bankAccountRepository;

  const MerchantScreen({
    super.key,
    this.merchantRepository,
    this.bankAccountRepository,
  });

  @override
  State<MerchantScreen> createState() => _MerchantScreenState();
}

class _MerchantScreenState extends State<MerchantScreen> {
  late final MerchantRepository _merchantRepo;
  late final BankAccountRepository _bankAccountRepo;
  MerchantProfileModel? _profile;
  MerchantSalesSummaryModel? _salesSummary;
  List<MerchantTransactionModel> _recentTransactions = [];
  List<MerchantOfferModel> _activeOffers = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _merchantRepo = widget.merchantRepository ?? AppDependencies.instance.merchantRepository;
    _bankAccountRepo = widget.bankAccountRepository ?? AppDependencies.instance.bankAccountRepository;
    _loadMerchantData();
  }

  Future<void> _loadMerchantData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final profile = await _merchantRepo.getMerchantProfile();
      final summary = await _merchantRepo.getSalesSummary();
      final txns = await _merchantRepo.getTransactions();
      final offers = await _merchantRepo.getOffers();

      if (mounted) {
        setState(() {
          _profile = profile;
          _salesSummary = summary;
          _recentTransactions = txns.take(3).toList();
          _activeOffers = offers;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = ErrorMessageMapper.map(e, fallback: 'Failed to load merchant console data. Please try again.');
          _isLoading = false;
        });
      }
    }
  }

  void _showQRCodeDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Store Static QR Code',
              style: TextStyle(fontFamily: 'Geist Sans', fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text(
              _profile?.storeName ?? 'Store QR Code',
              style: const TextStyle(fontFamily: 'Geist Sans', fontSize: 12, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.divider),
              ),
              child: const Icon(Icons.qr_code_2_rounded, size: 180, color: Colors.black87),
            ),
            const SizedBox(height: 12),
            Text(
              'UPI ID: ${_profile?.upiId ?? "merchant@payout"}',
              style: const TextStyle(fontFamily: 'Geist Sans', fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.primary),
            ),
            const SizedBox(height: 4),
            const Text(
              'Accept payments from Google Pay, PhonePe, Paytm, BHIM & all UPI apps.',
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'Geist Sans', fontSize: 10, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            PrimaryButton(
              text: 'Close',
              onPressed: () => Navigator.pop(ctx),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        appBar: CustomAppBar(title: 'Business Console'),
        body: Center(
          child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary)),
        ),
      );
    }

    if (_errorMessage != null || _profile == null || _salesSummary == null) {
      return Scaffold(
        appBar: const CustomAppBar(title: 'Business Console'),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.s24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline_rounded, size: 48, color: AppColors.error),
                const SizedBox(height: 16),
                Text(
                  _errorMessage ?? 'Merchant details unavailable',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontFamily: 'Geist Sans', fontSize: 14, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),
                PrimaryButton(
                  text: 'Retry',
                  onPressed: _loadMerchantData,
                ),
              ],
            ),
          ),
        ),
      );
    }

    final profile = _profile!;
    final summary = _salesSummary!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Business Console',
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_rounded, color: AppColors.textPrimary),
            tooltip: 'View QR Code',
            onPressed: _showQRCodeDialog,
          ),
          IconButton(
            icon: const Icon(Icons.storefront_rounded, color: AppColors.textPrimary),
            tooltip: 'Store Profile',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MerchantProfileScreen(merchantRepository: _merchantRepo),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.s24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Business Header Card
            AppCard(
              color: AppColors.primary,
              borderRadius: AppRadii.cardHero,
              padding: const EdgeInsets.all(AppSpacing.s20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              profile.storeName,
                              style: const TextStyle(
                                fontFamily: 'Geist Sans',
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${profile.businessCategory} • ${profile.city}',
                              style: const TextStyle(
                                fontFamily: 'Geist Sans',
                                fontSize: 11.0,
                                color: AppColors.primaryLight,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.success.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.success.withValues(alpha: 0.5), width: 1),
                        ),
                        child: Text(
                          profile.kycStatus.toUpperCase(),
                          style: const TextStyle(
                            fontFamily: 'Geist Sans',
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: Colors.white24, height: 1),
                  const SizedBox(height: 14),

                  // Sales Metrics Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Today's Store Sales",
                            style: TextStyle(fontFamily: 'Geist Sans', fontSize: 11, color: AppColors.primaryLight),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '₹${summary.todaySales.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontFamily: 'Geist Sans',
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            'Settlement Balance',
                            style: TextStyle(fontFamily: 'Geist Sans', fontSize: 11, color: AppColors.primaryLight),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '₹${summary.settlementPending.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontFamily: 'Geist Sans',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.amberAccent,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Instant Sweep Action Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MerchantSettlementScreen(
                              merchantRepository: _merchantRepo,
                              bankAccountRepository: _bankAccountRepo,
                            ),
                          ),
                        );
                        if (result == true) {
                          _loadMerchantData();
                        }
                      },
                      icon: const Icon(Icons.flash_on_rounded, size: 16, color: AppColors.primary),
                      label: const Text('Instant Sweep to Bank', style: TextStyle(fontFamily: 'Geist Sans', fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.primary)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.s24),

            // Merchant Hub Quick Actions Grid
            const Text(
              'Merchant Actions',
              style: TextStyle(
                fontFamily: 'Geist Sans',
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.s12),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.5,
              children: [
                _buildActionCard(
                  icon: Icons.qr_code_scanner_rounded,
                  title: 'Store Static QR Code',
                  subtitle: 'Download & print QR',
                  color: Colors.blue,
                  onTap: _showQRCodeDialog,
                ),
                _buildActionCard(
                  icon: Icons.receipt_long_rounded,
                  title: 'Store Transactions',
                  subtitle: '${summary.transactionCount} records today',
                  color: Colors.indigo,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MerchantTransactionsScreen(merchantRepository: _merchantRepo),
                      ),
                    );
                  },
                ),
                _buildActionCard(
                  icon: Icons.account_balance_rounded,
                  title: 'Settlement History',
                  subtitle: 'Instant sweep records',
                  color: Colors.teal,
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MerchantSettlementScreen(
                          merchantRepository: _merchantRepo,
                          bankAccountRepository: _bankAccountRepo,
                        ),
                      ),
                    );
                    if (result == true) {
                      _loadMerchantData();
                    }
                  },
                ),
                _buildActionCard(
                  icon: Icons.badge_rounded,
                  title: 'Business Profile',
                  subtitle: 'GST, KYC & Bank',
                  color: Colors.deepPurple,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MerchantProfileScreen(merchantRepository: _merchantRepo),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.s24),

            // Active Customer Offers
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Active Store Offers',
                  style: TextStyle(fontFamily: 'Geist Sans', fontSize: 15.0, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                Text(
                  '${_activeOffers.length} Active',
                  style: const TextStyle(fontFamily: 'Geist Sans', fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.s12),
            ..._activeOffers.map((offer) {
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.s12),
                child: AppCard(
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.s10),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(AppRadii.cardSmall),
                        ),
                        child: const Icon(Icons.local_offer_rounded, color: AppColors.primary, size: 22),
                      ),
                      const SizedBox(width: AppSpacing.s12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              offer.title,
                              style: const TextStyle(fontFamily: 'Geist Sans', fontWeight: FontWeight.bold, fontSize: 13),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Code: ${offer.code} • Min spend ₹${offer.minSpend.toInt()}',
                              style: const TextStyle(fontFamily: 'Geist Sans', fontSize: 11, color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.success.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${offer.discountPercent.toInt()}% OFF',
                          style: const TextStyle(fontFamily: 'Geist Sans', fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.success),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: AppSpacing.s24),

            // Recent Customer Payments
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent Store Payments',
                  style: TextStyle(
                    fontFamily: 'Geist Sans',
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MerchantTransactionsScreen(merchantRepository: _merchantRepo),
                      ),
                    );
                  },
                  child: const Text('View All', style: TextStyle(fontFamily: 'Geist Sans', fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.primary)),
                ),
              ],
            ),
            const SizedBox(height: 4),

            ..._recentTransactions.map((txn) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.s8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            txn.customerName,
                            style: const TextStyle(
                              fontFamily: 'Geist Sans',
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${txn.paymentMethod} • ${txn.dateTime}',
                            style: const TextStyle(
                              fontFamily: 'Geist Sans',
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '+₹${txn.amount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontFamily: 'Geist Sans',
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: AppColors.success,
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: AppSpacing.s32),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: AppCard(
        padding: const EdgeInsets.all(AppSpacing.s12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 6),
            Text(
              title,
              style: const TextStyle(fontFamily: 'Geist Sans', fontWeight: FontWeight.bold, fontSize: 12),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(fontFamily: 'Geist Sans', fontSize: 10, color: AppColors.textSecondary),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
