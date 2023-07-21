import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:new_ap/config/app_colors.dart';
import 'package:new_ap/config/app_string.dart';
import 'package:new_ap/config/firebase_api.dart';
import 'package:new_ap/model/chat_model.dart';
import 'package:new_ap/model/orders_model.dart';
import 'package:new_ap/screen/partner_screen/controller/partner_controller.dart';
import 'package:new_ap/screen/partner_screen/view/camera_picker_screen.dart';
import '../../../config/app_another.dart';
import '../../../config/app_dimens.dart';
import '../../../model/user_model.dart';

class OrderNowController extends GetxController {
  final Rx<List<OrderModel>> _order = Rx<List<OrderModel>>([]);
  final Rx<List<OrderModel>> _orderActive = Rx<List<OrderModel>>([]);
  List<OrderModel> get order => _order.value;
  List<OrderModel> get orderActive => _orderActive.value;
  RxInt status = 0.obs;

  List<String> statusDelivery = [
    AppString.statusDelivery1,
    AppString.statusDelivery2,
    AppString.statusDelivery3,
    AppString.statusDelivery4
  ];
  String url = '';
  File? _storeImage;
  File? get storeImage => _storeImage;
  UserModel _user =
      UserModel(id: '', email: '', image: '', mobile: '', userName: '');
  UserModel _userPartner =
      UserModel(id: '', email: '', image: '', mobile: '', userName: '');
  UserModel get userPartner => _userPartner;
  UserModel get user => _user;

