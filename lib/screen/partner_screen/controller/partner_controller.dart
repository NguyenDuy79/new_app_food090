import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_ap/screen/partner_screen/view/order_now_screen.dart';
import 'package:new_ap/screen/partner_screen/view/orders_history_screen.dart';
import 'package:new_ap/screen/partner_screen/view/orders_in_progress_screen.dart';
import 'package:new_ap/screen/partner_screen/view/partner_chat_dart.dart';

class PartnerController extends GetxController {
  double height = AppBar().preferredSize.height;

  List<Widget> _page = [
    OrdersNowScreen(),
    OrdersInProgressScreen(),
    Partner_chat(),
    OrdersHistoryScreen(),
  ];

  List<Widget> get page => _page;

  RxInt selectedPage = 0.obs;
  void selectPage(int index) {
    selectedPage.value = index;
    update();
  }
}
