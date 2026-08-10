import 'package:flutter/material.dart';
import 'package:payout/core/widgets/widgets.dart';
import 'package:payout/features/bills/models/bill_models.dart';
import 'package:payout/features/bills/presentation/review_bill_screen.dart';

class BillDetailsScreen extends StatelessWidget {
  final BillModel bill;

  const BillDetailsScreen({
    super.key,
    required this.bill,
  });

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.of(context).canPop();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                if (canPop)
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.arrow_back_rounded,
                        color: Color(0xFF3F37C9),
                        size: 20,
                      ),
                    ),
                  ),
                const Expanded(
                  child: Center(
                    child: Text(
                      'Bill Details',
                      style: TextStyle(
                        fontFamily: 'Geist Sans',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F1F1F),
                      ),
                    ),
                  ),
                ),
                if (canPop)
                  const SizedBox(width: 38)
                else
                  const SizedBox(width: 16),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Outstanding Balance',
                style: TextStyle(
                  fontFamily: 'Geist Sans',
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F1F1F),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF002E6E).withValues(alpha: 0.02),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      '₹${bill.amount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontFamily: 'Geist Sans',
                        fontSize: 32.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F1F1F),
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEF4444).withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'DUE BY ${bill.dueDate}',
                        style: const TextStyle(
                          fontFamily: 'Geist Sans',
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFEF4444),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              const Text(
                'Account Details',
                style: TextStyle(
                  fontFamily: 'Geist Sans',
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F1F1F),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF002E6E).withValues(alpha: 0.02),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildDetailRow('Provider / Biller', bill.billerName),
                    const Divider(color: Color(0xFFE2E8F0)),
                    _buildDetailRow('Consumer ID', bill.consumerNumber),
                    const Divider(color: Color(0xFFE2E8F0)),
                    _buildDetailRow('Consumer Name', bill.consumerName),
                    const Divider(color: Color(0xFFE2E8F0)),
                    _buildDetailRow('Bill Number', bill.billNumber),
                    const Divider(color: Color(0xFFE2E8F0)),
                    _buildDetailRow('Bill Date', bill.billDate),
                    const Divider(color: Color(0xFFE2E8F0)),
                    _buildDetailRow('Late Fee', '₹${bill.lateFee.toStringAsFixed(2)}'),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              PrimaryButton(
                text: 'Continue to Pay',
                height: 52,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReviewBillScreen(
                        bill: bill,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontFamily: 'Geist Sans', color: Color(0xFF64748B), fontSize: 13)),
          Text(value, style: const TextStyle(fontFamily: 'Geist Sans', fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1F1F1F))),
        ],
      ),
    );
  }
}
