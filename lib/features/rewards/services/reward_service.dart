import 'package:payout/features/rewards/models/reward_models.dart';

class RewardService {
  static double calculateTotalCashback(List<CashbackModel> list) {
    return list
        .where((c) => c.status.toUpperCase() == 'AVAILABLE')
        .map((c) => c.amount)
        .fold(0.0, (sum, val) => sum + val);
  }

  static RewardSummaryModel calculateRewardSummary(
    List<CashbackModel> cashbacks,
    List<CouponModel> coupons,
  ) {
    final available = cashbacks
        .where((c) => c.status.toUpperCase() == 'AVAILABLE')
        .fold(0.0, (sum, c) => sum + c.amount);
    final pending = cashbacks
        .where((c) => c.status.toUpperCase() == 'PENDING')
        .fold(0.0, (sum, c) => sum + c.amount);
    final expired = cashbacks
        .where((c) => c.status.toUpperCase() == 'EXPIRED')
        .fold(0.0, (sum, c) => sum + c.amount);
    final total = available + pending;

    return RewardSummaryModel(
      totalCashback: total,
      availableCashback: available,
      pendingCashback: pending,
      expiredCashback: expired,
      totalCoupons: coupons.where((c) => c.isActive).length,
    );
  }

  static List<CouponModel> filterCoupons(
    List<CouponModel> coupons, {
    String? category,
    bool? onlyActive = true,
  }) {
    return coupons.where((c) {
      if (onlyActive == true && !c.isActive) return false;
      if (category != null && category != 'All' && category.isNotEmpty) {
        if (c.category.toLowerCase() != category.toLowerCase()) return false;
      }
      return true;
    }).toList();
  }

  static List<CashbackModel> filterCashbacks(
    List<CashbackModel> cashbacks, {
    String? status,
  }) {
    if (status == null || status == 'All' || status.isEmpty) {
      return List.from(cashbacks);
    }
    return cashbacks.where((c) => c.status.toUpperCase() == status.toUpperCase()).toList();
  }

  static double calculateDiscountAmount(CouponModel coupon, double cartAmount) {
    if (cartAmount < coupon.minimumSpend) return 0.0;
    if (coupon.discountType.toUpperCase() == 'FLAT') {
      return coupon.discountValue.clamp(0.0, cartAmount);
    } else {
      final percentageDiscount = (cartAmount * coupon.discountValue) / 100.0;
      return percentageDiscount.clamp(0.0, coupon.maximumDiscount);
    }
  }
}
