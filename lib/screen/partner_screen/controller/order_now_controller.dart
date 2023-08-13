import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:new_ap/common_app/common_widget.dart';
import 'package:new_ap/config/app_string.dart';
import 'package:new_ap/config/firebase_api.dart';
import 'package:new_ap/model/chat_model.dart';
import 'package:new_ap/model/orders_model.dart';
import 'package:new_ap/screen/partner_screen/controller/partner_controller.dart';
import 'package:new_ap/screen/partner_screen/view/pages/camera_picker_screen.dart';
import '../../../config/app_another.dart';
import '../../../config/app_dimens.dart';
import '../../../model/user_model.dart';

class OrderNowController extends GetxController {
  final Rx<List<OrderModel>> _order = Rx<List<OrderModel>>([]);
  final Rx<List<OrderModel>> _orderActive = Rx<List<OrderModel>>([]);
  List<OrderModel> get order => _order.value;
  List<OrderModel> get orderActive => _orderActive.value;
  RxInt status = 0.obs;

  String url = '';
  File? _storeImage;
  File? get storeImage => _storeImage;
  UserModel _user = UserModel(
    id: '',
    email: '',
    image: '',
    mobile: '',
    userName: '',
  );
  UserModel _userPartner = UserModel(
    id: '',
    email: '',
    image: '',
    mobile: '',
    userName: '',
  );
  UserModel get userPartner => _userPartner;
  UserModel get user => _user;
  final RxBool _isLoadingData = false.obs;
  bool get isLoadingData => _isLoadingData.value;

  @override
  void onInit() {
    _order.bindStream(orderNowStream());
    if (FirebaseAuth.instance.currentUser != null) {
      _orderActive.bindStream(orderActiveStream());
      _historySearch.bindStream(getStreamHisrtory(AppAnother.userAuth!.uid));
    }
    super.onInit();
  }

  Stream<List<OrderModel>> orderNowStream() {
    return FirebaseApi()
        .orderNow
        .orderBy('timeStamp', descending: true)
        .snapshots()
        .map((QuerySnapshot query) {
      List<OrderModel> listOrderStream = [];

      if (FirebaseAuth.instance.currentUser != null) {
        if (query.docs.isNotEmpty) {
          if ((query.docs[0].data() as Map<String, dynamic>)['quantity'] !=
                  null &&
              (query.docs[0].data() as Map<String, dynamic>)['productPrice'] !=
                  null) {
            for (int i = 0; i < query.docs.length; i++) {
              if ((query.docs[i].data() as Map<String, dynamic>)['uid'] !=
                  FirebaseAuth.instance.currentUser!.uid) {
                listOrderStream.add(OrderModel.fromJson(
                    query.docs[i].data() as Map<String, dynamic>));
              }
            }
          }
        } else {
          status.value = 0;
        }
      }

      return listOrderStream;
    });
  }

  Stream<List<OrderModel>> orderActiveStream() {
    return FirebaseApi()
        .orderPartner(FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .map((QuerySnapshot query) {
      List<OrderModel> listOrderStream = [];
      if (query.docs.isNotEmpty) {
        if ((query.docs[0].data() as Map<String, dynamic>)['quantity'] !=
                null &&
            (query.docs[0].data() as Map<String, dynamic>)['productPrice'] !=
                null) {
          if ((query.docs[0].data() as Map<String, dynamic>)['billImage'] !=
              null) {
            url = (query.docs[0].data() as Map<String, dynamic>)['billImage'];
          }

          for (int i = 0; i < query.docs.length; i++) {
            listOrderStream.add(OrderModel.fromJson(
                query.docs[i].data() as Map<String, dynamic>));
          }
          if (listOrderStream.isNotEmpty) {
            if (listOrderStream[0].statusDelivery ==
                AppString.statusDelivery[0]) {
              status.value = 1;
            } else if (listOrderStream[0].statusDelivery ==
                AppString.statusDelivery[1]) {
              status.value = 2;
            } else if (listOrderStream[0].statusDelivery ==
                AppString.statusDelivery[2]) {
              status.value = 3;
            } else if (listOrderStream[0].statusDelivery ==
                AppString.statusDelivery[3]) {
              status.value = 4;
            } else {
              status.value = 0;
            }
          }
        }
      }

      return listOrderStream;
    });
  }

  Future<void> refreshIndicator() async {
    _order.bindStream(orderNowStream());
  }

  getUser(String uid, UserModel user) async {}

  int getprice(List<String> price, List<int> quantity) {
    var totalPrice = 0;
    for (int i = 0; i < price.length; i++) {
      totalPrice = totalPrice + int.parse(price[i]) * quantity[i];
    }
    return totalPrice;
  }

  getTrueLoading() {
    _isLoadingData.value = true;
  }

  getFalseLoading() {
    _isLoadingData.value = false;
  }

  getDialog(BuildContext ctx) {
    showDialog(
        context: ctx,
        builder: (ctx) => AlertDialog(
                title: const Text(
                  'Có đơn hàng chưa hoàn thành',
                  style: TextStyle(fontSize: AppDimens.dimens_22),
                ),
                content: const Text(
                  'Hãy hoàn thành đơn hàng hiện có rồi mới tiếp tục nhận đơn mới',
                  style: TextStyle(
                      fontSize: AppDimens.dimens_25,
                      fontWeight: FontWeight.bold),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: const Text('Close'),
                  ),
                ]));
  }

