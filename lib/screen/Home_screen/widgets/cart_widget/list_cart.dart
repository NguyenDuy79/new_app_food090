import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_ap/model/cart_model.dart';
import 'package:new_ap/model/kitchen_model.dart';

import 'package:new_ap/screen/Home_screen/controllers/cart_controller.dart';

import 'package:new_ap/screen/Home_screen/widgets/cart_widget/item_cart.dart';

import '../../../../config/app_dimens.dart';

// ignore: must_be_immutable
class ListCart extends StatelessWidget {
  ListCart(this.allKitchen, this.allCart, this.kitchen, {super.key});
  final List<KitchenModel> allKitchen;
  final List<CartModel> allCart;
  final List<String> kitchen;
  CartController controller = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    final height =
        MediaQuery.of(context).size.height - AppBar().preferredSize.height;
    final width = MediaQuery.of(context).size.width;

    return allCart.isEmpty
        ? Center(
            child: Column(
              children: <Widget>[
                const Text('Không có sản phẩm nào'),
                ElevatedButton(
                    onPressed: () {
                      for (int i = 0; i < controller.countScreen; i++) {
                        Get.back();
                      }
                      controller.resetCountScreen();
                    },
                    child: const Text('click để mua sắm'))
              ],
            ),
          )
        : SizedBox(
            height: allCart.length * 120 + kitchen.length * 100,
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index1) {
                String name = '';
                for (int i = 0; i < allKitchen.length; i++) {
                  if (allKitchen[i].id.trim() == kitchen[index1].trim()) {
                    name = allKitchen[i].name;
                  }
                }
                List<CartModel> cartOfKitchen = [];
                for (int i = 0; i < allCart.length; i++) {
                  if (allCart[i].kitchenId.trim() == kitchen[index1].trim()) {
                    cartOfKitchen.add(
                      allCart[i],
                    );
                  }
                }

                return Obx(
                  () => SizedBox(
                    child: Padding(
                      key: ValueKey(kitchen[index1]),
                      padding: const EdgeInsets.symmetric(
                          vertical: AppDimens.dimens_10),
                      child: Card(
                        color: Colors.grey.shade100,
                        child: Column(
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: AppDimens.dimens_8,
                                      right: AppDimens.dimens_10,
                                      left: AppDimens.dimens_10),
                                  child: SizedBox(
                                    height: AppDimens.dimens_30,
                                    width: AppDimens.dimens_30,
                                    child: Transform.scale(
                                      scale: 1.5,
                                      child: Checkbox(
                                          value: controller.selectIndex.value ==
                                                  index1 &&
                                              controller.cartOrder.isNotEmpty,
                                          onChanged: (value) {
                                            controller.cartOrder = [];
                                            if (controller.selectIndex.value ==
                                                index1) {
                                              controller.selectIndex.value = -1;
                                              controller.cartOrder = [];
                                              controller.getCount();
                                              controller.getApplyPromoCode();
                                              controller.getApplyShipping();
                                            } else {
                                              controller.selectIndex.value =
                                                  index1;
                                              for (int i = 0;
                                                  i < cartOfKitchen.length;
                                                  i++) {
                                                controller.cartOrder.add(
                                                    CartModel(
                                                        id: cartOfKitchen[i].id,
                                                        name: cartOfKitchen[i]
                                                            .name,
                                                        kitchenName:
                                                            cartOfKitchen[i]
                                                                .kitchenName,
                                                        price: cartOfKitchen[i]
                                                            .price,
                                                        quantity: cartOfKitchen[
                                                                i]
                                                            .quantity,
                                                        url: cartOfKitchen[i]
                                                            .url,
                                                        kitchenId:
                                                            cartOfKitchen[i]
                                                                .kitchenId,
                                                        productId:
                                                            cartOfKitchen[i]
                                                                .productId));
                                                controller.getCount();
                                                controller.getApplyPromoCode();
                                                controller.getApplyShipping();
                                              }
                                            }
                                          }),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {},
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: AppDimens.dimens_8,
                                        right: AppDimens.dimens_10,
                                        left: AppDimens.dimens_10),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            name,
                                            style: const TextStyle(
                                                fontSize: AppDimens.dimens_25,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Icon(
                                            Icons.arrow_forward_ios,
                                            color:
                                                Theme.of(context).primaryColor,
                                          )
                                        ]),
                                  ),
                                ),
                              ],
                            ),
                            const Divider(),
                            SizedBox(
                                width: double.infinity,
                                height:
                                    cartOfKitchen.length * AppDimens.dimens_130,
                                child: ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return ItemCart(
                                      cartOfKitchen,
                                      index1,
                                      cartOfKitchen[index],
                                      height,
                                      index,
                                      width,
                                    );
                                  },
                                  itemCount: cartOfKitchen.length,
                                ))
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
              itemCount: kitchen.length,
            ),
          );
  }
}
