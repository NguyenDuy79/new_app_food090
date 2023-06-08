class KitchenModel {
  late String name;
  late String imageUrl;
  late String id;

  late String imagechefUrl;
  late String intoduct;
  late String ship;
  late String time;
  late String rating;

  KitchenModel(
      {required this.name,
      required this.imageUrl,
      required this.id,
      required this.imagechefUrl,
      required this.intoduct,
      required this.ship,
      required this.time,
      required this.rating});
  KitchenModel.formJson(Map<dynamic, dynamic> map) {
    name = map['Name'];
    imageUrl = map['Image'];
    imagechefUrl = map['imagechef'];
    intoduct = map['Intoduct'];
    ship = map['Ship'];
    time = map['Time'];
    id = map['id'];
    rating = map['rating'];
  }
}
