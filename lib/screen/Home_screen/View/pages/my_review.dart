import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:new_ap/config/app_another.dart';
import 'package:new_ap/config/app_colors.dart';
import 'package:new_ap/config/app_dimens.dart';
import 'package:new_ap/config/app_font.dart';
import 'package:new_ap/screen/Home_screen/View/pages/kitchen_menu.dart';
import 'package:new_ap/screen/Home_screen/controllers/main_controller.dart';

import 'package:new_ap/screen/Home_screen/controllers/profile_controller.dart';

class MyReviewScreen extends StatelessWidget {
  MyReviewScreen({super.key});
  final ProfileController controller = Get.find<ProfileController>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: ColorConstants.colorWhite,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: ColorConstants.themeColor,
            )),
        elevation: AppDimens.dimens_1,
        backgroundColor: ColorConstants.colorWhite,
        title: const Text(
          'Đánh giá của tôi',
          style: TextStyle(
              fontSize: AppDimens.dimens_25,
              color: ColorConstants.colorBlack,
              fontWeight: AppFont.bold),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return Container(
            color: ColorConstants.colorWhite,
            margin: const EdgeInsets.only(top: AppDimens.dimens_10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimens.dimens_20,
                  ),
                  child: Row(
                    children: <Widget>[
                      const Icon(
                        size: AppDimens.dimens_25,
                        Icons.store,
                        color: ColorConstants.themeColor,
                      ),
                      const SizedBox(
                        width: AppDimens.dimens_5,
                      ),
                      Text(
                        AppAnother.capitalizefirstletter(
                            controller.rateAndComment[index].kitchenOrUserName),
                        style: const TextStyle(
                            fontSize: AppDimens.dimens_25,
                            fontWeight: AppFont.semiBold),
                      ),
                      const Expanded(child: SizedBox()),
                      TextButton(
                        onPressed: () {
                          int value = Get.find<MainController>()
                              .kitchenModel
                              .indexWhere((element) =>
                                  element.id ==
                                  controller
                                      .rateAndComment[index].kitchenOrUserId);
                          Get.back();
                          Get.to(() => KitchenMenu(
                              Get.find<MainController>().kitchenModel[value]));
                        },
                        style: TextButton.styleFrom(
                            padding: const EdgeInsets.all(AppDimens.dimens_0)),
                        child: const Text('Xem shop',
                            style: TextStyle(
                                color: ColorConstants.themeColor,
                                fontSize: AppDimens.dimens_18)),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppDimens.dimens_20),
                  child: Row(
                    children: <Widget>[
                      CircleAvatar(
                        backgroundImage: NetworkImage(controller.user.image),
                      ),
                      const SizedBox(
                        width: AppDimens.dimens_20,
                      ),
                      Text(
                        controller.user.userName,
                        style: const TextStyle(
                            fontSize: AppDimens.dimens_19,
                            fontWeight: AppFont.semiBold),
                      ),
                      const Expanded(child: SizedBox()),
                      Row(children: <Widget>[
                        controller.rateAndComment[index].like == 0
                            ? const Icon(Icons.favorite_border)
                            : const Icon(
                                Icons.favorite,
                                color: ColorConstants.colorRed1,
                              ),
                        controller.rateAndComment[index].like == 0
                            ? Text(
                                'Hữu ích',
                                style: TextStyle(
                                    fontSize: AppDimens.dimens_15,
                                    color: ColorConstants.charcoalGreen
                                        .withOpacity(0.7)),
                              )
                            : Text(
                                'Hữu ích (${controller.rateAndComment[index].like})',
                                style: TextStyle(
                                    fontSize: AppDimens.dimens_15,
                                    color: ColorConstants.charcoalGreen
                                        .withOpacity(0.7)),
                              )
                      ]),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppDimens.dimens_20),
                  child: Row(
                    children: [
                      RatingBarIndicator(
                          rating: double.parse(
                              controller.rateAndComment[index].rate.toString()),
                          itemSize: AppDimens.dimens_15,
                          unratedColor: ColorConstants.colorGrey3,
                          itemCount: 5,
                          direction: Axis.horizontal,
                          itemBuilder: (context, _) => const Icon(
                                Icons.star,
                                color: ColorConstants.colorYellow,
                              )),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppDimens.dimens_20),
                  child: Text(
                    controller.rateAndComment[index].comment,
                    style: TextStyle(
                        fontSize: AppDimens.dimens_15,
                        color: ColorConstants.colorBlack.withOpacity(0.8)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppDimens.dimens_20),
                  child: Text(
                    'Đã đặt: ${controller.getBooked(index)}',
                    style: TextStyle(
                        fontSize: AppDimens.dimens_15,
                        color: ColorConstants.colorGrey4.withOpacity(0.8)),
                  ),
                ),
              ],
            ),
          );
        },
        itemCount: controller.rateAndComment.length,
      ),
    ));
  }
}
