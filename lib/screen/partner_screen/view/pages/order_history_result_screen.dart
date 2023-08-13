import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_ap/screen/Search_Screen/partner/search_history_partner_product_screen.dart';
import 'package:new_ap/screen/partner_screen/controller/history_order_controller.dart';

import '../../../../config/app_colors.dart';
import '../../../../config/app_dimens.dart';
import '../../../../config/app_font.dart';
import '../../../../config/app_storage_path.dart';
import 'order_completed_detail_screen.dart';

class OrderHistoryResultScreen extends StatelessWidget {
  OrderHistoryResultScreen({super.key});
  final HistoryController controller = Get.find<HistoryController>();
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
            body: Obx(() => Column(children: <Widget>[
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
                                        Get.to(() =>
                                            HisotryOrderPartnerSearchScreen());
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
                                  return GestureDetector(
                                    onTap: () {
                                      int value = controller.order.indexWhere(
                                          (element) =>
                                              element.id ==
                                              controller
                                                  .resultSearch[index].id);
                                      Get.to(() =>
                                          OrderCompletedDetailScreen(value));
                                    },
                                    child: Container(
                                      height: AppDimens.dimens_175,
                                      width: double.infinity,
                                      margin: const EdgeInsets.all(
                                          AppDimens.dimens_20),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              AppDimens.dimens_15),
                                          color: ColorConstants.colorGrey1),
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: AppDimens.dimens_20,
                                                vertical: AppDimens.dimens_10),
                                            child: Row(
                                              children: <Widget>[
                                                const Icon(
                                                  size: AppDimens.dimens_25,
                                                  Icons.store,
                                                  color:
                                                      ColorConstants.themeColor,
                                                ),
                                                const SizedBox(
                                                  width: AppDimens.dimens_5,
                                                ),
                                                Text(
                                                  controller.resultSearch[index]
                                                      .kitchenName,
                                                  style: const TextStyle(
                                                      fontSize:
                                                          AppDimens.dimens_25,
                                                      fontWeight:
                                                          AppFont.semiBold),
                                                ),
                                                const Expanded(
                                                    child: SizedBox()),
                                                Text(
                                                  controller.resultSearch[index]
                                                      .status,
                                                  style: const TextStyle(
                                                      fontSize:
                                                          AppDimens.dimens_20,
                                                      fontWeight: AppFont.light,
                                                      color: ColorConstants
                                                          .themeColor),
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
                                                  height: AppDimens.dimens_100,
                                                  width: AppDimens.dimens_100,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            AppDimens
                                                                .dimens_15),
                                                    child: Image.network(
                                                      controller
                                                          .resultSearch[index]
                                                          .url[0],
                                                      fit: BoxFit.fitHeight,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: AppDimens
                                                                  .dimens_5),
                                                      child: Text(
                                                        '${controller.resultSearch[index].name[0][0].toUpperCase()}${controller.resultSearch[index].name[0].substring(1)} ',
                                                        style: const TextStyle(
                                                            fontSize: AppDimens
                                                                .dimens_20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                    Text(
                                                        '${controller.order[index].productId.length} items',
                                                        style: const TextStyle(
                                                          fontSize: AppDimens
                                                              .dimens_20,
                                                        )),
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: AppDimens
                                                                  .dimens_5),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: <Widget>[
                                                          Text(
                                                            '${controller.getNewPrice(controller.resultSearch[index].price)}VNĐ',
                                                            style: const TextStyle(
                                                                fontSize: AppDimens
                                                                    .dimens_15,
                                                                color: ColorConstants
                                                                    .themeColor),
                                                          ),
                                                          Container(
                                                            padding:
                                                                const EdgeInsets
                                                                        .all(
                                                                    AppDimens
                                                                        .dimens_5),
                                                            decoration: BoxDecoration(
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                        AppDimens
                                                                            .dimens_5)),
                                                            child: Text(
                                                              controller
                                                                  .resultSearch[
                                                                      index]
                                                                  .statusDelivery,
                                                              style: const TextStyle(
                                                                  fontSize:
                                                                      AppDimens
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
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                ])),
          ),
        ));
  }
}
