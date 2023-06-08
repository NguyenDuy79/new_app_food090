class ProductModel {
  late String id;
  late String kitchenId;
  late String imageUrl;
  late String price;
  late String intoduct;
  late String topping;
  late bool favorite;
  late String name;

  ProductModel(
      {required this.id,
      required this.imageUrl,
      required this.intoduct,
      required this.kitchenId,
      required this.name,
      required this.price,
      required this.topping,
      required this.favorite});
  ProductModel.formJson(Map<dynamic, dynamic> map) {
    id = map['id'];
    kitchenId = map['kitchenId'];
    imageUrl = map['image'];
    intoduct = map['intoduct'];
    price = map['price'];
    topping = map['topping'];
    favorite = map['favorite'];
    name = map['name'];
  }
}
