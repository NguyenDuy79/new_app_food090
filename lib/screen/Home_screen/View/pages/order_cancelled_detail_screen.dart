import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_ap/config/app_colors.dart';
import 'package:new_ap/config/app_dimens.dart';
import 'package:new_ap/config/app_font.dart';
import 'package:new_ap/screen/Home_screen/controllers/orders_controller.dart';

import '../../controllers/main_controller.dart';
import 'cart_screen.dart';

// ignore: must_be_immutable
class OrderCancelledDetailScreen extends StatelessWidget {
  OrderCancelledDetailScreen(this.index, {super.key});
  final int index;
  OrderController controller = Get.find<OrderController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.colorWhite,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: AppDimens.dimens_2,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: ColorConstants.themeColor,
            )),
        title: const Text(
          'Đã hủy',
          style: TextStyle(
              fontSize: AppDimens.dimens_24,
              fontWeight: AppFont.semiBold,
              color: ColorConstants.colorBlack),
        ),
        centerTitle: true,
        backgroundColor: ColorConstants.colorWhite,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.dimens_20),
          child: Column(
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: AppDimens.dimens_5),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Text(
                        'ID:',
                        style: TextStyle(
                            fontSize: AppDimens.dimens_20,
                            fontWeight: FontWeight.bold,
                            color: ColorConstants.colorBlack),
                      ),
                      Flexible(
                        child: FittedBox(
                            child: Text(
                                '${controller.getCancelledOrder()[index].id.split(':')[0]}:${controller.getCancelledOrder()[index].id.split(':')[1]}',
                                style: const TextStyle(
                                  fontSize: AppDimens.dimens_20,
                                  fontWeight: FontWeight.bold,
                                  color: ColorConstants.colorBlack,
                                ))),
                      )
                    ]),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: AppDimens.dimens_5),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Text(
                        'Thời gian tạo:',
                        style: TextStyle(
                            fontSize: AppDimens.dimens_20,
                            color: ColorConstants.colorBlack),
                      ),
                      Flexible(
                        child: FittedBox(
                            child: Text(
                                '${controller.getCancelledOrder()[index].id.split(':')[0]}:${controller.getCancelledOrder()[index].id.split(':')[1]}',
                                style: const TextStyle(
                                  fontSize: AppDimens.dimens_20,
                                  color: ColorConstants.colorBlack,
                                ))),
                      )
                    ]),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: AppDimens.dimens_5),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Text(
                        'Thời gian hủy:',
                        style: TextStyle(
                            fontSize: AppDimens.dimens_20,
                            color: ColorConstants.colorBlack),
                      ),
                      Flexible(
                        child: FittedBox(
                            child: Text(
                                '${controller.getCancelledOrder()[index].cancelOrder.toDate().toString().split(':')[0]}:${controller.getCancelledOrder()[index].cancelOrder.toDate().toString().split(':')[1]}',
                                style: const TextStyle(
                                  fontSize: AppDimens.dimens_20,
                                  color: ColorConstants.colorBlack,
                                ))),
                      )
                    ]),
              ),
              SizedBox(
                height: controller.getCancelledOrder()[index].productId.length *
                    AppDimens.dimens_130,
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount:
                      controller.getCancelledOrder()[index].productId.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppDimens.dimens_20,
                          vertical: AppDimens.dimens_10),
                      child: Card(
                        elevation: AppDimens.dimens_1,
                        color: ColorConstants.colorGrey0,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(AppDimens.dimens_15)),
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
                                        .getCancelledOrder()[index]
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
                                      Text(
                                        controller
                                            .getCancelledOrder()[index]
                                            .name[index],
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontSize: AppDimens.dimens_26,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      FittedBox(
                                        child: Text(
                                            '${controller.getCancelledOrder()[index].productPrice[index]}VNĐ',
                                            style: const TextStyle(
                                                fontSize: AppDimens.dimens_18,
                                                color:
                                                    ColorConstants.themeColor)),
                                      ),
                                      FittedBox(
                                        child: Text(
                                            'Số lượng :${controller.getCancelledOrder()[index].quantity[index]}',
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
                      ),
                    );
                  },
                ),
              ),
              Card(
                elevation: AppDimens.dimens_1,
                margin: const EdgeInsets.symmetric(
                    horizontal: AppDimens.dimens_20,
                    vertical: AppDimens.dimens_10),
                color: ColorConstants.colorGrey0,
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
                                '${controller.getprice(controller.getCancelledOrder()[index].productPrice, controller.getCancelledOrder()[index].quantity)} VNĐ',
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
                                '${controller.getCancelledOrder()[index].ship} VNĐ',
                                style: const TextStyle(
                                  fontSize: AppDimens.dimens_18,
                                )),
                            Text(
                                '-${controller.getCancelledOrder()[index].reduceShip} VNĐ',
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
                            controller.getCancelledOrder()[index].reduce ==
                                    '0.0'
                                ? const Text(
                                    '0 VNĐ',
                                    style: TextStyle(
                                        fontSize: AppDimens.dimens_18),
                                  )
                                : Text(
                                    '${controller.getCancelledOrder()[index].reduce}VNĐ',
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
                                '${controller.getCancelledOrder()[index].price} VNĐ',
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
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        height: AppDimens.dimens_70,
        padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.dimens_20, vertical: AppDimens.dimens_15),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                elevation: AppDimens.dimens_5,
                backgroundColor: ColorConstants.themeColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimens.dimens_8))),
            onPressed: () async {
              await controller.orderAgain(
                  controller.getCancelledOrder()[index], context);
              Get.back();
              Get.back();
              Get.to(() => CartScreen(Get.find<MainController>().kitchenModel));
            },
            child: const Text(
              'Mua Lại',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: AppDimens.dimens_25,
                  color: ColorConstants.colorWhite),
            )),
      ),
    );
  }
}
