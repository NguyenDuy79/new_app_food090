class PromoCode {
  late final String id;
  late final int reducePercent;
  late final int reduceNumber;
  late final int maximum;
  late final int applyPrice;
  late final String image;
  PromoCode(
      {required this.id,
      required this.applyPrice,
      required this.maximum,
      required this.reducePercent,
      required this.reduceNumber});
  PromoCode.fromJson(Map<String, dynamic> map) {
    id = map['id'];
    reduceNumber = map['reduce number'];
    reducePercent = map['reduce percent'];
    maximum = map['maximum'];
    applyPrice = map['apply price'];
    image = map['image'];
  }
}

class ShippingPromoCode {
  late final String id;

  late final int maximum;
  late final int applyPrice;
  ShippingPromoCode({
    required this.id,
    required this.applyPrice,
    required this.maximum,
  });
  ShippingPromoCode.formJson(Map<String, dynamic> map) {
    id = map['id'];
    maximum = map['maximum'];
    applyPrice = map['apply price'];
  }
}
