import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_ap/screen/Home_screen/controllers/Main_controller.dart';

import 'package:new_ap/screen/Home_screen/View/main_screen.dart';
import 'package:new_ap/screen/Home_screen/View/message_screen.dart';
import 'package:new_ap/screen/Home_screen/View/order_screen.dart';
import 'package:new_ap/screen/Home_screen/View/profile_screen.dart';

class HomeController extends GetxController {
  double height = AppBar().preferredSize.height;
  MainController controller = Get.put(MainController());
  final List<Map<String, Widget>> _page = [
    {'screen': MainScreen()},
    {
      'screen': OrderScreen(),
    },
    {
      'screen': const MessageScreen(),
    },
    {
      'screen': const ProfileScreen(),
    }
  ];

  List<Map<String, Widget>> get page => _page;

  RxInt selectedPage = 0.obs;

  static get value => null;
  void selectPage(int index) {
    selectedPage.value = index;
    update();
  }
}
