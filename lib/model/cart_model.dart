class CartModel {
  late String id;
  late int quantity;
  late String price;
  late String name;
  late String url;
  late String kitchenId;
  late String productId;
  CartModel(
      {required this.id,
      required this.name,
      required this.price,
      required this.quantity,
      required this.url,
      required this.kitchenId,
      required this.productId});
  CartModel.fromJson(Map<String, dynamic> map) {
    id = map['id'];
    quantity = map['quantity'];
    price = map['price'];
    name = map['name'];
    url = map['url'];
    kitchenId = map['kitchenId'];
    productId = map['productId'];
  }
}
