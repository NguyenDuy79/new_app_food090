import 'package:cloud_firestore/cloud_firestore.dart';

class ChatProfileModel {
  late String name;
  late String image;
  late String id;
  late bool insideChatGroup;
  late int myNotSeenMessage;
  late Timestamp timestamp;
  late int isNotSeenMessage;
  ChatProfileModel({
    required this.name,
    required this.image,
    required this.id,
    required this.insideChatGroup,
    required this.isNotSeenMessage,
    required this.myNotSeenMessage,
    required this.timestamp,
  });
  ChatProfileModel.fromJson(Map<String, dynamic> map) {
    name = map['userName'];
    image = map['userImage'];
    id = map['id'];
    insideChatGroup = map['inside chat group'];
    myNotSeenMessage = map['my not seen message'];
    isNotSeenMessage = map['is not seen message'];
    timestamp = map['timestamp'];
  }
}

class ChatModel {
  late String content;
  late String id;
  late Timestamp timestamp;
  late bool isMe;
  late bool isSeen;

  late bool mySeen;
  late int type;
  ChatModel(
      {required this.content,
      required this.id,
      required this.type,
      required this.timestamp,
      required this.isMe,
      required this.mySeen,
      required this.isSeen});
  ChatModel.fromJson(Map<String, dynamic> map) {
    content = map['content'];
    id = map['id'];
    type = map['type'];
    isMe = map['isMe'];
    mySeen = map['my seen'];
    isSeen = map['is seen'];
    timestamp = map['timestamp'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['content'] = content;
    data['type'] = type;
    data['isMe'] = isMe;
    data['my seen'] = mySeen;
    data['is seen'] = isSeen;
    data['timestamp'] = timestamp;
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
