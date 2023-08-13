import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:new_ap/config/app_another.dart';
import 'package:new_ap/config/app_colors.dart';
import 'package:new_ap/config/app_dimens.dart';
import 'package:new_ap/config/app_string.dart';
import 'package:new_ap/model/cart_model.dart';
import 'package:new_ap/model/orders_model.dart';
import 'package:new_ap/model/user_model.dart';
import '../../../common_app/common_widget.dart';
import '../../../config/firebase_api.dart';

class OrderController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController controller;
  int limit = 20;
  final Rx<List<OrderModel>> _allOrders = Rx<List<OrderModel>>([]);
  TextEditingController textEditing = TextEditingController();
  FocusNode focusNode = FocusNode();
  final RxInt _status = 0.obs;
  int get status => _status.value;
  List<bool> reviewDone = [];
  List<String> imageUrl = [];
  final List<Tab> myTabs = const [
    Tab(
      text: 'Đã hoàn thành',
    ),
    Tab(
      text: 'Đã hủy',
    )
  ];
  @override
  void onInit() {
    controller = TabController(length: 2, vsync: this);
    if (AppAnother.userAuth != null) {
      _allOrders.bindStream(getOrder(AppAnother.userAuth!.uid));
      _historySearch
          .bindStream(getStreamSearchHistory(AppAnother.userAuth!.uid));
    }
    super.onInit();
  }

  @override
  void onClose() {
    controller.dispose();
    super.onClose();
  }

  Stream<List<OrderModel>> getOrder(String uid) {
    return FirebaseApi()
        .orderCollection(uid)
        .orderBy('timeStamp', descending: true)
        .limit(limit)
        .snapshots()
        .map((query) {
      List<OrderModel> listCartStream = [];
      List<String> image = [];
      List<String> imageCompleted = [];
      List<bool> reviewDoneValue = [];
      if (query.docs.isNotEmpty) {
        for (int j = 0; j < query.docs.length; j++) {
          if ((query.docs[j].data() as Map<String, dynamic>)['quantity'] !=
                  null &&
              (query.docs[j].data() as Map<String, dynamic>)['productPrice'] !=
                  null) {
            listCartStream.add(OrderModel.fromJson(
                query.docs[j].data() as Map<String, dynamic>));
          }
          if ((query.docs[j].data() as Map<String, dynamic>)['status'] ==
              'Active') {
            if ((query.docs[j].data() as Map<String, dynamic>)['billImage'] !=
                null) {
              image.add(
                  (query.docs[j].data() as Map<String, dynamic>)['billImage']);
            } else {
              image.add('');
            }
          }
          if ((query.docs[j].data() as Map<String, dynamic>)['status'] ==
              'Completed') {
            imageCompleted.add(
                (query.docs[j].data() as Map<String, dynamic>)['billImage']);
            reviewDoneValue
                .add((query.docs[j].data() as Map<String, dynamic>)['review']);
          }
        }
        url = image;
        reviewDone = reviewDoneValue;
        imageUrl = imageCompleted;
      }

      return listCartStream;
    });
  }

  List<String> url = [];

  List<OrderModel> getActiveOrder() {
    List<OrderModel> activeOrders = [];
    for (int i = 0; i < _allOrders.value.length; i++) {
      if (_allOrders.value[i].status == 'Active') {
        activeOrders.add(_allOrders.value[i]);
      }
    }
    return activeOrders;
  }

  List<OrderModel> getCompletedOrder() {
    List<OrderModel> completedOrders = [];
    for (int i = 0; i < _allOrders.value.length; i++) {
      if (_allOrders.value[i].status == 'Completed') {
        completedOrders.add(_allOrders.value[i]);
      }
    }
    return completedOrders;
  }

  List<OrderModel> getCancelledOrder() {
    List<OrderModel> cancelledOrders = [];
    for (int i = 0; i < _allOrders.value.length; i++) {
      if (_allOrders.value[i].status == 'Cancelled') {
        cancelledOrders.add(_allOrders.value[i]);
      }
    }
    return cancelledOrders;
  }

  String getNewPrice(int price) {
    var length = price.toString().length;
    var reuslt =
        '${price.toString().substring(0, length - 3)}.${price.toString().substring(length - 3, length)}';
    return reuslt;
  }

  setStateShipDelivery(String id) async {
    if (FirebaseAuth.instance.currentUser != null) {
      await FirebaseApi()
          .orderCollection(FirebaseAuth.instance.currentUser!.uid)
          .doc(id)
          .update({'status': 'Completed', 'review': false});
    }
  }

  int getprice(List<String> price, List<int> quantity) {
    var totalPrice = 0;
    for (int i = 0; i < price.length; i++) {
      totalPrice = totalPrice + int.parse(price[i]) * quantity[i];
    }
    return totalPrice;
  }

  int getStatus(String statusDelivery) {
    if (statusDelivery == AppString.statusDelivery1) {
      return 1;
    } else if (statusDelivery == AppString.statusDelivery2) {
      return 2;
    } else if (statusDelivery == AppString.statusDelivery3) {
      return 3;
    } else if (statusDelivery == AppString.statusDelivery4) {
      return 4;
    } else {
      return 0;
    }
  }

  showDiaLogDelivery(
      BuildContext context,
      Timestamp timestamp,
      Timestamp timestamp1,
      Timestamp timestamp2,
      Timestamp timestamp3,
      Timestamp timestamp4) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: FittedBox(
            child: Column(
              children: <Widget>[
                const Text(
                  'Thời gian tạo đơn',
                  style: TextStyle(fontSize: AppDimens.dimens_20),
                ),
                FittedBox(
                  child: Text(
                    '${timestamp.toDate().toString().split(':')[0]} : ${timestamp.toDate().toString().split(':')[1]}',
                    style: const TextStyle(fontSize: AppDimens.dimens_20),
                  ),
                ),
                const Text(
                  'Thời gian nhận đơn',
                  style: TextStyle(fontSize: AppDimens.dimens_20),
                ),
                FittedBox(
                  child: Text(
                    '${timestamp1.toDate().toString().split(':')[0]} : ${timestamp1.toDate().toString().split(':')[1]}',
                    style: const TextStyle(
                      fontSize: AppDimens.dimens_20,
                    ),
                  ),
                ),
                const Text(
                  'Thời gian chuẩn bị',
                  style: TextStyle(fontSize: AppDimens.dimens_20),
                ),
                FittedBox(
                  child: Text(
                    '${timestamp2.toDate().toString().split(':')[0]} : ${timestamp2.toDate().toString().split(':')[1]}',
                    style: const TextStyle(fontSize: AppDimens.dimens_20),
                  ),
                ),
                const Text(
                  'Thời gian bắt đầu giao hàng',
                  style: TextStyle(fontSize: AppDimens.dimens_20),
                ),
                FittedBox(
                  child: Text(
                    '${timestamp3.toDate().toString().split(':')[0]} : ${timestamp3.toDate().toString().split(':')[1]}',
                    style: const TextStyle(fontSize: AppDimens.dimens_20),
                  ),
                ),
                const Text(
                  'Thời gian giao hàng',
                  style: TextStyle(
                    fontSize: AppDimens.dimens_20,
                  ),
                ),
                FittedBox(
                  child: Text(
                    '${timestamp4.toDate().toString().split(':')[0]} : ${timestamp4.toDate().toString().split(':')[1]}',
                    style: const TextStyle(fontSize: AppDimens.dimens_20),
                  ),
                )
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text(
                  'Đóng',
                  style: TextStyle(
                      fontSize: AppDimens.dimens_20,
                      color: ColorConstants.themeColor),
                ))
          ],
        );
      },
    );
  }

  Future<void> cancelOrder(OrderModel orderModel, String statusDelivery,
      String partnerId, BuildContext ctx) async {
    Timestamp timestamp = Timestamp.now();
    if (AppAnother.userAuth != null) {
      try {
        CommonWidget.showDialogLoading(ctx);
        OrderModel newOrder = OrderModel(
            id: orderModel.id,
            name: orderModel.name,
            timeStamp: orderModel.timeStamp,
            ship: orderModel.ship,
            partnerId: orderModel.partnerId,
            timeOne: orderModel.timeOne,
            timeTwo: orderModel.timeTwo,
            timeThree: orderModel.timeThree,
            timeFour: orderModel.timeFour,
            productId: orderModel.productId,
            price: orderModel.price,
            reduce: orderModel.reduce,
            cancelOrder: timestamp,
            reduceShip: orderModel.reduceShip,
            productPrice: orderModel.productPrice,
            kitchenId: orderModel.kitchenId,
            kitchenName: orderModel.kitchenName,
            promoCode: orderModel.promoCode,
            uid: orderModel.uid,
            quantity: orderModel.quantity,
            shippingCode: orderModel.shippingCode,
            status: 'Cancelled',
            statusDelivery: AppString.statusDelevery5,
            url: orderModel.url);
        Map<String, dynamic> getProductPrice = {
          'productPrice': orderModel.productPrice
        };
        Map<String, List> getQuantity = {'quantity': orderModel.quantity};

        if (statusDelivery == AppString.statusDelivery1 &&
            AppAnother.userAuth != null) {
          CommonWidget.showDialogLoading(ctx);
          await FirebaseApi()
              .userCollection
              .doc(AppAnother.userAuth!.uid)
              .collection('order')
              .doc(orderModel.id)
              .update({'status': 'Cancelled', 'cancel order': timestamp});

          FirebaseApi()
              .partner
              .doc(partnerId)
              .collection('orderCompleted')
              .doc(orderModel.id)
              .set(newOrder.toJson())
              .then((value) {
            FirebaseApi()
                .partner
                .doc(partnerId)
                .collection('orderCompleted')
                .doc(orderModel.id)
                .update(getQuantity);
            FirebaseApi()
                .partner
                .doc(partnerId)
                .collection('orderCompleted')
                .doc(orderModel.id)
                .update(getProductPrice);
            FirebaseApi()
                .partner
                .doc(partnerId)
                .collection('orderProgress')
                .doc(orderModel.id)
                .delete();
          });
          Get.back();
          Get.back();
        } else if (statusDelivery == AppString.statusDelivery0) {
          CommonWidget.showDialogLoading(ctx);
          await FirebaseApi()
              .userCollection
              .doc(AppAnother.userAuth!.uid)
              .collection('order')
              .doc(orderModel.id)
              .update({'status': 'Cancelled', 'cancel order': timestamp});

          FirebaseApi().orderNow.doc(orderModel.id).delete();
          Get.back();
          Get.back();
        }
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

  // search

  final Rx<List<OrderModel>> _orderSearch = Rx<List<OrderModel>>([]);
  List<OrderModel> get orderSearch => _orderSearch.value;
  final Rx<List<String>> _anyStringContains = Rx<List<String>>([]);
  List<String> get anyStringContains => _anyStringContains.value;
  final Rx<List<SearchModel>> _historySearch = Rx<List<SearchModel>>([]);
  List<String> historySearch = [];
  final RxBool _isCheck = false.obs;
  bool get isCheck => _isCheck.value;
  final RxBool _isMain = true.obs;
  bool get isMain => _isMain.value;
  final RxBool _reload = false.obs;
  bool get reload => _reload.value;

  Stream<List<SearchModel>> getStreamSearchHistory(String uid) {
    return FirebaseApi()
        .orderSearchCollection(uid)
        .orderBy('id', descending: true)
        .limit(10)
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

  getTrueIsMain() {
    _isMain.value = true;
  }

  getFalseIsMain() {
    _isMain.value = false;
  }

  Future<void> submitQuerySearch(String query, BuildContext ctx) async {
    Timestamp timestamp = Timestamp.now();

    if (AppAnother.userAuth != null) {
      try {
        if (historySearch.length <= 10) {
          await FirebaseApi()
              .orderSearchCollection(AppAnother.userAuth!.uid)
              .doc(timestamp.toString())
              .set({'id': timestamp, 'search value': query.trim()}).catchError(
                  (e) => throw e);
        } else {
          Timestamp id =
              _historySearch.value[_historySearch.value.length - 1].id;
          await FirebaseApi()
              .orderSearchCollection(AppAnother.userAuth!.uid)
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

        CommonWidget.showErrorDialog(ctx);
      } catch (err) {
        Get.back();

        CommonWidget.showErrorDialog(ctx);
      }
    }
  }

  getValueHistorySearch() {
    historySearch = [];
    for (var item in _historySearch.value) {
      if (!historySearch.contains(item.query)) {
        historySearch.add(item.query);
      }
    }
  }

  changeStatusEmpty() {
    if (textEditing.text == '') {
      _isCheck.value = false;
    } else {
      _isCheck.value = true;
    }
  }

  getListQuery(String query) {
    _reload.value = true;
    _orderSearch.value = [];

    for (var item in _allOrders.value) {
      if (item.kitchenName.toLowerCase().contains(query.toLowerCase())) {
        _orderSearch.value.add(item);
      }
      for (int i = 0; i < item.name.length; i++) {
        if (item.name[i].toLowerCase().contains(query.toLowerCase())) {
          if (!_orderSearch.value.contains(item)) {
            _orderSearch.value.add(item);
          }
        }
      }
    }
    _reload.value = false;
  }

  getSuggest(String value) {
    _anyStringContains.value = [];

    if (_allOrders.value.isNotEmpty) {
      for (int i = 0; i < _allOrders.value.length; i++) {
        if (_allOrders.value[i].kitchenName
            .toLowerCase()
            .contains(value.toLowerCase())) {
          if (!_anyStringContains.value
              .contains(_allOrders.value[i].kitchenName)) {
            _anyStringContains.value.add(_allOrders.value[i].kitchenName);
          }
        }

        for (int j = 0; j < _allOrders.value[i].name.length; j++) {
          if (_allOrders.value[i].name[j]
              .toLowerCase()
              .contains(value.toLowerCase())) {
            if (!_anyStringContains.value
                .contains(_allOrders.value[i].name[j])) {
              _anyStringContains.value.add(_allOrders.value[i].name[j]);
            }
          }
        }
      }
    }
  }

  Future<void> orderAgain(OrderModel order, BuildContext ctx) async {
    DateTime dateTime = DateTime.now();
    for (int i = 0; i < order.productId.length; i++) {
      CartModel newCart = CartModel(
          id: dateTime.toString(),
          name: order.name[i],
          price: order.productPrice[i],
          quantity: order.quantity[i],
          kitchenName: order.kitchenName,
          url: order.url[i],
          kitchenId: order.kitchenId,
          productId: order.productId[i]);
      if (AppAnother.userAuth != null) {
        await FirebaseApi()
            .getCartFirestore(AppAnother.userAuth!.uid)
            .then((value) async {
          try {
            if (value.isEmpty) {
              await FirebaseApi()
                  .cartCollection(AppAnother.userAuth!.uid)
                  .doc(dateTime.toString())
                  .set(newCart.toJson())
                  .catchError((e) => throw e);
            } else {
              int index = value.indexWhere((element) =>
                  (element.data() as Map<String, dynamic>)['productId'] ==
                  newCart.productId);
              if (index < 0) {
                await FirebaseApi()
                    .cartCollection(AppAnother.userAuth!.uid)
                    .doc(dateTime.toString())
                    .set(newCart.toJson())
                    .catchError((e) => throw e);
              } else {
                await FirebaseApi()
                    .cartCollection(FirebaseAuth.instance.currentUser!.uid)
                    .doc((value[index].data() as Map<String, dynamic>)['id'])
                    .update({
                  'quantity': (value[index].data()
                          as Map<String, dynamic>)['quantity'] +
                      newCart.quantity
                }).catchError((e) => throw e);
              }
            }
          } on PlatformException catch (err) {
            Get.back();
            log(err.message.toString());

            CommonWidget.showErrorDialog(ctx);
          } catch (err) {
            Get.back();

            CommonWidget.showErrorDialog(ctx);
          }
        });
      }
    }
  }
}
