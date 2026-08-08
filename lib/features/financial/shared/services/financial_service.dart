import 'dart:math';
import 'package:payout/features/financial/shared/models/financial_models.dart';

class FinancialService {
  static LoanEmiCalculation calculateEMI(double principal, double rateAnnual, int months, {double processingFeePercent = 1.5}) {
    if (principal <= 0 || rateAnnual <= 0 || months <= 0) {
      return const LoanEmiCalculation(
        monthlyEmi: 0.0,
        totalInterest: 0.0,
        totalRepayment: 0.0,
        processingFee: 0.0,
      );
    }
    final rateMonthly = rateAnnual / (12 * 100);
    final emi = (principal * rateMonthly * pow(1 + rateMonthly, months)) / (pow(1 + rateMonthly, months) - 1);
    final totalRepayment = emi * months;
    final totalInterest = totalRepayment - principal;
    final processingFee = (principal * processingFeePercent) / 100;

    return LoanEmiCalculation(
      monthlyEmi: double.parse(emi.toStringAsFixed(2)),
      totalInterest: double.parse(totalInterest.toStringAsFixed(2)),
      totalRepayment: double.parse(totalRepayment.toStringAsFixed(2)),
      processingFee: double.parse(processingFee.toStringAsFixed(2)),
    );
  }

  static InsuranceQuoteModel calculateInsurancePremium({
    required String policyId,
    required double basePremium,
    required int age,
    int memberCount = 1,
  }) {
    double ageFactor = 1.0;
    if (age > 45) {
      ageFactor = 1.35;
    } else if (age > 30) {
      ageFactor = 1.15;
    }
    final membersFactor = memberCount > 1 ? (1.0 + (memberCount - 1) * 0.4) : 1.0;
    final subtotal = basePremium * ageFactor * membersFactor;
    final taxAmount = subtotal * 0.18; // 18% GST
    final finalPremium = subtotal + taxAmount;

    return InsuranceQuoteModel(
      policyId: policyId,
      basePremium: double.parse(basePremium.toStringAsFixed(2)),
      ageFactor: double.parse(ageFactor.toStringAsFixed(2)),
      taxAmount: double.parse(taxAmount.toStringAsFixed(2)),
      finalPremium: double.parse(finalPremium.toStringAsFixed(2)),
    );
  }
}
