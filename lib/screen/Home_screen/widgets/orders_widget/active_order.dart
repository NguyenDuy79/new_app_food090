import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_ap/config/app_another.dart';

import 'package:new_ap/screen/Home_screen/controllers/orders_controller.dart';

import '../../../../config/app_colors.dart';
import '../../../../config/app_dimens.dart';

class ActiveOrder extends StatelessWidget {
  const ActiveOrder(this.height, this.width, {super.key});
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return GetX<OrderController>(
      init: Get.find<OrderController>(),
      builder: (controller) {
        return controller.getActiveOrder().isEmpty
            ? Padding(
                padding: const EdgeInsets.only(top: AppDimens.dimens_50),
                child: Center(
                  child: Column(
                    children: <Widget>[
                      const Text(
                        'Chưa có đơn hàng nào',
                        style: TextStyle(
                            fontSize: AppDimens.dimens_25,
                            fontWeight: FontWeight.bold),
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      AppDimens.dimens_8)),
                              backgroundColor: ColorConstants.themeColor),
                          onPressed: () {},
                          child: const Text(
                            'Đặt hàng ngay',
                            style: TextStyle(
                                fontSize: AppDimens.dimens_20,
                                fontWeight: FontWeight.bold),
                          ))
                    ],
                  ),
                ),
              )
            : PageStorage(
                bucket: AppAnother.pageBucket,
                child: ListView.builder(
                    key: const PageStorageKey<String>('Active'),
                    itemCount: controller.getActiveOrder().length,
                    itemBuilder: (contex, index) {
                      return Container(
                        height:
                            controller.getActiveOrder()[index].statusDelivery ==
                                    'Giao hàng thành công'
                                ? AppDimens.dimens_160
                                : AppDimens.dimens_120,
                        width: width,
                        margin: const EdgeInsets.all(AppDimens.dimens_20),
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(AppDimens.dimens_15),
                            color: ColorConstants.colorGrey1),
                        child: Column(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {},
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(
                                        AppDimens.dimens_10),
                                    child: SizedBox(
                                      height: AppDimens.dimens_90,
                                      width: AppDimens.dimens_90,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                            AppDimens.dimens_15),
                                        child: Image.network(
                                          controller
                                              .getActiveOrder()[index]
                                              .url[0],
                                          fit: BoxFit.fitHeight,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(
                                          AppDimens.dimens_10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: AppDimens.dimens_5),
                                            child: Text(
                                              '${controller.getActiveOrder()[index].name[0][0].toUpperCase()}${controller.getActiveOrder()[index].name[0].substring(1)} ',
                                              style: const TextStyle(
                                                  fontSize: AppDimens.dimens_20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Text(
                                              '${controller.getActiveOrder()[index].productId.length} items',
                                              style: const TextStyle(
                                                fontSize: AppDimens.dimens_20,
                                              )),
                                          Container(
                                            padding: const EdgeInsets.only(
                                                top: AppDimens.dimens_5),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Text(
                                                  '${controller.getNewPrice(controller.getActiveOrder()[index].price)}VNĐ',
                                                  style: const TextStyle(
                                                      fontSize:
                                                          AppDimens.dimens_15,
                                                      color: ColorConstants
                                                          .themeColor),
                                                ),
                                                const SizedBox(
                                                  width: AppDimens.dimens_15,
                                                ),
                                                Flexible(
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            AppDimens.dimens_5),
                                                    decoration: BoxDecoration(
                                                        color: ColorConstants
                                                            .themeColor,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                AppDimens
                                                                    .dimens_5)),
                                                    child: FittedBox(
                                                      child: Text(
                                                        controller
                                                            .getActiveOrder()[
                                                                index]
                                                            .statusDelivery,
                                                        style: const TextStyle(
                                                            fontSize: AppDimens
                                                                .dimens_15,
                                                            color: ColorConstants
                                                                .colorWhite),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            if (controller
                                    .getActiveOrder()[index]
                                    .statusDelivery ==
                                'Giao hàng thành công')
                              const Divider(
                                height: AppDimens.dimens_1,
                                thickness: AppDimens.dimens_0,
                              ),
                            if (controller
                                    .getActiveOrder()[index]
                                    .statusDelivery ==
                                'Giao hàng thành công')
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: AppDimens.dimens_20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      'Đã thanh toán ${controller.getNewPrice(controller.getActiveOrder()[index].price)}VNĐ',
                                      style: const TextStyle(
                                          fontSize: AppDimens.dimens_15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                ColorConstants.themeColor,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        AppDimens.dimens_5))),
                                        onPressed: () {
                                          controller.setStateShipDelivery(
                                              controller
                                                  .getActiveOrder()[index]
                                                  .id);
                                        },
                                        child: const Text('Xác nhận')),
                                  ],
                                ),
                              )
                          ],
                        ),
                      );
                    }),
              );
      },
    );
  }
}
