class TravelService {
  static double calculateTotalCost({
    required double rate,
    required int quantity,
    double taxPercentage = 18.0,
    double discountAmount = 0.0,
  }) {
    if (rate <= 0 || quantity <= 0) return 0.0;
    final subtotal = rate * quantity;
    final tax = subtotal * (taxPercentage / 100);
    final total = subtotal + tax - discountAmount;
    return total < 0 ? 0.0 : total;
  }
}