  chooseOrder(OrderModel orderChoose, BuildContext ctx) async {
    if (FirebaseAuth.instance.currentUser != null) {
      try {
        var dateTime = DateTime.now();
        var timeStamp = Timestamp.now();
        OrderModel newOrder = OrderModel(
            id: orderChoose.id,
            name: orderChoose.name,
            timeStamp: orderChoose.timeStamp,
            ship: orderChoose.ship,
            timeOne: timeStamp,
            timeTwo: orderChoose.timeTwo,
            timeThree: orderChoose.timeThree,
            timeFour: orderChoose.timeFour,
            productId: orderChoose.productId,
            price: orderChoose.price,
            reduce: orderChoose.reduce,
            reduceShip: orderChoose.reduceShip,
            productPrice: orderChoose.productPrice,
            kitchenId: orderChoose.kitchenId,
            partnerId: AppAnother.userAuth!.uid,
            kitchenName: orderChoose.kitchenName,
            promoCode: orderChoose.promoCode,
            uid: orderChoose.uid,
            cancelOrder: orderChoose.cancelOrder,
            quantity: orderChoose.quantity,
            shippingCode: orderChoose.shippingCode,
            status: orderChoose.status,
            statusDelivery: AppString.statusDelivery[0],
            url: orderChoose.url);
        ChatModel chatUser = ChatModel(
          content: 'Tôi đã nhận đơn hàng',
          timestamp: timeStamp,
          id: dateTime.toString(),
          type: TypeMessage.text,
          isMe: false,
          isSeen: true,
          mySeen: false,
        );
        ChatModel chatPartner = ChatModel(
            content: 'Tôi đã nhận đơn hàng',
            timestamp: timeStamp,
            id: dateTime.toString(),
            type: TypeMessage.text,
            isMe: true,
            mySeen: true,
            isSeen: false);
        Map<String, List> getQuantity = {'quantity': orderChoose.quantity};
        Map<String, List> getPrice = {'productPrice': orderChoose.productPrice};
        _isLoadingData.value = true;
        CommonWidget.showDialogLoading(ctx);
        await FirebaseApi().getUser(orderChoose.uid).then((value) {
          _user = UserModel.fromJson(value.data() as Map<String, dynamic>);
        });
        await FirebaseApi()
            .getUser(FirebaseAuth.instance.currentUser!.uid)
            .then((value) {
          _userPartner =
              UserModel.fromJson(value.data() as Map<String, dynamic>);
        });
        await FirebaseApi()
            .partner
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('orderProgress')
            .doc(orderChoose.id)
            .set(newOrder.toJson())
            .then((value) async {
          await FirebaseApi()
              .partner
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection('orderProgress')
              .doc(orderChoose.id)
              .update(getQuantity);
          await FirebaseApi()
              .partner
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection('orderProgress')
              .doc(orderChoose.id)
              .update(getPrice);
        }).then((value) async {
          await FirebaseApi()
              .chatProfileCollectionPartner(AppAnother.userAuth!.uid)
              .doc(orderChoose.uid)
              .set({
            'id': orderChoose.uid,
            'userImage': _user.image,
            'userName': _user.userName,
            'timestamp': timeStamp,
            'is not seen message': 1,
            'my not seen message': 0,
            'inside chat group': false,
            'online': true
          }).then((value) async {
            await FirebaseApi()
                .chatCollectionPartner(
                    AppAnother.userAuth!.uid, orderChoose.uid)
                .doc(dateTime.toString())
                .set(chatPartner.toJson());
          });
        }).catchError((e) => throw e);
        await FirebaseApi()
            .orderCollection(orderChoose.uid)
            .doc(orderChoose.id)
            .update({
          'status delivery': AppString.statusDelivery[0],
          'timeOne': timeStamp,
          'partnerId': AppAnother.userAuth!.uid
        }).then((value) async {
          await FirebaseApi()
              .userCollection
              .doc(orderChoose.uid)
              .collection('chat')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .set({
            'id': FirebaseAuth.instance.currentUser!.uid,
            'userImage': _userPartner.image,
            'userName': _userPartner.userName,
            'timestamp': timeStamp,
            'my not seen message': 1,
            'is not seen message': 0,
            'inside chat group': false,
            'online': false,
          });
        }).then((value) async {
          await FirebaseApi()
              .userCollection
              .doc(orderChoose.uid)
              .collection('chat')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection('content')
              .doc(dateTime.toString())
              .set(chatUser.toJson());
        }).then((value) {
          _isLoadingData.value = false;
          if (!isLoadingData) {
            Get.back();
          }
          Get.find<PartnerController>().selectPage(1);

          FirebaseApi().orderNow.doc(orderChoose.id).delete();
        }).catchError((e) => throw e);
      } on PlatformException catch (err) {
        _isLoadingData.value = false;
        Get.back();
        log(err.message.toString());

        CommonWidget.showErrorDialog(ctx);
      } catch (err) {
        _isLoadingData.value = false;
        Get.back();

        CommonWidget.showErrorDialog(ctx);
      }
    }
  }

