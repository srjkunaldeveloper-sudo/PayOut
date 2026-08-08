class RewardConstants {
  static const double maximumScratchReward = 1000.0;
  static const double minimumScratchReward = 5.0;

  static const List<String> couponCategories = [
    'All',
    'Shopping',
    'Food & Dining',
    'Travel & Flights',
    'Entertainment & Movies',
    'Electronics & Gadgets',
  ];

  static const List<String> rewardStatuses = [
    'AVAILABLE',
    'PENDING',
    'EXPIRED',
  ];

  static const List<String> scratchCardStatuses = [
    'UNSCRATCHED',
    'SCRATCHED',
    'EXPIRED',
  ];

  static const int pointsPerReferral = 500;
  static const List<String> rewardTypes = ['Cashback', 'Coupon', 'Scratch Card'];
  static const String couponExpiryRules = 'Coupons are valid for one-time redemption per user within the validity period.';
}
