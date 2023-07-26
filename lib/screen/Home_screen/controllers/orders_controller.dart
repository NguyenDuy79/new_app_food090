import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:new_ap/config/app_another.dart';
import 'package:new_ap/model/orders_model.dart';
import 'package:new_ap/model/user_model.dart';
import '../../../config/firebase_api.dart';

class OrderController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController controller;
  int limit = 20;
  final Rx<List<OrderModel>> _allOrders = Rx<List<OrderModel>>([]);
  TextEditingController textEditing = TextEditingController();
  FocusNode focusNode = FocusNode();
  final List<Tab> myTabs = const [
    Tab(
      text: 'Đang tiến hành',
    ),
    Tab(
      text: 'Đã hoàn thành',
    ),
    Tab(
      text: 'Đã hủy',
    )
  ];
  @override
  void onInit() {
    controller = TabController(length: 3, vsync: this);
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
      if (query.docs.isNotEmpty) {
        for (int j = 0; j < query.docs.length; j++) {
          if ((query.docs[j].data() as Map<String, dynamic>)['quantity'] !=
                  null &&
              (query.docs[j].data() as Map<String, dynamic>)['productPrice'] !=
                  null) {
            listCartStream.add(OrderModel.fromJson(
                query.docs[j].data() as Map<String, dynamic>));
          }
        }
      }

      return listCartStream;
    });
  }

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
          .update({'status': 'Completed'});
    }
  }

  int getprice(List<String> price, List<int> quantity) {
    var totalPrice = 0;
    for (int i = 0; i < price.length; i++) {
      totalPrice = totalPrice + int.parse(price[i]) * quantity[i];
    }
    return totalPrice;
  }

  // search

  Rx<List<OrderModel>> _orderSearch = Rx<List<OrderModel>>([]);
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
    _orderSearch = Rx<List<OrderModel>>([]);

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
    _anyStringContains.value.clear();

    if (_allOrders.value.isNotEmpty) {
      for (int i = 0; i < _allOrders.value.length; i++) {
        if (_allOrders.value[i].kitchenName
            .toLowerCase()
            .contains(value.toLowerCase())) {
          _anyStringContains.value.add(_allOrders.value[i].kitchenName);
        }

        for (int j = 0; j < _allOrders.value[i].name.length; j++) {
          if (_allOrders.value[i].name[j]
              .toLowerCase()
              .contains(value.toLowerCase())) {
            _anyStringContains.value.add(_allOrders.value[i].name[j]);
          }
        }
      }
      print(anyStringContains.length);
    }
  }
}