  String getText() {
    if (status.value == 1) {
      return 'Order at the shop';
    } else if (status.value == 2) {
      return 'Carry out delivery';
    } else if (status.value == 3) {
      return 'Successful delivery';
    } else if (status.value == 4) {
      return 'order completion';
    } else {
      return 'Nhận đơn';
    }
  }

  statusDeliveryMethod(BuildContext ctx) async {
    Timestamp timestamp = Timestamp.now();
    if (status.value == 1) {
      Get.to(() {
        return CameraPicker();
      });
    } else if (status.value == 2) {
      try {
        CommonWidget.showDialogLoading(ctx);
        await FirebaseApi()
            .orderPartner(FirebaseAuth.instance.currentUser!.uid)
            .doc(_orderActive.value[0].id)
            .update({
          'status delivery': AppString.statusDelivery3,
          'timeThree': timestamp
        }).then((value) {
          Get.back();
          FirebaseApi()
              .orderCollection(_orderActive.value[0].uid)
              .doc(_orderActive.value[0].id)
              .update({
            'status delivery': AppString.statusDelivery3,
            'timeThree': timestamp
          });
        });
      } on PlatformException catch (err) {
        Get.back();
        log(err.message.toString());

        CommonWidget.showErrorDialog(ctx);
      } catch (err) {
        Get.back();

        CommonWidget.showErrorDialog(ctx);
      }
    } else if (status.value == 3) {
      try {
        CommonWidget.showDialogLoading(ctx);
        await FirebaseApi()
            .orderPartner(FirebaseAuth.instance.currentUser!.uid)
            .doc(_orderActive.value[0].id)
            .update({
          'status delivery': AppString.statusDelivery4,
          'timeFour': timestamp,
        }).then((value) {
          Get.back();
          FirebaseApi()
              .orderCollection(_orderActive.value[0].uid)
              .doc(_orderActive.value[0].id)
              .update({
            'status delivery': AppString.statusDelivery4,
            'timeFour': timestamp,
          });
        });
        Get.back();
      } on PlatformException catch (err) {
        Get.back();
        log(err.message.toString());

        CommonWidget.showErrorDialog(ctx);
      } catch (err) {
        Get.back();

        CommonWidget.showErrorDialog(ctx);
      }
    } else if (status.value == 4) {
      if (AppAnother.userAuth != null) {
        try {
          CommonWidget.showDialogLoading(ctx);
          OrderModel newOrder = OrderModel(
              id: _orderActive.value[0].id,
              name: _orderActive.value[0].name,
              timeStamp: _orderActive.value[0].timeStamp,
              ship: _orderActive.value[0].ship,
              partnerId: _orderActive.value[0].partnerId,
              timeOne: _orderActive.value[0].timeOne,
              timeTwo: _orderActive.value[0].timeTwo,
              timeThree: _orderActive.value[0].timeThree,
              timeFour: _orderActive.value[0].timeFour,
              productId: _orderActive.value[0].productId,
              price: _orderActive.value[0].price,
              reduce: _orderActive.value[0].reduce,
              cancelOrder: _orderActive.value[0].cancelOrder,
              reduceShip: _orderActive.value[0].reduceShip,
              productPrice: _orderActive.value[0].productPrice,
              kitchenId: _orderActive.value[0].kitchenId,
              kitchenName: _orderActive.value[0].kitchenName,
              promoCode: _orderActive.value[0].promoCode,
              uid: _orderActive.value[0].uid,
              quantity: _orderActive.value[0].quantity,
              shippingCode: _orderActive.value[0].shippingCode,
              status: 'Completed',
              statusDelivery: AppString.statusDelivery[3],
              url: _orderActive.value[0].url);
          Map<String, dynamic> getProductPrice = {
            'productPrice': _orderActive.value[0].productPrice
          };
          Map<String, List> getQuantity = {
            'quantity': _orderActive.value[0].quantity
          };
          await FirebaseApi()
              .partner
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection('orderCompleted')
              .doc(_orderActive.value[0].id)
              .set(newOrder.toJson())
              .then((value) async {
            await FirebaseApi()
                .partner
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .collection('orderCompleted')
                .doc(_orderActive.value[0].id)
                .update(getQuantity);
            await FirebaseApi()
                .partner
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .collection('orderCompleted')
                .doc(_orderActive.value[0].id)
                .update({'billImage': url});
            await FirebaseApi()
                .partner
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .collection('orderCompleted')
                .doc(_orderActive.value[0].id)
                .update(getProductPrice);
            Get.back();
            Get.find<PartnerController>().selectPage(3);
            Get.toNamed('/partner');
            await FirebaseApi()
                .orderPartner(AppAnother.userAuth!.uid)
                .doc(_orderActive.value[0].id)
                .delete();
            url = '';
            status.value = 0;
          });
        } on PlatformException catch (err) {
          Get.back();
          log(err.message.toString());

          CommonWidget.showErrorDialog(ctx);
        } catch (err) {
          Get.back();

          CommonWidget.showErrorDialog(ctx);
        }
      }
    }
  }

