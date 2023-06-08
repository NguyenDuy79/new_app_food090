class PromoCode {
  final String id;
  final int reducePercent;
  final int reduceNumber;
  final int maximum;
  final int applyPrice;
  PromoCode(
      {required this.id,
      required this.applyPrice,
      required this.maximum,
      required this.reducePercent,
      required this.reduceNumber});
}

class ShippingPromoCode {
  final String id;

  final int maximum;
  final int applyPrice;
  ShippingPromoCode({
    required this.id,
    required this.applyPrice,
    required this.maximum,
  });
}
