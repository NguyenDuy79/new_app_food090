import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_ap/screen/Home_screen/controllers/main_controller.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../config/app_colors.dart';
import '../../../../config/app_dimens.dart';

// ignore: must_be_immutable
class PromoPage extends StatelessWidget {
  PromoPage({super.key});

  MainController controller = Get.find<MainController>();
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(
              top: AppDimens.dimens_20, bottom: AppDimens.dimens_10),
          height: width * 0.475,
          width: width * 0.95,
          child: PageView.builder(
              scrollDirection: Axis.horizontal,
              controller: controller.pageController,
              itemCount: 3,
              itemBuilder: (context, index) {
                return Obx(
                  () => GestureDetector(
                      onTap: () {},
                      child: controller.promoCode.isEmpty
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : Image.network(
                              controller.promoCode[index].image,
                              fit: BoxFit.cover,
                            )),
                );
              }),
        ),
        SmoothPageIndicator(
          controller: controller.pageController,
          count: 3,
          effect: const WormEffect(
              dotColor: ColorConstants.colorGrey4,
              dotHeight: AppDimens.dimens_12,
              dotWidth: AppDimens.dimens_12,
              activeDotColor: ColorConstants.themeColor,
              spacing: AppDimens.dimens_12,
              paintStyle: PaintingStyle.fill),
        ),
      ],
    );
  }
}
