import 'package:flutter/material.dart';

class PayoutThemeExtension extends ThemeExtension<PayoutThemeExtension> {
  final TextStyle? amountLarge;
  final TextStyle? amountMedium;
  final TextStyle? amountSmall;

  final Color? income;
  final Color? expense;
  final Color? credit;
  final Color? debit;
  final Color? pending;
  final Color? failed;

  const PayoutThemeExtension({
    required this.amountLarge,
    required this.amountMedium,
    required this.amountSmall,
    required this.income,
    required this.expense,
    required this.credit,
    required this.debit,
    required this.pending,
    required this.failed,
  });

  @override
  PayoutThemeExtension copyWith({
    TextStyle? amountLarge,
    TextStyle? amountMedium,
    TextStyle? amountSmall,
    Color? income,
    Color? expense,
    Color? credit,
    Color? debit,
    Color? pending,
    Color? failed,
  }) {
    return PayoutThemeExtension(
      amountLarge: amountLarge ?? this.amountLarge,
      amountMedium: amountMedium ?? this.amountMedium,
      amountSmall: amountSmall ?? this.amountSmall,
      income: income ?? this.income,
      expense: expense ?? this.expense,
      credit: credit ?? this.credit,
      debit: debit ?? this.debit,
      pending: pending ?? this.pending,
      failed: failed ?? this.failed,
    );
  }

  @override
  PayoutThemeExtension lerp(ThemeExtension<PayoutThemeExtension>? other, double t) {
    if (other is! PayoutThemeExtension) {
      return this;
    }
    return PayoutThemeExtension(
      amountLarge: TextStyle.lerp(amountLarge, other.amountLarge, t),
      amountMedium: TextStyle.lerp(amountMedium, other.amountMedium, t),
      amountSmall: TextStyle.lerp(amountSmall, other.amountSmall, t),
      income: Color.lerp(income, other.income, t),
      expense: Color.lerp(expense, other.expense, t),
      credit: Color.lerp(credit, other.credit, t),
      debit: Color.lerp(debit, other.debit, t),
      pending: Color.lerp(pending, other.pending, t),
      failed: Color.lerp(failed, other.failed, t),
    );
  }
}
