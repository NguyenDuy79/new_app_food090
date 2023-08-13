import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:new_ap/config/app_colors.dart';
import 'package:new_ap/config/app_dimens.dart';
import 'package:new_ap/config/app_font.dart';
import 'package:new_ap/config/app_storage_path.dart';
import 'package:new_ap/screen/Home_screen/controllers/main_controller.dart';

class RateAndComment extends StatelessWidget {
  RateAndComment(this.id, {super.key});
  final String id;
  final MainController controller = Get.find<MainController>();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return SafeArea(
        child: Scaffold(
            backgroundColor: ColorConstants.colorWhite,
            appBar: AppBar(
              elevation: AppDimens.dimens_0,
              backgroundColor: ColorConstants.colorWhite,
              automaticallyImplyLeading: false,
              leading: IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: ColorConstants.themeColor,
                  )),
              title: const Text(
                'Đánh giá và nhận xét',
                style: TextStyle(
                    fontSize: AppDimens.dimens_20,
                    fontWeight: AppFont.semiBold,
                    color: ColorConstants.colorBlack),
              ),
            ),
            body: SingleChildScrollView(
              child: GetX<MainController>(
                initState: (state) => controller.rateAndComment
                    .bindStream(controller.getReview(id)),
                builder: (controller) => Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: AppDimens.dimens_15,
                          horizontal: AppDimens.dimens_20),
                      child: SizedBox(
                        width: double.infinity,
                        child: IntrinsicHeight(
                          child: Row(children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: AppDimens.dimens_10,
                                  bottom: AppDimens.dimens_10,
                                  right: AppDimens.dimens_20),
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    controller.rateAndComment.value.isEmpty
                                        ? '0'
                                        : controller.getRate(),
                                    style: const TextStyle(
                                        fontSize: AppDimens.dimens_30,
                                        fontWeight: AppFont.semiBold,
                                        color: ColorConstants.colorBlack),
                                  ),
                                  RatingBarIndicator(
                                      rating: double.parse(controller
                                              .rateAndComment.value.isEmpty
                                          ? '0'
                                          : controller.getRate()),
                                      itemSize: AppDimens.dimens_15,
                                      unratedColor: ColorConstants.colorGrey3,
                                      itemCount: 5,
                                      direction: Axis.horizontal,
                                      itemBuilder: (context, _) => const Icon(
                                            Icons.star,
                                            color: ColorConstants.colorYellow,
                                          )),
                                  Text(
                                    controller.rateAndComment.value.isEmpty
                                        ? '0 đánh giá'
                                        : '${controller.rateAndComment.value.length.toString()} đánh giá',
                                    style: const TextStyle(
                                        fontSize: AppDimens.dimens_15,
                                        color: ColorConstants.colorGrey4),
                                  )
                                ],
                              ),
                            ),
                            const VerticalDivider(
                              width: AppDimens.dimens_2,
                              thickness: 2,
                              color: ColorConstants.colorGrey4,
                            ),
                            Expanded(
                                child: Padding(
                              padding: const EdgeInsets.only(
                                  top: AppDimens.dimens_10,
                                  bottom: AppDimens.dimens_10,
                                  left: AppDimens.dimens_20),
                              child: Column(
                                children: <Widget>[
                                  qunatityOverTotal(
                                      width,
                                      5,
                                      controller.rateAndComment.value.isEmpty
                                          ? 0
                                          : controller.ratioStart(5)),
                                  qunatityOverTotal(
                                      width,
                                      4,
                                      controller.rateAndComment.value.isEmpty
                                          ? 0
                                          : controller.ratioStart(4)),
                                  qunatityOverTotal(
                                      width,
                                      3,
                                      controller.rateAndComment.value.isEmpty
                                          ? 0
                                          : controller.ratioStart(3)),
                                  qunatityOverTotal(
                                      width,
                                      2,
                                      controller.rateAndComment.value.isEmpty
                                          ? 0
                                          : controller.ratioStart(2)),
                                  qunatityOverTotal(
                                      width,
                                      1,
                                      controller.rateAndComment.value.isEmpty
                                          ? 0
                                          : controller.ratioStart(1)),
                                ],
                              ),
                            ))
                          ]),
                        ),
                      ),
                    ),
                    Container(
                      height: controller.rateAndComment.value.isEmpty
                          ? height * 0.4
                          : controller.rateAndComment.value.length *
                                  AppDimens.dimens_100 +
                              AppDimens.dimens_40,
                      padding: const EdgeInsets.symmetric(
                          vertical: AppDimens.dimens_20,
                          horizontal: AppDimens.dimens_10),
                      child: controller.rateAndComment.value.isEmpty
                          ? Image.asset(AppStoragePath.empty)
                          : ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: controller.rateAndComment.value.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              controller
                                                  .rateAndComment
                                                  .value[index]
                                                  .kitchenOrUserImage),
                                        ),
                                        const SizedBox(
                                          width: AppDimens.dimens_20,
                                        ),
                                        Text(
                                          controller.rateAndComment.value[index]
                                              .kitchenOrUserName,
                                          style: const TextStyle(
                                              fontSize: AppDimens.dimens_19,
                                              fontWeight: AppFont.semiBold),
                                        ),
                                        const Expanded(child: SizedBox()),
                                        GestureDetector(
                                          onTap: () {
                                            controller.likeMethod(
                                                id, index, context);
                                          },
                                          child: Row(children: <Widget>[
                                            controller.rateAndComment
                                                        .value[index].like ==
                                                    0
                                                ? const Icon(
                                                    Icons.favorite_border)
                                                : const Icon(
                                                    Icons.favorite,
                                                    color: ColorConstants
                                                        .colorRed1,
                                                  ),
                                            controller.rateAndComment
                                                        .value[index].like ==
                                                    0
                                                ? Text(
                                                    'Hữu ích',
                                                    style: TextStyle(
                                                        fontSize:
                                                            AppDimens.dimens_15,
                                                        color: ColorConstants
                                                            .charcoalGreen
                                                            .withOpacity(0.7)),
                                                  )
                                                : Text(
                                                    'Hữu ích (${controller.rateAndComment.value[index].like})',
                                                    style: TextStyle(
                                                        fontSize:
                                                            AppDimens.dimens_15,
                                                        color: ColorConstants
                                                            .charcoalGreen
                                                            .withOpacity(0.7)),
                                                  )
                                          ]),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        RatingBarIndicator(
                                            rating: double.parse(controller
                                                .rateAndComment
                                                .value[index]
                                                .rate
                                                .toString()),
                                            itemSize: AppDimens.dimens_15,
                                            unratedColor:
                                                ColorConstants.colorGrey3,
                                            itemCount: 5,
                                            direction: Axis.horizontal,
                                            itemBuilder: (context, _) =>
                                                const Icon(
                                                  Icons.star,
                                                  color: ColorConstants
                                                      .colorYellow,
                                                )),
                                      ],
                                    ),
                                    Text(
                                      controller
                                          .rateAndComment.value[index].comment,
                                      style: TextStyle(
                                          fontSize: AppDimens.dimens_15,
                                          color: ColorConstants.colorBlack
                                              .withOpacity(0.8)),
                                    ),
                                    Text(
                                      'Đã đặt: ${controller.getBooked(index)}',
                                      style: TextStyle(
                                          fontSize: AppDimens.dimens_15,
                                          color: ColorConstants.colorGrey4
                                              .withOpacity(0.8)),
                                    ),
                                  ],
                                );
                              },
                            ),
                    )
                  ],
                ),
              ),
            )));
  }
}

Widget qunatityOverTotal(double width, int count, double raito) {
  return FittedBox(
    child: Row(
      children: <Widget>[
        Text(
          count.toString(),
          style: const TextStyle(fontSize: AppDimens.dimens_15),
        ),
        const SizedBox(
          width: AppDimens.dimens_10,
        ),
        SizedBox(
          height: AppDimens.dimens_7,
          width: width * 0.5,
          child: Stack(children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  color: ColorConstants.colorGrey3,
                  borderRadius: BorderRadius.circular(AppDimens.dimens_3)),
            ),
            FractionallySizedBox(
              widthFactor: raito,
              heightFactor: 1,
              child: Container(
                decoration: BoxDecoration(
                    color: ColorConstants.themeColor,
                    borderRadius: BorderRadius.circular(AppDimens.dimens_3)),
              ),
            )
          ]),
        ),
      ],
    ),
  );
}
