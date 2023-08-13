import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:new_ap/config/app_colors.dart';
import 'package:new_ap/config/app_dimens.dart';
import 'package:new_ap/config/app_font.dart';
import 'package:new_ap/screen/Home_screen/controllers/pageview_controller.dart';

class ReviewPage extends StatelessWidget {
  ReviewPage(this.kitchenId, this.productName, this.quantity, this.kitchenName,
      this.orderId,
      {super.key});
  final String kitchenId;
  final List<String> productName;
  final List<int> quantity;
  final String kitchenName;
  final String orderId;
  final ReviewPageController controller = Get.put(ReviewPageController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: ColorConstants.colorWhite,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.arrow_back_ios,
              color: ColorConstants.themeColor,
            )),
        title: const Text(
          'Đánh giá shop',
          style: TextStyle(
              fontSize: AppDimens.dimens_25,
              fontWeight: AppFont.semiBold,
              color: ColorConstants.colorBlack),
        ),
        centerTitle: true,
        elevation: AppDimens.dimens_0,
        backgroundColor: ColorConstants.colorWhite,
        actions: [
          TextButton(
              onPressed: () {},
              child: const Text(
                'Xem đơn hàng',
                style: TextStyle(
                    fontSize: AppDimens.dimens_15,
                    color: ColorConstants.themeColor),
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AppDimens.dimens_20,
          ),
          child: Column(
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: AppDimens.dimens_20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Đã đặt:',
                      style: TextStyle(
                        fontSize: AppDimens.dimens_20,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding:
                            const EdgeInsets.only(left: AppDimens.dimens_20),
                        height: AppDimens.dimens_50,
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            return Text(
                              '${productName[index]} x ${quantity[index].toString()}',
                              style: const TextStyle(
                                  fontSize: AppDimens.dimens_20),
                            );
                          },
                          itemCount: productName.length,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Obx(
                () => Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppDimens.dimens_20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      SizedBox(
                          width: AppDimens.dimens_150,
                          child: Text(
                            controller.reviewText[controller.starValue - 1],
                            style: const TextStyle(
                                fontSize: AppDimens.dimens_25,
                                fontWeight: AppFont.semiBold,
                                color: ColorConstants.colorBlack),
                          )),
                      Flexible(
                        child: FittedBox(
                          child: RatingBarIndicator(
                              rating: (controller.starValue).toDouble(),
                              itemSize: AppDimens.dimens_50,
                              itemPadding:
                                  const EdgeInsets.all(AppDimens.dimens_3),
                              unratedColor: ColorConstants.colorGrey3,
                              itemCount: 5,
                              direction: Axis.horizontal,
                              itemBuilder: (context, index) => IconButton(
                                  onPressed: () {
                                    controller.changeStarValue(index);
                                  },
                                  iconSize: AppDimens.dimens_50,
                                  padding:
                                      const EdgeInsets.all(AppDimens.dimens_0),
                                  icon: const Icon(
                                    Icons.star,
                                    color: ColorConstants.colorYellow,
                                  ))),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(
                thickness: AppDimens.dimens_2,
                color: ColorConstants.colorGrey2,
                height: AppDimens.dimens_30,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: AppDimens.dimens_20),
                child: Text(
                  'Bạn có hài lòng về bữa ăn không? Hãy cho nhà hàng biết ý kiến của bạn',
                  style: TextStyle(
                      fontSize: AppDimens.dimens_18,
                      color: ColorConstants.colorGrey4),
                ),
              ),
              const SizedBox(
                height: AppDimens.dimens_20,
              ),
              Obx(
                () => FittedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: ColorConstants.colorGrey2,
                              shape: RoundedRectangleBorder(
                                  side: controller.selecIndex == 1
                                      ? const BorderSide(
                                          width: AppDimens.dimens_1,
                                          color: ColorConstants.themeColor)
                                      : const BorderSide(
                                          width: AppDimens.dimens_0,
                                          color: ColorConstants.colorGrey2),
                                  borderRadius: BorderRadius.circular(
                                      AppDimens.dimens_10))),
                          onPressed: () {
                            controller.confirmTextSuggest(1);
                          },
                          child: Text(
                            'Chất lượng sản phẩm?',
                            style: TextStyle(
                                fontSize: AppDimens.dimens_17,
                                color:
                                    ColorConstants.colorBlack.withOpacity(0.6)),
                          )),
                      const SizedBox(
                        width: AppDimens.dimens_30,
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: ColorConstants.colorGrey2,
                              shape: RoundedRectangleBorder(
                                  side: controller.selecIndex == 2
                                      ? const BorderSide(
                                          width: AppDimens.dimens_1,
                                          color: ColorConstants.themeColor)
                                      : const BorderSide(
                                          color: ColorConstants.colorGrey2,
                                          width: AppDimens.dimens_0),
                                  borderRadius: BorderRadius.circular(
                                      AppDimens.dimens_10))),
                          onPressed: () {
                            controller.confirmTextSuggest(2);
                          },
                          child: Text(
                            'Đảm bảo vệ sinh?',
                            style: TextStyle(
                                fontSize: AppDimens.dimens_17,
                                color:
                                    ColorConstants.colorBlack.withOpacity(0.6)),
                          ))
                    ],
                  ),
                ),
              ),
              Obx(
                () => ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: ColorConstants.colorGrey2,
                        shape: RoundedRectangleBorder(
                            side: controller.selecIndex == 3
                                ? const BorderSide(
                                    width: AppDimens.dimens_1,
                                    color: ColorConstants.themeColor)
                                : const BorderSide(
                                    width: AppDimens.dimens_0,
                                    color: ColorConstants.colorGrey2),
                            borderRadius:
                                BorderRadius.circular(AppDimens.dimens_10))),
                    onPressed: () {
                      controller.confirmTextSuggest(3);
                    },
                    child: Text(
                      'Đúng giờ không?',
                      style: TextStyle(
                          fontSize: AppDimens.dimens_17,
                          color: ColorConstants.colorBlack.withOpacity(0.6)),
                    )),
              ),
              const SizedBox(
                height: AppDimens.dimens_20,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: AppDimens.dimens_20),
                child: TextField(
                  controller: controller.editingController,
                  maxLines: null,
                  decoration: const InputDecoration(
                    hintText: 'Hãy viết gì đó',
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: AppDimens.dimens_20,
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: ColorConstants.colorTransparent),
                        borderRadius: BorderRadius.all(
                            Radius.circular(AppDimens.dimens_15))),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                            Radius.circular(AppDimens.dimens_15)),
                        borderSide:
                            BorderSide(color: ColorConstants.colorTransparent)),
                    filled: true,
                    fillColor: ColorConstants.colorGrey2,
                  ),
                  onChanged: (value) {
                    if (controller.editingController.text
                            .replaceAll('\n', '')
                            .trim() !=
                        '') {
                      if (controller.selecIndex == 1 &&
                          controller.editingController.text !=
                              'Chất lượng sản phẩm:') {
                        controller.resetSelectIndex();
                      } else if (controller.selecIndex == 2 &&
                          controller.editingController.text != 'Vệ sinh:') {
                        controller.resetSelectIndex();
                      } else if (controller.selecIndex == 3 &&
                          controller.editingController.text != 'Thời gian:') {
                        controller.resetSelectIndex();
                      } else {
                        controller.changeStatusCheckEmpty();
                      }
                    } else {
                      controller.changeStatusCheckEmpty();
                    }
                  },
                ),
              ),
              Obx(
                () => Container(
                  width: double.infinity,
                  height: AppDimens.dimens_70,
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppDimens.dimens_50,
                      vertical: AppDimens.dimens_15),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: AppDimens.dimens_5,
                          backgroundColor: controller.checkEmpty
                              ? ColorConstants.colorGrey3
                              : ColorConstants.themeColor,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(AppDimens.dimens_8))),
                      onPressed: () {
                        if (!controller.checkEmpty) {
                          controller.submitReview(context, productName,
                              quantity, kitchenId, kitchenName, orderId);
                        }
                      },
                      child: const Text(
                        'Gửi',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: AppDimens.dimens_25,
                            color: ColorConstants.colorWhite),
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
