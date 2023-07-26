import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_ap/config/app_colors.dart';
import 'package:new_ap/config/app_dimens.dart';
import 'package:new_ap/model/kitchen_model.dart';
import 'package:new_ap/screen/Home_screen/controllers/detail_product_controller.dart';
import 'package:new_ap/model/product_model.dart';

import '../../widgets/cart_widget/badged.dart';
import 'cart_screen.dart';

// ignore: must_be_immutable
class DetailDishScreen extends StatelessWidget {
  DetailDishScreen(this.id, this.dish, this.name, this.kitchen, {super.key});
  final ProductModel dish;
  final String name;
  final String id;
  final List<KitchenModel> kitchen;

  DetailProductController controller = Get.put(DetailProductController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: ColorConstants.colorWhite,
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: ColorConstants.themeColor,
            ),
          ),
          title: const Text(
            'Food',
            style: TextStyle(
                color: ColorConstants.colorBlack,
                fontSize: AppDimens.dimens_24,
                fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          actions: [
            Obx(() {
              log(controller.cart.length.toString());
              return Badged(
                  value: controller.cart.length.toString(),
                  child: IconButton(
                    onPressed: () {
                      Get.to(() {
                        return CartScreen(kitchen);
                      });
                    },
                    icon: const Icon(Icons.shopping_cart_outlined,
                        color: ColorConstants.themeColor),
                  ));
            }),
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.density_medium_outlined,
                  color: ColorConstants.themeColor,
                ))
          ],
        ),
        body: SingleChildScrollView(
          child: Column(children: <Widget>[
            SizedBox(
                width: double.infinity,
                height: AppDimens.dimens_250,
                child: Image.network(
                  dish.imageUrl,
                  fit: BoxFit.cover,
                )),
            Container(
              padding: const EdgeInsets.only(top: AppDimens.dimens_20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppDimens.dimens_15),
                color: ColorConstants.colorGrey1,
              ),
              width: double.infinity,
              margin: const EdgeInsets.symmetric(
                  horizontal: AppDimens.dimens_20,
                  vertical: AppDimens.dimens_10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Container(
                      width: AppDimens.dimens_150,
                      height: AppDimens.dimens_54,
                      decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(AppDimens.dimens_15),
                          color: ColorConstants.themeColor),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            width: AppDimens.dimens_40,
                            height: AppDimens.dimens_54,
                            alignment: Alignment.center,
                            child: TextButton(
                                onPressed: () {
                                  if (controller.count > 1) {
                                    controller.reduce();
                                  }
                                },
                                child: const Text(
                                  '-',
                                  style: TextStyle(
                                      color: ColorConstants.colorBlack,
                                      fontSize: AppDimens.dimens_30,
                                      fontWeight: FontWeight.bold),
                                )),
                          ),
                          SizedBox(
                              width: AppDimens.dimens_70,
                              child: Align(
                                  alignment: Alignment.center,
                                  child: FittedBox(
                                    child: Obx(
                                      () => Text(
                                        '${controller.count}',
                                        style: const TextStyle(
                                            fontSize: AppDimens.dimens_25),
                                      ),
                                    ),
                                  ))),
                          Container(
                            width: AppDimens.dimens_40,
                            height: AppDimens.dimens_54,
                            alignment: Alignment.center,
                            child: TextButton(
                                onPressed: () {
                                  controller.increase();
                                },
                                child: const Text(
                                  '+',
                                  style: TextStyle(
                                      color: ColorConstants.colorBlack,
                                      fontSize: AppDimens.dimens_30,
                                      fontWeight: FontWeight.bold),
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      FittedBox(
                        child: Text(
                          dish.name,
                          style: const TextStyle(
                              fontSize: AppDimens.dimens_25,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                        icon: dish.favorite
                            ? const Icon(
                                Icons.favorite,
                                color: Colors.red,
                              )
                            : const Icon(Icons.favorite_border_outlined),
                        onPressed: () {},
                      )
                    ],
                  ),
                  Center(
                    child: Container(
                      width: 110,
                      decoration: BoxDecoration(
                          color: ColorConstants.colorGrey2,
                          borderRadius:
                              BorderRadius.circular(AppDimens.dimens_5)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppDimens.dimens_10,
                          vertical: AppDimens.dimens_5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const Icon(
                            Icons.attach_money_sharp,
                            color: ColorConstants.themeColor,
                          ),
                          FittedBox(
                              child: Text(
                            dish.price,
                            style:
                                const TextStyle(fontSize: AppDimens.dimens_22),
                          ))
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: AppDimens.dimens_22,
                  ),
                  const Text(
                    'Details',
                    style: TextStyle(
                        fontSize: AppDimens.dimens_22,
                        fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(AppDimens.dimens_20),
                    child: Text(
                      dish.intoduct,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                  if ((dish.topping).isNotEmpty)
                    const Text(
                      'Topping',
                      style: TextStyle(
                          fontSize: AppDimens.dimens_25,
                          fontWeight: FontWeight.bold),
                    ),
                  if ((dish.topping).isNotEmpty)
                    Container(
                      height: (dish.topping).split(',').length % 3 == 0
                          ? ((dish.topping).split(',').length / 3) * 70
                          : ((dish.topping).split(',').length ~/ 3 + 1) * 70,
                      padding: const EdgeInsets.all(AppDimens.dimens_15),
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                childAspectRatio: 3 / 1,
                                crossAxisSpacing: AppDimens.dimens_15),
                        itemBuilder: (ctx, index) => InkWell(
                          onTap: () {},
                          child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: AppDimens.dimens_6,
                                  vertical: AppDimens.dimens_3),
                              decoration: BoxDecoration(
                                  color: ColorConstants.colorGrey2,
                                  borderRadius:
                                      BorderRadius.circular(AppDimens.dimens_5),
                                  border: Border.all(
                                      color: controller.selectIndex == index
                                          ? ColorConstants.themeColor
                                          : ColorConstants.colorGrey2,
                                      width: AppDimens.dimens_1)),
                              child: FittedBox(
                                  child: Text(dish.topping.split(',')[index]))),
                        ),
                        itemCount: (dish.topping).split(',').length,
                      ),
                    )
                ],
              ),
            ),
          ]),
        ),
        bottomNavigationBar: Container(
          margin: const EdgeInsets.symmetric(
              horizontal: AppDimens.dimens_10, vertical: AppDimens.dimens_5),
          height: AppDimens.dimens_60,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: ColorConstants.themeColor,
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppDimens.dimens_15))),
              onPressed: () {
                controller.addItem(context, name, dish.id, dish.price,
                    dish.name, dish.imageUrl, id, controller.count);
              },
              child: Obx(() {
                return controller.loadingData.value == true
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text('Add to cart:',
                              style: TextStyle(
                                fontSize: AppDimens.dimens_23,
                                fontWeight: FontWeight.bold,
                                color: ColorConstants.colorWhite,
                              )),
                          Text(
                              ' ${int.parse(dish.price) * controller.count}VNĐ',
                              style: const TextStyle(
                                  fontSize: AppDimens.dimens_23,
                                  fontWeight: FontWeight.bold,
                                  color: ColorConstants.colorWhite))
                        ],
                      );
              })),
        ));
  }
}
