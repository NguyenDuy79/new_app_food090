import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_ap/config/app_another.dart';
import 'package:new_ap/config/app_colors.dart';
import 'package:new_ap/config/app_storage_path.dart';
import 'package:new_ap/screen/Home_screen/View/pages/order_cancelled_detail_screen.dart';
import 'package:new_ap/screen/Home_screen/controllers/orders_controller.dart';
import '../../../../config/app_dimens.dart';
import '../../../../config/app_font.dart';
import '../../View/pages/cart_screen.dart';
import '../../controllers/main_controller.dart';

class CancelledOrder extends StatelessWidget {
  const CancelledOrder({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return GetX<OrderController>(
      init: Get.find<OrderController>(),
      builder: (controller) {
        return controller.getCancelledOrder().isEmpty
            ? Center(
                child: SizedBox(
                  height: height * 0.6,
                  child: Image.asset(AppStoragePath.empty),
                ),
              )
            : PageStorage(
                bucket: AppAnother.pageBucket,
                child: ListView.builder(
                    key: const PageStorageKey<String>('keyCanelled'),
                    itemCount: controller.getCancelledOrder().length,
                    itemBuilder: (contex, index) {
                      return Container(
                        height: AppDimens.dimens_210,
                        width: double.infinity,
                        margin: const EdgeInsets.all(AppDimens.dimens_20),
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(AppDimens.dimens_15),
                            color: ColorConstants.colorGrey1),
                        child: Column(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                Get.to(() => OrderCancelledDetailScreen(index));
                              },
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: AppDimens.dimens_20,
                                        vertical: AppDimens.dimens_10),
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
                                          controller
                                              .getCancelledOrder()[index]
                                              .kitchenName,
                                          style: const TextStyle(
                                              fontSize: AppDimens.dimens_25,
                                              fontWeight: AppFont.semiBold),
                                        ),
                                        const Expanded(child: SizedBox()),
                                        Text(
                                          controller
                                              .getCancelledOrder()[index]
                                              .status,
                                          style: const TextStyle(
                                              fontSize: AppDimens.dimens_22,
                                              fontWeight: AppFont.light,
                                              color: ColorConstants.themeColor),
                                        )
                                      ],
                                    ),
                                  ),
                                  Row(
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
                                                  .getCancelledOrder()[index]
                                                  .url[0],
                                              fit: BoxFit.fitHeight,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          padding: const EdgeInsets.only(
                                              bottom: AppDimens.dimens_10,
                                              top: AppDimens.dimens_10,
                                              right: AppDimens.dimens_10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: AppDimens.dimens_5),
                                                child: Text(
                                                  '${controller.getCancelledOrder()[index].name[0][0].toUpperCase()}${controller.getCancelledOrder()[index].name[0].substring(1)} ',
                                                  style: const TextStyle(
                                                      fontSize:
                                                          AppDimens.dimens_20,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              Text(
                                                  '${controller.getCancelledOrder()[index].productId.length} items',
                                                  style: const TextStyle(
                                                    fontSize:
                                                        AppDimens.dimens_20,
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
                                                      '${controller.getNewPrice(controller.getCancelledOrder()[index].price)}VNĐ',
                                                      style: const TextStyle(
                                                          fontSize: AppDimens
                                                              .dimens_15,
                                                          color: ColorConstants
                                                              .themeColor),
                                                    ),
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              AppDimens
                                                                  .dimens_5),
                                                      decoration: BoxDecoration(
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                          borderRadius: BorderRadius
                                                              .circular(AppDimens
                                                                  .dimens_5)),
                                                      child: Text(
                                                        controller
                                                            .getCancelledOrder()[
                                                                index]
                                                            .status,
                                                        style: const TextStyle(
                                                            fontSize: AppDimens
                                                                .dimens_15,
                                                            color: ColorConstants
                                                                .colorWhite),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const Divider(
                              indent: AppDimens.dimens_20,
                              endIndent: AppDimens.dimens_20,
                              thickness: 2,
                              height: AppDimens.dimens_0,
                            ),
                            Container(
                              height: AppDimens.dimens_50,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: AppDimens.dimens_20,
                                  vertical: AppDimens.dimens_10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  SizedBox(
                                    height: AppDimens.dimens_35,
                                    width: AppDimens.dimens_130,
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                                side: const BorderSide(
                                                    width: AppDimens.dimens_3,
                                                    color: ColorConstants
                                                        .themeColor),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        AppDimens.dimens_15)),
                                            backgroundColor:
                                                ColorConstants.colorWhite),
                                        onPressed: () async {
                                          await controller.orderAgain(
                                              controller
                                                  .getCancelledOrder()[index],
                                              context);
                                          Get.back();
                                          Get.back();
                                          Get.to(() => CartScreen(
                                              Get.find<MainController>()
                                                  .kitchenModel));
                                        },
                                        child: const Text(
                                          'Mua lại',
                                          style: TextStyle(
                                              color: ColorConstants.themeColor),
                                        )),
                                  ),
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
