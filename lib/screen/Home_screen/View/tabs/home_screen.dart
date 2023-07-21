import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_ap/config/app_colors.dart';
import 'package:new_ap/config/app_dimens.dart';
import 'package:new_ap/config/app_string.dart';
import 'package:new_ap/screen/Home_screen/controllers/home_controller.dart';

// ignore: must_be_immutable
class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  HomeController controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Obx(
          () => IndexedStack(
            index: controller.selectedPage,
            children: <Widget>[
              controller.page[0],
              controller.page[1],
              controller.page[2],
              controller.page[3]
            ],
          ),
        ),
        bottomNavigationBar: Obx(() => BottomNavigationBar(
              elevation: AppDimens.dimens_5,
              onTap: (value) {
                controller.setStateSelectedValue(value);
              },
              backgroundColor: ColorConstants.colorGrey2,
              unselectedItemColor: ColorConstants.colorBlack,
              selectedItemColor: ColorConstants.themeColor,
              currentIndex: controller.selectedPage,
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.home_outlined,
                      size: AppDimens.dimens_30,
                    ),
                    label: AppString.home),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.article_outlined,
                      size: AppDimens.dimens_30,
                    ),
                    label: AppString.orderUpper),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.message_outlined,
                      size: AppDimens.dimens_30,
                    ),
                    label: AppString.message),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.person_2_outlined,
                      size: AppDimens.dimens_30,
                    ),
                    label: AppString.profile),
              ],
            )));
  }
}
