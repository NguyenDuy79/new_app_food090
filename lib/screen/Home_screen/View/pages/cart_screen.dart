import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_ap/config/app_colors.dart';
import 'package:new_ap/config/app_dimens.dart';
import 'package:new_ap/model/kitchen_model.dart';
import 'package:new_ap/screen/Home_screen/controllers/cart_controller.dart';
import 'package:new_ap/screen/Home_screen/widgets/cart_widget/bill.dart';
import 'package:new_ap/screen/Home_screen/widgets/cart_widget/list_cart.dart';

class CartScreen extends GetWidget<CartController> {
  const CartScreen(this.listKitchen, {super.key});

  final List<KitchenModel> listKitchen;

  @override
  Widget build(BuildContext context) {
    final height =
        MediaQuery.of(context).size.height - AppBar().preferredSize.height;

    final width = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async {
        controller.setValue();
        return true;
      },
      child: Scaffold(
        backgroundColor: ColorConstants.colorWhite,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              controller.count.value = 0;
              controller.setValue();
              Get.back();
            },
            icon: const Icon(
              Icons.subdirectory_arrow_left_sharp,
              color: ColorConstants.themeColor,
            ),
          ),
          centerTitle: true,
          backgroundColor: ColorConstants.colorWhite,
          elevation: 0,
          title: const Text(
            'Cart',
            style: TextStyle(
                fontSize: AppDimens.dimens_28,
                fontWeight: FontWeight.bold,
                color: ColorConstants.colorBlack),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              GetX<CartController>(
                  init: Get.find<CartController>(),
                  builder: (CartController controller) {
                    controller.getKitchen();
                    return ListCart(
                        listKitchen, controller.cart, controller.kitchen);
                  }),
              BillCart(height, width)
            ],
          ),
        ),
        bottomNavigationBar: Obx(() => controller.cart.isEmpty
            ? Container(
                height: AppDimens.dimens_54,
                color: ColorConstants.colorWhite,
              )
            : Container(
                margin: const EdgeInsets.symmetric(
                    horizontal: AppDimens.dimens_20,
                    vertical: AppDimens.dimens_10),
                height: AppDimens.dimens_54,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: ColorConstants.themeColor,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(AppDimens.dimens_15))),
                    onPressed: () async {
                      if (controller.cartOrder.isNotEmpty) {
                        await controller.orders(context);
                      } else {
                        if (controller.error.value) {
                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                                  backgroundColor: ColorConstants.colorRed1,
                                  duration: Duration(seconds: 1),
                                  content: Text(
                                    'Bạn chưa chọn sản phẩm nào',
                                    style: TextStyle(
                                        fontSize: AppDimens.dimens_20),
                                  )));
                        } else {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                                  backgroundColor: ColorConstants.colorRed1,
                                  duration: Duration(seconds: 1),
                                  content: Text(
                                    'Bạn chưa chọn sản phẩm nào',
                                    style: TextStyle(
                                        fontSize: AppDimens.dimens_20),
                                  )));
                        }
                      }
                    },
                    child: controller.error.value
                        ? const Text('Không thể áp dụng mã giảm',
                            style: TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.bold,
                                color: ColorConstants.colorWhite))
                        : const Text('Đặt hàng',
                            style: TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.bold,
                                color: ColorConstants.colorWhite))))),
      ),
    );
  }
}
