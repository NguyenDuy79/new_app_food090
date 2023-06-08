import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_ap/model/cart_model.dart';
import 'package:new_ap/model/kitchen_model.dart';
import 'package:new_ap/screen/Home_screen/controllers/cart_controller.dart';
import 'package:new_ap/screen/Home_screen/widgets/cart_widget/item_cart.dart';

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
                    onPressed: () {}, child: const Text('click để mua sắm'))
              ],
            ),
          )
        : ListView.builder(
            itemBuilder: (context, index1) {
              String name = '';
              for (int i = 0; i < allKitchen.length; i++) {
                if (allKitchen[i].id.trim() == kitchen[index1]) {
                  name = allKitchen[i].name;
                }
              }
              List<CartModel> cartOfKitchen = [];

              for (int i = 0; i < allCart.length; i++) {
                if (allCart[i].kitchenId.trim() == kitchen[index1]) {
                  cartOfKitchen.add(
                    CartModel(
                        id: allCart[i].id,
                        name: allCart[i].name,
                        price: allCart[i].price,
                        quantity: allCart[i].quantity,
                        url: allCart[i].url,
                        kitchenId: allCart[i].kitchenId,
                        productId: allCart[i].productId),
                  );
                }
              }
              return Obx(() => Padding(
                    key: ValueKey(kitchen[index1]),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Card(
                      color: Colors.grey.shade100,
                      child: Column(
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 8, right: 10, left: 10),
                                child: SizedBox(
                                    height: 0.05 * width,
                                    width: 0.05 * width,
                                    child: Transform.scale(
                                      scale: 1.3,
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
                                              print(
                                                  controller.selectIndex.value);
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
                                                        price: cartOfKitchen[i]
                                                            .price,
                                                        quantity:
                                                            cartOfKitchen[i]
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
                                    )),
                              ),
                              GestureDetector(
                                onTap: () {},
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8, right: 10, left: 10),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          name,
                                          style: const TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          color: Theme.of(context).primaryColor,
                                        )
                                      ]),
                                ),
                              ),
                            ],
                          ),
                          const Divider(),
                          SizedBox(
                              width: double.infinity,
                              height: height * 0.15 * cartOfKitchen.length,
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
                  ));
            },
            itemCount: kitchen.length,
          );
  }
}
