import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';
import 'package:payout/core/widgets/app_bar.dart';
import 'package:payout/core/widgets/widgets.dart';
import 'package:payout/features/financial/shared/models/financial_models.dart';

class FinancialSuccessScreen extends StatelessWidget {
  final LoanApplicationModel application;

  const FinancialSuccessScreen({
    super.key,
    required this.application,
  });

  @override
  Widget build(BuildContext context) {
    final isApproved = application.status == 'APPROVED';
    final isPending = application.status == 'PENDING';

    Color statusColor = isApproved ? AppColors.success : (isPending ? Colors.orange : AppColors.error);
    IconData statusIcon = isApproved
        ? Icons.check_circle_rounded
        : (isPending ? Icons.hourglass_top_rounded : Icons.cancel_rounded);
    String statusTitle = isApproved
        ? 'Loan Application Approved'
        : (isPending ? 'Application Under Review' : 'Application Not Approved');
    String statusSubtitle = isApproved
        ? 'Congratulations! Your loan request has been sanctioned. Disbursal initiated.'
        : (isPending
            ? 'We are reviewing your income records. You will receive an update in 2 hours.'
            : (application.rejectionReason ?? 'Your profile did not meet the credit approval criteria.'));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: isApproved ? 'Application Approved' : (isPending ? 'Under Review' : 'Status'),
        showLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.s24),
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.s16),
              Center(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.s20),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.08),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(statusIcon, size: 56, color: statusColor),
                    ),
                    const SizedBox(height: AppSpacing.s16),
                    Text(
                      statusTitle,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.s8),
                    Text(
                      statusSubtitle,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13.0,
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (isApproved) ...[
                      const SizedBox(height: AppSpacing.s20),
                      Text(
                        '₹${application.requestedAmount.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 32.0,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Sanctioned Amount',
                        style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.textSecondary),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.s28),

              // Application Details Card
              AppCard(
                child: Column(
                  children: [
                    _buildDetailRow('Application ID', application.id),
                    const Divider(color: AppColors.divider),
                    _buildDetailRow('Loan Product', application.loanTitle),
                    const Divider(color: AppColors.divider),
                    _buildDetailRow('Applicant', application.applicantName),
                    const Divider(color: AppColors.divider),
                    _buildDetailRow('Tenure', '${application.tenureMonths} Months'),
                    const Divider(color: AppColors.divider),
                    _buildDetailRow('Monthly EMI', '₹${application.monthlyEmi.toStringAsFixed(2)}'),
                    const Divider(color: AppColors.divider),
                    _buildDetailRow('Processing Fee', '₹${application.processingFee.toStringAsFixed(2)}'),
                    const Divider(color: AppColors.divider),
                    _buildDetailRow('Total Repayment', '₹${application.totalRepayment.toStringAsFixed(2)}'),
                    const Divider(color: AppColors.divider),
                    _buildDetailRow('Status', application.status, valueColor: statusColor),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.s32),

              // Bottom Actions
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  text: isApproved ? 'Done' : (isPending ? 'Check Status Later' : 'Try Another Product'),
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.s16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontFamily: 'Inter', color: AppColors.textSecondary, fontSize: 12)),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: valueColor ?? AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