  @override
  void onInit() {
    _order.bindStream(orderNowStream());
    if (FirebaseAuth.instance.currentUser != null) {
      _orderActive.bindStream(orderActiveStream());
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
            if (listOrderStream[0].statusDelivery == statusDelivery[0]) {
              status.value = 1;
            } else if (listOrderStream[0].statusDelivery == statusDelivery[1]) {
              status.value = 2;
            } else if (listOrderStream[0].statusDelivery == statusDelivery[2]) {
              status.value = 3;
            } else {
              status.value = 4;
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
            timeOne: dateTime.toString(),
            timeTwo: orderChoose.timeTwo,
            timeThree: orderChoose.timeThree,
            timeFour: orderChoose.timeFour,
            productId: orderChoose.productId,
            price: orderChoose.price,
            reduce: orderChoose.reduce,
            reduceShip: orderChoose.reduceShip,
            productPrice: orderChoose.productPrice,
            kitchenId: orderChoose.kitchenId,
            kitchenName: orderChoose.kitchenName,
            promoCode: orderChoose.promoCode,
            uid: orderChoose.uid,
            quantity: orderChoose.quantity,
            shippingCode: orderChoose.shippingCode,
            status: orderChoose.status,
            statusDelivery: statusDelivery[0],
            url: orderChoose.url);
        ChatModel chatUser = ChatModel(
            content: 'Tôi đã nhận đơn hàng',
            id: timeStamp,
            type: TypeMessage.text,
            isMe: false,
            seen: false);
        ChatModel chatPartner = ChatModel(
            content: 'Tôi đã nhận đơn hàng',
            id: timeStamp,
            type: TypeMessage.text,
            isMe: true,
            seen: true);
        Map<String, List> getQuantity = {'quantity': orderChoose.quantity};
        Map<String, List> getPrice = {'productPrice': orderChoose.productPrice};
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
            'userName': _user.userName
          }).then((value) async {
            await FirebaseApi()
                .chatCollectionPartner(
                    AppAnother.userAuth!.uid, orderChoose.uid)
                .doc(timeStamp.toString())
                .set(chatPartner.toJson());
          });
        }).catchError((e) => throw e);
        await FirebaseApi()
            .orderCollection(orderChoose.uid)
            .doc(orderChoose.id)
            .update({
          'status delivery': statusDelivery[0],
          'timeOne': dateTime.toString()
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
          Get.find<PartnerController>().selectPage(1);
          Get.toNamed('/partner');
          FirebaseApi().orderNow.doc(orderChoose.id).delete();
        }).catchError((e) => throw e);
      } on PlatformException catch (err) {
        var message = 'An error, try again';
        if (err.message != null) {
          message = err.message!;
        }
        ScaffoldMessenger.of(ctx).hideCurrentSnackBar();
        ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
          content: Text(message),
          backgroundColor: ColorConstants.colorRed1,
        ));
      } catch (err) {
        ScaffoldMessenger.of(ctx).hideCurrentSnackBar();
        ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
          content: Text(err.toString()),
          backgroundColor: ColorConstants.colorRed1,
        ));
      }
    }
  }

  Color getColors(int count, int value, BuildContext ctx) {
    if (count >= value) {
      return Theme.of(ctx).primaryColor;
    } else {
      return Colors.grey;
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

  Widget getWidget(
      BuildContext context, int count, IconData icon, String time) {
    return Container(
      height: AppDimens.dimens_130,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.dimens_20,
      ),
      child: Row(
        children: <Widget>[
          Column(
            children: <Widget>[
              Icon(
                icon,
                color: getColors(status.value, count, context),
              ),
              Container(
                height: AppDimens.dimens_100,
                width: AppDimens.dimens_5,
                decoration: BoxDecoration(
                    color: getColors(status.value, count, context)),
              )
            ],
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.only(top: AppDimens.dimens_10),
            child: Column(
              children: <Widget>[
                FittedBox(
                  child: Text(
                    'Tình trạng: ${statusDelivery[count - 1]}',
                    style: TextStyle(
                        fontSize: AppDimens.dimens_20,
                        fontWeight: FontWeight.bold,
                        color:
                            status.value >= count ? Colors.black : Colors.grey),
                  ),
                ),
                status.value >= count
                    ? Text(
                        '${time.split(':')[0]}:${time.split(':')[1]}',
                        style: const TextStyle(color: Colors.black),
                      )
                    : const Text(''),
                if (url != '' && count == 2)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: AppDimens.dimens_10),
                    height: AppDimens.dimens_80,
                    width: AppDimens.dimens_50,
                    child: Image.network(
                      url,
                      fit: BoxFit.cover,
                    ),
                  ),
                const Expanded(child: SizedBox()),
                Divider(
                    height: AppDimens.dimens_0,
                    thickness: AppDimens.dimens_2,
                    color: getColors(status.value, count, context))
              ],
            ),
          ))
        ],
      ),
    );
  }

  statusDeliveryMethod(BuildContext ctx) async {
    String dateTime = DateTime.now().toString();
    if (status.value == 1) {
      Get.to(() {
        return CameraPicker();
      });
    } else if (status.value == 2) {
      await FirebaseApi()
          .orderPartner(FirebaseAuth.instance.currentUser!.uid)
          .doc(_orderActive.value[0].id)
          .update({
        'status delivery': AppString.statusDelivery3,
        'timeThree': dateTime
      }).then((value) async {
        await FirebaseApi()
            .orderCollection(_orderActive.value[0].uid)
            .doc(_orderActive.value[0].id)
            .update({
          'status delivery': AppString.statusDelivery3,
          'timeThree': dateTime
        });
      });
    } else if (status.value == 3) {
      await FirebaseApi()
          .orderPartner(FirebaseAuth.instance.currentUser!.uid)
          .doc(_orderActive.value[0].id)
          .update({
        'status delivery': AppString.statusDelivery4,
        'timeFour': dateTime
      }).then((value) async {
        await FirebaseApi()
            .orderCollection(_orderActive.value[0].uid)
            .doc(_orderActive.value[0].id)
            .update({
          'status delivery': AppString.statusDelivery4,
          'timeFour': dateTime
        });
      });
    } else if (status.value == 4) {
      if (AppAnother.userAuth != null) {
        try {
          OrderModel newOrder = OrderModel(
              id: _orderActive.value[0].id,
              name: _orderActive.value[0].name,
              timeStamp: _orderActive.value[0].timeStamp,
              ship: _orderActive.value[0].ship,
              timeOne: _orderActive.value[0].timeOne,
              timeTwo: _orderActive.value[0].timeTwo,
              timeThree: _orderActive.value[0].timeThree,
              timeFour: _orderActive.value[0].timeFour,
              productId: _orderActive.value[0].productId,
              price: _orderActive.value[0].price,
              reduce: _orderActive.value[0].reduce,
              reduceShip: _orderActive.value[0].reduceShip,
              productPrice: _orderActive.value[0].productPrice,
              kitchenId: _orderActive.value[0].kitchenId,
              kitchenName: _orderActive.value[0].kitchenName,
              promoCode: _orderActive.value[0].promoCode,
              uid: _orderActive.value[0].uid,
              quantity: _orderActive.value[0].quantity,
              shippingCode: _orderActive.value[0].shippingCode,
              status: 'Completed',
              statusDelivery: statusDelivery[3],
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
            Get.find<PartnerController>().selectPage(3);
            Get.toNamed('/partner');
            await FirebaseApi()
                .orderPartner(AppAnother.userAuth!.uid)
                .doc(_orderActive.value[0].id)
                .delete();
            status.value = 0;
          }).catchError((e) => throw e);
        } on PlatformException catch (err) {
          var message = 'An error, try again';
          if (err.message != null) {
            message = err.message!;
          }
          ScaffoldMessenger.of(ctx).hideCurrentSnackBar();
          ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
            content: Text(message),
            backgroundColor: ColorConstants.colorRed1,
          ));
        } catch (err) {
          ScaffoldMessenger.of(ctx).hideCurrentSnackBar();
          ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
            content: Text(err.toString()),
            backgroundColor: ColorConstants.colorRed1,
          ));
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
    Timestamp timestamp = Timestamp.now();
    String dateTime = DateTime.now().toString();
    if (FirebaseAuth.instance.currentUser != null) {
      if (_storeImage != null) {
        try {
          var ref = FirebaseStorage.instance.ref().child('image_order').child(
              '${FirebaseAuth.instance.currentUser!.uid}${DateTime.now()}.png');
          await ref.putFile(storeImage!);
          String billImage = await ref.getDownloadURL();
          ChatModel chatPartner = ChatModel(
              content: billImage,
              id: timestamp,
              type: TypeMessage.image,
              isMe: true,
              seen: true);
          ChatModel chatUser = ChatModel(
              content: billImage,
              id: timestamp,
              type: TypeMessage.image,
              isMe: false,
              seen: false);
          await FirebaseApi()
              .orderPartner(FirebaseAuth.instance.currentUser!.uid)
              .doc(_orderActive.value[0].id)
              .update({
            'billImage': url,
            'status delivery': 'Đang chuẩn bị',
            'timeTwo': dateTime
          }).then((value) async {
            await FirebaseApi()
                .chatCollectionPartner(FirebaseAuth.instance.currentUser!.uid,
                    _orderActive.value[0].uid)
                .doc(dateTime)
                .set(chatPartner.toJson());
            await FirebaseApi()
                .chatCollection(_orderActive.value[0].uid,
                    FirebaseAuth.instance.currentUser!.uid)
                .doc(dateTime)
                .set(chatUser.toJson());
            await FirebaseApi()
                .orderCollection(_orderActive.value[0].uid)
                .doc(_orderActive.value[0].id)
                .update({
              'billImage': url,
              'status delivery': 'Đang chuẩn bị',
              'timeTwo': dateTime
            }).then((value) {
              _storeImage = null;
              Get.back();
            });
          });
        } on PlatformException catch (err) {
          var message = 'An error, try again';
          if (err.message != null) {
            message = err.message!;
          }
          ScaffoldMessenger.of(ctx).hideCurrentSnackBar();
          ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
            content: Text(message),
            backgroundColor: ColorConstants.colorRed1,
          ));
        } catch (err) {
          ScaffoldMessenger.of(ctx).hideCurrentSnackBar();
          ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
            content: Text(err.toString()),
            backgroundColor: ColorConstants.colorRed1,
          ));
        }
      }
    }
  }
}
