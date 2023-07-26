import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_ap/config/app_colors.dart';
import 'package:new_ap/config/app_font.dart';
import 'package:new_ap/screen/Home_screen/View/pages/categories_screen.dart';
import 'package:new_ap/screen/Home_screen/View/pages/kitchen_screen.dart';

import 'package:new_ap/screen/Search_Screen/home/search_kitchen_screen.dart';
import 'package:new_ap/screen/Home_screen/controllers/main_controller.dart';
import 'package:new_ap/screen/Home_screen/View/pages/cart_screen.dart';
import 'package:new_ap/screen/Home_screen/widgets/cart_widget/badged.dart';
import 'package:new_ap/screen/Home_screen/widgets/main_widget.dart/categori_widget.dart';
import 'package:new_ap/screen/Home_screen/widgets/main_widget.dart/grid_kitchen.dart';
import 'package:new_ap/screen/Home_screen/widgets/main_widget.dart/promo_page.dart';
import '../../../../config/app_dimens.dart';

// ignore: must_be_immutable
class MainScreen extends StatelessWidget {
  MainScreen({super.key});
  MainController controller = Get.find<MainController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, controller.getAppbarHeight),
        child: GetX<MainController>(
          init: Get.find<MainController>(),
          builder: (controller) => controller.scrollPosition <=
                  (AppDimens.dimens_60)
              ? AnimatedOpacity(
                  opacity: controller.scrollPosition <= (AppDimens.dimens_60)
                      ? 1
                      : 0,
                  duration: const Duration(microseconds: 200),
                  child: AppBar(
                    elevation: AppDimens.dimens_0,
                    leading: controller.user.image == ''
                        ? const CircleAvatar(
                            backgroundColor: ColorConstants.colorBlue1,
                            backgroundImage:
                                AssetImage('assets/image/user.png'),
                          )
                        : CircleAvatar(
                            backgroundColor: ColorConstants.colorBlue1,
                            backgroundImage:
                                NetworkImage(controller.user.image),
                          ),
                    backgroundColor: ColorConstants.colorGrey0,
                    actions: [
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.notifications_none_outlined,
                            color: ColorConstants.themeColor,
                          )),
                      Badged(
                          value: controller.cart.length.toString(),
                          child: IconButton(
                            onPressed: () {
                              Get.to(() {
                                return CartScreen(controller.kitchenModel);
                              });
                            },
                            icon: const Icon(Icons.shopping_cart_outlined,
                                color: ColorConstants.themeColor),
                          )),
                    ],
                  ),
                )
              : AnimatedOpacity(
                  opacity: controller.scrollPosition <= (AppDimens.dimens_60)
                      ? 0
                      : 1,
                  duration: const Duration(microseconds: 200),
                  child: AppBar(
                    elevation: AppDimens.dimens_0,
                    title: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: ColorConstants.colorGrey2,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15))),
                        onPressed: () {
                          log(MediaQuery.of(context).padding.top.toString());
                        },
                        child: SizedBox(
                          height: 40,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: const <Widget>[
                              Icon(
                                Icons.search,
                                size: 35,
                                color: ColorConstants.colorGrey4,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                'Search',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: AppFont.medium,
                                    color: ColorConstants.colorBlack),
                              )
                            ],
                          ),
                        )),
                    backgroundColor: ColorConstants.colorGrey0,
                    actions: [
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.notifications_none_outlined,
                            color: ColorConstants.themeColor,
                          )),
                      Badged(
                          value: controller.cart.length.toString(),
                          child: IconButton(
                            onPressed: () {
                              Get.to(() {
                                return CartScreen(controller.kitchenModel);
                              });
                            },
                            icon: const Icon(Icons.shopping_cart_outlined,
                                color: ColorConstants.themeColor),
                          )),
                    ],
                  ),
                ),
        ),
      ),
      body: SingleChildScrollView(
        controller: controller.scrollController,
        child: Column(
          children: <Widget>[
            Container(
              height: AppBar().preferredSize.height,
              padding: const EdgeInsets.only(
                  top: AppDimens.dimens_20,
                  left: AppDimens.dimens_30,
                  right: AppDimens.dimens_30),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: ColorConstants.colorGrey2,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15))),
                  onPressed: () {
                    Get.to(() => SearchKitchenScreen());
                  },
                  child: SizedBox(
                    height: 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const <Widget>[
                        Icon(
                          Icons.search,
                          size: 35,
                          color: ColorConstants.colorGrey4,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          'Search',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: AppFont.medium,
                              color: ColorConstants.colorBlack),
                        )
                      ],
                    ),
                  )),
            ),
            SizedBox(
              height: AppDimens.dimens_210,
              child: PromoPage(),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  bottom: AppDimens.dimens_10,
                  top: AppDimens.dimens_0,
                  left: AppDimens.dimens_15,
                  right: AppDimens.dimens_15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text(
                    'Categories',
                    style: TextStyle(
                        fontSize: AppDimens.dimens_20,
                        fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                      onPressed: () {
                        Get.to(() => CategoriesScreen());
                      },
                      child: const Text(
                        'See all',
                        style: TextStyle(color: ColorConstants.themeColor),
                      ))
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppDimens.dimens_10),
              child: SizedBox(
                  height: AppDimens.dimens_120, child: CategoriesWidget()),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: AppDimens.dimens_15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text(
                    'Kitchen near you',
                    style: TextStyle(
                        fontSize: AppDimens.dimens_20,
                        fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                      onPressed: () {
                        controller.getListQuery('');
                        Get.to(() => KitchenScreen());
                      },
                      child: const Text(
                        'See all',
                        style: TextStyle(color: ColorConstants.themeColor),
                      ))
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppDimens.dimens_15),
              child: GirdKitchen(),
            ),
          ],
        ),
      ),
    );
  }
}
