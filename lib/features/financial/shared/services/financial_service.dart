import 'dart:math';

class FinancialService {
  static double calculateEMI(double principal, double rateAnnual, int months) {
    if (principal <= 0 || rateAnnual <= 0 || months <= 0) return 0.0;
    final rateMonthly = rateAnnual / (12 * 100);
    final emi = (principal * rateMonthly * pow(1 + rateMonthly, months)) / (pow(1 + rateMonthly, months) - 1);
    return emi;
  }
}
