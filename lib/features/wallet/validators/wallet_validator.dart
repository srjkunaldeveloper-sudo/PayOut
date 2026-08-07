import 'package:payout/features/wallet/constants/wallet_constants.dart';

class WalletValidationResult {
  final bool isValid;
  final String? errorMessage;

  const WalletValidationResult({required this.isValid, this.errorMessage});
}

class WalletValidator {
  static WalletValidationResult validateAmount(double? amount) {
    if (amount == null || amount <= 0) {
      return const WalletValidationResult(isValid: false, errorMessage: 'Amount must be greater than zero.');
    }
    return const WalletValidationResult(isValid: true);
  }

  static WalletValidationResult validateWalletBalance(double balance, double withdrawAmount) {
    if (withdrawAmount > balance) {
      return const WalletValidationResult(isValid: false, errorMessage: 'Insufficient balance in your Payout wallet.');
    }
    return const WalletValidationResult(isValid: true);
  }

  static WalletValidationResult validateAddMoney(double amount) {
    final amountVal = validateAmount(amount);
    if (!amountVal.isValid) return amountVal;

    if (amount < WalletConstants.minimumAddMoney) {
      return const WalletValidationResult(
        isValid: false,
        errorMessage: 'Minimum amount to add is ${WalletConstants.currencySymbol}${WalletConstants.minimumAddMoney}.',
      );
    }
    if (amount > WalletConstants.maximumAddMoney) {
      return const WalletValidationResult(
        isValid: false,
        errorMessage: 'Maximum amount to add in a single transaction is ${WalletConstants.currencySymbol}${WalletConstants.maximumAddMoney}.',
      );
    }
    return const WalletValidationResult(isValid: true);
  }

  static WalletValidationResult validateWithdraw(double amount, double balance) {
    final amountVal = validateAmount(amount);
    if (!amountVal.isValid) return amountVal;

    final balanceVal = validateWalletBalance(balance, amount);
    if (!balanceVal.isValid) return balanceVal;

    if (amount < WalletConstants.minimumWithdraw) {
      return const WalletValidationResult(
        isValid: false,
        errorMessage: 'Minimum amount to withdraw is ${WalletConstants.currencySymbol}${WalletConstants.minimumWithdraw}.',
      );
    }
    if (amount > WalletConstants.maximumWithdraw) {
      return const WalletValidationResult(
        isValid: false,
        errorMessage: 'Maximum amount to withdraw in a single transaction is ${WalletConstants.currencySymbol}${WalletConstants.maximumWithdraw}.',
      );
    }
    return const WalletValidationResult(isValid: true);
  }

  static WalletValidationResult validateDailyLimit(double currentDailyTotal, double amount) {
    if (currentDailyTotal + amount > WalletConstants.dailyTransactionLimit) {
      return const WalletValidationResult(
        isValid: false,
        errorMessage: 'Transaction exceeds daily wallet limit of ${WalletConstants.currencySymbol}${WalletConstants.dailyTransactionLimit}.',
      );
    }
    return const WalletValidationResult(isValid: true);
  }
}
