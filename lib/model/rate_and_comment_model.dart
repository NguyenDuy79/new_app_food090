import 'package:cloud_firestore/cloud_firestore.dart';

class RateAndCommentModel {
  late String id;
  late Timestamp timestamp;
  late int rate;
  late String comment;
  late String kitchenOrUserId;
  late String kitchenOrUserName;
  late String kitchenOrUserImage;
  late List<String> name;
  late List<int> quantity;
  late int like;
  late List<String> listLike;
  RateAndCommentModel(
      {required this.id,
      required this.comment,
      required this.timestamp,
      required this.kitchenOrUserId,
      required this.kitchenOrUserImage,
      required this.kitchenOrUserName,
      required this.like,
      required this.name,
      required this.quantity,
      required this.listLike,
      required this.rate});
  RateAndCommentModel.fromJson(Map<String, dynamic> map) {
    id = map['id'];
    timestamp = map['timestamp'];
    comment = map['comment'];
    kitchenOrUserId = map['kitchen or user id'];
    kitchenOrUserImage = map['kitchen or user image'];
    kitchenOrUserName = map['kitchen or user name'];
    name = List.from(map['productName']);
    quantity = List.from(map['quantity']);
    like = map['like'];
    rate = map['rate'];
    listLike = List.from(map['list like']);
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['timestamp'] = timestamp;
    data['comment'] = comment;
    data['like'] = like;
    data['kitchen or user id'] = kitchenOrUserId;
    data['kitchen or user image'] = kitchenOrUserImage;
    data['kitchen or user name'] = kitchenOrUserName;
    data['productName'] = FieldValue.arrayUnion(name);
    data['list like'] = FieldValue.arrayUnion(listLike);
    data['rate'] = rate;
    return data;
  }
}
