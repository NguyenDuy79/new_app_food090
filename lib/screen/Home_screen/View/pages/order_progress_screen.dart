import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_ap/config/app_colors.dart';
import 'package:new_ap/config/app_dimens.dart';
import 'package:new_ap/config/app_font.dart';
import 'package:new_ap/screen/Home_screen/controllers/orders_controller.dart';

import '../../../../common_app/common_widget.dart';

class OrderProgressScreen extends StatelessWidget {
  OrderProgressScreen(this.index, {super.key});
  final OrderController controller = Get.find<OrderController>();
  final int index;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            'Đang tiến hành',
            style: TextStyle(
                color: ColorConstants.colorBlack,
                fontSize: AppDimens.dimens_23,
                fontWeight: AppFont.bold),
          ),
          centerTitle: true,
          backgroundColor: ColorConstants.colorWhite,
          elevation: AppDimens.dimens_0,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.dimens_20, vertical: AppDimens.dimens_20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                FittedBox(
                  child: Text(
                    ' ID: ${controller.getActiveOrder()[index].id}',
                    style: const TextStyle(
                        fontWeight: AppFont.semiBold,
                        fontSize: AppDimens.dimens_20),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: AppDimens.dimens_15),
                  height: controller.getActiveOrder()[index].productId.length *
                      AppDimens.dimens_130,
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount:
                        controller.getActiveOrder()[index].productId.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: AppDimens.dimens_5,
                        color: ColorConstants.colorGrey1,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(AppDimens.dimens_10)),
                        child: SizedBox(
                          width: double.infinity,
                          height: AppDimens.dimens_90,
                          child: Row(
                            children: <Widget>[
                              SizedBox(
                                height: AppDimens.dimens_90,
                                width: AppDimens.dimens_120,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      AppDimens.dimens_10),
                                  child: Image.network(
                                    controller
                                        .getActiveOrder()[index]
                                        .url[index],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: AppDimens.dimens_10,
                                      vertical: AppDimens.dimens_5),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      FittedBox(
                                        child: Text(
                                          controller
                                              .getActiveOrder()[index]
                                              .name[index],
                                          style: const TextStyle(
                                              fontSize: AppDimens.dimens_26,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      FittedBox(
                                        child: Text(
                                            '${controller.getActiveOrder()[index].productPrice[index]}VNĐ',
                                            style: const TextStyle(
                                                fontSize: AppDimens.dimens_18,
                                                color:
                                                    ColorConstants.themeColor)),
                                      ),
                                      FittedBox(
                                        child: Text(
                                            'Số lượng :${controller.getActiveOrder()[index].quantity[index]}',
                                            style: const TextStyle(
                                                fontSize: AppDimens.dimens_18,
                                                fontWeight: FontWeight.bold)),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Card(
                  elevation: AppDimens.dimens_5,
                  color: ColorConstants.colorGrey1,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimens.dimens_15)),
                  child: SizedBox(
                    height: AppDimens.dimens_190,
                    width: double.infinity,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: AppDimens.dimens_10,
                              horizontal: AppDimens.dimens_15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              const Text(
                                'Tổng giá trị:',
                                style: TextStyle(
                                    fontSize: AppDimens.dimens_20,
                                    fontWeight: FontWeight.w700),
                              ),
                              Text(
                                  '${controller.getprice(controller.getActiveOrder()[index].productPrice, controller.getActiveOrder()[index].quantity)} VNĐ',
                                  style: const TextStyle(
                                    fontSize: AppDimens.dimens_18,
                                  ))
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: AppDimens.dimens_10,
                              horizontal: AppDimens.dimens_15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              const Text(
                                'Tiền ship',
                                style: TextStyle(
                                    fontSize: AppDimens.dimens_20,
                                    fontWeight: FontWeight.w700),
                              ),
                              Text(
                                  '${controller.getActiveOrder()[index].ship} VNĐ',
                                  style: const TextStyle(
                                    fontSize: AppDimens.dimens_18,
                                  )),
                              Text(
                                  '-${controller.getActiveOrder()[index].reduceShip} VNĐ',
                                  style: const TextStyle(
                                    fontSize: AppDimens.dimens_18,
                                  ))
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: AppDimens.dimens_10,
                              horizontal: AppDimens.dimens_15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              const Text(
                                'Giảm giá:',
                                style: TextStyle(
                                    fontSize: AppDimens.dimens_20,
                                    fontWeight: FontWeight.w700),
                              ),
                              controller.getActiveOrder()[index].reduce == '0.0'
                                  ? const Text(
                                      '0 VNĐ',
                                      style: TextStyle(
                                          fontSize: AppDimens.dimens_18),
                                    )
                                  : Text(
                                      '${controller.getActiveOrder()[index].reduce}VNĐ',
                                      style: const TextStyle(
                                        fontSize: AppDimens.dimens_18,
                                      ))
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: AppDimens.dimens_10,
                              horizontal: AppDimens.dimens_15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              const Text(
                                'Số tiền thanh toán:',
                                style: TextStyle(
                                    fontSize: AppDimens.dimens_20,
                                    fontWeight: FontWeight.w700),
                              ),
                              Text(
                                  '${controller.getActiveOrder()[index].price} VNĐ',
                                  style: const TextStyle(
                                      fontSize: AppDimens.dimens_20,
                                      fontWeight: FontWeight.w700))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: AppDimens.dimens_10),
                  child: Text(
                    'Progress',
                    style: TextStyle(
                        fontSize: AppDimens.dimens_24,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Obx(
                  () => Column(
                    children: [
                      if (controller.getStatus(controller
                              .getActiveOrder()[index]
                              .statusDelivery) >=
                          0)
                        const Center(
                          child: Text(
                            'Đơn hàng đang được đang được xử lý',
                            style: TextStyle(
                                fontSize: AppDimens.dimens_20,
                                fontWeight: AppFont.medium,
                                color: ColorConstants.colorBlack),
                          ),
                        ),
                      if (controller.getStatus(controller
                              .getActiveOrder()[index]
                              .statusDelivery) >=
                          1)
                        CommonWidget.getWidget(
                            context,
                            1,
                            Icons.note_alt_outlined,
                            controller
                                .getActiveOrder()[index]
                                .timeOne
                                .toDate()
                                .toString(),
                            controller.url[index]),
                      if (controller.getStatus(controller
                              .getActiveOrder()[index]
                              .statusDelivery) >=
                          2)
                        CommonWidget.getWidget(
                            context,
                            2,
                            Icons.soup_kitchen_outlined,
                            controller
                                .getActiveOrder()[index]
                                .timeTwo
                                .toDate()
                                .toString(),
                            controller.url[index]),
                      if (controller.getStatus(controller
                              .getActiveOrder()[index]
                              .statusDelivery) >=
                          3)
                        CommonWidget.getWidget(
                            context,
                            3,
                            Icons.soup_kitchen_outlined,
                            controller
                                .getActiveOrder()[index]
                                .timeThree
                                .toDate()
                                .toString(),
                            controller.url[index]),
                      if (controller.getStatus(controller
                              .getActiveOrder()[index]
                              .statusDelivery) >=
                          4)
                        CommonWidget.getWidget(
                            context,
                            4,
                            Icons.soup_kitchen_outlined,
                            controller
                                .getActiveOrder()[index]
                                .timeFour
                                .toDate()
                                .toString(),
                            controller.url[index])
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Obx(
          () => Container(
            height: AppDimens.dimens_50,
            margin: const EdgeInsets.symmetric(
                horizontal: AppDimens.dimens_15, vertical: AppDimens.dimens_5),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: controller.getStatus(controller
                                    .getActiveOrder()[index]
                                    .statusDelivery) >=
                                2 &&
                            controller.getStatus(controller
                                    .getActiveOrder()[index]
                                    .statusDelivery) <
                                4
                        ? ColorConstants.colorGrey4
                        : ColorConstants.themeColor,
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppDimens.dimens_10))),
                onPressed: () {
                  if (controller.getStatus(
                          controller.getActiveOrder()[index].statusDelivery) <
                      2) {
                    Get.back();
                    controller.cancelOrder(
                        controller.getActiveOrder()[index],
                        controller.getActiveOrder()[index].statusDelivery,
                        controller.getActiveOrder()[index].partnerId,
                        context);
                  } else if (controller.getStatus(
                          controller.getActiveOrder()[index].statusDelivery) ==
                      4) {
                    controller.setStateShipDelivery(
                        controller.getActiveOrder()[index].id);
                    Get.back();
                  }
                },
                child: FittedBox(
                    child: controller.getStatus(controller
                                .getActiveOrder()[index]
                                .statusDelivery) <
                            2
                        ? const Text(
                            'Hủy đơn hàng',
                            style: TextStyle(
                                fontSize: AppDimens.dimens_23,
                                fontWeight: FontWeight.bold,
                                color: ColorConstants.colorWhite),
                          )
                        : const Text(
                            'Đã nhận được hàng',
                            style: TextStyle(
                                fontSize: AppDimens.dimens_23,
                                fontWeight: FontWeight.bold,
                                color: ColorConstants.colorWhite),
                          ))),
          ),
        ));
  }
}
