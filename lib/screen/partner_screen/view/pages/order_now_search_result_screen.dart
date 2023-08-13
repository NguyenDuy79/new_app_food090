import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_ap/config/app_storage_path.dart';
import 'package:new_ap/screen/Search_Screen/partner/search_order_now_screen.dart';
import 'package:new_ap/screen/partner_screen/controller/order_now_controller.dart';

import '../../../../config/app_colors.dart';
import '../../../../config/app_dimens.dart';
import '../../../../config/app_font.dart';

// ignore: must_be_immutable
class OrderNowSearchResultScreen extends StatelessWidget {
  OrderNowSearchResultScreen({super.key});
  OrderNowController controller = Get.find<OrderNowController>();
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async {
        controller.textEditing.clear();
        controller.changeStatusEmpty();
        controller.getListQuery('');
        controller.getTrueIsMain();
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: ColorConstants.colorWhite,
          body: Obx(() => Column(
                children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.only(
                          top: AppDimens.dimens_30,
                          left: AppDimens.dimens_5,
                          right: AppDimens.dimens_25),
                      child: SizedBox(
                          height: AppDimens.dimens_40,
                          child: Row(
                            children: [
                              IconButton(
                                  padding: const EdgeInsets.all(0),
                                  onPressed: () {
                                    controller.textEditing.clear();
                                    controller.changeStatusEmpty();
                                    controller.getListQuery('');
                                    controller.getTrueIsMain();
                                    Get.back();
                                  },
                                  iconSize: AppDimens.dimens_30,
                                  icon: const Icon(
                                    Icons.arrow_back_ios,
                                    color: ColorConstants.themeColor,
                                  )),
                              Expanded(
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                        backgroundColor:
                                            ColorConstants.colorGrey2,
                                      ),
                                      onPressed: () {
                                        controller.changeStatusEmpty();
                                        controller.getSuggest(
                                            controller.textEditing.text);
                                        Get.to(() => SearchOrderNowScreen());
                                      },
                                      child: SizedBox(
                                          height: 40,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              const Icon(
                                                Icons.search,
                                                size: 35,
                                                color:
                                                    ColorConstants.colorGrey4,
                                              ),
                                              const SizedBox(
                                                width: 20,
                                              ),
                                              controller.textEditing.text == ''
                                                  ? const Text('Search Product',
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              AppFont.medium,
                                                          color: ColorConstants
                                                              .colorGrey4))
                                                  : Text(
                                                      controller
                                                          .textEditing.text,
                                                      style: const TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              AppFont.medium,
                                                          color: ColorConstants
                                                              .colorBlack),
                                                    )
                                            ],
                                          )))),
                            ],
                          ))),
                  controller.isLoading == true
                      ? const Align(
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(),
                        )
                      : controller.resultSearch.isEmpty
                          ? Center(
                              child: SizedBox(
                                height: height * 0.6,
                                child: Image.asset(AppStoragePath.empty),
                              ),
                            )
                          : Container(
                              height: AppDimens.dimens_40 +
                                  AppDimens.dimens_235 *
                                      controller.resultSearch.length,
                              padding: const EdgeInsets.only(
                                  left: AppDimens.dimens_10,
                                  right: AppDimens.dimens_10,
                                  top: AppDimens.dimens_40),
                              child: ListView.builder(
                                itemCount: controller.resultSearch.length,
                                itemBuilder: (context, index) {
                                  return Card(
                                    elevation: AppDimens.dimens_4,
                                    color: ColorConstants.colorGrey1,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            AppDimens.dimens_10)),
                                    child: SizedBox(
                                      width: double.infinity,
                                      height: AppDimens.dimens_225,
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              padding: const EdgeInsets.only(
                                                  right: AppDimens.dimens_20,
                                                  top: AppDimens.dimens_5,
                                                  bottom: AppDimens.dimens_5,
                                                  left: AppDimens.dimens_5),
                                              child: Row(
                                                children: <Widget>[
                                                  const Icon(
                                                    size: AppDimens.dimens_25,
                                                    Icons.store,
                                                    color: ColorConstants
                                                        .themeColor,
                                                  ),
                                                  const SizedBox(
                                                    width: AppDimens.dimens_5,
                                                  ),
                                                  Text(
                                                    controller
                                                        .resultSearch[index]
                                                        .kitchenName,
                                                    style: const TextStyle(
                                                        fontSize:
                                                            AppDimens.dimens_25,
                                                        fontWeight:
                                                            AppFont.semiBold),
                                                  ),
                                                  const Expanded(
                                                      child: SizedBox()),
                                                  const Text(
                                                    'Cách ... km',
                                                    style: TextStyle(
                                                        fontSize:
                                                            AppDimens.dimens_20,
                                                        fontWeight:
                                                            AppFont.light,
                                                        color: ColorConstants
                                                            .themeColor),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: AppDimens.dimens_10,
                                                  right: AppDimens.dimens_10),
                                              child: Row(
                                                children: <Widget>[
                                                  SizedBox(
                                                    height:
                                                        AppDimens.dimens_120,
                                                    width: AppDimens.dimens_150,
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              AppDimens
                                                                  .dimens_15),
                                                      child: Image.network(
                                                        controller
                                                            .resultSearch[index]
                                                            .url[0],
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: AppDimens
                                                                  .dimens_5),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          FittedBox(
                                                            child: Text(
                                                              controller
                                                                  .resultSearch[
                                                                      index]
                                                                  .kitchenName,
                                                              style: const TextStyle(
                                                                  fontSize:
                                                                      AppDimens
                                                                          .dimens_25,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: AppDimens
                                                                .dimens_5,
                                                          ),
                                                          FittedBox(
                                                            child: Row(
                                                              children: [
                                                                Text(
                                                                  '${controller.resultSearch[index].productId.length} items',
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          AppDimens
                                                                              .dimens_22),
                                                                ),
                                                                const SizedBox(
                                                                  width: AppDimens
                                                                      .dimens_20,
                                                                ),
                                                                Text(
                                                                    '${controller.resultSearch[index].price}VNĐ',
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            AppDimens
                                                                                .dimens_22,
                                                                        color: ColorConstants
                                                                            .themeColor)),
                                                              ],
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: AppDimens
                                                                .dimens_5,
                                                          ),
                                                          FittedBox(
                                                              child: Text(
                                                            'Thời gian đặt: ${controller.formatTime(controller.resultSearch[index].timeStamp)} trước',
                                                            style: const TextStyle(
                                                                fontSize: AppDimens
                                                                    .dimens_17),
                                                          ))
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const Divider(
                                              height: AppDimens.dimens_5,
                                              thickness: AppDimens.dimens_0,
                                            ),
                                            Container(
                                              height: AppDimens.dimens_50,
                                              width: double.infinity,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical:
                                                          AppDimens.dimens_10,
                                                      horizontal:
                                                          AppDimens.dimens_40),
                                              child: ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                      backgroundColor:
                                                          ColorConstants
                                                              .themeColor,
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius
                                                              .circular(AppDimens
                                                                  .dimens_15))),
                                                  onPressed: () {
                                                    if (controller
                                                        .orderActive.isEmpty) {
                                                      controller.chooseOrder(
                                                          controller
                                                                  .resultSearch[
                                                              index],
                                                          context);
                                                    } else {
                                                      controller
                                                          .getDialog(context);
                                                    }
                                                  },
                                                  child: const Text(
                                                    'Nhận đơn',
                                                    style: TextStyle(
                                                        fontSize:
                                                            AppDimens.dimens_20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: ColorConstants
                                                            .colorBlack),
                                                  )),
                                            ),
                                          ]),
                                    ),
                                  );
                                },
                              ),
                            )
                ],
              )),
        ),
      ),
    );
  }
}
