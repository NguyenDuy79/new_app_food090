import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:new_ap/database/Firebase_users.dart';
import 'package:new_ap/model/orders_model.dart';

class OrderController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController controller;
  List<OrderModel> activeOrders = [];
  List<OrderModel> completedOrders = [];
  List<OrderModel> cancelledOrders = [];

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
    super.onInit();
  }

  @override
  void onClose() {
    controller.dispose();
    super.onClose();
  }

  getActiveOrder(List<QueryDocumentSnapshot<Object?>> value) {
    activeOrders = [];
    for (int i = 0; i < value.length; i++) {
      if ((value[i].data() as Map<String, dynamic>)['status'] == 'active') {
        activeOrders
            .add(OrderModel.fromJson(value[i].data() as Map<String, dynamic>));
      }
    }
    print(activeOrders.length);
  }

  getCompletedOrder(List<QueryDocumentSnapshot<Object?>> value) {
    completedOrders = [];
    for (int i = 0; i < value.length; i++) {
      if ((value[i].data() as Map<String, dynamic>)['status'] == 'completed') {
        completedOrders
            .add(OrderModel.fromJson(value[i].data() as Map<String, dynamic>));
      }
    }
  }

  getCancelledOrder(List<QueryDocumentSnapshot<Object?>> value) {
    cancelledOrders = [];
    for (int i = 0; i < value.length; i++) {
      if ((value[i].data() as Map<String, dynamic>)['status'] == 'cancelled') {
        cancelledOrders
            .add(OrderModel.fromJson(value[i].data() as Map<String, dynamic>));
      }
    }
  }

  String getNewPrice(int price) {
    var length = price.toString().length;
    var reuslt =
        '${price.toString().substring(0, length - 3)}.${price.toString().substring(length - 3, length)}';
    return reuslt;
  }

  setStateShipDelivery(String id) async {
    if (FirebaseAuth.instance.currentUser != null) {
      await FireBaseUsers()
          .orderCollection(FirebaseAuth.instance.currentUser!.uid)
          .doc(id)
          .update({'status': 'completed'});
    }
  }
}
