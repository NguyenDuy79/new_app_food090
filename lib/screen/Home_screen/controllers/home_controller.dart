import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_ap/config/app_colors.dart';
import 'package:new_ap/screen/Home_screen/controllers/main_controller.dart';

import 'package:new_ap/screen/Home_screen/View/tabs/main_screen.dart';
import 'package:new_ap/screen/Home_screen/View/tabs/message_screen.dart';
import 'package:new_ap/screen/Home_screen/View/tabs/order_screen.dart';
import 'package:new_ap/screen/Home_screen/View/tabs/profile_screen.dart';

class HomeController extends GetxController {
  double height = AppBar().preferredSize.height;
  MainController controller = Get.put(MainController());
  final List<Widget> _page = [
    MainScreen(),
    OrderScreen(),
    MessageScreen(),
    const ProfileScreen(),
  ];

  List<Widget> get page => _page;

  final RxInt _selectedPage = 0.obs;
  int get selectedPage => _selectedPage.value;

  void setStateSelectedValue(int page) {
    _selectedPage.value = page;
  }

  Color getColor(int page) {
    if (_selectedPage.value == page) {
      return ColorConstants.themeColor;
    } else {
      return ColorConstants.colorBlack;
    }
  }
}
