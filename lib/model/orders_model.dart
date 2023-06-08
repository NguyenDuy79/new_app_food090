class OrderModel {
  late String id;
  late List<String> name;
  late List<String> productId;
  late int price;
  late List<int> quantity;
  late String shippingCode;
  late String promoCode;
  late List<String> url;
  late String kitchenId;
  late String status;
  late String statusDelivery;
  OrderModel(
      {required this.id,
      required this.name,
      required this.productId,
      required this.price,
      required this.kitchenId,
      required this.promoCode,
      required this.quantity,
      required this.shippingCode,
      required this.status,
      required this.statusDelivery,
      required this.url});
  OrderModel.fromJson(Map<String, dynamic> map) {
    id = map['id'];
    kitchenId = map['kitchenId'];
    name = List.from(map['name']);
    price = map['price'];
    quantity = List.from(map['quantity']);
    productId = List.from(map['product']);
    url = List.from(map['url']);
    shippingCode = map['shippingCode'];
    promoCode = map['promoCode'];
    status = map['status'];
    statusDelivery = map['status delivery'];
  }
}
