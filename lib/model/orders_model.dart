import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  late String id;
  late List<String> name;
  late List<String> productId;
  late int price;
  late List<int> quantity;
  late String shippingCode;
  late String promoCode;
  late List<String> url;
  late List<String> productPrice;
  late String reduce;
  late String reduceShip;
  late String kitchenId;
  late String kitchenName;
  late String status;
  late String statusDelivery;
  late String uid;
  late String ship;
  late String timeOne;
  late String timeTwo;
  late String timeThree;
  late String timeFour;
  late Timestamp timeStamp;
  OrderModel(
      {required this.id,
      required this.name,
      required this.timeStamp,
      required this.ship,
      required this.timeOne,
      required this.timeTwo,
      required this.timeThree,
      required this.timeFour,
      required this.productId,
      required this.price,
      required this.reduce,
      required this.reduceShip,
      required this.productPrice,
      required this.kitchenId,
      required this.kitchenName,
      required this.promoCode,
      required this.uid,
      required this.quantity,
      required this.shippingCode,
      required this.status,
      required this.statusDelivery,
      required this.url});
  OrderModel.fromJson(Map<String, dynamic> map) {
    id = map['id'];
    ship = map['ship'];
    kitchenId = map['kitchenId'];
    name = List.from(map['name']);
    price = map['totalPrice'];
    timeOne = map['timeOne'];
    timeTwo = map['timeTwo'];
    timeThree = map['timeThree'];
    timeFour = map['timeFour'];
    kitchenName = map['kitchenName'];
    quantity = List.from(map['quantity']);
    productId = List.from(map['product']);
    url = List.from(map['url']);
    uid = map['uid'];
    shippingCode = map['shippingCode'];
    promoCode = map['promoCode'];
    status = map['status'];
    statusDelivery = map['status delivery'];
    productPrice = List.from(map['productPrice']);
    reduce = map['reduce'];
    reduceShip = map['reduceShip'];
    timeStamp = map['timeStamp'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['ship'] = ship;
    data['kitchenId'] = kitchenId;
    data['kitchenName'] = kitchenName;
    data['uid'] = uid;
    data['shippingCode'] = shippingCode;
    data['promoCode'] = promoCode;
    data['status'] = status;
    data['status delivery'] = statusDelivery;
    data['reduce'] = reduce;
    data['reduceShip'] = reduceShip;
    data['timeStamp'] = timeStamp;
    data['timeOne'] = timeOne;
    data['timeTwo'] = timeTwo;
    data['timeThree'] = timeThree;
    data['timeFour'] = timeFour;
    data['totalPrice'] = price;
    data['name'] = FieldValue.arrayUnion(name);
    data['product'] = FieldValue.arrayUnion(productId);
    data['url'] = FieldValue.arrayUnion(url);
    return data;
  }
}
