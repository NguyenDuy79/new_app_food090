class ProductModel {
  late String id;
  late String imageUrl;
  late String price;
  late String intoduct;
  late String topping;

  late String name;

  ProductModel({
    required this.id,
    required this.imageUrl,
    required this.intoduct,
    required this.name,
    required this.price,
    required this.topping,
  });
  ProductModel.formJson(Map<dynamic, dynamic> map) {
    id = map['id'];
    imageUrl = map['image'];
    intoduct = map['intoduct'];
    price = map['price'];
    topping = map['topping'];

    name = map['name'];
  }
}
