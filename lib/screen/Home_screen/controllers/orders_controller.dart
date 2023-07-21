import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_ap/model/orders_model.dart';
import '../../../config/firebase_api.dart';

class OrderController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController controller;
  int limit = 20;
  final Rx<List<OrderModel>> _allOrders = Rx<List<OrderModel>>([]);

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
    if (FirebaseAuth.instance.currentUser != null) {
      _allOrders.bindStream(getOrder(FirebaseAuth.instance.currentUser!.uid));
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
}
