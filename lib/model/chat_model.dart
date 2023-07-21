import 'package:cloud_firestore/cloud_firestore.dart';

class ChatProfileModel {
  late String name;
  late String image;
  late String id;
  ChatProfileModel({required this.name, required this.image, required this.id});
  ChatProfileModel.fromJson(Map<String, dynamic> map) {
    name = map['userName'];
    image = map['userImage'];
    id = map['id'];
  }
}

class ChatModel {
  late String content;
  late Timestamp id;
  late bool isMe;
  late bool seen;
  late int type;
  ChatModel(
      {required this.content,
      required this.id,
      required this.type,
      required this.isMe,
      required this.seen});
  ChatModel.fromJson(Map<String, dynamic> map) {
    content = map['content'];
    id = map['id'];
    type = map['type'];
    isMe = map['isMe'];
    seen = map['seen'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['content'] = content;
    data['type'] = type;
    data['isMe'] = isMe;
    data['seen'] = seen;
    return data;
  }
}

class TypeMessage {
  TypeMessage._();
  static const text = 0;
  static const image = 1;
  static const sticker = 2;
  static const record = 3;
}