  Future<void> takePictureCamera() async {
    final imageFile = await ImagePicker()
        .pickImage(source: ImageSource.camera, maxHeight: 400, maxWidth: 400);
    if (imageFile == null) {
      return;
    }
    _storeImage = File(imageFile.path);
    update();
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

  getBack() {
    _storeImage = null;
  }

  getImageBill(BuildContext ctx) async {
    Timestamp dateTime = Timestamp.now();
    if (FirebaseAuth.instance.currentUser != null) {
      if (_storeImage != null) {
        try {
          CommonWidget.showDialogLoading(ctx);

          var ref = FirebaseStorage.instance.ref().child('image_order').child(
              '${FirebaseAuth.instance.currentUser!.uid}${DateTime.now()}.png');
          await ref.putFile(storeImage!);
          String billImage = await ref.getDownloadURL();

          await FirebaseApi()
              .orderPartner(FirebaseAuth.instance.currentUser!.uid)
              .doc(_orderActive.value[0].id)
              .update({
            'billImage': billImage,
            'status delivery': 'Đang chuẩn bị',
            'timeTwo': dateTime
          }).then((value) async {
            await FirebaseApi()
                .orderCollection(_orderActive.value[0].uid)
                .doc(_orderActive.value[0].id)
                .update({
              'billImage': billImage,
              'status delivery': 'Đang chuẩn bị',
              'timeTwo': dateTime
            }).then((value) {
              _storeImage = null;
              Get.back();
              Get.back();
              CommonWidget.showDialogSuccess(ctx);
            });
          });
        } on PlatformException catch (err) {
          Get.back();
          Get.back();
          log(err.message.toString());

          CommonWidget.showErrorDialog(ctx);
        } catch (err) {
          Get.back();
          Get.back();

          CommonWidget.showErrorDialog(ctx);
        }
      }
    }
  }

  String formatTime(Timestamp timestamp) {
    Duration value =
        Duration(seconds: Timestamp.now().seconds - timestamp.seconds);

    final days = value.inDays.toString();
    final hours = value.inHours.remainder(24).toString();
    final minutes = value.inMinutes.remainder(60).toString();
    final seconds = value.inSeconds.remainder(60).toString();

    if (value.inDays > 0) {
      return '$days ngày';
    } else if (value.inHours > 0) {
      return '$hours giờ';
    } else if (value.inMinutes > 0) {
      return '$minutes phút';
    } else {
      return '$seconds giây';
    }
  }

  // search
  final TextEditingController textEditing = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  FocusNode get focusNode => _focusNode;
  final Rx<List<SearchModel>> _historySearch = Rx<List<SearchModel>>([]);
  List<String> historySearch = [];
  final Rx<List<String>> _suggestString = Rx<List<String>>([]);
  List<String> get suggestString => _suggestString.value;
  final Rx<List<OrderModel>> _resultSearch = Rx<List<OrderModel>>([]);
  List<OrderModel> get resultSearch => _resultSearch.value;
  final RxBool _isCheck = false.obs;
  bool get isCheck => _isCheck.value;
  final RxBool _isMain = true.obs;
  bool get isMain => _isMain.value;
  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  Stream<List<SearchModel>> getStreamHisrtory(String uid) {
    return FirebaseApi()
        .orderNowSearchCollection(uid)
        .orderBy('id', descending: true)
        .snapshots()
        .map((event) {
      List<SearchModel> listSearchStream = [];
      for (var item in event.docs) {
        listSearchStream
            .add(SearchModel.fromJson(item.data() as Map<String, dynamic>));
      }
      return listSearchStream;
    });
  }

  Future<void> submitQuerySearch(String query, BuildContext ctx) async {
    Timestamp timestamp = Timestamp.now();

    if (AppAnother.userAuth != null) {
      try {
        if (historySearch.length <= 10) {
          await FirebaseApi()
              .orderNowSearchCollection(AppAnother.userAuth!.uid)
              .doc(timestamp.toString())
              .set({'id': timestamp, 'search value': query.trim()}).catchError(
                  (e) => throw e);
        } else {
          Timestamp id =
              _historySearch.value[_historySearch.value.length - 1].id;
          await FirebaseApi()
              .orderNowSearchCollection(AppAnother.userAuth!.uid)
              .doc(timestamp.toString())
              .set({'id': timestamp, 'search value': query.trim()}).then(
                  (value) => FirebaseApi()
                      .orderSearchCollection(AppAnother.userAuth!.uid)
                      .doc(id.toString())
                      .delete());
        }
      } on PlatformException catch (err) {
        Get.back();
        log(err.message.toString());
        // ignore: use_build_context_synchronously
        CommonWidget.showErrorDialog(ctx);
      } catch (err) {
        Get.back();
        // ignore: use_build_context_synchronously
        CommonWidget.showErrorDialog(ctx);
      }
    }
  }

  changeStatusEmpty() {
    if (textEditing.text.trim() == '') {
      _isCheck.value = false;
    } else {
      _isCheck.value = true;
    }
  }

  getTrueIsMain() {
    _isMain.value = true;
  }

  getFalseIsMain() {
    _isMain.value = false;
  }

  getSuggest(String value) {
    _suggestString.value = [];
    for (var item in _order.value) {
      if (item.kitchenName.toLowerCase().contains(value.toLowerCase())) {
        if (!_suggestString.value.contains(item.kitchenName)) {
          _suggestString.value.add(item.kitchenName);
        }
      }
      for (var name in item.name) {
        if (name.toLowerCase().contains(value.toLowerCase())) {
          if (!_suggestString.value.contains(name)) {
            _suggestString.value.add(name);
          }
        }
      }
    }
  }

  getListQuery(String query) {
    _isLoading.value = true;
    _resultSearch.value = [];
    for (var item in _order.value) {
      if (item.kitchenName.toLowerCase().contains(query.toLowerCase())) {
        if (!_resultSearch.value.contains(item)) {
          _resultSearch.value.add(item);
        }
      }
      for (var name in item.name) {
        if (name.toLowerCase().contains(query.toLowerCase())) {
          if (!_resultSearch.value.contains(item)) {
            _resultSearch.value.add(item);
          }
        }
      }
    }
    _isLoading.value = false;
  }

  getValueHistorySearch() {
    historySearch = [];
    for (var item in _historySearch.value) {
      if (!historySearch.contains(item.query)) {
        historySearch.add(item.query);
      }
    }
  }
}
