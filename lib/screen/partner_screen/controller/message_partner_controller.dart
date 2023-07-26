import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:new_ap/config/app_dimens.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:new_ap/model/chat_model.dart';
import 'package:new_ap/screen/partner_screen/widget/chat_detail_widget_partner/record_again_partner.dart';
import '../../../config/app_another.dart';
import '../../../config/firebase_api.dart';
import '../../../model/user_model.dart';

class MessagePartnerController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final RxBool _recording = false.obs;
  final recorder = FlutterSoundRecorder();
  late AudioPlayer audioPlayer;
  late AudioPlayer audioPlayerAgain;
  RxInt currentDuration = 0.obs;
  RxDouble percentDuration = 0.0.obs;
  RxInt totalDuration = 0.obs;
  RxInt currentDurationAgain = 0.obs;
  RxDouble percentDurationAgain = 0.0.obs;
  RxInt totalDurationAgain = 0.obs;
  final RxBool _isPlaying = false.obs;
  final RxBool _isPlayingAgain = false.obs;
  bool get isPlayingAgain => _isPlayingAgain.value;
  bool get isPlaying => _isPlaying.value;
  final RxInt _currenId = 0.obs;
  RxInt get currenId => _currenId;
  RxBool get recording => _recording;
  final Rx<List<ChatProfileModel>> _chatProfileUser =
      Rx<List<ChatProfileModel>>([]);
  List<ChatProfileModel> get chatProfileUser => _chatProfileUser.value;
  Rx<List<ChatModel>> chatContent = Rx<List<ChatModel>>([]);
  Rx<UserModel> user =
      UserModel(id: '', email: '', image: '', mobile: '', userName: '').obs;
  final RxBool _checkEmty = false.obs;
  bool get checkEmty => _checkEmty.value;
  File? _storeImage;
  String value = '';
  final RxInt _limit = 20.obs;
  int get limit => _limit.value;
  File? get storeImage => _storeImage;
  List<String> _listImage = [];
  List<String> get listImage => _listImage;
  final RxBool _visibilitySticker = false.obs;
  bool get visibilitySticker => _visibilitySticker.value;
  late TabController _controller;
  TabController get controller => _controller;
  final messageImageController = TextEditingController();
  final messageController = TextEditingController();
  final _focusNode = FocusNode();
  FocusNode get focusNode => _focusNode;
  Rx<ChatProfileModel> chatProfile = ChatProfileModel(
          name: '',
          image: '',
          id: '',
          insideChatGroup: false,
          isNotSeenMessage: 0,
          myNotSeenMessage: 0,
          timestamp: Timestamp.now())
      .obs;

  final List<Tab> myTabs = const [
    Tab(
      text: 'Đoạn chat',
    ),
    Tab(
      text: 'Cuộc gọi',
    )
  ];

  Future<void> changeLimit(String id) async {
    _limit.value = _limit.value + 20;
    log(_limit.value.toString());
    chatContent
        .bindStream(getChatContent(AppAnother.userAuth!.uid, id, _limit.value));
  }

  resetLimit() {
    _limit.value = 20;
  }

  @override
  void onInit() {
    audioPlayer = AudioPlayer();
    audioPlayer.setReleaseMode(ReleaseMode.loop);

    audioPlayer.onDurationChanged.listen((newDuration) {
      totalDuration.value = newDuration.inMicroseconds;
    });
    audioPlayer.onPositionChanged.listen((newPosition) {
      percentDuration.value = newPosition.inMicroseconds / totalDuration.value;
      currentDuration.value = newPosition.inMicroseconds;
    });
    audioPlayerAgain = AudioPlayer();
    audioPlayerAgain.setReleaseMode(ReleaseMode.stop);

    audioPlayerAgain.onDurationChanged.listen((newDuration) {
      totalDurationAgain.value = newDuration.inMicroseconds;
    });
    audioPlayerAgain.onPositionChanged.listen((newPosition) {
      percentDurationAgain.value =
          newPosition.inMicroseconds / totalDurationAgain.value;
      currentDurationAgain.value = newPosition.inMicroseconds;
    });
    _controller = TabController(length: 2, vsync: this);
    if (FirebaseAuth.instance.currentUser != null) {
      _chatProfileUser.bindStream(getProfileChat(AppAnother.userAuth!.uid));
    }
    super.onInit();
  }

  @override
  void onClose() {
    controller.dispose();
    messageController.dispose();
    recorder.closeRecorder();

    super.onClose();
  }

  Stream<List<ChatModel>> getChatContent(String uid, String id, int limit) {
    return FirebaseApi()
        .chatCollectionPartner(uid, id)
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .snapshots()
        .map((query) {
      List<ChatModel> listCartStream = [];
      if (query.docs.isNotEmpty) {
        for (int j = 0; j < query.docs.length; j++) {
          listCartStream.add(
              ChatModel.fromJson(query.docs[j].data() as Map<String, dynamic>));
        }
      }

      return listCartStream;
    });
  }

  Stream<UserModel> getUser(String uid) {
    return FirebaseApi().userCollection.doc(uid).snapshots().map((event) {
      UserModel userStream =
          UserModel.fromJson(event.data() as Map<String, dynamic>);
      return userStream;
    });
  }

  Stream<List<ChatProfileModel>> getProfileChat(String uid) {
    return FirebaseApi()
        .chatProfileCollectionPartner(uid)
        .snapshots()
        .map((QuerySnapshot query) {
      List<ChatProfileModel> listCartStream = [];
      if (query.docs.isNotEmpty) {
        for (int i = 0; i < query.docs.length; i++) {
          listCartStream.add(ChatProfileModel.fromJson(
              query.docs[i].data() as Map<String, dynamic>));
        }
      }

      return listCartStream;
    });
  }

  Stream<ChatProfileModel> getChatGroupProfile(String id) {
    return FirebaseApi()
        .chatProfileCollectionPartner(AppAnother.userAuth!.uid)
        .doc(id)
        .snapshots()
        .map((event) {
      ChatProfileModel value =
          ChatProfileModel.fromJson(event.data() as Map<String, dynamic>);
      return value;
    });
  }

  Future<void> changeStatusSeen(
      List<QueryDocumentSnapshot<Object?>> document, String id) async {
    if (AppAnother.userAuth != null) {
      for (int i = 0; i < document.length; i++) {
        await FirebaseApi()
            .chatCollectionPartner(AppAnother.userAuth!.uid, id)
            .doc(document[i]['id'].toString())
            .update({'my seen': true});

        await FirebaseApi()
            .chatCollection(id, AppAnother.userAuth!.uid)
            .doc(document[i]['id'].toString())
            .update({'is seen': true});
      }
    }
  }

  Future<void> changeNotSeenValue(String id) async {
    await FirebaseApi()
        .chatProfileCollectionPartner(AppAnother.userAuth!.uid)
        .doc(id)
        .update({'my not seen message': 0});
    await FirebaseApi()
        .chatProfileCollection(id)
        .doc(AppAnother.userAuth!.uid)
        .update({'is not seen message': 0});
  }

  Future<void> getChatDetailScreen(String id) async {
    if (AppAnother.userAuth != null) {
      await FirebaseApi()
          .chatProfileCollection(id)
          .doc(AppAnother.userAuth!.uid)
          .update({'inside chat group': true});
    }
  }

  Future<void> outChatDetailScreen(String id) async {
    if (AppAnother.userAuth != null) {
      await FirebaseApi()
          .chatProfileCollection(id)
          .doc(AppAnother.userAuth!.uid)
          .update({'inside chat group': false});
    }
  }

  String getContentChatInChatScreen(
      int type, String content, String name, bool isMe) {
    if (type == TypeMessage.text) {
      return isMe == true ? content : '$name: $content';
    } else if (type == TypeMessage.image) {
      if (content.contains('"')) {
        return isMe == true
            ? 'Bạn: Đã gửi ${content.split('"').length.toString()} ảnh'
            : '$name: Đã gửi ${content.split('"').length.toString()} ảnh';
      } else {
        return isMe == true ? 'Bạn: Đã gửi 1 ảnh' : '$name: Đã gửi 1 ảnh';
      }
    } else if (type == TypeMessage.sticker) {
      return isMe == true ? 'Bạn: Đã gửi 1 sticker' : '$name: Đã gửi 1 sticker';
    } else {
      return isMe == true
          ? 'Bạn: Đã gửi một tin nhắn thoại'
          : '$name: Đã gửi một tin nhắn thoại';
    }
  }

  // ĐẶt border radius cho chat bubble
  Radius getRadiusBottomRight(bool isMe, int index) {
    if ((index < chatContent.value.length - 1 && index > 0)) {
      var front = chatContent.value[index + 1].isMe;
      var behind = chatContent.value[index - 1].isMe;
      if (isMe == true) {
        if (behind == true && front == false) {
          return const Radius.circular(AppDimens.dimens_0);
        } else if (behind == false && front == true) {
          return const Radius.circular(AppDimens.dimens_12);
        } else if (behind == true && front == true) {
          return const Radius.circular(AppDimens.dimens_0);
        } else {
          return const Radius.circular(AppDimens.dimens_12);
        }
      } else {
        return const Radius.circular(AppDimens.dimens_12);
      }
    }
    if (index < chatContent.value.length - 1 && index == 0) {
      return const Radius.circular(12);
    } else if (index == chatContent.value.length - 1 && index > 0) {
      var behind = chatContent.value[index - 1].isMe;
      if (isMe == true) {
        if (behind == true) {
          return const Radius.circular(AppDimens.dimens_0);
        } else {
          return const Radius.circular(AppDimens.dimens_12);
        }
      } else {
        return const Radius.circular(AppDimens.dimens_12);
      }
    } else {
      return const Radius.circular(AppDimens.dimens_12);
    }
  }

  Radius getRadiusTopRight(bool isMe, int index) {
    if ((index < chatContent.value.length - 1 && index > 0)) {
      var front = chatContent.value[index + 1].isMe;
      var behind = chatContent.value[index - 1].isMe;
      if (isMe == true) {
        if (behind == true && front == false) {
          return const Radius.circular(AppDimens.dimens_12);
        } else if (behind == false && front == true) {
          return const Radius.circular(AppDimens.dimens_0);
        } else if (behind == true && front == true) {
          return const Radius.circular(AppDimens.dimens_0);
        } else {
          return const Radius.circular(AppDimens.dimens_12);
        }
      } else {
        return const Radius.circular(AppDimens.dimens_12);
      }
    }
    if (index < chatContent.value.length - 1 && index == 0) {
      var front = chatContent.value[index + 1].isMe;
      if (isMe == true) {
        if (front == true) {
          return const Radius.circular(AppDimens.dimens_0);
        } else {
          return const Radius.circular(AppDimens.dimens_12);
        }
      } else {
        return const Radius.circular(AppDimens.dimens_12);
      }
    } else if (index == chatContent.value.length - 1 && index > 0) {
      return const Radius.circular(AppDimens.dimens_12);
    } else {
      return const Radius.circular(AppDimens.dimens_12);
    }
  }

  Radius getRadiusBottomLeft(bool isMe, int index) {
    if ((index < chatContent.value.length - 1 && index > 0)) {
      var front = chatContent.value[index + 1].isMe;
      var behind = chatContent.value[index - 1].isMe;
      if (isMe == false) {
        if (behind == false && front == true) {
          return const Radius.circular(AppDimens.dimens_0);
        } else if (behind == true && front == false) {
          return const Radius.circular(AppDimens.dimens_12);
        } else if (behind == false && front == false) {
          return const Radius.circular(AppDimens.dimens_0);
        } else {
          return const Radius.circular(AppDimens.dimens_12);
        }
      } else {
        return const Radius.circular(AppDimens.dimens_12);
      }
    }
    if (index < chatContent.value.length - 1 && index == 0) {
      return const Radius.circular(12);
    } else if (index == chatContent.value.length - 1 && index > 0) {
      var behind = chatContent.value[index - 1].isMe;
      if (isMe == false) {
        if (behind == false) {
          return const Radius.circular(AppDimens.dimens_0);
        } else {
          return const Radius.circular(AppDimens.dimens_12);
        }
      } else {
        return const Radius.circular(AppDimens.dimens_12);
      }
    } else {
      return const Radius.circular(AppDimens.dimens_12);
    }
  }

  Radius getRadiusTopLeft(bool isMe, int index) {
    if ((index < chatContent.value.length - 1 && index > 0)) {
      var front = chatContent.value[index + 1].isMe;
      var behind = chatContent.value[index - 1].isMe;
      if (isMe == false) {
        if (behind == true && front == false) {
          return const Radius.circular(0);
        } else if (behind == false && front == true) {
          return const Radius.circular(12);
        } else if (behind == false && front == false) {
          return const Radius.circular(0);
        } else {
          return const Radius.circular(AppDimens.dimens_12);
        }
      } else {
        return const Radius.circular(AppDimens.dimens_12);
      }
    }
    if (index < chatContent.value.length - 1 && index == 0) {
      var front = chatContent.value[index + 1].isMe;
      if (isMe == false) {
        if (front == false) {
          return const Radius.circular(AppDimens.dimens_0);
        } else {
          return const Radius.circular(AppDimens.dimens_12);
        }
      } else {
        return const Radius.circular(AppDimens.dimens_12);
      }
    } else if (index == chatContent.value.length - 1 && index > 0) {
      return const Radius.circular(AppDimens.dimens_12);
    } else {
      return const Radius.circular(AppDimens.dimens_12);
    }
  }
  ////

  Future<void> submitNewMessage(String id, BuildContext ctx, String content,
      int type, int notSeen, bool insideChatGroup) async {
    Timestamp timestamp = Timestamp.now();
    String dateTime = DateTime.now().toString();
    if (FirebaseAuth.instance.currentUser != null) {
      try {
        if (type == TypeMessage.sticker) {
          _visibilitySticker.value = false;
        }
        ChatModel chatUser = ChatModel(
            content: content,
            id: dateTime,
            timestamp: timestamp,
            type: TypeMessage.text,
            isMe: false,
            isSeen: true,
            mySeen: false);
        ChatModel chatPartner = ChatModel(
            content: content,
            id: dateTime,
            timestamp: timestamp,
            type: TypeMessage.text,
            isMe: true,
            isSeen: false,
            mySeen: true);
        messageController.text = '';
        _checkEmty.value = false;
        await FirebaseApi()
            .chatCollectionPartner(FirebaseAuth.instance.currentUser!.uid, id)
            .doc(dateTime)
            .set(chatPartner.toJson())
            .then((value) async {
          await FirebaseApi()
              .chatProfileCollectionPartner(AppAnother.userAuth!.uid)
              .doc(id)
              .update({
            'is not seen message': notSeen + 1,
            'timestamp': timestamp,
          });
        });
        await FirebaseApi()
            .chatCollection(id, FirebaseAuth.instance.currentUser!.uid)
            .doc(dateTime)
            .set(chatUser.toJson())
            .then((value) async {
          await FirebaseApi()
              .chatProfileCollection(id)
              .doc(AppAnother.userAuth!.uid)
              .update({
            'timestamp': timestamp,
            'my not seen message': notSeen + 1,
          });
        });
        if (insideChatGroup == true) {
          await FirebaseApi()
              .chatCollection(id, AppAnother.userAuth!.uid)
              .doc(dateTime)
              .update({'my seen': true});
          await FirebaseApi()
              .chatProfileCollection(id)
              .doc(AppAnother.userAuth!.uid)
              .update({'my not seen message': 0});
          await FirebaseApi()
              .chatCollectionPartner(AppAnother.userAuth!.uid, id)
              .doc(dateTime)
              .update({'is seen': true});

          await FirebaseApi()
              .chatProfileCollectionPartner(AppAnother.userAuth!.uid)
              .doc(id)
              .update({'is not seen message': 0});
        }
      } on PlatformException catch (err) {
        var message = 'An error, try again';
        if (err.message != null) {
          message = err.message!;
        }
        ScaffoldMessenger.of(ctx).hideCurrentSnackBar();
        ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(ctx).colorScheme.error,
        ));
      } catch (err) {
        ScaffoldMessenger.of(ctx).hideCurrentSnackBar();
        ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
          content: Text(err.toString()),
          backgroundColor: Theme.of(ctx).colorScheme.error,
        ));
      }
    }
  }

  submitMultiImage(
      String id, BuildContext ctx, int notSeen, bool insideChatGroup) async {
    Timestamp timestamp = Timestamp.now();
    String dateTime = DateTime.now().toString();
    if (AppAnother.userAuth != null) {
      if (imageFileList.isNotEmpty) {
        try {
          String content = '';
          var count = 0;
          for (int i = 0; i < imageFileList.length; i++) {
            File file = File(imageFileList[i].path);
            var ref = FirebaseStorage.instance.ref().child('image_message').child(
                '${AppAnother.userAuth!.uid}-$id:${DateTime.now().toString()}.png');
            await ref.putFile(file);
            final url = await ref.getDownloadURL();
            if (i == 0) {
              content = content + url;
            } else {
              content = '$content"$url';
            }

            count++;
            log(count.toString());
          }
          ChatModel chatUser = ChatModel(
              content: content,
              id: dateTime,
              timestamp: timestamp,
              type: TypeMessage.image,
              isMe: false,
              isSeen: true,
              mySeen: false);
          ChatModel chatPartner = ChatModel(
              content: content,
              id: dateTime,
              timestamp: timestamp,
              type: TypeMessage.image,
              isMe: true,
              isSeen: false,
              mySeen: true);
          await FirebaseApi()
              .chatCollectionPartner(FirebaseAuth.instance.currentUser!.uid, id)
              .doc(dateTime)
              .set(chatPartner.toJson())
              .then((value) async {
            await FirebaseApi()
                .chatProfileCollectionPartner(AppAnother.userAuth!.uid)
                .doc(id)
                .update({
              'timestamp': timestamp,
              'is not seen message': notSeen + 1,
            });
          });
          await FirebaseApi()
              .chatCollection(id, FirebaseAuth.instance.currentUser!.uid)
              .doc(dateTime)
              .set(chatUser.toJson())
              .then((value) async {
            await FirebaseApi()
                .chatProfileCollection(id)
                .doc(AppAnother.userAuth!.uid)
                .update({
              'timestamp': timestamp,
              'my not seen message': notSeen + 1,
            });
            imageFileList.clear();
          });
          if (insideChatGroup == true) {
            await FirebaseApi()
                .chatCollection(id, AppAnother.userAuth!.uid)
                .doc(dateTime)
                .update({'my seen': true});
            await FirebaseApi()
                .chatProfileCollection(id)
                .doc(AppAnother.userAuth!.uid)
                .update({'my not seen message': 0});
            await FirebaseApi()
                .chatCollectionPartner(AppAnother.userAuth!.uid, id)
                .doc(dateTime)
                .update({'is seen': true});

            await FirebaseApi()
                .chatProfileCollectionPartner(AppAnother.userAuth!.uid)
                .doc(id)
                .update({'is not seen message': 0});
          }
        } on PlatformException catch (err) {
          var message = 'An error, try again';
          if (err.message != null) {
            message = err.message!;
          }
          ScaffoldMessenger.of(ctx).hideCurrentSnackBar();
          ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
            content: Text(message),
            backgroundColor: Theme.of(ctx).colorScheme.error,
          ));
        } catch (err) {
          ScaffoldMessenger.of(ctx).hideCurrentSnackBar();
          ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
            content: Text(err.toString()),
            backgroundColor: Theme.of(ctx).colorScheme.error,
          ));
        }
      }
    }
  }

  Future<void> submitData(String id, BuildContext ctx, int type, int notSeen,
      bool insideChatGroup) async {
    Timestamp timestamp = Timestamp.now();
    String dateTime = DateTime.now().toString();
    if (FirebaseAuth.instance.currentUser != null) {
      if (type == 1 ? _storeImage != null : audioFile != null) {
        try {
          var ref = type == 1
              ? FirebaseStorage.instance.ref().child('image_message').child(
                  '${FirebaseAuth.instance.currentUser!.uid}-$id:${DateTime.now().toString()}.png')
              : FirebaseStorage.instance.ref().child('record_message').child(
                  '${FirebaseAuth.instance.currentUser!.uid}-$id:${DateTime.now().toString()}.mp3');

          await ref.putFile(type == 1 ? _storeImage! : audioFile!);
          final url = await ref.getDownloadURL();

          ChatModel chatUser = ChatModel(
              content: url,
              id: dateTime,
              timestamp: timestamp,
              type: type,
              isMe: false,
              isSeen: true,
              mySeen: false);
          ChatModel chatPartner = ChatModel(
              content: url,
              id: dateTime,
              timestamp: timestamp,
              type: type,
              isMe: true,
              isSeen: false,
              mySeen: true);
          await FirebaseApi()
              .chatCollectionPartner(FirebaseAuth.instance.currentUser!.uid, id)
              .doc(dateTime)
              .set(chatPartner.toJson())
              .then((value) async {
            await FirebaseApi()
                .chatProfileCollectionPartner(AppAnother.userAuth!.uid)
                .doc(id)
                .update({
              'timestamp': timestamp,
              'is not seen message': notSeen + 1
            });
          });
          await FirebaseApi()
              .chatCollection(id, FirebaseAuth.instance.currentUser!.uid)
              .doc(dateTime)
              .set(chatUser.toJson())
              .then((value) async {
            await FirebaseApi()
                .chatProfileCollection(id)
                .doc(AppAnother.userAuth!.uid)
                .update({
              'timestamp': timestamp,
              'my not seen message': notSeen + 1,
            });
            _storeImage = null;
          });
          if (insideChatGroup == true) {
            await FirebaseApi()
                .chatCollection(id, AppAnother.userAuth!.uid)
                .doc(dateTime)
                .update({'my seen': true});
            await FirebaseApi()
                .chatProfileCollection(id)
                .doc(AppAnother.userAuth!.uid)
                .update({'my not seen message': 0});
            await FirebaseApi()
                .chatCollectionPartner(AppAnother.userAuth!.uid, id)
                .doc(dateTime)
                .update({'is seen': true});

            await FirebaseApi()
                .chatProfileCollectionPartner(AppAnother.userAuth!.uid)
                .doc(id)
                .update({'is not seen message': 0});
          }
        } on PlatformException catch (err) {
          var message = 'An error, try again';
          if (err.message != null) {
            message = err.message!;
          }
          ScaffoldMessenger.of(ctx).hideCurrentSnackBar();
          ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
            content: Text(message),
            backgroundColor: Theme.of(ctx).colorScheme.error,
          ));
        } catch (err) {
          ScaffoldMessenger.of(ctx).hideCurrentSnackBar();
          ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
            content: Text(err.toString()),
            backgroundColor: Theme.of(ctx).colorScheme.error,
          ));
        }
      }
    }
  }

  Future<void> takePictureCamera() async {
    final imageFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );
    if (imageFile == null) {
      return;
    }
    _storeImage = File(imageFile.path);
  }

  final List<XFile> imageFileList = [];
  Future<void> takePictureGallery() async {
    final List<XFile> listImage = await ImagePicker().pickMultiImage();
    if (listImage.isEmpty) {
      return;
    }
    imageFileList.addAll(listImage);
    log(imageFileList.length.toString());
  }

  Image getImage() {
    if (_storeImage != null) {
      return Image.file(
        storeImage!,
        fit: BoxFit.cover,
      );
    } else {
      return Image.asset('assets/image/camera.jpg');
    }
  }

  int getCrossCount(int count) {
    if (count == 2) {
      return 2;
    } else {
      return 3;
    }
  }

  double getHeight(int count, double width) {
    if (count == 2) {
      return width * 0.75 / 2;
    } else {
      if (count % 3 == 0) {
        return width * 0.25 * (count / 3);
      } else {
        return width * 0.25 * (count ~/ 3 + 1);
      }
    }
  }

  void onPressPlayButton(int id, String content, int duration) async {
    currenId.value = id;
    if (isPlaying) {
      await _pauseRecord(duration).then((value) async {
        if (currenId.value == id) {
        } else {
          currentDuration.value = 0;
          _isPlaying.value = true;
          await audioPlayer.play(UrlSource(content));
        }
      });
    } else {
      currentDuration.value = 0;
      _isPlaying.value = true;
      await audioPlayer.play(UrlSource(content));
    }
  }

  void onPressPlayButtonListenAgane(int duration) async {
    if (isPlayingAgain) {
      audioPlayerAgain.pause();
      audioPlayerAgain.seek(Duration(microseconds: duration));
      _isPlayingAgain.value = false;
    } else {
      await audioPlayerAgain.resume();
      _isPlayingAgain.value = true;
    }
  }

  _pauseRecord(int duration) {
    _isPlaying.value = false;
    audioPlayer.pause();
    audioPlayer.seek(Duration(microseconds: duration));
  }

  checkEmtyTextField(String value) {
    if (value.isNotEmpty) {
      _checkEmty.value = true;
    } else {
      _checkEmty.value = false;
    }
  }

  Rx<RecordingDisposition> time = RecordingDisposition.zero().obs;
  Stream<RecordingDisposition> timeSteam() {
    return recorder.onProgress!;
  }

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final house = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return [if (duration.inHours > 0) house, minutes, seconds].join(':');
  }

  Future<void> start() async {
    time = RecordingDisposition.zero().obs;
    var dateTime = Timestamp.now().toString();

    await recorder.openRecorder();
    recorder.setSubscriptionDuration(const Duration(milliseconds: 500));
    _recording.value = true;
    await recorder.startRecorder(toFile: dateTime);
    time.bindStream(timeSteam());
  }

  File? audioFile;
  String? path;
  Future<void> stop() async {
    path = await recorder.stopRecorder();
    audioFile = File(path!);
    await recorder.closeRecorder();

    _recording.value = false;
  }

  visibilityStickerWidget() {
    if (visibilitySticker) {
      _visibilitySticker.value = false;
    } else {
      _visibilitySticker.value = true;
    }
  }

  void getBottomSheet(
      BuildContext context, String id, int notSeen, bool insideChatGroup) {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AppDimens.dimens_25),
                topRight: Radius.circular(AppDimens.dimens_25))),
        context: context,
        builder: (_) => SizedBox(
            height: 230,
            child: ListenAgainPartner(notSeen, id, insideChatGroup)));
  }

  resetImagePicker() {
    _storeImage = null;
  }

  setListImage() {
    _listImage = [];
    for (int i = 0; i < chatContent.value.length; i++) {
      if (chatContent.value[i].type == TypeMessage.image) {
        if (chatContent.value[i].content.contains('"')) {
          for (int j = chatContent.value[i].content.split('"').length - 1;
              j >= 0;
              j--) {
            _listImage.add(chatContent.value[i].content.split('"')[j]);
          }
        } else {
          _listImage.add(chatContent.value[i].content);
        }
      }
    }
  }

  // image click
  final RxBool _gestureUp = false.obs;
  bool get gestureUp => _gestureUp.value;
  final RxDouble _height = 0.0.obs;
  double get height => _height.value;

  final RxDouble _height1 = 0.0.obs;
  double get height1 => _height1.value;

  final RxBool _isFill = true.obs;
  bool get isFill => _isFill.value;

  setHeight(double value) {
    _height.value = value;
  }

  reduceHeight(double value) {
    _height.value -= value;
  }

  setHeight1(double value) {
    _height1.value = value;
  }

  reduceHeight1(double value) {
    _height1.value -= value;
  }

  setFalseGestureUp() {
    _gestureUp.value = false;
  }

  setTrueGestureUp() {
    _gestureUp.value = true;
  }

  changeStatusFill() {
    if (isFill) {
      _isFill.value = false;
    } else {
      _isFill.value = true;
    }
  }

  resetFill() {
    _isFill.value = true;
  }

  bool returnValue(DateTime dateTime, DateTime dateTime1) {
    return dateTime.day == dateTime1.day &&
        dateTime.month == dateTime1.month &&
        dateTime.year == dateTime1.year;
  }

  bool getCircleAvatar(int index, Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();

    if (index > 0 && index < chatContent.value.length) {
      DateTime dateTime1 = chatContent.value[index - 1].timestamp.toDate();
      if (returnValue(dateTime, dateTime1) &&
          !chatContent.value[index - 1].isMe) {
        return false;
      } else {
        return true;
      }
    } else {
      return true;
    }
  }

  bool getSeenWidget(int index) {
    if (index > 0) {
      if (chatContent.value[index].isSeen == true) {
        if (chatContent.value[index - 1].isSeen == true) {
          return false;
        } else {
          return true;
        }
      } else {
        return false;
      }
    } else {
      if (chatContent.value[index].isSeen == true) {
        return true;
      } else {
        return false;
      }
    }
  }
}
