import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  late String id;
  late String email;
  late String image;
  late String mobile;
  late bool partner;
  late String userName;
  UserModel(
      {required this.id,
      required this.email,
      required this.image,
      required this.mobile,
      this.partner = false,
      required this.userName});
  UserModel.fromJson(Map<String, dynamic> map) {
    id = map['id'];
    email = map['email'];
    image = map['image'];
    mobile = map['mobile'];
    userName = map['username'];
    partner = map['partner'];
  }
  Map<String, dynamic> toJon() {
    Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    data['image'] = image;
    data['mobile'] = mobile;
    data['userName'] = userName;
    data['partner'] = partner;
    return data;
  }
}

class SearchModel {
  late Timestamp id;
  late String query;

  SearchModel.fromJson(Map<String, dynamic> map) {
    id = map['id'];
    query = map['search value'];
  }
}
