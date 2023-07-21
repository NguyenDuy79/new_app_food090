import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:new_ap/config/app_colors.dart';

import 'package:new_ap/model/kitchen_model.dart';
import 'package:new_ap/model/product_model.dart';
import 'package:new_ap/screen/Home_screen/View/pages/detail_dish_screen.dart';
import 'package:new_ap/screen/Home_screen/controllers/main_controller.dart';

import '../../../../config/app_dimens.dart';
import '../../../../config/app_font.dart';
import '../../widgets/cart_widget/badged.dart';
import 'cart_screen.dart';

// ignore: must_be_immutable
class KitchenMenu extends StatelessWidget {
  KitchenMenu(this.kitchen, {super.key});
  final KitchenModel kitchen;

  MainController controller = Get.find<MainController>();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return CustomScrollView(slivers: [
      SliverAppBar(
        toolbarHeight: AppDimens.dimens_50,
        pinned: true,
        elevation: AppDimens.dimens_0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: ColorConstants.themeColor,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        title: ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: ColorConstants.colorBlack.withOpacity(0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
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
                    color: ColorConstants.colorGrey1,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    'Search',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: AppFont.medium,
                        color: ColorConstants.colorGrey3),
                  )
                ],
              ),
            )),
        backgroundColor: ColorConstants.colorWhite,
        expandedHeight: AppDimens.dimens_190,
        actions: [
          GetX<MainController>(
            init: Get.find<MainController>(),
            builder: (controller) => Badged(
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
          )
        ],
        flexibleSpace: Image.network(
          kitchen.imageUrl,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(AppDimens.dimens_40),
          child: Container(
              width: double.infinity,
              height: AppDimens.dimens_40,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(AppDimens.dimens_10),
                    topRight: Radius.circular(AppDimens.dimens_10)),
                color: ColorConstants.colorWhite,
              ),
              child: Container(
                decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color: ColorConstants.colorGrey3,
                            width: AppDimens.dimens_1))),
                child: Center(
                  child: Text(
                    '${kitchen.name[0].toUpperCase()}${kitchen.name.substring(1).toLowerCase()}',
                    style: const TextStyle(
                      fontSize: AppDimens.dimens_25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )),
        ),
      ),
      SliverToBoxAdapter(
        child: Container(
          color: ColorConstants.colorWhite,
          child: Column(children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.dimens_20,
                  vertical: AppDimens.dimens_5),
              child: Card(
                elevation: AppDimens.dimens_5,
                child: Column(children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppDimens.dimens_8,
                        vertical: AppDimens.dimens_5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        const Text(
                          'Đánh giá :',
                          style: TextStyle(
                              fontSize: AppDimens.dimens_25,
                              fontWeight: FontWeight.bold),
                        ),
                        RatingBarIndicator(
                          rating: double.parse(kitchen.rating),
                          itemCount: 5,
                          direction: Axis.horizontal,
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: ColorConstants.colorYellow,
                          ),
                        )
                      ],
                    ),
                  ),
                  const Divider(),
                  GestureDetector(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppDimens.dimens_8,
                          vertical: AppDimens.dimens_5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const <Widget>[
                          Text('Nhận xét :',
                              style: TextStyle(
                                  fontSize: AppDimens.dimens_25,
                                  fontWeight: FontWeight.bold)),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.green,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(),
                  GestureDetector(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.only(
                          right: AppDimens.dimens_8,
                          left: AppDimens.dimens_8,
                          bottom: AppDimens.dimens_10,
                          top: AppDimens.dimens_5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const <Widget>[
                          Text('Địa chỉ :',
                              style: TextStyle(
                                  fontSize: AppDimens.dimens_25,
                                  fontWeight: FontWeight.bold)),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: ColorConstants.themeColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ]),
              ),
            ),
            GetX<MainController>(
                initState: (state) => controller.product
                    .bindStream(controller.getProduct(kitchen.id.trim())),
                builder: (controller) {
                  return Container(
                    height: controller.getHeight(
                        height, controller.product.value.length),
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppDimens.dimens_20),
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 2 / 2.2,
                              mainAxisSpacing: AppDimens.dimens_20),
                      itemBuilder: (context, index) => menuItem(
                          kitchen.id,
                          kitchen.name,
                          controller.product.value[index],
                          controller.kitchenModel),
                      itemCount: controller.product.value.length,
                    ),
                  );
                })
          ]),
        ),
      )
    ]);
  }
}

Widget menuItem(
    String id, String name, ProductModel product, List<KitchenModel> kitchen) {
  return GestureDetector(
    onTap: () {
      Get.to(() => DetailDishScreen(id, product, name, kitchen));
    },
    child: Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.dimens_15)),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: SizedBox(
                height: AppDimens.dimens_150,
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: AppDimens.dimens_5),
              child: Text(
                product.name,
                style: const TextStyle(
                    fontSize: AppDimens.dimens_20, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.dimens_5, vertical: AppDimens.dimens_2),
              child: Text(
                '${product.price} VNĐ',
                style: const TextStyle(fontSize: AppDimens.dimens_15),
              ),
            )
          ]),
    ),
  );
}
