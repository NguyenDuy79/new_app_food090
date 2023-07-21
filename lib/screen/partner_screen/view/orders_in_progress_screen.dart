import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_ap/config/app_colors.dart';
import 'package:new_ap/screen/partner_screen/controller/order_now_controller.dart';

import '../../../config/app_dimens.dart';

// ignore: must_be_immutable
class OrdersInProgressScreen extends StatelessWidget {
  OrdersInProgressScreen({super.key});
  OrderNowController controller = Get.find<OrderNowController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: AppDimens.dimens_0,
          backgroundColor: ColorConstants.colorWhite,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: const Text(
            'Đang thực hiện',
            style: TextStyle(
                fontSize: AppDimens.dimens_24,
                fontWeight: FontWeight.bold,
                color: ColorConstants.colorBlack),
          ),
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(
                Icons.arrow_back,
                color: ColorConstants.themeColor,
              )),
          actions: [
            IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(
                  Icons.search,
                  color: ColorConstants.themeColor,
                ))
          ],
        ),
        body: SingleChildScrollView(
          child: GetX<OrderNowController>(
            init: Get.find<OrderNowController>(),
            builder: (controller) => controller.orderActive.isEmpty
                ? const Center(
                    child: Text('Hiện chưa nhận đơn hàng nào',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: AppDimens.dimens_25)),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppDimens.dimens_20,
                            vertical: AppDimens.dimens_10),
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(AppDimens.dimens_10)),
                          color: ColorConstants.colorGrey1,
                          child: Padding(
                            padding: const EdgeInsets.all(AppDimens.dimens_10),
                            child: FittedBox(
                              child: Text(
                                'ID:${controller.orderActive[0].id}',
                                style: const TextStyle(
                                    fontSize: AppDimens.dimens_20,
                                    fontWeight: FontWeight.bold,
                                    color: ColorConstants.colorBlack),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: controller.orderActive[0].productId.length *
                            AppDimens.dimens_130,
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: controller.orderActive[0].productId.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: AppDimens.dimens_20,
                                  vertical: AppDimens.dimens_10),
                              child: Card(
                                elevation: AppDimens.dimens_5,
                                color: ColorConstants.colorGrey1,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        AppDimens.dimens_10)),
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
                                                .orderActive[0].url[index],
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      const Expanded(child: SizedBox()),
                                      Padding(
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
                                                    .orderActive[0].name[index],
                                                style: const TextStyle(
                                                    fontSize:
                                                        AppDimens.dimens_26,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            FittedBox(
                                              child: Text(
                                                  '${controller.orderActive[0].productPrice[index]}VNĐ',
                                                  style: const TextStyle(
                                                      fontSize:
                                                          AppDimens.dimens_18,
                                                      color: ColorConstants
                                                          .themeColor)),
                                            ),
                                            FittedBox(
                                              child: Text(
                                                  'Số lượng :${controller.orderActive[0].quantity[index]}',
                                                  style: const TextStyle(
                                                      fontSize:
                                                          AppDimens.dimens_18,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Card(
                        elevation: AppDimens.dimens_5,
                        margin: const EdgeInsets.symmetric(
                            horizontal: AppDimens.dimens_20,
                            vertical: AppDimens.dimens_10),
                        color: ColorConstants.colorGrey1,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(AppDimens.dimens_15)),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    const Text(
                                      'Tổng giá trị:',
                                      style: TextStyle(
                                          fontSize: AppDimens.dimens_20,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Text(
                                        '${controller.getprice(controller.orderActive[0].productPrice, controller.orderActive[0].quantity)} VNĐ',
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    const Text(
                                      'Tiền ship',
                                      style: TextStyle(
                                          fontSize: AppDimens.dimens_20,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Text(
                                        '${controller.orderActive[0].ship} VNĐ',
                                        style: const TextStyle(
                                          fontSize: AppDimens.dimens_18,
                                        )),
                                    Text(
                                        '-${controller.orderActive[0].reduceShip} VNĐ',
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    const Text(
                                      'Giảm giá:',
                                      style: TextStyle(
                                          fontSize: AppDimens.dimens_20,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    controller.orderActive[0].reduce == '0.0'
                                        ? const Text(
                                            '0 VNĐ',
                                            style: TextStyle(
                                                fontSize: AppDimens.dimens_18),
                                          )
                                        : Text(
                                            '${controller.orderActive[0].reduce}VNĐ',
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    const Text(
                                      'Số tiền thanh toán:',
                                      style: TextStyle(
                                          fontSize: AppDimens.dimens_20,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Text(
                                        '${controller.orderActive[0].price} VNĐ',
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
                        padding: EdgeInsets.symmetric(
                            horizontal: AppDimens.dimens_20,
                            vertical: AppDimens.dimens_10),
                        child: Text(
                          'Progress',
                          style: TextStyle(
                              fontSize: AppDimens.dimens_24,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      controller.getWidget(context, 1, Icons.note_alt_outlined,
                          controller.orderActive[0].timeOne),
                      controller.getWidget(
                          context,
                          2,
                          Icons.soup_kitchen_outlined,
                          controller.orderActive[0].timeTwo),
                      controller.getWidget(
                          context,
                          3,
                          Icons.delivery_dining_outlined,
                          controller.orderActive[0].timeThree),
                      controller.getWidget(
                          context,
                          4,
                          Icons.door_back_door_outlined,
                          controller.orderActive[0].timeFour)
                    ],
                  ),
          ),
        ),
        bottomNavigationBar: Obx(() => controller.status.value != 0
            ? Container(
                height: AppDimens.dimens_50,
                margin: const EdgeInsets.symmetric(
                    horizontal: AppDimens.dimens_15,
                    vertical: AppDimens.dimens_5),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: ColorConstants.themeColor,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(AppDimens.dimens_10))),
                    onPressed: () {
                      controller.statusDeliveryMethod(context);
                    },
                    child: FittedBox(
                      child: Text(
                        controller.getText(),
                        style: const TextStyle(
                            fontSize: AppDimens.dimens_23,
                            fontWeight: FontWeight.bold,
                            color: ColorConstants.colorBlack),
                      ),
                    )),
              )
            : const FittedBox(
                child: Text(
                  'Hãy nhận đơn hàng rồi quay lại',
                  style: TextStyle(
                      fontSize: AppDimens.dimens_20,
                      fontWeight: FontWeight.bold),
                ),
              )));
  }
}
