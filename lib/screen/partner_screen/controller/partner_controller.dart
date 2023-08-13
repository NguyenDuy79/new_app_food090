import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_ap/screen/partner_screen/view/tabs/order_now_screen.dart';
import 'package:new_ap/screen/partner_screen/view/tabs/orders_history_screen.dart';
import 'package:new_ap/screen/partner_screen/view/tabs/orders_in_progress_screen.dart';
import 'package:new_ap/screen/partner_screen/view/tabs/partner_chat_dart.dart';

class PartnerController extends GetxController {
  final List<Widget> _page = [
    OrdersNowScreen(),
    OrdersInProgressScreen(),
    MessagePartnerScreen(),
    OrdersHistoryScreen(),
  ];
  List<Widget> get page => _page;
  RxInt selectedPage = 0.obs;
  void selectPage(int index) {
    selectedPage.value = index;
    update();
  }
}
