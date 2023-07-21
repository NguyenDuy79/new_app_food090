import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_ap/config/app_colors.dart';
import 'package:new_ap/config/app_font.dart';
import 'package:new_ap/screen/Home_screen/controllers/main_controller.dart';
import 'package:new_ap/model/kitchen_model.dart';
import 'package:new_ap/screen/Home_screen/View/pages/kitchen_menu.dart';

import '../../../../config/app_dimens.dart';

class GirdKitchen extends GetView<MainController> {
  const GirdKitchen({super.key});

  @override
  Widget build(BuildContext context) {
    final heightImage =
        MediaQuery.of(context).size.width - AppDimens.dimens_20 * 2;

    return GetX<MainController>(
      init: Get.find<MainController>(),
      builder: (controller) => SizedBox(
        height: (heightImage / 2) *
            (3.05 / 2) *
            (controller.getLenght(controller.kitchenModel.length) / 2),
        width: double.infinity,
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: AppDimens.dimens_20,
              childAspectRatio: 2 / 3.05),
          itemBuilder: (ctx, i) => kitChenItem(
              controller,
              context,
              heightImage,
              controller.kitchenModel[i],
              controller.kitchenModel[i].imageUrl,
              controller.kitchenModel[i].imagechefUrl,
              controller.kitchenModel[i].name,
              controller.kitchenModel[i].time,
              controller.kitchenModel[i].ship,
              controller.kitchenModel[i].intoduct),
          itemCount: controller.kitchenModel.length,
        ),
      ),
    );
  }
}

Widget kitChenItem(
    MainController controller,
    BuildContext context,
    double height,
    KitchenModel kitchen,
    String url,
    String urlchef,
    String name,
    String time,
    String ship,
    String intoduct) {
  final intoductItem = intoduct.split(',');
  return GestureDetector(
    onTap: () {
      Get.to(() => KitchenMenu(kitchen));
    },
    child: Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.dimens_15)),
      child: Column(
        children: <Widget>[
          ClipRRect(
              borderRadius: BorderRadius.circular(AppDimens.dimens_15),
              child: SizedBox(
                height: AppDimens.dimens_150,
                child: Image.network(
                  url,
                  fit: BoxFit.cover,
                ),
              )),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.dimens_5, vertical: AppDimens.dimens_8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(
                  height: AppDimens.dimens_60,
                  width: AppDimens.dimens_60,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(urlchef),
                  ),
                ),
                const SizedBox(
                  width: AppDimens.dimens_5,
                ),
                Column(
                  children: <Widget>[
                    FittedBox(
                      child: Text(
                        name,
                        style: const TextStyle(
                            fontSize: AppDimens.dimens_17,
                            fontWeight: AppFont.semiBold),
                      ),
                    ),
                    FittedBox(
                      child: Row(
                        children: <Widget>[
                          const Icon(Icons.motorcycle_outlined,
                              color: ColorConstants.themeColor),
                          Text(
                            ship,
                            style: const TextStyle(
                                color: ColorConstants.themeColor,
                                fontSize: AppDimens.dimens_12,
                                fontWeight: AppFont.medium),
                          )
                        ],
                      ),
                    ),
                    FittedBox(
                      child: Row(
                        children: <Widget>[
                          const Icon(
                            Icons.timer,
                            color: ColorConstants.themeColor,
                          ),
                          Text(
                            time,
                            style: const TextStyle(
                                color: ColorConstants.colorGrey4,
                                fontSize: AppDimens.dimens_12,
                                fontWeight: AppFont.semiBold),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          FittedBox(
            child: Padding(
              padding: const EdgeInsets.all(AppDimens.dimens_5),
              child: Row(
                children: <Widget>[
                  ...intoductItem
                      .map(
                        (e) => Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppDimens.dimens_4),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: AppDimens.dimens_2),
                            height: AppDimens.dimens_17,
                            decoration: BoxDecoration(
                                color: ColorConstants.colorGrey2,
                                borderRadius:
                                    BorderRadius.circular(AppDimens.dimens_5)),
                            width: (height / 2 - 5 * 2 - 16) / 3,
                            child: FittedBox(
                              child: Text(
                                e,
                                style: const TextStyle(
                                    fontSize: AppDimens.dimens_15),
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList()
                ],
              ),
            ),
          )
        ],
      ),
    ),
  );
}
